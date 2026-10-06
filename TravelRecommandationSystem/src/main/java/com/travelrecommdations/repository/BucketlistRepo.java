package com.travelrecommdations.repository;

import com.travelrecommdations.model.Destination;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class BucketlistRepo{

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // RowMapper to map destination records
    private final RowMapper<Destination> rowMapper = (rs, rowNum) -> {
        Destination dest = new Destination();
        dest.setId(rs.getLong("id"));
        dest.setDestinationName(rs.getString("destination_name"));
        dest.setState(rs.getString("state"));
        dest.setCountry(rs.getString("country"));
        dest.setCategory(rs.getString("category"));
        dest.setBudget(rs.getObject("budget", Double.class));
        dest.setBestSeason(rs.getString("best_season"));
        dest.setDescription(rs.getString("description"));
        dest.setImage(rs.getString("image"));
        dest.setStatus(rs.getString("status"));
        return dest;
    };

    // Add destination to bucketlist
    public int addToBucketlist(Long userId, Long destinationId) {
        String sql = "INSERT INTO bucket_list (user_id, destination_id) VALUES (?, ?)";
        return jdbcTemplate.update(sql, userId, destinationId);
    }

    // Remove from bucketlist
    public int removeFromBucketlist(Long userId, Long destinationId) {
        String sql = "DELETE FROM bucket_list WHERE user_id = ? AND destination_id = ?";
        return jdbcTemplate.update(sql, userId, destinationId);
    }

    // Get all bucketlist destinations for a specific user
    public List<Destination> getBucketlistByUser(Long userId) {
        String sql = "SELECT d.* FROM destination d JOIN bucket_list b ON d.id = b.destination_id WHERE b.user_id = ? ORDER BY b.id DESC";
        return jdbcTemplate.query(sql, rowMapper, userId);
    }

    // Check if destination is already in user's bucketlist
    public boolean isAlreadyInBucketlist(Long userId, Long destinationId) {
        String sql = "SELECT COUNT(*) FROM bucket_list WHERE user_id = ? AND destination_id = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, userId, destinationId);
        return count != null && count > 0;
    }
}