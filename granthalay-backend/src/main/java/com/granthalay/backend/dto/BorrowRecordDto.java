package com.granthalay.backend.dto;

import com.granthalay.backend.entity.BorrowRecord;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class BorrowRecordDto {

    private Long id;

    // Book info (denormalized for Flutter compatibility)
    private Long bookId;
    private String bookCode;
    private String bookTitleMr;
    private String bookTitleEn;
    private String bookAuthorMr;
    private String bookAuthorEn;

    // Member info (denormalized)
    private Long memberId;
    private String memberCode;
    private String memberNameMr;
    private String memberNameEn;
    private String memberPhone;

    private LocalDate issueDate;
    private LocalDate dueDate;
    private LocalDate returnDate;
    private String status;
    private LocalDateTime createdAt;

    public static BorrowRecordDto fromEntity(BorrowRecord record) {
        return BorrowRecordDto.builder()
                .id(record.getId())
                .bookId(record.getBook().getId())
                .bookCode(record.getBook().getBookCode())
                .bookTitleMr(record.getBook().getTitleMr())
                .bookTitleEn(record.getBook().getTitleEn())
                .bookAuthorMr(record.getBook().getAuthorMr())
                .bookAuthorEn(record.getBook().getAuthorEn())
                .memberId(record.getMember().getId())
                .memberCode(record.getMember().getMemberCode())
                .memberNameMr(record.getMember().getNameMr())
                .memberNameEn(record.getMember().getNameEn())
                .memberPhone(record.getMember().getPhone())
                .issueDate(record.getIssueDate())
                .dueDate(record.getDueDate())
                .returnDate(record.getReturnDate())
                .status(record.getStatus().name())
                .createdAt(record.getCreatedAt())
                .build();
    }
}
