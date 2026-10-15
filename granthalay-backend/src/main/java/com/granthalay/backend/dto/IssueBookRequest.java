package com.granthalay.backend.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;

@Data
public class IssueBookRequest {

    @NotNull(message = "Book ID is required")
    private Long bookId;

    @NotNull(message = "Member ID is required")
    private Long memberId;

    private LocalDate issueDate;
    private LocalDate dueDate;
}
