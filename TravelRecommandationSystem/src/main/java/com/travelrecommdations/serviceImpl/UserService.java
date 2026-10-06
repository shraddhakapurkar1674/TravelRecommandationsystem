package com.travelrecommdations.serviceImpl;

import com.travelrecommdations.dto.LoginResponseDTO;
import com.travelrecommdations.dto.UserRegisterDTO;
import com.travelrecommdations.model.user;
import com.travelrecommdations.repository.userRepo;
import com.travelrecommdations.util.JwtUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private userRepo userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private EmailService emailService;
    @Autowired
    private NotificationService notificationService;


    // =====================================================
    // CHECK EMAIL
    // =====================================================

    public boolean emailExists(String email) {

        if (email == null ||
                email.trim().isEmpty()) {

            return false;
        }

        return userRepository
                .findByEmail(email.trim())
                .isPresent();
    }


    // =====================================================
    // REGISTER USER
    // =====================================================

    public boolean registerUser(
            UserRegisterDTO registerDTO) {

        if (registerDTO == null) {
            return false;
        }


        String email =
                registerDTO.getEmail() == null
                        ? ""
                        : registerDTO.getEmail().trim();


        if (email.isEmpty()) {
            return false;
        }


        /*
         * Do not create duplicate users.
         */

        if (userRepository
                .findByEmail(email)
                .isPresent()) {

            return false;
        }


        user u = new user();


        u.setFullName(
                registerDTO.getFullName().trim()
        );


        u.setEmail(email);


        /*
         * Password is stored encrypted.
         */

        u.setPassword(
                passwordEncoder.encode(
                        registerDTO.getPassword()
                )
        );


        /*
         * Normal registered user.
         */

        if (registerDTO.getRole() != null
                && !registerDTO.getRole().trim().isEmpty()) {

            u.setRole(
                    registerDTO.getRole().trim()
            );

        } else {

            u.setRole("ROLE_USER");
        }


        userRepository.save(u);
        notificationService
        .notifyAdminAboutNewUser(
                u.getFullName()
        );


        // =================================================
        // WELCOME EMAIL
        // =================================================

        try {

            emailService.sendWelcomeEmail(
                    u.getEmail(),
                    u.getFullName()
            );

        } catch (Exception e) {

            /*
             * Email failure should not cancel
             * successful database registration.
             */

            e.printStackTrace();
        }


        return true;
    }


    // =====================================================
    // LOGIN USER
    // =====================================================

    public Optional<LoginResponseDTO> loginUser(
            String email,
            String rawPassword) {

        if (email == null ||
                rawPassword == null) {

            return Optional.empty();
        }


        Optional<user> userOptional =
                userRepository.findByEmail(
                        email.trim()
                );


        if (userOptional.isEmpty()) {

            return Optional.empty();
        }


        user u =
                userOptional.get();


        /*
         * Compare entered password with
         * encrypted database password.
         */

        boolean isMatch =
                passwordEncoder.matches(
                        rawPassword,
                        u.getPassword()
                );


        if (!isMatch) {

            return Optional.empty();
        }


        // =================================================
        // GENERATE JWT
        // =================================================

        String token =
                jwtUtil.generateToken(
                        u.getEmail(),
                        u.getRole()
                );


        // =================================================
        // LOGIN RESPONSE
        // =================================================

        LoginResponseDTO response =
                new LoginResponseDTO(
                        u.getId(),
                        token,
                        u.getRole(),
                        u.getFullName(),
                        u.getEmail()
                );


        return Optional.of(response);
    }
}