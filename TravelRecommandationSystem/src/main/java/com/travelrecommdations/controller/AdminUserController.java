package com.travelrecommdations.controller;

import com.travelrecommdations.repository.userRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class AdminUserController {

    @Autowired
    private userRepo userRepo;

    @GetMapping("/admin/users")
    public List<Map<String, Object>> getAllUsers() {
        return userRepo.findAllUsersWithProfilesAsMaps();
    }

    @DeleteMapping("/admin/users/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable Long id) {
        userRepo.deleteUserAndProfile(id);
        return ResponseEntity.ok().body("User and profile deleted successfully");
    }
}
