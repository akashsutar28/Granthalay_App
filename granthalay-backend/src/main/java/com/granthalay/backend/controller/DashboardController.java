package com.granthalay.backend.controller;

import com.granthalay.backend.dto.DashboardStatsDto;
import com.granthalay.backend.service.BorrowingService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final BorrowingService borrowingService;

    @GetMapping("/statistics")
    public ResponseEntity<DashboardStatsDto> getDashboardStatistics() {
        return ResponseEntity.ok(borrowingService.getDashboardStats());
    }

    @GetMapping("/stats")
    public ResponseEntity<DashboardStatsDto> getDashboardStats() {
        return ResponseEntity.ok(borrowingService.getDashboardStats());
    }
}
