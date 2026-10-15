package com.granthalay.backend.controller;

import com.granthalay.backend.dto.MemberDto;
import com.granthalay.backend.service.MemberService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/members")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    @GetMapping
    public ResponseEntity<Page<MemberDto>> getMembers(
            @RequestParam(defaultValue = "") String search,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        return ResponseEntity.ok(memberService.getMembers(search, page, size));
    }

    @GetMapping("/all")
    public ResponseEntity<List<MemberDto>> getAllMembers() {
        return ResponseEntity.ok(memberService.getAllMembers());
    }

    @GetMapping("/{id}")
    public ResponseEntity<MemberDto> getMemberById(@PathVariable Long id) {
        return ResponseEntity.ok(memberService.getMemberById(id));
    }

    @PostMapping
    public ResponseEntity<MemberDto> createMember(@Valid @RequestBody MemberDto dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(memberService.createMember(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<MemberDto> updateMember(@PathVariable Long id,
                                                  @Valid @RequestBody MemberDto dto) {
        return ResponseEntity.ok(memberService.updateMember(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteMember(@PathVariable Long id) {
        memberService.deleteMember(id);
        return ResponseEntity.noContent().build();
    }
}
