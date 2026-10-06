package com.travelrecommdations.dto;

import java.util.List;
import java.util.Map;

public class DashboardStatsDTO {

    private long totalUsers;
    private long totalDestinations;
    private long totalHotels;
    private long totalTransport;
    private long totalActivities;
    private long totalReviews;

    private long totalBookings;
    private long confirmedBookings;
    private long pendingBookings;

    private List<Map<String, Object>> topDestinations;
    private List<Map<String, Object>> topHotels;
    private List<Map<String, Object>> topTransport;
    private List<Map<String, Object>> topActivities;

    private List<Map<String, Object>> recentReviews;
    private List<Map<String, Object>> recentUsers;
    private List<Map<String, Object>> latestBookings;

    public DashboardStatsDTO() {}

    // Getters and Setters
    public long getTotalUsers() { return totalUsers; }
    public void setTotalUsers(long totalUsers) { this.totalUsers = totalUsers; }

    public long getTotalDestinations() { return totalDestinations; }
    public void setTotalDestinations(long totalDestinations) { this.totalDestinations = totalDestinations; }

    public long getTotalHotels() { return totalHotels; }
    public void setTotalHotels(long totalHotels) { this.totalHotels = totalHotels; }

    public long getTotalTransport() { return totalTransport; }
    public void setTotalTransport(long totalTransport) { this.totalTransport = totalTransport; }

    public long getTotalActivities() { return totalActivities; }
    public void setTotalActivities(long totalActivities) { this.totalActivities = totalActivities; }

    public long getTotalReviews() { return totalReviews; }
    public void setTotalReviews(long totalReviews) { this.totalReviews = totalReviews; }

    public long getTotalBookings() { return totalBookings; }
    public void setTotalBookings(long totalBookings) { this.totalBookings = totalBookings; }

    public long getConfirmedBookings() { return confirmedBookings; }
    public void setConfirmedBookings(long confirmedBookings) { this.confirmedBookings = confirmedBookings; }

    public long getPendingBookings() { return pendingBookings; }
    public void setPendingBookings(long pendingBookings) { this.pendingBookings = pendingBookings; }

    public List<Map<String, Object>> getTopDestinations() { return topDestinations; }
    public void setTopDestinations(List<Map<String, Object>> topDestinations) { this.topDestinations = topDestinations; }

    public List<Map<String, Object>> getTopHotels() { return topHotels; }
    public void setTopHotels(List<Map<String, Object>> topHotels) { this.topHotels = topHotels; }

    public List<Map<String, Object>> getTopTransport() { return topTransport; }
    public void setTopTransport(List<Map<String, Object>> topTransport) { this.topTransport = topTransport; }

    public List<Map<String, Object>> getTopActivities() { return topActivities; }
    public void setTopActivities(List<Map<String, Object>> topActivities) { this.topActivities = topActivities; }

    public List<Map<String, Object>> getRecentReviews() { return recentReviews; }
    public void setRecentReviews(List<Map<String, Object>> recentReviews) { this.recentReviews = recentReviews; }

    public List<Map<String, Object>> getRecentUsers() { return recentUsers; }
    public void setRecentUsers(List<Map<String, Object>> recentUsers) { this.recentUsers = recentUsers; }

    public List<Map<String, Object>> getLatestBookings() { return latestBookings; }
    public void setLatestBookings(List<Map<String, Object>> latestBookings) { this.latestBookings = latestBookings; }
}