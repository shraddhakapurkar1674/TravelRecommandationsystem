package com.travelrecommdations.controller;

import com.travelrecommdations.dto.ApiResponse;
import com.travelrecommdations.dto.LoginResponseDTO;
import com.travelrecommdations.dto.UserLoginDTO;
import com.travelrecommdations.dto.UserRegisterDTO;
import com.travelrecommdations.serviceImpl.UserService;

import jakarta.validation.Valid;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")

public class userController {

    @Autowired
    private UserService userService;


    // =====================================================
    // REGISTER
    // =====================================================

    @PostMapping("/users/register")
    public ResponseEntity<ApiResponse<LoginResponseDTO>> registerUser(
            @Valid @RequestBody UserRegisterDTO registerDTO) {

        try {

            boolean isRegistered =
                    userService.registerUser(registerDTO);

            if (!isRegistered) {

                return ResponseEntity
                        .status(HttpStatus.CONFLICT)
                        .body(
                                new ApiResponse<>(
                                        false,
                                        "Email already registered. Please login.",
                                        null
                                )
                        );
            }

            /*
             * Registration successful.
             *
             * Immediately login the newly registered user
             * so that userId and JWT token are available for
             * create_profile.jsp.
             */

            Optional<LoginResponseDTO> loginResponse =
                    userService.loginUser(
                            registerDTO.getEmail(),
                            registerDTO.getPassword()
                    );

            if (loginResponse.isPresent()) {

                return ResponseEntity
                        .status(HttpStatus.CREATED)
                        .body(
                                new ApiResponse<>(
                                        true,
                                        "Registration successful.",
                                        loginResponse.get()
                                )
                        );
            }

            return ResponseEntity
                    .status(HttpStatus.CREATED)
                    .body(
                            new ApiResponse<>(
                                    true,
                                    "Registration successful. Please login.",
                                    null
                            )
                    );

        } catch (Exception e) {

            e.printStackTrace();

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(
                            new ApiResponse<>(
                                    false,
                                    "Server error during registration.",
                                    null
                            )
                    );
        }
    }


    // =====================================================
    // LOGIN
    // =====================================================

    @PostMapping("/users/login")
    public ResponseEntity<ApiResponse<LoginResponseDTO>> loginUser(
            @Valid @RequestBody UserLoginDTO loginDTO) {

        /*
         * First check whether email exists.
         *
         * This is important because frontend must distinguish:
         *
         * 1. Existing user with wrong password
         * 2. Completely new user
         */

        boolean emailExists =
                userService.emailExists(
                        loginDTO.getEmail()
                );


        // =================================================
        // NEW USER
        // =================================================

        if (!emailExists) {

            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(
                            new ApiResponse<>(
                                    false,
                                    "User not found. Please register first.",
                                    null
                            )
                    );
        }


        // =================================================
        // EXISTING USER LOGIN
        // =================================================

        Optional<LoginResponseDTO> loginResponseOptional =
                userService.loginUser(
                        loginDTO.getEmail(),
                        loginDTO.getPassword()
                );


        if (loginResponseOptional.isPresent()) {

            return ResponseEntity.ok(
                    new ApiResponse<>(
                            true,
                            "Login successful!",
                            loginResponseOptional.get()
                    )
            );
        }


        // =================================================
        // WRONG PASSWORD
        // =================================================

        return ResponseEntity
                .status(HttpStatus.UNAUTHORIZED)
                .body(
                        new ApiResponse<>(
                                false,
                                "Invalid password.",
                                null
                        )
                );
    }
}
