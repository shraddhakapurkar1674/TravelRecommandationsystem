package com.travelrecommdations.serviceImpl;

import com.travelrecommdations.dto.HotelDTO;
import com.travelrecommdations.exception.HotelException;
import com.travelrecommdations.model.Hotel;
import com.travelrecommdations.repository.HotelRepo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;

@Service
public class HotelService {

    @Autowired
    private HotelRepo hotelRepo;

    /*
     * =====================================================
     * UPLOAD DIRECTORY
     * =====================================================
     *
     *
     *
     * Example:
     *
     * file:
     *   upload-dir: D:/TravelRecommandationSystem/images
     *
     */

    @Value("${file.upload-dir}")
    private String uploadDir;


    // =====================================================
    // GET / FILTER HOTELS
    // =====================================================

    public List<Hotel> getFilteredHotels(
            String search,
            Long destinationId,
            String status) {

        return hotelRepo.getFilteredHotels(
                search,
                destinationId,
                status
        );
    }


    // =====================================================
    // GET HOTEL BY ID
    // =====================================================

    public Hotel getHotelById(Long id)
            throws HotelException {

        return hotelRepo
                .getHotelById(id)
                .orElseThrow(
                        () -> new HotelException(
                                "Hotel not found with ID: " + id
                        )
                );
    }


    // =====================================================
    // ADD HOTEL
    // =====================================================

    public boolean addHotel(
            HotelDTO dto,
            MultipartFile file)
            throws IOException {

        if (dto == null) {

            throw new IllegalArgumentException(
                    "Hotel data cannot be null."
            );
        }

        Hotel hotel = mapDtoToModel(dto);


        /*
         * =================================================
         * SAVE IMAGE
         * =================================================
         */

        if (file != null && !file.isEmpty()) {

            String imageFileName = saveImage(file);

            /*
             * Database मध्ये फक्त filename:
             *
             * hotel.jpg
             *
             * Full path नाही.
             */

            hotel.setImage(imageFileName);
        }


        /*
         * =================================================
         * SAVE HOTEL IN DATABASE
         * =================================================
         */

        int result = hotelRepo.addHotel(hotel);

        return result > 0;
    }


    // =====================================================
    // UPDATE HOTEL
    // =====================================================

    public boolean updateHotel(
            Long id,
            HotelDTO dto,
            MultipartFile file)
            throws IOException, HotelException {

        /*
         * Existing hotel
         */

        Hotel existing = getHotelById(id);


        /*
         * New hotel data
         */

        Hotel hotel = mapDtoToModel(dto);


        /*
         * =================================================
         * NEW IMAGE SELECTED
         * =================================================
         */

        if (file != null && !file.isEmpty()) {

            /*
             * Save new image first
             */

            String newImageFileName = saveImage(file);

            hotel.setImage(newImageFileName);


            /*
             * Delete old image
             */

            if (existing.getImage() != null
                    && !existing.getImage().trim().isEmpty()) {

                deleteImage(existing.getImage());
            }

        } else {

            /*
             * =================================================
             * NO NEW IMAGE
             * =================================================
             *
             * 
             */

            hotel.setImage(existing.getImage());
        }


        /*
         * =================================================
         * UPDATE DATABASE
         * =================================================
         */

        int result =
                hotelRepo.updateHotel(
                        id,
                        hotel
                );

        return result > 0;
    }


    // =====================================================
    // DELETE HOTEL
    // =====================================================

    public boolean deleteHotel(Long id)
            throws HotelException {

        /*
         * Existing hotel मिळवा
         */

        Hotel existing = getHotelById(id);


        /*
         * 
         */

        int result = hotelRepo.deleteHotel(id);


        /*
         * 
         */

        if (result > 0) {

            deleteImage(existing.getImage());
        }


        return result > 0;
    }


    // =====================================================
    // DTO -> MODEL
    // =====================================================

