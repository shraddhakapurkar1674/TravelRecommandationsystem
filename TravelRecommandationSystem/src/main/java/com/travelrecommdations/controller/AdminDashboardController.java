package com.travelrecommdations.controller;

import com.travelrecommdations.serviceImpl.DashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api")

public class AdminDashboardController {

    @Autowired
    private DashboardService dashboardService;

    @GetMapping("/admin/dashboard/stats")
    public ResponseEntity<Map<String, Object>> getDashboardStats() {
        Map<String, Object> stats = dashboardService.getDashboardData();
        return ResponseEntity.ok(stats);
    }
}
