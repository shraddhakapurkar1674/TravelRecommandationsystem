package com.travelrecommdations.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.travelrecommdations.dto.TravelProfileDTO;
import com.travelrecommdations.model.TravelProfile;
import com.travelrecommdations.serviceImpl.TravelProfileService;
import com.travelrecommdations.repository.userRepo;
import com.travelrecommdations.model.user;

@RestController
@RequestMapping("/api")

public class TravelProfileController {

    @Autowired
    private TravelProfileService travelProfileService;

    @Autowired
    private userRepo userRepository;

    @Value("${file.upload-dir}")
    private String uploadDir;

    // =========================================================
    // GET PROFILE
    // =========================================================

    @GetMapping("/travel-profile/{userId}")
    public ResponseEntity<?> getProfile(
            @PathVariable Long userId) {

        try {

            Optional<TravelProfile> profile =
                    travelProfileService.getProfileByUserId(userId);

            if (profile.isEmpty()) {

                return ResponseEntity
                        .status(HttpStatus.NOT_FOUND)
                        .body(Map.of(
                                "success", false,
                                "message", "Travel profile not found"
                        ));
            }

            TravelProfileDTO dto =
                    travelProfileService.convertToDTO(profile.get());

            return ResponseEntity.ok(
                    Map.of(
                            "success", true,
                            "data", dto
                    )
            );

        } catch (Exception e) {

            e.printStackTrace();

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of(
                            "success", false,
                            "message", "Unable to load travel profile"
                    ));
        }
    }

    // =========================================================
    // CHECK PROFILE
    // =========================================================

    @GetMapping("/travel-profile/check/{userId}")
    public ResponseEntity<?> checkProfile(
            @PathVariable Long userId) {

        try {

            boolean completed =
                    travelProfileService.isProfileCompleted(userId);

            return ResponseEntity.ok(completed);

        } catch (Exception e) {

            e.printStackTrace();

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(false);
        }
    }

    // =========================================================
    // SAVE OR UPDATE PROFILE
    // =========================================================

    @PostMapping("/travel-profile")public ResponseEntity<?> saveProfile(
            @RequestBody TravelProfileDTO dto) {

        try {

            if (dto == null || dto.getUserId() == null) {

                return ResponseEntity
                        .badRequest()
                        .body(Map.of(
                                "success", false,
                                "message", "User ID is required"
                        ));
            }

            boolean saved =
                    travelProfileService.saveOrUpdateProfile(dto);

            if (saved) {

                return ResponseEntity.ok(
                        Map.of(
                                "success", true,
                                "message",
                                "Travel profile saved successfully"
                        )
                );
            }

            return ResponseEntity
                    .badRequest()
                    .body(Map.of(
                            "success", false,
                            "message",
                            "Unable to save travel profile"
                    ));

        } catch (Exception e) {

            e.printStackTrace();

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of(
                            "success", false,
                            "message",
                            "Server error while saving profile"
                    ));
        }
    }

    // =========================================================
    // UPDATE PROFILE
    // =========================================================

    @PutMapping("/travel-profile")public ResponseEntity<?> updateProfile(
            @RequestBody TravelProfileDTO dto) {

        try {

            if (dto == null || dto.getUserId() == null) {

                return ResponseEntity
                        .badRequest()
                        .body(Map.of(
                                "success", false,
                                "message", "User ID is required"
                        ));
            }

            boolean updated =
                    travelProfileService.updateProfile(dto);

            if (updated) {

                return ResponseEntity.ok(
                        Map.of(
                                "success", true,
                                "message",
                                "Travel profile updated successfully"
                        )
                );
            }

            return ResponseEntity
                    .badRequest()
                    .body(Map.of(
                            "success", false,
                            "message",
                            "Unable to update travel profile"
                    ));

        } catch (Exception e) {

            e.printStackTrace();

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of(
                            "success", false,
                            "message",
                            "Server error while updating profile"
                    ));
        }
    }

    // =========================================================
    // UPLOAD PROFILE PHOTO
    // =========================================================
    //
    // Database:
    // profile_photo = "welcome.jpg"
    //
    // Physical file:
    // uploads/images/profile/welcome.jpg
    //
    // URL:
    // http://localhost:8091/uploads/profile/welcome.jpg
    //
    // =========================================================

    @PostMapping("/travel-profile/upload-photo/{userId}")
    public ResponseEntity<?> uploadProfilePhoto(
            @PathVariable Long userId,
            @RequestParam("profilePhoto") MultipartFile file) {

        try {

            if (file == null || file.isEmpty()) {

                return ResponseEntity
                        .badRequest()
                        .body(Map.of(
                                "success", false,
                                "message", "Please select an image"
                        ));
            }

            // -------------------------------------------------
            // Validate image
            // -------------------------------------------------

            String contentType =
                    file.getContentType();

            if (contentType == null ||
                    !contentType.startsWith("image/")) {

                return ResponseEntity
                        .badRequest()
                        .body(Map.of(
                                "success", false,
                                "message",
                                "Only image files are allowed"
                        ));
            }

            // -------------------------------------------------
            // Original file name
            // Example:
            // welcome.jpg
            // -------------------------------------------------

            String originalName =
                    file.getOriginalFilename();

            if (originalName == null ||
                    originalName.trim().isEmpty()) {

                return ResponseEntity
                        .badRequest()
                        .body(Map.of(
                                "success", false,
                                "message",
                                "Invalid image file name"
                        ));
            }

            /*
             * Remove any directory path from the filename.
             * Example:
             *
             * C:\Users\abc\welcome.jpg
             *
             * becomes:
             *
             * welcome.jpg
             */

            String safeOriginalName =
                    Paths.get(originalName)
                            .getFileName()
                            .toString();

            String extension = "";
            int dotIndex = safeOriginalName.lastIndexOf('.');

            if (dotIndex >= 0 && dotIndex < safeOriginalName.length() - 1) {
                extension = safeOriginalName
                        .substring(dotIndex + 1)
                        .toLowerCase(Locale.ENGLISH);
            }

            if (extension.isEmpty()) {
                return ResponseEntity
                        .badRequest()
                        .body(Map.of(
                                "success", false,
                                "message", "Image extension is missing"
                        ));
            }

            Optional<user> currentUser =
                    userRepository.findById(userId);

            if (currentUser.isEmpty()) {
                return ResponseEntity
                        .status(HttpStatus.NOT_FOUND)
                        .body(Map.of(
                                "success", false,
                                "message", "User not found"
                        ));
            }

            String fullName = currentUser.get().getFullName();
            String firstName = "profile";

            if (fullName != null && !fullName.trim().isEmpty()) {
                firstName = fullName.trim().split("\\s+")[0];
            }

            firstName = firstName
                    .replaceAll("[^A-Za-z0-9]", "")
                    .toLowerCase(Locale.ENGLISH);

            if (firstName.isEmpty()) {
                firstName = "profile";
            }

            String fileName = firstName + "." + extension;

            // -------------------------------------------------
            // Profile image directory
            // uploads/images/profile/
            // -------------------------------------------------

            Path baseUploadPath =
                    Paths.get(uploadDir)
                            .toAbsolutePath()
                            .normalize();

            Path profileUploadPath =
                    baseUploadPath
                            .resolve("profile")
                            .normalize();

            Files.createDirectories(
                    profileUploadPath
            );

            // -------------------------------------------------
            // Final file path
            // -------------------------------------------------

            Path targetPath =
                    profileUploadPath
                            .resolve(fileName)
                            .normalize();

            // Security check
            if (!targetPath.startsWith(profileUploadPath)) {

                return ResponseEntity
                        .badRequest()
                        .body(Map.of(
                                "success", false,
                                "message",
                                "Invalid file path"
                        ));
            }

            // -------------------------------------------------
            // Save original filename
            // -------------------------------------------------

            Files.copy(
                    file.getInputStream(),
                    targetPath,
                    StandardCopyOption.REPLACE_EXISTING
            );

            // -------------------------------------------------
            // Save ONLY filename into database
            // -------------------------------------------------

            boolean updated =
                    travelProfileService.updateProfilePhoto(
                            userId,
                            fileName
                    );

            if (!updated) {

                return ResponseEntity
                        .badRequest()
                        .body(Map.of(
                                "success", false,
                                "message",
                                "Profile photo database update failed"
                        ));
            }

            Map<String, Object> response =
                    new HashMap<>();

            response.put(
                    "success",
                    true
            );

            response.put(
                    "message",
                    "Profile photo uploaded successfully"
            );

            response.put(
                    "data",
                    fileName
            );

            response.put(
                    "imageUrl",
                    "/uploads/profile/" + fileName
            );

            return ResponseEntity.ok(
                    response
            );

        } catch (IOException e) {

            e.printStackTrace();

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of(
                            "success", false,
                            "message",
                            "Unable to upload profile photo"
                    ));

        } catch (Exception e) {

            e.printStackTrace();

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of(
                            "success", false,
                            "message",
                            "Server error during photo upload"
                    ));
        }
    }

    // =========================================================
    // DELETE PROFILE
    // =========================================================

    @DeleteMapping("/travel-profile/{userId}")
    public ResponseEntity<?> deleteProfile(
            @PathVariable Long userId) {

        try {

            int result =
                    travelProfileService.deleteProfile(userId);

            if (result > 0) {

                return ResponseEntity.ok(
                        Map.of(
                                "success", true,
                                "message",
                                "Profile deleted successfully"
                        )
                );
            }

            return ResponseEntity
                    .badRequest()
                    .body(Map.of(
                            "success", false,
                            "message",
                            "Profile not found"
                    ));

        } catch (Exception e) {

            e.printStackTrace();

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of(
                            "success", false,
                            "message",
                            "Unable to delete profile"
                    ));
        }
    }
}

