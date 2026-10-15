package com.granthalay.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "members", indexes = {
    @Index(name = "idx_member_code", columnList = "member_code"),
    @Index(name = "idx_member_phone", columnList = "phone")
})
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Member {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "member_code", unique = true, nullable = false, length = 50)
    private String memberCode;

    @Column(name = "name_mr", length = 300)
    private String nameMr;

    @Column(name = "name_en", length = 300)
    private String nameEn;

    @Column(name = "phone", length = 15)
    private String phone;

    @Column(name = "email", length = 200)
    private String email;

    @Column(name = "address", length = 500)
    private String address;

    @Column(name = "department_class", length = 100)
    private String departmentClass;

    @Column(name = "registered_date")
    private LocalDate registeredDate;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (registeredDate == null) registeredDate = LocalDate.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
