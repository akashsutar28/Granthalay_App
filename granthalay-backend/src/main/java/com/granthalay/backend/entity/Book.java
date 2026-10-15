package com.granthalay.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "books", indexes = {
    @Index(name = "idx_book_code", columnList = "book_code"),
    @Index(name = "idx_category", columnList = "category")
})
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Book {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "book_code", unique = true, nullable = false, length = 50)
    private String bookCode;

    @Column(name = "title_mr", length = 500)
    private String titleMr;

    @Column(name = "title_en", length = 500)
    private String titleEn;

    @Column(name = "author_mr", length = 300)
    private String authorMr;

    @Column(name = "author_en", length = 300)
    private String authorEn;

    @Column(name = "category", length = 200)
    private String category;

    @Column(name = "isbn", length = 30)
    private String isbn;

    @Column(name = "publisher", length = 300)
    private String publisher;

    @Column(name = "publication_year")
    private Integer publicationYear;

    @Column(name = "total_copies", nullable = false)
    private Integer totalCopies;

    @Column(name = "available_copies", nullable = false)
    private Integer availableCopies;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (availableCopies == null) availableCopies = totalCopies;
        if (totalCopies == null) totalCopies = 1;
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
