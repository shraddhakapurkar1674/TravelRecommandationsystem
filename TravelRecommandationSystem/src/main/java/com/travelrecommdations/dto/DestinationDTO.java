package com.travelrecommdations.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public class DestinationDTO {

    private Long id;

    @NotBlank(message = "Destination name is required")
    @Size(max = 200, message = "Destination name must not exceed 200 characters")
    private String destinationName;

    @NotBlank(message = "State is required")
    @Size(max = 100, message = "State must not exceed 100 characters")
    private String state;

    @NotBlank(message = "Country is required")
    @Size(max = 100, message = "Country must not exceed 100 characters")
    private String country;

    @NotBlank(message = "Category is required")
    @Size(max = 100, message = "Category must not exceed 100 characters")
    private String category;

    @NotNull(message = "Budget is required")
    @DecimalMin(value = "0.0", message = "Budget cannot be negative")
    private Double budget;

    @NotBlank(message = "Best season is required")
    @Size(max = 100, message = "Best season must not exceed 100 characters")
    private String bestSeason;

    @NotBlank(message = "Description is required")
    private String description;

    /*
     * IMPORTANT:
     *
     * Store ONLY filename.
     *
     * Example:
     * Goa.jpg
     * Manali.jpg
     * Jaipur.jpg
     *
     * NOT:
     * /images/Goa.jpg
     * images/Goa.jpg
     * D:/Travel...
     */
    private String image;

    private String status;

    // ----------------------------------------------------
    // GETTERS AND SETTERS
    // ----------------------------------------------------

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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
}