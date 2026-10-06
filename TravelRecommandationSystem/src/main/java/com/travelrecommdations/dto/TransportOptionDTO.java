package com.travelrecommdations.dto;

public class TransportOptionDTO {

    private Integer transportId;
    private String transportType;
    private String transportProvider;
    private String pricingType;
    private Double pricingValue;
    private String facilities;
    private Double facilityCharge;
    private String image;

    public TransportOptionDTO() {
    }

    public Integer getTransportId() {
        return transportId;
    }

    public void setTransportId(Integer transportId) {
        this.transportId = transportId;
    }

    public String getTransportType() {
        return transportType;
    }

    public void setTransportType(String transportType) {
        this.transportType = transportType;
    }

    public String getTransportProvider() {
        return transportProvider;
    }

    public void setTransportProvider(String transportProvider) {
        this.transportProvider = transportProvider;
    }

    public String getPricingType() {
        return pricingType;
    }

    public void setPricingType(String pricingType) {
        this.pricingType = pricingType;
    }

    public Double getPricingValue() {
        return pricingValue;
    }

    public void setPricingValue(Double pricingValue) {
        this.pricingValue = pricingValue;
    }

    public String getFacilities() {
        return facilities;
    }

    public void setFacilities(String facilities) {
        this.facilities = facilities;
    }

    public Double getFacilityCharge() {
        return facilityCharge;
    }

    public void setFacilityCharge(Double facilityCharge) {
        this.facilityCharge = facilityCharge;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}