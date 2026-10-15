package com.granthalay.backend.service;

import com.granthalay.backend.dto.LoginRequest;
import com.granthalay.backend.dto.LoginResponse;
import com.granthalay.backend.entity.AppUser;
import com.granthalay.backend.repository.AppUserRepository;
import com.granthalay.backend.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final AuthenticationManager authenticationManager;
    private final JwtTokenProvider jwtTokenProvider;
    private final AppUserRepository appUserRepository;

    public LoginResponse login(LoginRequest request) {
        Authentication auth = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsername(), request.getPassword()));

        String token = jwtTokenProvider.generateToken(request.getUsername());

        AppUser user = appUserRepository.findByUsername(request.getUsername())
                .orElseThrow();

        return LoginResponse.builder()
                .token(token)
                .tokenType("Bearer")
                .username(user.getUsername())
                .role(user.getRole().name())
                .fullName(user.getFullName())
                .expiresInMs(jwtTokenProvider.getExpirationMs())
                .build();
    }
}
