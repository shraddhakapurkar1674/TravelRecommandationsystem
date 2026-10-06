package com.travelrecommdations.dto;
import java.time.LocalDateTime;

public class AdminUserResponseDTO {
    private Long id;
    private String fullName;
    private String email;
    private String role;
    private LocalDateTime createdAt;
    
    // Travel Profile Fields
    private Long profileId;
    private String profilePhoto;
    private Integer age;
    private String location;
    private String travelCompanion;
    private Double budget;

    // Constructors, Getters, and Setters
    public AdminUserResponseDTO(Long id, String fullName, String email, String role, LocalDateTime createdAt,
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