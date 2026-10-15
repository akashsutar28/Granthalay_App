package com.granthalay.backend;

import com.granthalay.backend.entity.AppUser;
import com.granthalay.backend.entity.AppUser.Role;
import com.granthalay.backend.repository.AppUserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

/**
 * Creates default admin and librarian users on first startup if they don't exist.
 *
 * Default credentials:
 *   admin   / Admin@123
 *   librarian / Lib@12345
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

    private final AppUserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        createUserIfNotExists("admin", "Admin@123", Role.ADMIN, "Library Administrator");
        createUserIfNotExists("librarian", "Lib@12345", Role.LIBRARIAN, "Head Librarian");
        log.info("Granthalay Backend started successfully!");
        log.info("Default users: admin/Admin@123 | librarian/Lib@12345");
        log.info("Swagger UI: http://localhost:8080/api/swagger-ui.html");
        log.info("Health check: http://localhost:8080/api/health");
    }

    private void createUserIfNotExists(String username, String password,
                                        Role role, String fullName) {
        if (!userRepository.existsByUsername(username)) {
            AppUser user = AppUser.builder()
                    .username(username)
                    .passwordHash(passwordEncoder.encode(password))
                    .role(role)
                    .fullName(fullName)
                    .isActive(true)
                    .build();
            userRepository.save(user);
            log.info("Created default user: {} ({})", username, role);
        }
    }
}
