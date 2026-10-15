package com.granthalay.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class CsvImportResultDto {
    private int totalRows;
    private int successCount;
    private int skipCount;
    private int errorCount;
    private List<String> errors;
    private String message;
}
