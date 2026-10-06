package com.travelrecommdations.controller;

import com.travelrecommdations.model.Notification;
import com.travelrecommdations.model.user;
import com.travelrecommdations.repository.userRepo;
import com.travelrecommdations.serviceImpl.NotificationService;
import com.travelrecommdations.util.JwtUtil;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api")

public class NotificationController {

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private userRepo userRepository;


    // =========================================================
    // GET LOGGED-IN USER ID FROM JWT
    // =========================================================

    private Long getLoggedInUserId(HttpServletRequest request) {

        String authorizationHeader =
                request.getHeader("Authorization");

        if (authorizationHeader == null ||
                !authorizationHeader.startsWith("Bearer ")) {

            return null;
        }

        try {

            String token =
                    authorizationHeader.substring(7);

            // JWT subject contains user's email
            String email =
                    jwtUtil.extractEmail(token);

            Optional<user> userOptional =
                    userRepository.findByEmail(email);

            if (userOptional.isPresent()) {

                return userOptional.get().getId();
            }

        } catch (Exception e) {

            System.out.println(
                    "JWT Error: " + e.getMessage()
            );
        }

        return null;
    }


    // =========================================================
    // USER - GET ALL NOTIFICATIONS
    // =========================================================

    @GetMapping("/notifications/user")
    public ResponseEntity<?> getUserNotifications(
            HttpServletRequest request) {

        Long userId =
                getLoggedInUserId(request);

        if (userId == null) {

            return ResponseEntity
                    .status(401)
                    .body("User not logged in");
        }

        List<Notification> notifications =
                notificationService
                        .getUserNotifications(userId);

        return ResponseEntity.ok(notifications);
    }


    // =========================================================
    // USER - GET UNREAD COUNT
    // =========================================================

    @GetMapping("/notifications/user/unread-count")
    public ResponseEntity<?> getUserUnreadCount(
            HttpServletRequest request) {

        Long userId =
                getLoggedInUserId(request);

        if (userId == null) {

            return ResponseEntity
                    .status(401)
                    .body("User not logged in");
        }

        int count =
                notificationService
                        .getUserUnreadCount(userId);

        return ResponseEntity.ok(count);
    }


    // =========================================================
    // USER - MARK ONE NOTIFICATION AS READ
    // =========================================================

    @PutMapping("/notifications/user/{notificationId}/read")
    public ResponseEntity<?> markAsRead(
            @PathVariable Long notificationId,
            HttpServletRequest request) {

        Long userId =
                getLoggedInUserId(request);

        if (userId == null) {

            return ResponseEntity
                    .status(401)
                    .body("User not logged in");
        }

        boolean updated =
                notificationService.markAsRead(
                        notificationId,
                        userId
                );

        if (updated) {

            return ResponseEntity.ok(
                    "Notification marked as read"
            );
        }

        return ResponseEntity
                .badRequest()
                .body(
                        "Notification already read or not found"
                );
    }


    // =========================================================
    // USER - MARK ALL NOTIFICATIONS AS READ
    // =========================================================

    @PutMapping("/notifications/user/read-all")
    public ResponseEntity<?> markAllUserAsRead(
            HttpServletRequest request) {

        Long userId =
                getLoggedInUserId(request);

        if (userId == null) {

            return ResponseEntity
                    .status(401)
                    .body("User not logged in");
        }

        notificationService
                .markAllUserAsRead(userId);

        return ResponseEntity.ok(
                "All notifications marked as read"
        );
    }


    // =========================================================
    // ADMIN - GET NOTIFICATIONS
    // =========================================================

    @GetMapping("/notifications/admin")
    public ResponseEntity<List<Notification>>
    getAdminNotifications() {

        return ResponseEntity.ok(
                notificationService
                        .getAdminNotifications()
        );
    }


    // =========================================================
    // ADMIN - GET UNREAD COUNT
    // =========================================================

    @GetMapping("/notifications/admin/unread-count")
    public ResponseEntity<Integer>
    getAdminUnreadCount() {

        return ResponseEntity.ok(
                notificationService
                        .getAdminUnreadCount()
        );
    }


    // =========================================================
    // ADMIN - MARK ONE NOTIFICATION AS READ
    // =========================================================

    @PutMapping("/notifications/admin/{notificationId}/read")
    public ResponseEntity<String>
    markAdminAsRead(
            @PathVariable Long notificationId) {

        boolean updated =
                notificationService
                        .markAdminAsRead(
                                notificationId
                        );

        if (updated) {

            return ResponseEntity.ok(
                    "Admin notification marked as read"
            );
        }

        return ResponseEntity
                .badRequest()
                .body(
                        "Notification not found"
                );
    }


    // =========================================================
    // ADMIN - MARK ALL NOTIFICATIONS AS READ
    // =========================================================

    @PutMapping("/notifications/admin/read-all")
    public ResponseEntity<String>
    markAllAdminAsRead() {

        notificationService
                .markAllAdminAsRead();

        return ResponseEntity.ok(
                "All admin notifications marked as read"
        );
    }
}

