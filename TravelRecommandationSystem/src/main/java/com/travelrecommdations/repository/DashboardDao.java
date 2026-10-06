package com.travelrecommdations.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Repository
public class DashboardDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // --- 1. SAFE COUNTS ---
    public int getTotalUsersCount() {
        return queryForIntSafely("SELECT COUNT(*) FROM users");
    }

    public int getDestinationsCount() {
        return queryForIntSafely("SELECT COUNT(*) FROM destination");
    }

    public int getHotelsCount() {
        return queryForIntSafely("SELECT COUNT(*) FROM hotel");
    }

    public int getTransportCount() {
        return queryForIntSafely("SELECT COUNT(*) FROM transport");
    }

    public int getActivitiesCount() {
        return queryForIntSafely("SELECT COUNT(*) FROM activity");
    }

    public int getUserPreferencesCount() {
        return queryForIntSafely("SELECT COUNT(*) FROM user_prefrence");
    }

    // --- 2. SAFE LIST QUERIES ---
    public List<Map<String, Object>> getTop5Destinations() {
        return queryForListSafely("SELECT * FROM destination LIMIT 5");
    }

    public List<Map<String, Object>> getTop5Hotels() {
        return queryForListSafely("SELECT * FROM hotel LIMIT 5");
    }

    public List<Map<String, Object>> getTop5Transports() {
        return queryForListSafely("SELECT * FROM transport LIMIT 5");
    }

    public List<Map<String, Object>> getTop5Activities() {
        return queryForListSafely("SELECT * FROM activity LIMIT 5");
    }

    public List<Map<String, Object>> getRecentUsers() {
        return queryForListSafely("SELECT * FROM users ORDER BY id DESC LIMIT 5");
    }

    // --- HELPER METHODS TO PREVENT 500 SERVER ERRORS ---
    private int queryForIntSafely(String sql) {
        try {
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class);
            return count != null ? count : 0;
        } catch (Exception e) {
            System.err.println("DAO Count Query Failed [" + sql + "]: " + e.getMessage());
            return 0;
        }
    }

    private List<Map<String, Object>> queryForListSafely(String sql) {
        try {
            return jdbcTemplate.queryForList(sql);
        } catch (Exception e) {
            System.err.println("DAO List Query Failed [" + sql + "]: " + e.getMessage());
            return new ArrayList<>();
        }
    }
    
    
}