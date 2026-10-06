package com.travelrecommdations.controller;

import com.travelrecommdations.dto.RecommendationDTO;
import com.travelrecommdations.serviceImpl.RecommendationService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class RecommendationController {

    @Autowired
    private RecommendationService recommendationService;


    // =====================================================
    // FOR YOU
    // =====================================================

    /*
     * Uses logged-in user's TravelProfile.
     *
     * Example:
     * GET /api/recommendations/1
     */
    @GetMapping("/recommendations/{userId}")
    public ResponseEntity<List<RecommendationDTO>>
    getRecommendations(
            @PathVariable Long userId) {

        if (userId == null) {
            return ResponseEntity.badRequest().build();
        }

        List<RecommendationDTO> recommendations =
                recommendationService
                        .getRecommendationsForUser(userId);

        return ResponseEntity.ok(recommendations);
    }


    // =====================================================
    // BUDGET
    // =====================================================

    @GetMapping("/recommendations/budget")
    public ResponseEntity<List<RecommendationDTO>>
    getByBudget(
            @RequestParam Double minBudget,
            @RequestParam Double maxBudget) {

        if (minBudget == null ||
            maxBudget == null ||
            minBudget < 0 ||
            maxBudget < minBudget) {

            return ResponseEntity.badRequest().build();
        }

        List<RecommendationDTO> recommendations =
                recommendationService.getByBudget(
                        minBudget,
                        maxBudget
                );

        return ResponseEntity.ok(recommendations);
    }


    // =====================================================
    // MOOD
    // =====================================================

    @GetMapping("/recommendations/mood/{mood}")
    public ResponseEntity<List<RecommendationDTO>>
    getByMood(
            @PathVariable String mood) {

        if (mood == null ||
            mood.trim().isEmpty()) {

            return ResponseEntity.badRequest().build();
        }

        List<RecommendationDTO> recommendations =
                recommendationService.getByMood(mood);

        return ResponseEntity.ok(recommendations);
    }


    // =====================================================
    // SEASON
    // =====================================================

    @GetMapping("/recommendations/season/{season}")
    public ResponseEntity<List<RecommendationDTO>>
    getBySeason(
            @PathVariable String season) {

        if (season == null ||
            season.trim().isEmpty()) {

            return ResponseEntity.badRequest().build();
        }

        List<RecommendationDTO> recommendations =
                recommendationService.getBySeason(season);

        return ResponseEntity.ok(recommendations);
    }


    // =====================================================
    // RECOMMENDATION DETAILS
    // =====================================================

    /*
     * Used ONLY when destination is opened from
     * Recommendation -> View Destination.
     *
     * Example:
     *
     * /api/recommendations/details/5?userId=1
     *
     * This returns:
     *
     * - Overall match
     * - Budget match
     * - Season match
     * - Interest match
     * - Category match
     * - Location match
     */
    @GetMapping("/recommendations/details/{destinationId}")
    public ResponseEntity<RecommendationDTO>
    getRecommendationDetails(
            @PathVariable Long destinationId,
            @RequestParam Long userId) {

        if (destinationId == null ||
            userId == null) {

            return ResponseEntity.badRequest().build();
        }

        RecommendationDTO recommendation =
                recommendationService
                        .getRecommendationDetails(
                                destinationId,
                                userId
                        );

        if (recommendation == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(recommendation);
    }
 // =====================================================
    // PERSONALIZED FILTER
    // =====================================================

    		@GetMapping("/recommendations/personalized")
    	    public ResponseEntity<?> getPersonalizedDestinations(
    	            @RequestParam(required = false) Double minBudget,
    	            @RequestParam(required = false) Double maxBudget,
    	            @RequestParam(required = false) String season,
    	            @RequestParam(required = false) String mood,
    	            @RequestParam(required = false) String category,
    	            @RequestParam(required = false) String companion) {

    	        // PRINT STATEMENT TO DEBUG FRONTEND VALUES
    	        System.out.println("=== PERSONALIZED FILTER CALLED ===");
    	        System.out.println("minBudget: " + minBudget);
    	        System.out.println("maxBudget: " + maxBudget);
    	        System.out.println("season: " + season);
    	        System.out.println("mood: " + mood);
    	        System.out.println("category: " + category);
    	        System.out.println("companion: " + companion);

    	        try {
    	            List<RecommendationDTO> recommendations = 
    	                    recommendationService.getPersonalizedDestinations(minBudget, maxBudget, season, mood, category, companion);
    	            System.out.println("Found Destinations Count: " + (recommendations != null ? recommendations.size() : 0));
    	            return ResponseEntity.ok(recommendations);
    	        } catch (Exception e) {
    	            e.printStackTrace();
    	            return ResponseEntity.status(500).body("Error: " + e.getMessage());
    	        }
    	    }
    
}

