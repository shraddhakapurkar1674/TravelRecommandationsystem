package com.travelrecommdations.dto;

import java.util.List;
import org.springframework.web.multipart.MultipartFile;

public class PackageDTO {
    private Long packageId;
    private String packageName;
    private String duration;
    private Double price;
    private String packageType;
    private String description;
    private String includedServices;
    private String excludedServices;
    private String status;
    
    private List<DestinationItemDTO> destinations;

    public static class DestinationItemDTO {
        private String destinationName;
        private MultipartFile imageFile; // Actual file being uploaded
        private String imageName; // Fallback or existing image name

        public String getDestinationName() { return destinationName; }
        public void setDestinationName(String destinationName) { this.destinationName = destinationName; }
        public MultipartFile getImageFile() { return imageFile; }
        public void setImageFile(MultipartFile imageFile) { this.imageFile = imageFile; }
        public String getImageName() { return imageName; }
        public void setImageName(String imageName) { this.imageName = imageName; }
    }

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
    public List<DestinationItemDTO> getDestinations() { return destinations; }
    public void setDestinations(List<DestinationItemDTO> destinations) { this.destinations = destinations; }
}