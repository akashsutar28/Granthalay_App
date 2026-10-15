package com.granthalay.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class DashboardStatsDto {
    private long totalBooks;
    private long totalCopies;
    private long availableCopies;
    private long issuedBooks;
    private long totalMembers;
    private long overdueBooks;
    private long totalReturned;
}
