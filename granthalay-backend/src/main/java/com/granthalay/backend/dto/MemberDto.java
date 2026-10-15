package com.granthalay.backend.dto;

import com.granthalay.backend.entity.Member;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class MemberDto {

    private Long id;

    @NotBlank(message = "Member code is required")
    private String memberCode;

    private String name;
    private String nameMr;
    private String nameEn;

    @NotBlank(message = "Phone number is required")
    private String phone;

    private String email;
    private String address;
    private String departmentClass;
    private LocalDate registeredDate;
    private LocalDateTime createdAt;

    public static MemberDto fromEntity(Member member) {
        String effectiveName = (member.getNameMr() != null && !member.getNameMr().isBlank())
                ? member.getNameMr()
                : (member.getNameEn() != null ? member.getNameEn() : "");

        return MemberDto.builder()
                .id(member.getId())
                .memberCode(member.getMemberCode())
                .name(effectiveName)
                .nameMr(member.getNameMr())
                .nameEn(member.getNameEn())
                .phone(member.getPhone())
                .email(member.getEmail())
                .address(member.getAddress())
                .departmentClass(member.getDepartmentClass())
                .registeredDate(member.getRegisteredDate())
                .createdAt(member.getCreatedAt())
                .build();
    }

    public Member toEntity() {
        String effectiveNameMr = (nameMr != null && !nameMr.isBlank())
                ? nameMr
                : (name != null ? name : (nameEn != null ? nameEn : ""));
        String effectiveNameEn = (nameEn != null && !nameEn.isBlank())
                ? nameEn
                : (name != null ? name : effectiveNameMr);

        return Member.builder()
                .memberCode(memberCode)
                .nameMr(effectiveNameMr)
                .nameEn(effectiveNameEn)
                .phone(phone)
                .email(email != null ? email : "")
                .address(address != null ? address : "")
                .departmentClass(departmentClass != null ? departmentClass : "")
                .registeredDate(registeredDate != null ? registeredDate : LocalDate.now())
                .build();
    }
}
