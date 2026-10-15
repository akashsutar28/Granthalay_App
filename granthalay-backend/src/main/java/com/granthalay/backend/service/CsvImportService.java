package com.granthalay.backend.service;

import com.granthalay.backend.dto.CsvImportResultDto;
import com.granthalay.backend.entity.Book;
import com.granthalay.backend.repository.BookRepository;
import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Bulk Book Import Service for CSV and Excel (.xlsx, .xls) files.
 *
 * Expected format (with header row):
 * bookCode,titleMr,titleEn,authorMr,authorEn,category,isbn,publisher,publicationYear,totalCopies
 *
 * Processes records in chunks of 100 for memory efficiency (handles 5000+ books).
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class CsvImportService {

    private static final int CHUNK_SIZE = 100;
    private static final int EXPECTED_COLUMNS = 10;

    private final BookRepository bookRepository;

    @Transactional
    public CsvImportResultDto importBooks(MultipartFile file) {
        List<String> errors = new ArrayList<>();
        int successCount = 0;
        int skipCount = 0;
        int totalRows = 0;

        try {
            List<String[]> allRows = extractRows(file);

            if (allRows.isEmpty()) {
                return CsvImportResultDto.builder()
                        .message("File is empty")
                        .totalRows(0).build();
            }

            // Skip header row
            int startRow = 0;
            String[] firstRow = allRows.get(0);
            if (isHeaderRow(firstRow)) {
                startRow = 1;
            }

            totalRows = allRows.size() - startRow;
            List<Book> chunk = new ArrayList<>(CHUNK_SIZE);

            for (int i = startRow; i < allRows.size(); i++) {
                String[] row = allRows.get(i);
                int rowNum = i + 1;

                try {
                    Book book = parseRow(row, rowNum);

                    if (bookRepository.existsByBookCode(book.getBookCode())) {
                        skipCount++;
                        log.debug("Row {}: Skipped - book code '{}' already exists",
                                rowNum, book.getBookCode());
                        continue;
                    }

                    chunk.add(book);

                    // Flush chunk
                    if (chunk.size() >= CHUNK_SIZE) {
                        bookRepository.saveAll(chunk);
                        successCount += chunk.size();
                        log.info("Imported chunk: {} books saved", chunk.size());
                        chunk.clear();
                    }

                } catch (IllegalArgumentException e) {
                    errors.add("Row " + rowNum + ": " + e.getMessage());
                    log.warn("CSV row {} error: {}", rowNum, e.getMessage());
                }
            }

            // Save remaining records
            if (!chunk.isEmpty()) {
                bookRepository.saveAll(chunk);
                successCount += chunk.size();
            }

        } catch (IOException | CsvException e) {
            log.error("Failed to parse CSV file", e);
            errors.add("Failed to read CSV: " + e.getMessage());
        }

        String message = String.format(
                "Import complete: %d added, %d skipped (duplicate), %d errors",
                successCount, skipCount, errors.size());

        return CsvImportResultDto.builder()
                .totalRows(totalRows)
                .successCount(successCount)
                .skipCount(skipCount)
                .errorCount(errors.size())
                .errors(errors.size() > 50 ? errors.subList(0, 50) : errors)
                .message(message)
                .build();
    }

    private Book parseRow(String[] row, int rowNum) {
        if (row.length < EXPECTED_COLUMNS) {
            throw new IllegalArgumentException(
                    "Expected " + EXPECTED_COLUMNS + " columns, got " + row.length);
        }

        String bookCode = row[0].trim();
        if (bookCode.isEmpty()) {
            throw new IllegalArgumentException("Book code (column 1) cannot be empty");
        }

        int totalCopies = 1;
        try {
            String copiesStr = row[9].trim();
            if (!copiesStr.isEmpty()) {
                totalCopies = Integer.parseInt(copiesStr);
            }
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid totalCopies value: " + row[9]);
        }

        int publicationYear = 0;
        try {
            String yearStr = row[8].trim();
            if (!yearStr.isEmpty()) {
                publicationYear = Integer.parseInt(yearStr);
            }
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid publicationYear value: " + row[8]);
        }

        String titleMr = row[1].trim();
        String titleEn = row[2].trim();
        String isbn = row[6].trim();

        // If titleEn is numeric (e.g. Accession number in library CSV), move it to isbn and use titleMr
        if (titleEn.matches("^\\d+$")) {
            if (isbn.isEmpty()) {
                isbn = titleEn;
            }
            titleEn = titleMr;
        }
        if (titleMr.isEmpty()) titleMr = titleEn;
        if (titleEn.isEmpty()) titleEn = titleMr;

        String authorMr = row[3].trim();
        String authorEn = row[4].trim();
        if (authorMr.isEmpty()) authorMr = authorEn;
        if (authorEn.isEmpty()) authorEn = authorMr;

        return Book.builder()
                .bookCode(bookCode)
                .titleMr(titleMr)
                .titleEn(titleEn)
                .authorMr(authorMr)
                .authorEn(authorEn)
                .category(row[5].trim().isEmpty() ? "General" : row[5].trim())
                .isbn(isbn)
                .publisher(row[7].trim())
                .publicationYear(publicationYear)
                .totalCopies(totalCopies)
                .availableCopies(totalCopies)
                .build();
    }

    private List<String[]> extractRows(MultipartFile file) throws IOException, CsvException {
        String filename = file.getOriginalFilename() != null ? file.getOriginalFilename().toLowerCase() : "";

        if (filename.endsWith(".xlsx") || filename.endsWith(".xls")) {
            return extractExcelRows(file);
        } else {
            return extractCsvRows(file);
        }
    }

    private List<String[]> extractCsvRows(MultipartFile file) throws IOException, CsvException {
        try (CSVReader reader = new CSVReader(
                new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8))) {
            return reader.readAll();
        }
    }

    private List<String[]> extractExcelRows(MultipartFile file) throws IOException {
        List<String[]> rows = new ArrayList<>();
        DataFormatter formatter = new DataFormatter();

        try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);
            for (Row row : sheet) {
                int lastCell = Math.max(row.getLastCellNum(), EXPECTED_COLUMNS);
                String[] cells = new String[lastCell];
                boolean hasContent = false;
                for (int c = 0; c < lastCell; c++) {
                    Cell cell = row.getCell(c, Row.MissingCellPolicy.CREATE_NULL_AS_BLANK);
                    String val = formatter.formatCellValue(cell).trim();
                    cells[c] = val;
                    if (!val.isEmpty()) {
                        hasContent = true;
                    }
                }
                if (hasContent) {
                    rows.add(cells);
                }
            }
        }
        return rows;
    }

    private boolean isHeaderRow(String[] row) {
        if (row.length == 0) return false;
        String first = row[0].trim().toLowerCase().replaceAll("[^a-z0-9]", "");
        return first.contains("bookcode") || first.contains("code") || first.contains("srno")
                || first.contains("serial") || first.equals("sno") || first.equals("no");
    }
}
