package com.travelrecommdations.dto;

import java.util.List;

public class RouteRecommendationDTO {

    private String startingPoint;
    private String destination;
    private String distance;
    private String duration;
    private String route;

    private List<TransportOptionDTO> transportOptions;

    public RouteRecommendationDTO() {
    }

    public String getStartingPoint() {
        return startingPoint;
    }

    public void setStartingPoint(String startingPoint) {
        this.startingPoint = startingPoint;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    public String getDistance() {
        return distance;
    }

    public void setDistance(String distance) {
        this.distance = distance;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public String getRoute() {
        return route;
    }

    public void setRoute(String route) {
        this.route = route;
    }

    public List<TransportOptionDTO> getTransportOptions() {
        return transportOptions;
    }

    public void setTransportOptions(List<TransportOptionDTO> transportOptions) {
        this.transportOptions = transportOptions;
    }
}