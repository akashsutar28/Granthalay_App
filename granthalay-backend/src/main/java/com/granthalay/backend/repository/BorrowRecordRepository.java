package com.granthalay.backend.repository;

import com.granthalay.backend.entity.BorrowRecord;
import com.granthalay.backend.entity.BorrowRecord.Status;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface BorrowRecordRepository extends JpaRepository<BorrowRecord, Long> {

    List<BorrowRecord> findByMemberIdOrderByIssueDateDesc(Long memberId);

    Page<BorrowRecord> findByStatusOrderByIssueDateDesc(Status status, Pageable pageable);

    @Query("""
        SELECT br FROM BorrowRecord br
        JOIN FETCH br.book b
        JOIN FETCH br.member m
        WHERE br.status = 'ISSUED' AND br.dueDate < :today
        ORDER BY br.dueDate ASC
        """)
    List<BorrowRecord> findOverdueRecords(@Param("today") LocalDate today);

    @Query("""
        SELECT br FROM BorrowRecord br
        JOIN FETCH br.book b
        JOIN FETCH br.member m
        WHERE br.status = 'ISSUED'
        ORDER BY br.issueDate DESC
        """)
    Page<BorrowRecord> findCurrentlyIssued(Pageable pageable);

    long countByStatus(Status status);

    @Query("""
        SELECT br FROM BorrowRecord br
        JOIN FETCH br.book b
        JOIN FETCH br.member m
        ORDER BY br.createdAt DESC
        """)
    Page<BorrowRecord> findAllWithDetails(Pageable pageable);

    boolean existsByBookIdAndMemberIdAndStatus(Long bookId, Long memberId, Status status);

    List<BorrowRecord> findByMemberIdAndStatusOrderByIssueDateDesc(Long memberId, Status status);

    @org.springframework.data.jpa.repository.Modifying
    @org.springframework.transaction.annotation.Transactional
    @Query("DELETE FROM BorrowRecord b WHERE b.book.id = :bookId")
    void deleteByBookId(@Param("bookId") Long bookId);

    @org.springframework.data.jpa.repository.Modifying
    @org.springframework.transaction.annotation.Transactional
    @Query("DELETE FROM BorrowRecord b WHERE b.member.id = :memberId")
    void deleteByMemberId(@Param("memberId") Long memberId);
}
