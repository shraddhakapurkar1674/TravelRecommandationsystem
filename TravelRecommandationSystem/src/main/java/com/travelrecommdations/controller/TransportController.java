
package com.travelrecommdations.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.travelrecommdations.dto.TransportDTO;
import com.travelrecommdations.model.Transport;
import com.travelrecommdations.serviceImpl.TransportServiceImpl;

@RestController
@RequestMapping("/api")
public class TransportController {

    private final TransportServiceImpl transportService;

    @Value("${file.upload-dir}")
    private String uploadDir;

    public TransportController(TransportServiceImpl transportService) {
        this.transportService = transportService;
    }

    // =========================================================
    // GET ALL TRANSPORTS
    // URL: /api/transports
    // =========================================================

    @GetMapping("/transports")
    public ResponseEntity<List<Transport>> getAllTransports() {

        return ResponseEntity.ok(
                transportService.getAllTransports()
        );
    }

    // =========================================================
    // GET TRANSPORT FOR DESTINATION
    // URL: /api/transports/by-destination?destination=Pune
    // =========================================================

    @GetMapping("/transports/by-destination")
    public ResponseEntity<List<Transport>> getTransportForDestination(
            @RequestParam String destination) {

        return ResponseEntity.ok(
                transportService.getTransportForDestination(destination)
        );
    }

    // =========================================================
    // GET TRANSPORT BY ID
    // URL: /api/transports/{id}
    // =========================================================

    @GetMapping("/transports/{id}")
    public ResponseEntity<?> getTransportById(
            @PathVariable Integer id) {

        Transport transport =
                transportService.getTransportById(id);

        if (transport == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body("Transport not found");
        }

        return ResponseEntity.ok(transport);
    }

    // =========================================================
    // SEARCH TRANSPORTS
    // URL: /api/transports/search?keyword=bus
    // =========================================================

    @GetMapping("/transports/search")
    public ResponseEntity<List<Transport>> searchTransports(
            @RequestParam(required = false) String keyword) {

        return ResponseEntity.ok(
                transportService.searchTransports(keyword)
        );
    }

    // =========================================================
    // GET TRANSPORT IMAGE
    // URL: /api/transports/images/{fileName}
    // =========================================================

    @GetMapping("/transports/images/{fileName:.+}")
    public ResponseEntity<Resource> getTransportImage(
            @PathVariable String fileName) {

        try {

            Path imagePath = Paths
                    .get(uploadDir)
                    .resolve(fileName)
                    .normalize();

            Path uploadPath = Paths
                    .get(uploadDir)
                    .toAbsolutePath()
                    .normalize();

            Path requestedPath = imagePath
                    .toAbsolutePath()
                    .normalize();

            // Security check
            if (!requestedPath.startsWith(uploadPath)) {
                return ResponseEntity
                        .status(HttpStatus.BAD_REQUEST)
                        .build();
            }

            // File not found
            if (!Files.exists(requestedPath)
                    || !Files.isRegularFile(requestedPath)) {

                return ResponseEntity
                        .notFound()
                        .build();
            }

            Resource resource =
                    new UrlResource(requestedPath.toUri());

            String contentType =
                    Files.probeContentType(requestedPath);

            if (contentType == null) {
                contentType =
                        MediaType.APPLICATION_OCTET_STREAM_VALUE;
            }

            return ResponseEntity
                    .ok()
                    .contentType(
                            MediaType.parseMediaType(contentType)
                    )
                    .header(
                            HttpHeaders.CACHE_CONTROL,
                            "max-age=86400"
                    )
                    .body(resource);

        } catch (Exception e) {

            System.out.println(
                    "Image loading error: " + e.getMessage()
            );

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .build();
        }
    }

    // =========================================================
    // ADD TRANSPORT
    // URL: POST /api/transports
    // =========================================================

