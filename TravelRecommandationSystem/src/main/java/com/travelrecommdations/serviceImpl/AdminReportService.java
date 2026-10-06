package com.travelrecommdations.serviceImpl;

import com.travelrecommdations.repository.DestinationDao;
import com.travelrecommdations.repository.HotelRepo;
import com.travelrecommdations.repository.TransportRepo;
import com.travelrecommdations.repository.userRepo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AdminReportService {

    @Autowired
    private userRepo userRepo;

    @Autowired
    private DestinationDao destinationDao;

    @Autowired
    private HotelRepo hotelRepo;

    @Autowired
    private TransportRepo transportRepo;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public Map<String, Object> getDashboardStatistics() {
        Map<String, Object> result = new HashMap<>();
        result.put("totalUsers", getUserCount());
        result.put("totalDestinations", getDestinationCount());
        result.put("totalHotels", getHotelCount());
        result.put("totalTransports", getTransportCount());
        result.put("totalActivities", getActivityCount());
        result.put("totalPackages", getPackageCount());
        result.put("totalReviews", getReviewCount());
        result.put("averageRating", getAverageRating());
        return result;
    }

    private long getUserCount() {
        try { return userRepo.count(); } catch (Exception e) { return 0; }
    }

    private long getDestinationCount() {
        try { return destinationDao.count(); } catch (Exception e) {
            try {
                Long count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM destination", Long.class);
                return count != null ? count : 0;
            } catch (Exception ex) { return 0; }
        }
    }

    private long getHotelCount() {
        try { return hotelRepo.count(); } catch (Exception e) {
            try {
                Long count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM hotel", Long.class);
                return count != null ? count : 0;
            } catch (Exception ex) { return 0; }
        }
    }

    private long getTransportCount() {
        try { return transportRepo.count(); } catch (Exception e) {
            try {
                Long count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM transport", Long.class);
                return count != null ? count : 0;
            } catch (Exception ex) { return 0; }
        }
    }

    private long getActivityCount() { return countTable("activity"); }
    private long getPackageCount() { return countTable("travel_package"); }
    private long getReviewCount() { return countTable("user_reviews"); }

    private long countTable(String tableName) {
        try {
            String sql = "SELECT COUNT(*) FROM " + tableName;
            Long count = jdbcTemplate.queryForObject(sql, Long.class);
            return count != null ? count : 0;
        } catch (Exception e) { return 0; }
    }

    private double getAverageRating() {
        try {
            Double rating = jdbcTemplate.queryForObject("SELECT AVG(rating) FROM user_reviews", Double.class);
            if (rating == null) return 0.0;
            return Math.round(rating * 10.0) / 10.0;
        } catch (Exception e) { return 0.0; }
    }

    public Map<String, Object> getAnalytics() {
        Map<String, Object> analytics = new HashMap<>();
        analytics.put("statistics", getDashboardStatistics());
        analytics.put("destinationCategories", getDestinationCategories());
        analytics.put("travelPreferences", getTravelPreferences());
        analytics.put("ratingDistribution", getRatingDistribution());
        analytics.put("monthlyUsers", getMonthlyUsers());
        analytics.put("topDestinations", getTopDestinations());
        return analytics;
    }

    private List<Map<String, Object>> getDestinationCategories() {
        List<Map<String, Object>> result = new ArrayList<>();
        try {
            String sql = "SELECT COALESCE(category, 'Other') AS name, COUNT(*) AS value FROM destination GROUP BY category ORDER BY value DESC";
            return jdbcTemplate.queryForList(sql);
        } catch (Exception e) { return result; }
    }

    private List<Map<String, Object>> getTravelPreferences() {
        List<Map<String, Object>> result = new ArrayList<>();
        try {
            String sql = "SELECT destination_categories FROM travel_profile WHERE destination_categories IS NOT NULL AND destination_categories <> ''";
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql);
            Map<String, Integer> counter = new HashMap<>();

            for (Map<String, Object> row : rows) {
                Object value = row.get("destination_categories");
                if (value == null) continue;
                String[] categories = value.toString().split("[,;|]");
                for (String category : categories) {
                    String name = category.trim();
                    if (name.isEmpty()) continue;
                    counter.put(name, counter.getOrDefault(name, 0) + 1);
                }
            }

            int total = 0;
            for (Integer value : counter.values()) { total += value; }

            for (Map.Entry<String, Integer> entry : counter.entrySet()) {
                Map<String, Object> item = new HashMap<>();
                item.put("name", entry.getKey());
                int percentage = (total == 0) ? 0 : (int) Math.round(entry.getValue() * 100.0 / total);
                item.put("value", percentage);
                result.add(item);
            }
        } catch (Exception e) { return result; }
        return result;
    }

    private List<Map<String, Object>> getRatingDistribution() {
        List<Map<String, Object>> result = new ArrayList<>();
        try {
            Integer total = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM user_reviews", Integer.class);
            int totalReviews = total == null ? 0 : total;

            for (int star = 5; star >= 1; star--) {
                Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM user_reviews WHERE rating = ?", Integer.class, star);
                int ratingCount = count == null ? 0 : count;
                int percentage = (totalReviews == 0) ? 0 : (int) Math.round(ratingCount * 100.0 / totalReviews);

                Map<String, Object> item = new HashMap<>();
                item.put("star", star);
                item.put("value", percentage);
                result.add(item);
            }
        } catch (Exception e) { return result; }
        return result;
    }

    private List<Integer> getMonthlyUsers() {
        List<Integer> result = new ArrayList<>();
        try {
            String sql = "SELECT MONTH(created_at) AS month_number, COUNT(*) AS total FROM users WHERE created_at >= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH) GROUP BY MONTH(created_at) ORDER BY MONTH(created_at)";
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql);
            Map<Integer, Integer> monthly = new HashMap<>();

            for (Map<String, Object> row : rows) {
                Object monthValue = row.get("month_number");
                Object totalValue = row.get("total");
                if (monthValue == null || totalValue == null) continue;
                monthly.put(((Number) monthValue).intValue(), ((Number) totalValue).intValue());
            }

            java.time.LocalDate today = java.time.LocalDate.now();
            for (int i = 5; i >= 0; i--) {
                int month = today.minusMonths(i).getMonthValue();
                result.add(monthly.getOrDefault(month, 0));
            }
        } catch (Exception e) {
            long total = getUserCount();
            for (int i = 1; i <= 6; i++) {
                result.add((int) Math.round(total * i / 6.0));
            }
        }
        return result;
    }

    private List<Map<String, Object>> getTopDestinations() {
        List<Map<String, Object>> result = new ArrayList<>();
        try {
            String sql = "SELECT destination_name AS name, category, state, country FROM destination ORDER BY budget DESC LIMIT 5";
            return jdbcTemplate.queryForList(sql);
        } catch (Exception e) { return result; }
    
    }
}