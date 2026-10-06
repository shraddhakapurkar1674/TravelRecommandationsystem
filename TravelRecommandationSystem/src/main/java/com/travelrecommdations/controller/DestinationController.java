package com.travelrecommdations.controller;

import com.travelrecommdations.dto.ApiResponse;
import com.travelrecommdations.dto.DestinationDTO;
import com.travelrecommdations.exception.DestinationException;
import com.travelrecommdations.model.Destination;
import com.travelrecommdations.serviceImpl.DestinationService;

import jakarta.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;

import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@RestController
@RequestMapping("/api")
public class DestinationController {

    @Autowired
    private DestinationService destinationService;

    // =========================================================
    // IMAGE UPLOAD DIRECTORY
    // =========================================================

    @Value("${file.upload-dir}")
    private String uploadDir;


    // =========================================================
    // GET ALL DESTINATIONS
    // =========================================================

    @GetMapping(value = "/destinations",
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    public ResponseEntity<ApiResponse<List<Destination>>>
    getAllDestinations(

            @RequestParam(required = false)
            String search,

            @RequestParam(required = false)
            String country,

            @RequestParam(required = false)
            String status) {

        try {

            List<Destination> destinations =
                    destinationService.getFilteredDestinations(
                            search,
                            country,
                            status
                    );

            return ResponseEntity.ok(
                    new ApiResponse<>(
                            true,
                            "Destinations fetched successfully.",
                            destinations
                    )
            );

        } catch (Exception e) {

            e.printStackTrace();

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(
                            new ApiResponse<>(
                                    false,
                                    "Failed to fetch destinations: "
                                            + e.getMessage(),
                                    null
                            )
                    );
        }
    }


    // =========================================================
    // GET DESTINATION BY ID
    // =========================================================

    @GetMapping(
            value = "/destinations/{id}",
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    public ResponseEntity<ApiResponse<Destination>>
    getDestination(@PathVariable Long id) {

        try {

            Destination destination =
                    destinationService.getDestinationById(id);

            return ResponseEntity.ok(
                    new ApiResponse<>(
                            true,
                            "Destination fetched successfully.",
                            destination
                    )
            );

        } catch (DestinationException e) {

            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(
                            new ApiResponse<>(
                                    false,
                                    e.getMessage(),
                                    null
                            )
                    );

        } catch (Exception e) {

            e.printStackTrace();

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(
                            new ApiResponse<>(
                                    false,
                                    "Failed to fetch destination: "
                                            + e.getMessage(),
                                    null
                            )
                    );
        }
    }


    // =========================================================
    // ADD DESTINATION + IMAGE
    // =========================================================

    @PostMapping(value = "/destinations",
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    public ResponseEntity<ApiResponse<String>>
    createDestination(

            @Valid
            @RequestPart("destination")
            DestinationDTO destinationDTO,

            @RequestPart(
                    value = "file",
                    required = false
            )
            MultipartFile file) {

        try {

            boolean saved =
                    destinationService.addDestination(
                            destinationDTO,
                            file
                    );

            if (!saved) {

                return ResponseEntity
                        .status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body(
                                new ApiResponse<>(
                                        false,
                                        "Destination could not be saved.",
                                        null
                                )
                        );
            }

            return ResponseEntity
                    .status(HttpStatus.CREATED)
                    .body(
                            new ApiResponse<>(
                                    true,
                                    "Destination created successfully!",
                                    null
                            )
                    );

        } catch (Exception e) {

            e.printStackTrace();

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(
                            new ApiResponse<>(
                                    false,
                                    "Failed to create destination: "
                                            + e.getMessage(),
                                    null
                            )
                    );
        }
    }


    // =========================================================
    // UPDATE DESTINATION + IMAGE
    // =========================================================

    @PutMapping(
            value = "/destinations/{id}",
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    public ResponseEntity<ApiResponse<String>>
    updateDestination(

            @PathVariable Long id,

            @Valid
            @RequestPart("destination")
            DestinationDTO destinationDTO,

            @RequestPart(
                    value = "file",
                    required = false
            )
            MultipartFile file) {

        try {

            boolean updated =
                    destinationService.updateDestination(
                            id,
                            destinationDTO,
                            file
                    );

            if (!updated) {

                return ResponseEntity
                        .status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body(
                                new ApiResponse<>(
                                        false,
                                        "Destination could not be updated.",
                                        null
                                )
                        );
            }

            return ResponseEntity.ok(
                    new ApiResponse<>(
                            true,
                            "Destination updated successfully!",
                            null
                    )
            );

        } catch (DestinationException e) {

            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(
                            new ApiResponse<>(
                                    false,
                                    e.getMessage(),
                                    null
                            )
                    );

        } catch (Exception e) {

            e.printStackTrace();

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(
                            new ApiResponse<>(
                                    false,
                                    "Failed to update destination: "
                                            + e.getMessage(),
                                    null
                            )
                    );
        }
    }


    // =========================================================
    // DELETE DESTINATION
    // =========================================================

    @DeleteMapping(
            value = "/destinations/{id}",
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    public ResponseEntity<ApiResponse<String>>
    deleteDestination(@PathVariable Long id) {

        try {

            boolean deleted =
                    destinationService.deleteDestination(id);

            if (!deleted) {

                return ResponseEntity
                        .status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body(
                                new ApiResponse<>(
                                        false,
                                        "Destination could not be deleted.",
                                        null
                                )
                        );
            }

            return ResponseEntity.ok(
                    new ApiResponse<>(
                            true,
                            "Destination deleted successfully!",
                            null
                    )
            );

        } catch (DestinationException e) {

            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(
                            new ApiResponse<>(
                                    false,
                                    e.getMessage(),
                                    null
                            )
                    );

        } catch (Exception e) {

            e.printStackTrace();

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(
                            new ApiResponse<>(
                                    false,
                                    "Failed to delete destination: "
                                            + e.getMessage(),
                                    null
                            )
                    );
        }
    }


    // =========================================================
    // GET DESTINATION IMAGE
    // =========================================================
    //
    // Example:
    //
    // http://localhost:8091/api/destinations/images/Goa.jpg
    //
    // It reads:
    //
    // uploads/images/Goa.jpg
    //
    // =========================================================

    @GetMapping(
            value = "/destinations/images/{fileName:.+}"
    )
    public ResponseEntity<Resource>
    getDestinationImage(
            @PathVariable String fileName) {

        try {

            // =================================================
            // GET UPLOAD DIRECTORY
            // =================================================

            Path uploadPath =
                    Paths.get(uploadDir)
                            .toAbsolutePath()
                            .normalize();


            // =================================================
            // GET IMAGE PATH
            // =================================================

            Path imagePath =
                    uploadPath
                            .resolve(fileName)
                            .normalize();


            // =================================================
            // SECURITY CHECK
            // =================================================

            if (!imagePath.startsWith(uploadPath)) {

                return ResponseEntity
                        .badRequest()
                        .build();
            }


            // =================================================
            // CHECK IMAGE EXISTS
            // =================================================

            if (!Files.exists(imagePath)
                    || !Files.isRegularFile(imagePath)) {

                return ResponseEntity
                        .notFound()
                        .build();
            }


            // =================================================
            // CREATE RESOURCE
            // =================================================

            Resource resource =
                    new UrlResource(
                            imagePath.toUri()
                    );


            // =================================================
            // FIND CONTENT TYPE
            // =================================================

            String contentType =
                    Files.probeContentType(
                            imagePath
                    );


            if (contentType == null) {

                contentType =
                        MediaType
                                .APPLICATION_OCTET_STREAM_VALUE;
            }


            // =================================================
            // RETURN IMAGE
            // =================================================

            return ResponseEntity
                    .ok()
                    .contentType(
                            MediaType.parseMediaType(
                                    contentType
                            )
                    )
                    .header(
                            HttpHeaders.CACHE_CONTROL,
                            "max-age=86400"
                    )
                    .body(resource);


        } catch (Exception e) {

            e.printStackTrace();

            return ResponseEntity
                    .status(
                            HttpStatus.INTERNAL_SERVER_ERROR
                    )
                    .build();
        }
    }
}

