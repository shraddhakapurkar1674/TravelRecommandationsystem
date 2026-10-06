package com.travelrecommdations.controller;

import com.travelrecommdations.dto.ApiResponse;
import com.travelrecommdations.dto.HotelDTO;
import com.travelrecommdations.exception.HotelException;
import com.travelrecommdations.model.Hotel;
import com.travelrecommdations.serviceImpl.HotelService;

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



public class HotelController {


    @Autowired
    private HotelService hotelService;


    @Value("${file.upload-dir}")
    private String uploadDir;


    // =========================================================
    // GET ALL HOTELS / FILTER
    // =========================================================

    @GetMapping(value = "/hotels",
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    public ResponseEntity<ApiResponse<List<Hotel>>>
    getAllHotels(

            @RequestParam(required = false)
            String search,

            @RequestParam(required = false)
            Long destinationId,

            @RequestParam(required = false)
            String status) {

        try {

            List<Hotel> hotels =
                    hotelService.getFilteredHotels(
                            search,
                            destinationId,
                            status
                    );


            return ResponseEntity.ok(

                    new ApiResponse<>(
                            true,
                            "Hotels fetched successfully.",
                            hotels
                    )

            );

        }
        catch (Exception e) {

            e.printStackTrace();


            return ResponseEntity
                    .status(
                            HttpStatus.INTERNAL_SERVER_ERROR
                    )

                    .body(

                            new ApiResponse<>(
                                    false,
                                    "Failed to fetch hotels: "
                                            + e.getMessage(),
                                    null
                            )

                    );
        }
    }


    // =========================================================
    // GET HOTEL BY ID
    // =========================================================

    @GetMapping(
            value = "/hotels/{id}",
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    public ResponseEntity<ApiResponse<Hotel>>
    getHotel(
            @PathVariable Long id) {

        try {

            Hotel hotel =
                    hotelService.getHotelById(id);


            return ResponseEntity.ok(

                    new ApiResponse<>(
                            true,
                            "Hotel fetched successfully.",
                            hotel
                    )

            );

        }
        catch (HotelException e) {

            return ResponseEntity
                    .status(
                            HttpStatus.NOT_FOUND
                    )

                    .body(

                            new ApiResponse<>(
                                    false,
                                    e.getMessage(),
                                    null
                            )

                    );

        }
        catch (Exception e) {

            e.printStackTrace();


            return ResponseEntity
                    .status(
                            HttpStatus.INTERNAL_SERVER_ERROR
                    )

                    .body(

                            new ApiResponse<>(
                                    false,
                                    "Failed to fetch hotel: "
                                            + e.getMessage(),
                                    null
                            )

                    );
        }
    }


    // =========================================================
    // ADD HOTEL + IMAGE
    // =========================================================

    @PostMapping(value = "/hotels",
            consumes =
                    MediaType.MULTIPART_FORM_DATA_VALUE,

            produces =
                    MediaType.APPLICATION_JSON_VALUE
    )
    public ResponseEntity<ApiResponse<String>>
    createHotel(

            @Valid
            @RequestPart("hotel")
            HotelDTO hotelDTO,

            @RequestPart(
                    value = "file",
                    required = false
            )
            MultipartFile file) {

        try {

            boolean saved =
                    hotelService.addHotel(
                            hotelDTO,
                            file
                    );


            if (!saved) {

                return ResponseEntity
                        .status(
                                HttpStatus.INTERNAL_SERVER_ERROR
                        )

                        .body(

                                new ApiResponse<>(
                                        false,
                                        "Hotel could not be saved.",
                                        null
                                )

                        );
            }


            return ResponseEntity
                    .status(
                            HttpStatus.CREATED
                    )

                    .body(

                            new ApiResponse<>(
                                    true,
                                    "Hotel created successfully!",
                                    null
                            )

                    );

        }
        catch (Exception e) {

            e.printStackTrace();


            return ResponseEntity
                    .status(
                            HttpStatus.INTERNAL_SERVER_ERROR
                    )

                    .body(

                            new ApiResponse<>(
                                    false,
                                    "Failed to create hotel: "
                                            + e.getMessage(),
                                    null
                            )

                    );
        }
    }


    // =========================================================
    // UPDATE HOTEL + IMAGE
    // =========================================================

    @PutMapping(
            value = "/hotels/{id}",
            consumes =
                    MediaType.MULTIPART_FORM_DATA_VALUE,

            produces =
                    MediaType.APPLICATION_JSON_VALUE
    )
    public ResponseEntity<ApiResponse<String>>
    updateHotel(

            @PathVariable Long id,

            @Valid
            @RequestPart("hotel")
            HotelDTO hotelDTO,

            @RequestPart(
                    value = "file",
                    required = false
            )
            MultipartFile file) {

        try {

            boolean updated =
                    hotelService.updateHotel(
                            id,
                            hotelDTO,
                            file
                    );


            if (!updated) {

                return ResponseEntity
                        .status(
                                HttpStatus.INTERNAL_SERVER_ERROR
                        )

                        .body(

                                new ApiResponse<>(
                                        false,
                                        "Hotel could not be updated.",
                                        null
                                )

                        );
            }


            return ResponseEntity.ok(

                    new ApiResponse<>(
                            true,
                            "Hotel updated successfully!",
                            null
                    )

            );

        }
        catch (HotelException e) {

            return ResponseEntity
                    .status(
                            HttpStatus.NOT_FOUND
                    )

                    .body(

                            new ApiResponse<>(
                                    false,
                                    e.getMessage(),
                                    null
                            )

                    );

        }
        catch (Exception e) {

            e.printStackTrace();


            return ResponseEntity
                    .status(
                            HttpStatus.INTERNAL_SERVER_ERROR
                    )

                    .body(

                            new ApiResponse<>(
                                    false,
                                    "Failed to update hotel: "
                                            + e.getMessage(),
                                    null
                            )

                    );
        }
    }


    // =========================================================
    // DELETE HOTEL
    // =========================================================

    @DeleteMapping(
            value = "/hotels/{id}",
            produces =
                    MediaType.APPLICATION_JSON_VALUE
    )
    public ResponseEntity<ApiResponse<String>>
    deleteHotel(
            @PathVariable Long id) {

        try {

            boolean deleted =
                    hotelService.deleteHotel(id);


            if (!deleted) {

                return ResponseEntity
                        .status(
                                HttpStatus.INTERNAL_SERVER_ERROR
                        )

                        .body(

                                new ApiResponse<>(
                                        false,
                                        "Hotel could not be deleted.",
                                        null
                                )

                        );
            }


            return ResponseEntity.ok(

                    new ApiResponse<>(
                            true,
                            "Hotel deleted successfully!",
                            null
                    )

            );

        }
        catch (HotelException e) {

            return ResponseEntity
                    .status(
                            HttpStatus.NOT_FOUND
                    )

                    .body(

                            new ApiResponse<>(
                                    false,
                                    e.getMessage(),
                                    null
                            )

                    );

        }
        catch (Exception e) {

            e.printStackTrace();


            return ResponseEntity
                    .status(
                            HttpStatus.INTERNAL_SERVER_ERROR
                    )

                    .body(

                            new ApiResponse<>(
                                    false,
                                    "Failed to delete hotel: "
                                            + e.getMessage(),
                                    null
                            )

                    );
        }
    }


    // =========================================================
    // GET HOTEL IMAGE
    // =========================================================
    //
    // URL:
    //
    // http://localhost:8091/api/hotels/images/Hotel.jpg
    //
    // =========================================================

    @GetMapping(
            value = "/hotels/images/{fileName:.+}"
    )
    public ResponseEntity<Resource>
    getHotelImage(
            @PathVariable String fileName) {

        try {

            // =================================================
            // UPLOAD DIRECTORY
            // =================================================

            Path uploadPath =
                    Paths.get(uploadDir)
                            .toAbsolutePath()
                            .normalize();


            // =================================================
            // IMAGE PATH
            // =================================================

            Path imagePath =
                    uploadPath
                            .resolve(fileName)
                            .normalize();


            // =================================================
            // SECURITY CHECK
            // =================================================

            if (
                    !imagePath.startsWith(
                            uploadPath
                    )
            ) {

                return ResponseEntity
                        .badRequest()
                        .build();
            }


            // =================================================
            // CHECK IMAGE EXISTS
            // =================================================

            if (
                    !Files.exists(imagePath) ||
                    !Files.isRegularFile(imagePath)
            ) {

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
            // CONTENT TYPE
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

        }
        catch (Exception e) {

            e.printStackTrace();


            return ResponseEntity
                    .status(
                            HttpStatus.INTERNAL_SERVER_ERROR
                    )
                    .build();
        }
    }
}

