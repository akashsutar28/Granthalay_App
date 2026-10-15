package com.granthalay.backend.service;

import com.granthalay.backend.dto.BookDto;
import com.granthalay.backend.entity.Book;
import com.granthalay.backend.exception.ResourceNotFoundException;
import com.granthalay.backend.repository.BookRepository;
import com.granthalay.backend.repository.BorrowRecordRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class BookService {

    private final BookRepository bookRepository;
    private final BorrowRecordRepository borrowRecordRepository;

    public Page<BookDto> getBooks(String search, String category, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
        return bookRepository.searchBooks(search, category, pageable)
                .map(BookDto::fromEntity);
    }

    public List<BookDto> getAllBooks() {
        return bookRepository.findAll(Sort.by(Sort.Direction.DESC, "createdAt"))
                .stream().map(BookDto::fromEntity).toList();
    }

    public BookDto getBookById(Long id) {
        return bookRepository.findById(id)
                .map(BookDto::fromEntity)
                .orElseThrow(() -> new ResourceNotFoundException("Book", id));
    }

    @Transactional
    public BookDto createBook(BookDto dto) {
        if (bookRepository.existsByBookCode(dto.getBookCode())) {
            throw new IllegalArgumentException(
                    "Book with code '" + dto.getBookCode() + "' already exists");
        }
        Book book = dto.toEntity();
        return BookDto.fromEntity(bookRepository.save(book));
    }

    @Transactional
    public BookDto updateBook(Long id, BookDto dto) {
        Book existing = bookRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Book", id));

        // If code changed, check uniqueness
        if (!existing.getBookCode().equals(dto.getBookCode())
                && bookRepository.existsByBookCode(dto.getBookCode())) {
            throw new IllegalArgumentException(
                    "Book with code '" + dto.getBookCode() + "' already exists");
        }

        String effectiveTitleMr = (dto.getTitleMr() != null && !dto.getTitleMr().isBlank())
                ? dto.getTitleMr()
                : (dto.getTitle() != null ? dto.getTitle() : dto.getTitleEn());
        String effectiveTitleEn = (dto.getTitleEn() != null && !dto.getTitleEn().isBlank())
                ? dto.getTitleEn()
                : (dto.getTitle() != null ? dto.getTitle() : effectiveTitleMr);

        String effectiveAuthorMr = (dto.getAuthorMr() != null && !dto.getAuthorMr().isBlank())
                ? dto.getAuthorMr()
                : (dto.getAuthor() != null ? dto.getAuthor() : dto.getAuthorEn());
        String effectiveAuthorEn = (dto.getAuthorEn() != null && !dto.getAuthorEn().isBlank())
                ? dto.getAuthorEn()
                : (dto.getAuthor() != null ? dto.getAuthor() : effectiveAuthorMr);

        existing.setBookCode(dto.getBookCode());
        existing.setTitleMr(effectiveTitleMr != null ? effectiveTitleMr : "");
        existing.setTitleEn(effectiveTitleEn != null ? effectiveTitleEn : "");
        existing.setAuthorMr(effectiveAuthorMr != null ? effectiveAuthorMr : "");
        existing.setAuthorEn(effectiveAuthorEn != null ? effectiveAuthorEn : "");
        existing.setCategory(dto.getCategory() != null && !dto.getCategory().isBlank()
                ? dto.getCategory()
                : (existing.getCategory() != null ? existing.getCategory() : "General"));
        if (dto.getIsbn() != null) {
            existing.setIsbn(dto.getIsbn());
        }
        if (dto.getPublisher() != null) {
            existing.setPublisher(dto.getPublisher());
        }
        if (dto.getPublicationYear() != null) {
            existing.setPublicationYear(dto.getPublicationYear());
        }
        existing.setTotalCopies(dto.getTotalCopies());
        if (dto.getAvailableCopies() != null) {
            existing.setAvailableCopies(dto.getAvailableCopies());
        }

        return BookDto.fromEntity(bookRepository.save(existing));
    }

    @Transactional
    public void deleteBook(Long id) {
        if (!bookRepository.existsById(id)) {
            throw new ResourceNotFoundException("Book", id);
        }
        borrowRecordRepository.deleteByBookId(id);
        bookRepository.deleteById(id);
    }

    @Transactional
    public void updateAvailableCopies(Long bookId, int delta) {
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new ResourceNotFoundException("Book", bookId));
        int newAvail = Math.max(0, Math.min(book.getTotalCopies(),
                book.getAvailableCopies() + delta));
        book.setAvailableCopies(newAvail);
        bookRepository.save(book);
    }
}
