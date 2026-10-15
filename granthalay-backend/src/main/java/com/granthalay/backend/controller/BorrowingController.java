package com.granthalay.backend.controller;

import com.granthalay.backend.dto.BorrowRecordDto;
import com.granthalay.backend.dto.DashboardStatsDto;
import com.granthalay.backend.dto.IssueBookRequest;
import com.granthalay.backend.service.BorrowingService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping({"/borrowings", "/borrow-records"})
@RequiredArgsConstructor
public class BorrowingController {

    private final BorrowingService borrowingService;

    @GetMapping
    public ResponseEntity<Page<BorrowRecordDto>> getAllRecords(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        return ResponseEntity.ok(borrowingService.getAllRecords(page, size));
    }

    @GetMapping("/{id}")
    public ResponseEntity<BorrowRecordDto> getRecordById(@PathVariable Long id) {
        return ResponseEntity.ok(borrowingService.getRecordById(id));
    }

    @GetMapping({"/currently-issued", "/issued"})
    public ResponseEntity<Page<BorrowRecordDto>> getCurrentlyIssued(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        return ResponseEntity.ok(borrowingService.getCurrentlyIssued(page, size));
    }

    @GetMapping("/overdue")
    public ResponseEntity<List<BorrowRecordDto>> getOverdueRecords() {
        return ResponseEntity.ok(borrowingService.getOverdueRecords());
    }

    @GetMapping("/member/{memberId}")
    public ResponseEntity<List<BorrowRecordDto>> getMemberHistory(
            @PathVariable Long memberId) {
        return ResponseEntity.ok(borrowingService.getMemberHistory(memberId));
    }

    @PostMapping("/issue")
    public ResponseEntity<BorrowRecordDto> issueBook(
            @Valid @RequestBody IssueBookRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(borrowingService.issueBook(request));
    }

    @RequestMapping(value = "/{id}/return", method = {RequestMethod.PUT, RequestMethod.POST})
    public ResponseEntity<BorrowRecordDto> returnBook(@PathVariable Long id) {
        return ResponseEntity.ok(borrowingService.returnBook(id));
    }

    @GetMapping({"/stats", "/statistics"})
    public ResponseEntity<DashboardStatsDto> getDashboardStats() {
        return ResponseEntity.ok(borrowingService.getDashboardStats());
    }
}