    private Hotel mapDtoToModel(HotelDTO dto) {

        Hotel hotel = new Hotel();


        /*
         * Destination
         */

        hotel.setDestinationId(
                dto.getDestinationId()
        );


        /*
         * Hotel name
         */

        hotel.setHotelName(
                dto.getHotelName()
        );


        /*
         * Location
         */

        hotel.setLocation(
                dto.getLocation()
        );


        /*
         * Rating
         */

        hotel.setRating(
                dto.getRating()
        );


        /*
         * Price
         */

        hotel.setPricePerNight(
                dto.getPricePerNight()
        );


        /*
         * Contact
         */

        hotel.setContactNumber(
                dto.getContactNumber()
        );


        /*
         * Description
         */

        hotel.setDescription(
                dto.getDescription()
        );


        /*
         * Status
         */

        if (dto.getStatus() == null
                || dto.getStatus().trim().isEmpty()) {

            hotel.setStatus("ACTIVE");

        } else {

            hotel.setStatus(
                    dto.getStatus()
                            .trim()
                            .toUpperCase()
            );
        }


        /*
         * Image
         *
         * 
         */

        hotel.setImage(
                cleanFileName(
                        dto.getImage()
                )
        );


        return hotel;
    }


    // =====================================================
    // SAVE IMAGE
    // =====================================================

    private String saveImage(
            MultipartFile file)
            throws IOException {

        /*
         * Empty file
         */

        if (file == null || file.isEmpty()) {

            return null;
        }


        /*
         * =================================================
         * IMAGE VALIDATION
         * =================================================
         */

        String contentType = file.getContentType();

        if (contentType == null
                || !contentType.startsWith("image/")) {

            throw new IOException(
                    "Only image files are allowed."
            );
        }


        /*
         * =================================================
         * CREATE UPLOAD DIRECTORY
         * =================================================
         */

        Path uploadPath =
                Paths.get(uploadDir)
                        .toAbsolutePath()
                        .normalize();

        Files.createDirectories(uploadPath);


        /*
         * =================================================
         * ORIGINAL FILE NAME
         * =================================================
         */

        String originalName =
                file.getOriginalFilename();


        if (originalName == null
                || originalName.trim().isEmpty()) {

            throw new IOException(
                    "Invalid image filename."
            );
        }


        /*
         * Remove path information
         */

        originalName =
                Paths.get(originalName)
                        .getFileName()
                        .toString();


        /*
         * =================================================
         * SANITIZE FILE NAME
         * =================================================
         */

        originalName =
                originalName
                        .replace("\\", "_")
                        .replace("/", "_");


        originalName =
                originalName.replaceAll(
                        "[^a-zA-Z0-9._() -]",
                        "_"
                );


        /*
         * =================================================
         * FINAL FILE PATH
         * =================================================
         */

        Path targetPath =
                uploadPath.resolve(originalName)
                          .normalize();


        /*
         * Security check
         *
         * File upload directory
         *          */

        if (!targetPath.startsWith(uploadPath)) {

            throw new IOException(
                    "Invalid file path."
            );
        }


        /*
         * =================================================
         * SAVE FILE
         * =================================================
         */

        Files.copy(
                file.getInputStream(),
                targetPath,
                StandardCopyOption.REPLACE_EXISTING
        );


        /*
         * =================================================
         * 
         * =================================================
         *
         * Example:
         *
         * hotel.jpg
         */

        return originalName;
    }


    // =====================================================
    // CLEAN FILE NAME
    // =====================================================

    private String cleanFileName(
            String imageName) {

        if (imageName == null
                || imageName.trim().isEmpty()) {

            return null;
        }


        String value =
                imageName
                        .trim()
                        .replace("\\", "/");


       

        if (value.contains("/")) {

            value =
                    value.substring(
                            value.lastIndexOf("/") + 1
                    );
        }


        return value;
    }


    // =====================================================
    // DELETE IMAGE
    // =====================================================

    private void deleteImage(
            String imageName) {

        try {

            String fileName =
                    cleanFileName(imageName);


            if (fileName == null
                    || fileName.isEmpty()) {

                return;
            }


            Path uploadPath =
                    Paths.get(uploadDir)
                            .toAbsolutePath()
                            .normalize();


            Path imagePath =
                    uploadPath
                            .resolve(fileName)
                            .normalize();


            /*
             * Security check
             */

            if (!imagePath.startsWith(uploadPath)) {

                return;
            }


            Files.deleteIfExists(imagePath);


        } catch (Exception e) {

            System.err.println(
                    "Could not delete hotel image: "
                    + e.getMessage()
            );
        }
    }
}