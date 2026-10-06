package com.travelrecommdations.model;

import java.util.List;

public class Package {
    private Long packageId;
    private String packageName;
    private String duration;
    private Double price;
    private String packageType;
    private String description;
    private String includedServices;
    private String excludedServices;
    private String status;
    private String createdAt;
    
    private List<PackageDestination> destinations;

    // Getters and Setters
    public Long getPackageId() { return packageId; }
    public void setPackageId(Long packageId) { this.packageId = packageId; }
    public String getPackageName() { return packageName; }
    public void setPackageName(String packageName) { this.packageName = packageName; }
    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }
    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }
    public String getPackageType() { return packageType; }
    public void setPackageType(String packageType) { this.packageType = packageType; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getIncludedServices() { return includedServices; }
    public void setIncludedServices(String includedServices) { this.includedServices = includedServices; }
    public String getExcludedServices() { return excludedServices; }
    public void setExcludedServices(String excludedServices) { this.excludedServices = excludedServices; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    public List<PackageDestination> getDestinations() { return destinations; }
    public void setDestinations(List<PackageDestination> destinations) { this.destinations = destinations; }
}