    @PostMapping(
            value = "/transports",
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE
    )
    public ResponseEntity<?> addTransport(

            @RequestParam("fromLocation")
            String fromLocation,

            @RequestParam("toLocation")
            String toLocation,

            @RequestParam("transportType")
            String transportType,

            @RequestParam("transportProvider")
            String transportProvider,

            @RequestParam("pricingType")
            String pricingType,

            @RequestParam("pricingValue")
            Double pricingValue,

            @RequestParam(required = false)
            String facilities,

            @RequestParam(
                    required = false,
                    defaultValue = "0"
            )
            Double facilityCharge,

            @RequestParam(
                    value = "imageFile",
                    required = false
            )
            MultipartFile imageFile,

            @RequestParam(
                    required = false,
                    defaultValue = "ACTIVE"
            )
            String status) {

        try {

            TransportDTO dto = new TransportDTO();

            dto.setFromLocation(fromLocation);
            dto.setToLocation(toLocation);
            dto.setTransportType(transportType);
            dto.setTransportProvider(transportProvider);
            dto.setPricingType(pricingType);
            dto.setPricingValue(pricingValue);
            dto.setFacilities(facilities);
            dto.setFacilityCharge(facilityCharge);
            dto.setImageFile(imageFile);
            dto.setStatus(status);

            Transport transport =
                    transportService.addTransport(dto);

            return ResponseEntity
                    .status(HttpStatus.CREATED)
                    .body(transport);

        } catch (IOException e) {

            e.printStackTrace();

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(
                            "Image upload failed: "
                            + e.getMessage()
                    );
        }
    }

    // =========================================================
    // UPDATE TRANSPORT
    // URL: PUT /api/transports/{id}
    // =========================================================

    @PutMapping(
            value = "/transports/{id}",
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE
    )
    public ResponseEntity<?> updateTransport(

            @PathVariable Integer id,

            @RequestParam("fromLocation")
            String fromLocation,

            @RequestParam("toLocation")
            String toLocation,

            @RequestParam("transportType")
            String transportType,

            @RequestParam("transportProvider")
            String transportProvider,

            @RequestParam("pricingType")
            String pricingType,

            @RequestParam("pricingValue")
            Double pricingValue,

            @RequestParam(required = false)
            String facilities,

            @RequestParam(
                    required = false,
                    defaultValue = "0"
            )
            Double facilityCharge,

            @RequestParam(
                    value = "imageFile",
                    required = false
            )
            MultipartFile imageFile,

            @RequestParam(
                    required = false,
                    defaultValue = "ACTIVE"
            )
            String status) {

        try {

            TransportDTO dto = new TransportDTO();

            dto.setFromLocation(fromLocation);
            dto.setToLocation(toLocation);
            dto.setTransportType(transportType);
            dto.setTransportProvider(transportProvider);
            dto.setPricingType(pricingType);
            dto.setPricingValue(pricingValue);
            dto.setFacilities(facilities);
            dto.setFacilityCharge(facilityCharge);
            dto.setImageFile(imageFile);
            dto.setStatus(status);

            Transport updatedTransport =
                    transportService.updateTransport(
                            id,
                            dto
                    );

            if (updatedTransport == null) {

                return ResponseEntity
                        .status(HttpStatus.NOT_FOUND)
                        .body("Transport not found");
            }

            return ResponseEntity.ok(updatedTransport);

        } catch (IOException e) {

            e.printStackTrace();

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(
                            "Image upload failed: "
                            + e.getMessage()
                    );
        }
    }

    // =========================================================
    // DELETE TRANSPORT
    // URL: DELETE /api/transports/{id}
    // =========================================================

    @DeleteMapping("/transports/{id}")
    public ResponseEntity<?> deleteTransport(
            @PathVariable Integer id) {

        try {

            boolean deleted =
                    transportService.deleteTransport(id);

            if (!deleted) {

                return ResponseEntity
                        .status(HttpStatus.NOT_FOUND)
                        .body("Transport not found");
            }

            return ResponseEntity.ok(
                    "Transport deleted successfully"
            );

        } catch (Exception e) {

            e.printStackTrace();

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(e.getMessage());
        }
    }
}

