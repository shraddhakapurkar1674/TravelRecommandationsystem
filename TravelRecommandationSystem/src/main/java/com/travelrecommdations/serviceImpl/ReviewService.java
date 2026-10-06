package com.travelrecommdations.serviceImpl;

import com.travelrecommdations.model.Review;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Service
public class ReviewService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public boolean saveReview(Review review) {
        if (review.getUserId() == null) {
            throw new IllegalArgumentException("User ID cannot be null");
        }

        Long destinationId = review.getDestinationId();

        if (destinationId == null) {
            String cleanDestName = (review.getDestinationName() != null) ? review.getDestinationName().trim() : "";
            if (cleanDestName.isEmpty()) {
                throw new IllegalArgumentException("Destination name or ID cannot be empty");
            }

            String findDestSql = "SELECT id FROM destination WHERE LOWER(destination_name) = LOWER(?)";
            try {
                destinationId = jdbcTemplate.queryForObject(findDestSql, Long.class, cleanDestName);
            } catch (Exception e) {
                throw new IllegalArgumentException("Destination '" + cleanDestName + "' does not exist in the database.");
            }
        }

        String sql = "INSERT INTO user_reviews (user_id, destination_id, rating, comment) VALUES (?, ?, ?, ?)";
        int rowsAffected = jdbcTemplate.update(
                sql,
                review.getUserId(),
                destinationId,
                review.getRating(),
                review.getComment()
        );
        return rowsAffected > 0;
    }

    public List<Review> getReviewsByUserId(Long userId) {
        try {
            // Using LEFT JOIN so reviews display even if user/destination join has loose references
            String sql = "SELECT r.review_id AS reviewId, r.user_id AS userId, r.destination_id AS destinationId, " +
                         "r.rating AS rating, r.comment AS comment, r.created_at AS createdAt, " +
                         "COALESCE(u.full_name, 'Unknown User') AS userName, " +
                         "COALESCE(d.destination_name, 'Unknown Destination') AS destinationName " +
                         "FROM user_reviews r " +
                         "LEFT JOIN users u ON r.user_id = u.id " +
                         "LEFT JOIN destination d ON r.destination_id = d.id " +
                         "WHERE r.user_id = ? " +
                         "ORDER BY r.created_at DESC";

            return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Review.class), userId);
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public List<Review> getAllReviewsWithDetails() {
        try {
            // Using LEFT JOIN for admin view to ensure all review cards appear without failing
            String sql = "SELECT r.review_id AS reviewId, r.user_id AS userId, r.destination_id AS destinationId, " +
                         "r.rating AS rating, r.comment AS comment, r.created_at AS createdAt, " +
                         "COALESCE(u.full_name, 'Unknown User') AS userName, " +
                         "COALESCE(d.destination_name, 'Unknown Destination') AS destinationName " +
                         "FROM user_reviews r " +
                         "LEFT JOIN users u ON r.user_id = u.id " +
                         "LEFT JOIN destination d ON r.destination_id = d.id " +
                         "ORDER BY r.created_at DESC";

            return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Review.class));
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public boolean deleteReview(Long reviewId) {
        try {
            String sql = "DELETE FROM user_reviews WHERE review_id = ?";
            int rowsAffected = jdbcTemplate.update(sql, reviewId);
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}