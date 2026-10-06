package com.travelrecommdations.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.travelrecommdations.dto.PackageDTO;
import com.travelrecommdations.model.Activity;
import com.travelrecommdations.model.Hotel;
import com.travelrecommdations.model.Package;
import com.travelrecommdations.serviceImpl.PackageServiceImpl;

import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
@RequestMapping("/api")

public class PackageController {

    @Autowired
    private PackageServiceImpl packageService;

    @GetMapping("/travel-packages")public ResponseEntity<List<Package>> getAllPackages() {
        List<Package> list = packageService.getAllPackages();
        return ResponseEntity.ok(list);
    }

    @PostMapping("/travel-packages")public ResponseEntity<?> createPackage(
            @RequestParam("packageName") String packageName,
            @RequestParam("duration") String duration,
            @RequestParam("price") Double price,
            @RequestParam(value = "packageType", required = false) String packageType,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam(value = "includedServices", required = false) String includedServices,
            @RequestParam(value = "excludedServices", required = false) String excludedServices,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam("destinationsJson") String destinationsJson,
            @RequestParam(value = "imageFiles", required = false) List<MultipartFile> imageFiles
    ) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            List<PackageDTO.DestinationItemDTO> destList = mapper.readValue(
                destinationsJson, 
                mapper.getTypeFactory().constructCollectionType(List.class, PackageDTO.DestinationItemDTO.class)
            );

            if (imageFiles != null && !imageFiles.isEmpty() && destList != null) {
                for (int i = 0; i < destList.size() && i < imageFiles.size(); i++) {
                    destList.get(i).setImageFile(imageFiles.get(i));
                }
            }

            PackageDTO dto = new PackageDTO();
            dto.setPackageName(packageName);
            dto.setDuration(duration);
            dto.setPrice(price);
            dto.setPackageType(packageType);
            dto.setDescription(description);
            dto.setIncludedServices(includedServices);
            dto.setExcludedServices(excludedServices);
            dto.setStatus(status);
            dto.setDestinations(destList);

            Long savedId = packageService.createPackage(dto);

            return ResponseEntity.status(HttpStatus.CREATED).body(
                "Travel Package created successfully with ID: " + savedId
            );

        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to create package: " + e.getMessage());
        }
    }

    @PutMapping("/travel-packages/{id}")
    public ResponseEntity<?> updatePackage(
            @PathVariable Long id,
            @RequestParam("packageName") String packageName,
            @RequestParam("duration") String duration,
            @RequestParam("price") Double price,
            @RequestParam(value = "packageType", required = false) String packageType,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam(value = "includedServices", required = false) String includedServices,
            @RequestParam(value = "excludedServices", required = false) String excludedServices,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam("destinationsJson") String destinationsJson,
            @RequestParam(value = "imageFiles", required = false) List<MultipartFile> imageFiles
    ) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            List<PackageDTO.DestinationItemDTO> destList = mapper.readValue(
                destinationsJson, 
                mapper.getTypeFactory().constructCollectionType(List.class, PackageDTO.DestinationItemDTO.class)
            );

            if (imageFiles != null && !imageFiles.isEmpty() && destList != null) {
                for (int i = 0; i < destList.size() && i < imageFiles.size(); i++) {
                    destList.get(i).setImageFile(imageFiles.get(i));
                }
            }

            PackageDTO dto = new PackageDTO();
            dto.setPackageName(packageName);
            dto.setDuration(duration);
            dto.setPrice(price);
            dto.setPackageType(packageType);
            dto.setDescription(description);
            dto.setIncludedServices(includedServices);
            dto.setExcludedServices(excludedServices);
            dto.setStatus(status);
            dto.setDestinations(destList);

            packageService.updatePackage(id, dto);

            return ResponseEntity.ok("Travel Package updated successfully with ID: " + id);

        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to update package: " + e.getMessage());
        }
    }

    @DeleteMapping("/travel-packages/{id}")
    public ResponseEntity<?> deletePackage(@PathVariable Long id) {
        try {
            packageService.deletePackage(id);
            return ResponseEntity.ok("Travel Package deleted successfully.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to delete package: " + e.getMessage());
        }
    }
    
    
    @GetMapping("/travel-packages/{id}/details")
    public ResponseEntity<?> getPackageDetailsWithHotelsAndActivities(@PathVariable Long id) {
        try {
            // 1. Get Package Info
            Package pkg = packageService.getPackageById(id);
            if (pkg == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Package not found");
            }

            // 2. Get Destinations inside this package
            List<PackageDTO.DestinationItemDTO> destinations = packageService.getDestinationsByPackageId(id);
            
            // Extract destination names to fetch related hotels and activities
            List<String> destNames = destinations.stream()
                                                 .map(PackageDTO.DestinationItemDTO::getDestinationName)
                                                 .collect(Collectors.toList());

            // 3. Get Hotels related to these destinations
            List<Hotel> hotels = packageService.getHotelsForDestinations(destNames);

            // 4. Get Activities related to these destinations
            List<Activity> activities = packageService.getActivitiesForDestinations(destNames);

            // Build a comprehensive response object/map or DTO
            Map<String, Object> response = new HashMap<>();
            response.put("packageInfo", pkg);
            response.put("destinations", destinations);
            response.put("hotels", hotels);
            response.put("activities", activities);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error fetching package details: " + e.getMessage());
        }
    }
}
