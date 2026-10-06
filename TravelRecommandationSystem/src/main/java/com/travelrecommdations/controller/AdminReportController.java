package com.travelrecommdations.controller;

import com.travelrecommdations.serviceImpl.AdminReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api")
public class AdminReportController {

    @Autowired
    private AdminReportService adminReportService;

    @GetMapping("/admin/reports/analytics")
    public ResponseEntity<Map<String, Object>> getAnalytics(
            @RequestParam(defaultValue = "6m") String period,
            @RequestParam(defaultValue = "all") String category
    ) {
        Map<String, Object> data = adminReportService.getAnalytics();
        return ResponseEntity.ok(data);
    }
}