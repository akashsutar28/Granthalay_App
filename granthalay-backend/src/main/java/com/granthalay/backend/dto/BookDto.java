package com.granthalay.backend.dto;

import com.granthalay.backend.entity.Book;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class BookDto {

    private Long id;

    @NotBlank(message = "Book code is required")
    private String bookCode;

    private String title;
    private String titleMr;
    private String titleEn;
    private String author;
    private String authorMr;
    private String authorEn;
    private String category;
    private String isbn;
    private String publisher;
    private Integer publicationYear;

    @NotNull(message = "Total copies is required")
    @Min(value = 1, message = "Total copies must be at least 1")
    private Integer totalCopies;

    private Integer availableCopies;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static BookDto fromEntity(Book book) {
        String effectiveTitle = (book.getTitleMr() != null && !book.getTitleMr().isBlank())
                ? book.getTitleMr()
                : (book.getTitleEn() != null ? book.getTitleEn() : "");
        String effectiveAuthor = (book.getAuthorMr() != null && !book.getAuthorMr().isBlank())
                ? book.getAuthorMr()
                : (book.getAuthorEn() != null ? book.getAuthorEn() : "");

        return BookDto.builder()
                .id(book.getId())
                .bookCode(book.getBookCode())
                .title(effectiveTitle)
                .titleMr(book.getTitleMr())
                .titleEn(book.getTitleEn())
                .author(effectiveAuthor)
                .authorMr(book.getAuthorMr())
                .authorEn(book.getAuthorEn())
                .category(book.getCategory())
                .isbn(book.getIsbn())
                .publisher(book.getPublisher())
                .publicationYear(book.getPublicationYear())
                .totalCopies(book.getTotalCopies())
                .availableCopies(book.getAvailableCopies())
                .createdAt(book.getCreatedAt())
                .updatedAt(book.getUpdatedAt())
                .build();
    }

    public Book toEntity() {
        String effectiveTitleMr = (titleMr != null && !titleMr.isBlank())
                ? titleMr
                : (title != null ? title : (titleEn != null ? titleEn : ""));
        String effectiveTitleEn = (titleEn != null && !titleEn.isBlank())
                ? titleEn
                : (title != null ? title : effectiveTitleMr);

        String effectiveAuthorMr = (authorMr != null && !authorMr.isBlank())
                ? authorMr
                : (author != null ? author : (authorEn != null ? authorEn : ""));
        String effectiveAuthorEn = (authorEn != null && !authorEn.isBlank())
                ? authorEn
                : (author != null ? author : effectiveAuthorMr);

        return Book.builder()
                .bookCode(bookCode)
                .titleMr(effectiveTitleMr)
                .titleEn(effectiveTitleEn)
                .authorMr(effectiveAuthorMr)
                .authorEn(effectiveAuthorEn)
                .category(category != null ? category : "General")
                .isbn(isbn != null ? isbn : "")
                .publisher(publisher != null ? publisher : "")
                .publicationYear(publicationYear != null ? publicationYear : 0)
                .totalCopies(totalCopies)
                .availableCopies(availableCopies != null ? availableCopies : totalCopies)
                .build();
    }
}
