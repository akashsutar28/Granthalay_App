package com.granthalay.backend.service;

import com.granthalay.backend.dto.MemberDto;
import com.granthalay.backend.entity.Member;
import com.granthalay.backend.exception.ResourceNotFoundException;
import com.granthalay.backend.repository.BorrowRecordRepository;
import com.granthalay.backend.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MemberService {

    private final MemberRepository memberRepository;
    private final BorrowRecordRepository borrowRecordRepository;

    public Page<MemberDto> getMembers(String search, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
        return memberRepository.searchMembers(search, pageable)
                .map(MemberDto::fromEntity);
    }

    public List<MemberDto> getAllMembers() {
        return memberRepository.findAll(Sort.by(Sort.Direction.DESC, "createdAt"))
                .stream().map(MemberDto::fromEntity).toList();
    }

    public MemberDto getMemberById(Long id) {
        return memberRepository.findById(id)
                .map(MemberDto::fromEntity)
                .orElseThrow(() -> new ResourceNotFoundException("Member", id));
    }

    @Transactional
    public MemberDto createMember(MemberDto dto) {
        if (memberRepository.existsByMemberCode(dto.getMemberCode())) {
            throw new IllegalArgumentException(
                    "Member with code '" + dto.getMemberCode() + "' already exists");
        }
        Member member = dto.toEntity();
        return MemberDto.fromEntity(memberRepository.save(member));
    }

    @Transactional
    public MemberDto updateMember(Long id, MemberDto dto) {
        Member existing = memberRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Member", id));

        if (!existing.getMemberCode().equals(dto.getMemberCode())
                && memberRepository.existsByMemberCode(dto.getMemberCode())) {
            throw new IllegalArgumentException(
                    "Member with code '" + dto.getMemberCode() + "' already exists");
        }

        String effectiveNameMr = (dto.getNameMr() != null && !dto.getNameMr().isBlank())
                ? dto.getNameMr()
                : (dto.getName() != null ? dto.getName() : dto.getNameEn());
        String effectiveNameEn = (dto.getNameEn() != null && !dto.getNameEn().isBlank())
                ? dto.getNameEn()
                : (dto.getName() != null ? dto.getName() : effectiveNameMr);

        existing.setMemberCode(dto.getMemberCode());
        existing.setNameMr(effectiveNameMr != null ? effectiveNameMr : "");
        existing.setNameEn(effectiveNameEn != null ? effectiveNameEn : "");
        existing.setPhone(dto.getPhone());
        existing.setEmail(dto.getEmail());
        existing.setAddress(dto.getAddress());
        existing.setDepartmentClass(dto.getDepartmentClass());
        if (dto.getRegisteredDate() != null) {
            existing.setRegisteredDate(dto.getRegisteredDate());
        }

        return MemberDto.fromEntity(memberRepository.save(existing));
    }

    @Transactional
    public void deleteMember(Long id) {
        if (!memberRepository.existsById(id)) {
            throw new ResourceNotFoundException("Member", id);
        }
        borrowRecordRepository.deleteByMemberId(id);
        memberRepository.deleteById(id);
    }
}
