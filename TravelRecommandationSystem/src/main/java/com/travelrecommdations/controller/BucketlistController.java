package com.travelrecommdations.controller;

import com.travelrecommdations.dto.ApiResponse;
import com.travelrecommdations.model.Destination;
import com.travelrecommdations.serviceImpl.BucketlistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")

public class BucketlistController {

    @Autowired
    private BucketlistService bucketlistService;

    @PostMapping("/bucketlist/add")
    public ResponseEntity<ApiResponse<String>> addToBucketlist(
            @RequestParam Long userId,
            @RequestParam Long destinationId) {
        try {
            boolean success = bucketlistService.addDestination(userId, destinationId);
            if (success) {
                return ResponseEntity.ok(new ApiResponse<>(true, "Added to bucketlist successfully!", null));
            }
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, "Failed to add to bucketlist", null));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, e.getMessage(), null));
        }
    }

    @DeleteMapping("/bucketlist/remove")
    public ResponseEntity<ApiResponse<String>> removeFromBucketlist(
            @RequestParam Long userId,
            @RequestParam Long destinationId) {
        try {
            boolean success = bucketlistService.removeDestination(userId, destinationId);
            if (success) {
                return ResponseEntity.ok(new ApiResponse<>(true, "Removed from bucketlist successfully!", null));
            }
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new ApiResponse<>(false, "Item not found in bucketlist", null));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, e.getMessage(), null));
        }
    }

    @GetMapping("/bucketlist/user/{userId}")
    public ResponseEntity<ApiResponse<List<Destination>>> getUserBucketlist(@PathVariable Long userId) {
        try {
            List<Destination> destinations = bucketlistService.getUserBucketlist(userId);
            return ResponseEntity.ok(new ApiResponse<>(true, "Bucketlist fetched successfully", destinations));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, e.getMessage(), null));
        }
    }
}
