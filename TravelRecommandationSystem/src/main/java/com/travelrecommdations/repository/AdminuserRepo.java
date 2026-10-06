package com.travelrecommdations.repository;


import com.travelrecommdations.model.user;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;


import java.time.LocalDateTime;

public class AdminuserRepo {
    private Long id;
    private String fullName;
    private String email;
    private String role;
    private LocalDateTime createdAt;
    
    private Long profileId;
    private String profilePhoto;
    private Integer age;
    private String location;
    private String travelCompanion;
    private Double budget;

    public AdminuserRepo(Long id, String fullName, String email, String role, LocalDateTime createdAt,
                                Long profileId, String profilePhoto, Integer age, String location, 
                                String travelCompanion, Double budget) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.role = role;
        this.createdAt = createdAt;
        this.profileId = profileId;
        this.profilePhoto = profilePhoto;
        this.age = age;
        this.location = location;
        this.travelCompanion = travelCompanion;
        this.budget = budget;
    }

    public Long getId() { return id; }
    public String getFullName() { return fullName; }
    public String getEmail() { return email; }
    public String getRole() { return role; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public Long getProfileId() { return profileId; }
    public String getProfilePhoto() { return profilePhoto; }
    public Integer getAge() { return age; }
    public String getLocation() { return location; }
    public String getTravelCompanion() { return travelCompanion; }
    public Double getBudget() { return budget; }
}