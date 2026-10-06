package com.travelrecommdations.serviceImpl;

import com.travelrecommdations.repository.DashboardDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DashboardService {

    @Autowired
    private DashboardDao dashboardDao;

    public Map<String, Object> getDashboardData() {
        Map<String, Object> data = new HashMap<>();

        // 1. Metric Counts
        data.put("totalUsers", dashboardDao.getTotalUsersCount());
        data.put("totalDestinations", dashboardDao.getDestinationsCount());
        data.put("totalHotels", dashboardDao.getHotelsCount());
        data.put("totalTransport", dashboardDao.getTransportCount());
        data.put("totalActivities", dashboardDao.getActivitiesCount());
        data.put("totalReviews", dashboardDao.getUserPreferencesCount());

        // Bookings (Default placeholders)
        data.put("totalBookings", 0);
        data.put("confirmedBookings", 0);
        data.put("pendingBookings", 0);

        // 2. Rankings & Data Lists
        data.put("topDestinations", formatList(dashboardDao.getTop5Destinations(), "destination_name", "name"));
        data.put("topHotels", formatList(dashboardDao.getTop5Hotels(), "hotel_name", "name"));
        data.put("topTransport", formatList(dashboardDao.getTop5Transports(), "type", "name"));
        data.put("topActivities", formatList(dashboardDao.getTop5Activities(), "activity_name", "name"));

        // 3. Recent Users
        List<Map<String, Object>> formattedUsers = new ArrayList<>();
        for (Map<String, Object> u : dashboardDao.getRecentUsers()) {
            Map<String, Object> map = new HashMap<>();
            Object nameObj = u.getOrDefault("full_name", u.getOrDefault("name", u.getOrDefault("username", "User")));
            map.put("name", nameObj != null ? nameObj.toString() : "User");
            map.put("email", u.getOrDefault("email", ""));
            map.put("date", "Recent");
            formattedUsers.add(map);
        }
        data.put("recentUsers", formattedUsers);

        // Placeholders
        data.put("recentReviews", new ArrayList<>());
        data.put("latestBookings", new ArrayList<>());

        return data;
    }

    private List<Map<String, Object>> formatList(List<Map<String, Object>> rawList, String primaryNameKey, String secondaryNameKey) {
        List<Map<String, Object>> result = new ArrayList<>();
        for (Map<String, Object> row : rawList) {
            Map<String, Object> map = new HashMap<>();
            Object name = row.getOrDefault(primaryNameKey, row.getOrDefault(secondaryNameKey, "Item"));
            map.put("name", name != null ? name.toString() : "Item");
            map.put("rating", row.getOrDefault("rating", "4.5"));
            map.put("views", row.getOrDefault("views", 100));
            map.put("bookings", row.getOrDefault("bookings", 10));
            map.put("imageUrl", row.getOrDefault("image", ""));
            result.add(map);
        }
        return result;
    }
}