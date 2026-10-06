package com.travelrecommdations.dto;

public class TravelProfileDTO {

    private Long profileId;
    private Long userId;

    private String profilePhoto;
    private Integer age;
    private String location;
    private String travelCompanion;

    private Double budget;
    private String tripDuration;
    private String transportation;
    private String accommodation;

    private String interests;
    private String destinationCategories;

    private String foodPreference;
    private String preferredSeason;
    private String tripExperience;

    private Boolean profileCompleted;

    public Long getProfileId() {
        return profileId;
    }

    public void setProfileId(Long profileId) {
        this.profileId = profileId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getProfilePhoto() {
        return profilePhoto;
    }

    public void setProfilePhoto(String profilePhoto) {
        this.profilePhoto = profilePhoto;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getTravelCompanion() {
        return travelCompanion;
    }

    public void setTravelCompanion(String travelCompanion) {
        this.travelCompanion = travelCompanion;
    }

    public Double getBudget() {
        return budget;
    }

    public void setBudget(Double budget) {
        this.budget = budget;
    }

    public String getTripDuration() {
        return tripDuration;
    }

    public void setTripDuration(String tripDuration) {
        this.tripDuration = tripDuration;
    }

    public String getTransportation() {
        return transportation;
    }

    public void setTransportation(String transportation) {
        this.transportation = transportation;
    }

    public String getAccommodation() {
        return accommodation;
    }

    public void setAccommodation(String accommodation) {
        this.accommodation = accommodation;
    }

    public String getInterests() {
        return interests;
    }

    public void setInterests(String interests) {
        this.interests = interests;
    }

    public String getDestinationCategories() {
        return destinationCategories;
    }

    public void setDestinationCategories(String destinationCategories) {
        this.destinationCategories = destinationCategories;
    }

    public String getFoodPreference() {
        return foodPreference;
    }

    public void setFoodPreference(String foodPreference) {
        this.foodPreference = foodPreference;
    }

    public String getPreferredSeason() {
        return preferredSeason;
    }

    public void setPreferredSeason(String preferredSeason) {
        this.preferredSeason = preferredSeason;
    }

    public String getTripExperience() {
        return tripExperience;
    }

    public void setTripExperience(String tripExperience) {
        this.tripExperience = tripExperience;
    }

    public Boolean getProfileCompleted() {
        return profileCompleted;
    }

    public void setProfileCompleted(Boolean profileCompleted) {
        this.profileCompleted = profileCompleted;
    }
}