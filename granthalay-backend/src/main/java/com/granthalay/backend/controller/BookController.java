package com.granthalay.backend.controller;

import com.granthalay.backend.dto.BookDto;
import com.granthalay.backend.dto.CsvImportResultDto;
import com.granthalay.backend.service.BookService;
import com.granthalay.backend.service.CsvImportService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/books")
@RequiredArgsConstructor
public class BookController {

    private final BookService bookService;
    private final CsvImportService csvImportService;

    /** Paginated search — used by Flutter with infinite scroll */
    @GetMapping
    public ResponseEntity<Page<BookDto>> getBooks(
            @RequestParam(defaultValue = "") String search,
            @RequestParam(defaultValue = "") String category,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        return ResponseEntity.ok(bookService.getBooks(search, category, page, size));
    }

    /** Full list (no pagination) — for Flutter dropdown/search */
    @GetMapping("/all")
    public ResponseEntity<List<BookDto>> getAllBooks() {
        return ResponseEntity.ok(bookService.getAllBooks());
    }

    @GetMapping("/{id}")
    public ResponseEntity<BookDto> getBookById(@PathVariable Long id) {
        return ResponseEntity.ok(bookService.getBookById(id));
    }

    @PostMapping
    public ResponseEntity<BookDto> createBook(@Valid @RequestBody BookDto dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(bookService.createBook(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<BookDto> updateBook(@PathVariable Long id,
                                              @Valid @RequestBody BookDto dto) {
        return ResponseEntity.ok(bookService.updateBook(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteBook(@PathVariable Long id) {
        bookService.deleteBook(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * Bulk CSV import endpoint.
     * Accepts multipart file with header:
     * bookCode,titleMr,titleEn,authorMr,authorEn,category,isbn,publisher,publicationYear,totalCopies
     */
    @PostMapping("/bulk-import")
    public ResponseEntity<CsvImportResultDto> bulkImport(
            @RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return ResponseEntity.badRequest().build();
        }
        CsvImportResultDto result = csvImportService.importBooks(file);
        return ResponseEntity.ok(result);
    }
}
