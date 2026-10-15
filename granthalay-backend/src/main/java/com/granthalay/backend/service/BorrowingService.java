package com.granthalay.backend.service;

import com.granthalay.backend.dto.BorrowRecordDto;
import com.granthalay.backend.dto.DashboardStatsDto;
import com.granthalay.backend.dto.IssueBookRequest;
import com.granthalay.backend.entity.Book;
import com.granthalay.backend.entity.BorrowRecord;
import com.granthalay.backend.entity.BorrowRecord.Status;
import com.granthalay.backend.entity.Member;
import com.granthalay.backend.exception.ResourceNotFoundException;
import com.granthalay.backend.repository.BookRepository;
import com.granthalay.backend.repository.BorrowRecordRepository;
import com.granthalay.backend.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class BorrowingService {

    private final BorrowRecordRepository borrowRecordRepository;
    private final BookRepository bookRepository;
    private final MemberRepository memberRepository;

    public Page<BorrowRecordDto> getAllRecords(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return borrowRecordRepository.findAllWithDetails(pageable)
                .map(BorrowRecordDto::fromEntity);
    }

    public Page<BorrowRecordDto> getCurrentlyIssued(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return borrowRecordRepository.findCurrentlyIssued(pageable)
                .map(BorrowRecordDto::fromEntity);
    }

    public List<BorrowRecordDto> getOverdueRecords() {
        // First sync overdue statuses
        syncOverdueStatuses();
        return borrowRecordRepository.findOverdueRecords(LocalDate.now())
                .stream().map(BorrowRecordDto::fromEntity).toList();
    }

    public List<BorrowRecordDto> getMemberHistory(Long memberId) {
        return borrowRecordRepository.findByMemberIdOrderByIssueDateDesc(memberId)
                .stream().map(BorrowRecordDto::fromEntity).toList();
    }

    public BorrowRecordDto getRecordById(Long id) {
        return borrowRecordRepository.findById(id)
                .map(BorrowRecordDto::fromEntity)
                .orElseThrow(() -> new ResourceNotFoundException("BorrowRecord", id));
    }

    @Transactional
    public BorrowRecordDto issueBook(IssueBookRequest request) {
        Book book = bookRepository.findById(request.getBookId())
                .orElseThrow(() -> new ResourceNotFoundException("Book", request.getBookId()));

        Member member = memberRepository.findById(request.getMemberId())
                .orElseThrow(() -> new ResourceNotFoundException("Member", request.getMemberId()));

        if (book.getAvailableCopies() <= 0) {
            throw new IllegalArgumentException(
                    "No available copies for book: " + book.getBookCode());
        }

        // Check for duplicate active issue
        if (borrowRecordRepository.existsByBookIdAndMemberIdAndStatus(
                book.getId(), member.getId(), Status.ISSUED)) {
            throw new IllegalArgumentException(
                    "This book is already issued to this member");
        }

        LocalDate issueDate = request.getIssueDate() != null
                ? request.getIssueDate() : LocalDate.now();
        LocalDate dueDate = request.getDueDate() != null
                ? request.getDueDate() : issueDate.plusDays(14);

        BorrowRecord record = BorrowRecord.builder()
                .book(book)
                .member(member)
                .issueDate(issueDate)
                .dueDate(dueDate)
                .status(Status.ISSUED)
                .build();

        BorrowRecord saved = borrowRecordRepository.save(record);

        // Decrement available copies
        book.setAvailableCopies(book.getAvailableCopies() - 1);
        bookRepository.save(book);

        return BorrowRecordDto.fromEntity(saved);
    }

    @Transactional
    public BorrowRecordDto returnBook(Long recordId) {
        BorrowRecord record = borrowRecordRepository.findById(recordId)
                .orElseThrow(() -> new ResourceNotFoundException("BorrowRecord", recordId));

        if (record.getStatus() == Status.RETURNED) {
            throw new IllegalArgumentException("This book is already returned");
        }

        record.setReturnDate(LocalDate.now());
        record.setStatus(Status.RETURNED);
        BorrowRecord saved = borrowRecordRepository.save(record);

        // Increment available copies
        Book book = record.getBook();
        book.setAvailableCopies(Math.min(book.getTotalCopies(),
                book.getAvailableCopies() + 1));
        bookRepository.save(book);

        return BorrowRecordDto.fromEntity(saved);
    }

    public DashboardStatsDto getDashboardStats() {
        syncOverdueStatuses();

        long totalBooks = bookRepository.count();
        Long availCopies = bookRepository.sumAvailableCopies();
        Long issuedCopies = bookRepository.sumIssuedCopies();
        long totalMembers = memberRepository.count();
        long overdueBooks = borrowRecordRepository.countByStatus(Status.OVERDUE);
        long totalReturned = borrowRecordRepository.countByStatus(Status.RETURNED);

        long ac = availCopies != null ? availCopies : 0;
        long ic = issuedCopies != null ? issuedCopies : 0;

        return DashboardStatsDto.builder()
                .totalBooks(totalBooks)
                .totalCopies(ac + ic)
                .availableCopies(ac)
                .issuedBooks(ic)
                .totalMembers(totalMembers)
                .overdueBooks(overdueBooks)
                .totalReturned(totalReturned)
                .build();
    }

    @Transactional
    private void syncOverdueStatuses() {
        // Mark ISSUED records past due date as OVERDUE
        List<BorrowRecord> overdueRecords =
                borrowRecordRepository.findOverdueRecords(LocalDate.now());
        overdueRecords.forEach(r -> {
            if (r.getStatus() == Status.ISSUED) {
                r.setStatus(Status.OVERDUE);
            }
        });
        if (!overdueRecords.isEmpty()) {
            borrowRecordRepository.saveAll(overdueRecords);
        }
    }
}
