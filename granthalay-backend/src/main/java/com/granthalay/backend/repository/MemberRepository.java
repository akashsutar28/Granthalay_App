package com.granthalay.backend.repository;

import com.granthalay.backend.entity.Member;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface MemberRepository extends JpaRepository<Member, Long> {

    Optional<Member> findByMemberCode(String memberCode);

    boolean existsByMemberCode(String memberCode);

    Optional<Member> findByPhone(String phone);

    @Query("""
        SELECT m FROM Member m
        WHERE (:search IS NULL OR :search = '' OR
               LOWER(m.nameMr) LIKE LOWER(CONCAT('%',:search,'%')) OR
               LOWER(m.nameEn) LIKE LOWER(CONCAT('%',:search,'%')) OR
               LOWER(m.memberCode) LIKE LOWER(CONCAT('%',:search,'%')) OR
               m.phone LIKE CONCAT('%',:search,'%') OR
               LOWER(m.email) LIKE LOWER(CONCAT('%',:search,'%')))
        """)
    Page<Member> searchMembers(@Param("search") String search, Pageable pageable);
}
