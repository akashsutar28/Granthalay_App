package com.granthalay.backend.repository;

import com.granthalay.backend.entity.Book;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface BookRepository extends JpaRepository<Book, Long> {

    Optional<Book> findByBookCode(String bookCode);

    boolean existsByBookCode(String bookCode);

    @Query("""
        SELECT b FROM Book b
        WHERE (:search IS NULL OR :search = '' OR
               LOWER(b.titleMr) LIKE LOWER(CONCAT('%',:search,'%')) OR
               LOWER(b.titleEn) LIKE LOWER(CONCAT('%',:search,'%')) OR
               LOWER(b.authorMr) LIKE LOWER(CONCAT('%',:search,'%')) OR
               LOWER(b.authorEn) LIKE LOWER(CONCAT('%',:search,'%')) OR
               LOWER(b.bookCode) LIKE LOWER(CONCAT('%',:search,'%')) OR
               LOWER(b.isbn) LIKE LOWER(CONCAT('%',:search,'%')))
        AND (:category IS NULL OR :category = '' OR b.category = :category)
        """)
    Page<Book> searchBooks(@Param("search") String search,
                           @Param("category") String category,
                           Pageable pageable);

    long countByAvailableCopiesGreaterThan(int copies);

    @Query("SELECT SUM(b.availableCopies) FROM Book b")
    Long sumAvailableCopies();

    @Query("SELECT SUM(b.totalCopies - b.availableCopies) FROM Book b")
    Long sumIssuedCopies();
}
