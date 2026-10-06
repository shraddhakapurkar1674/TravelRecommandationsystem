package com.travelrecommdations.dto;

public class RecommendationDTO {

    private Long destinationId;
    private String destinationName;
    private String state;
    private String country;
    private String category;
    private Double budget;
    private String bestSeason;
    private String description;
    private String image;
    private String status;

    // Recommendation factor percentages
    private Double matchPercentage;
    private Double budgetMatch;
    private Double seasonMatch;
    private Double interestMatch;
    private Double categoryMatch;
    private Double locationMatch;

    private String recommendationType;
    private String recommendationReason;

    // =====================================================
    // GETTERS AND SETTERS
    // =====================================================

    public Long getDestinationId() {
        return destinationId;
    }

    public void setDestinationId(Long destinationId) {
        this.destinationId = destinationId;
    }

    public String getDestinationName() {
        return destinationName;
    }

    public void setDestinationName(String destinationName) {
        this.destinationName = destinationName;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Double getBudget() {
        return budget;
    }

    public void setBudget(Double budget) {
        this.budget = budget;
    }

    public String getBestSeason() {
        return bestSeason;
    }

    public void setBestSeason(String bestSeason) {
        this.bestSeason = bestSeason;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // =====================================================
    // RECOMMENDATION SCORES
    // =====================================================

    public Double getMatchPercentage() {
        return matchPercentage;
    }

    public void setMatchPercentage(Double matchPercentage) {
        this.matchPercentage = matchPercentage;
    }

    public Double getBudgetMatch() {
        return budgetMatch;
    }

    public void setBudgetMatch(Double budgetMatch) {
        this.budgetMatch = budgetMatch;
    }

    public Double getSeasonMatch() {
        return seasonMatch;
    }

    public void setSeasonMatch(Double seasonMatch) {
        this.seasonMatch = seasonMatch;
    }

    public Double getInterestMatch() {
        return interestMatch;
    }

    public void setInterestMatch(Double interestMatch) {
        this.interestMatch = interestMatch;
    }

    public Double getCategoryMatch() {
        return categoryMatch;
    }

    public void setCategoryMatch(Double categoryMatch) {
        this.categoryMatch = categoryMatch;
    }

    public Double getLocationMatch() {
        return locationMatch;
    }

    public void setLocationMatch(Double locationMatch) {
        this.locationMatch = locationMatch;
    }

    public String getRecommendationReason() {
        return recommendationReason;
    }

    public void setRecommendationReason(String recommendationReason) {
        this.recommendationReason = recommendationReason;
    }

    // =====================================================
    // RECOMMENDATION TYPE
    // =====================================================

    public String getRecommendationType() {
        return recommendationType;
    }

    public void setRecommendationType(String recommendationType) {
        this.recommendationType = recommendationType;
    }
}