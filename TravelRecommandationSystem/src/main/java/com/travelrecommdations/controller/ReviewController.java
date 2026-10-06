package com.travelrecommdations.controller;

import com.travelrecommdations.dto.ApiResponse;
import com.travelrecommdations.model.Review;
import com.travelrecommdations.serviceImpl.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")

public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    @PostMapping("/reviews")public ResponseEntity<ApiResponse<String>> addReview(@RequestBody Review review) {
        try {
            boolean saved = reviewService.saveReview(review);
            if (!saved) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body(new ApiResponse<>(false, "Failed to submit review.", null));
            }
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(new ApiResponse<>(true, "Review submitted successfully!", null));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, "Error: " + e.getMessage(), null));
        }
    }

    @GetMapping("/reviews/user/{userId}")
    public ResponseEntity<ApiResponse<List<Review>>> getReviewsByUserId(@PathVariable Long userId) {
        try {
            List<Review> reviews = reviewService.getReviewsByUserId(userId);
            return ResponseEntity.ok(new ApiResponse<>(true, "Fetched successfully", reviews));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, "Error: " + e.getMessage(), null));
        }
    }

    @GetMapping("/reviews/admin/all")
    public ResponseEntity<ApiResponse<List<Review>>> getAllReviewsForAdmin() {
        try {
            List<Review> reviews = reviewService.getAllReviewsWithDetails();
            return ResponseEntity.ok(new ApiResponse<>(true, "All reviews fetched for admin", reviews));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, "Error: " + e.getMessage(), null));
        }
    }

    @DeleteMapping("/reviews/admin/{reviewId}")
    public ResponseEntity<ApiResponse<String>> deleteReviewByAdmin(@PathVariable Long reviewId) {
        try {
            boolean deleted = reviewService.deleteReview(reviewId);
            if (deleted) {
                return ResponseEntity.ok(new ApiResponse<>(true, "Review deleted successfully", null));
            }
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, "Could not delete review", null));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, "Error: " + e.getMessage(), null));
        }
    }
}

