
package com.travelrecommdations.serviceImpl;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.travelrecommdations.dto.TransportDTO;
import com.travelrecommdations.model.Transport;
import com.travelrecommdations.repository.TransportRepo;

@Service
public class TransportServiceImpl {

    @Autowired
    private TransportRepo transportRepository;

    @Value("${file.upload-dir}")
    private String uploadDir;

    // =========================================================
    // ADD
    // =========================================================

    public Transport addTransport(
            TransportDTO dto) throws IOException {

        Transport transport =
                new Transport();

        transport.setFromLocation(
                dto.getFromLocation()
        );

        transport.setToLocation(
                dto.getToLocation()
        );

        transport.setTransportType(
                dto.getTransportType()
        );

        transport.setTransportProvider(
                dto.getTransportProvider()
        );

        transport.setPricingType(
                dto.getPricingType()
        );

        transport.setPricingValue(
                dto.getPricingValue()
        );

        transport.setFacilities(
                dto.getFacilities()
        );

        transport.setFacilityCharge(
                dto.getFacilityCharge() == null
                        ? 0.0
                        : dto.getFacilityCharge()
        );

        transport.setStatus(
                dto.getStatus() == null ||
                dto.getStatus().isBlank()
                        ? "ACTIVE"
                        : dto.getStatus()
        );

        // =====================================================
        // IMAGE
        // =====================================================

        MultipartFile imageFile =
                dto.getImageFile();

        if (imageFile != null &&
            !imageFile.isEmpty()) {

            String fileName =
                    saveImage(imageFile);

            /*
             * DB:
             * bus.jpg
             *
             * NOT:
             * D:/Travel...
             */

            transport.setImage(fileName);

            System.out.println(
                    "IMAGE SAVED: " + fileName
            );

        } else {

            System.out.println(
                    "NO IMAGE RECEIVED"
            );

            transport.setImage(null);
        }

        // =====================================================
        // DATABASE
        // =====================================================

        transportRepository.save(
                transport
        );

        return transport;
    }

    // =========================================================
    // GET ALL
    // =========================================================

    public List<Transport> getAllTransports() {

        return transportRepository.findAll();
    }

    // =========================================================
    // GET TRANSPORT FOR DESTINATION
    // =========================================================

    public List<Transport> getTransportForDestination(
            String destination) {

        if (destination == null ||
            destination.trim().isEmpty()) {

            return List.of();
        }

        return transportRepository.findByDestination(
                destination.trim()
        );
    }

    // =========================================================
    // GET BY ID
    // =========================================================

    public Transport getTransportById(
            Integer id) {

        return transportRepository.findById(id);
    }

    // =========================================================
    // UPDATE
    // =========================================================

    public Transport updateTransport(
            Integer id,
            TransportDTO dto
    ) throws IOException {

        Transport existingTransport =
                transportRepository.findById(id);

        if (existingTransport == null) {

            return null;
        }

        existingTransport.setTransportId(id);

        existingTransport.setFromLocation(
                dto.getFromLocation()
        );

        existingTransport.setToLocation(
                dto.getToLocation()
        );

        existingTransport.setTransportType(
                dto.getTransportType()
        );

        existingTransport.setTransportProvider(
                dto.getTransportProvider()
        );

        existingTransport.setPricingType(
                dto.getPricingType()
        );

        existingTransport.setPricingValue(
                dto.getPricingValue()
        );

        existingTransport.setFacilities(
                dto.getFacilities()
        );

        existingTransport.setFacilityCharge(
                dto.getFacilityCharge() == null
                        ? 0.0
                        : dto.getFacilityCharge()
        );

        existingTransport.setStatus(
                dto.getStatus() == null ||
                dto.getStatus().isBlank()
                        ? "ACTIVE"
                        : dto.getStatus()
        );

        // =====================================================
        // IMAGE UPDATE
        // =====================================================

        MultipartFile imageFile =
                dto.getImageFile();

        if (imageFile != null &&
            !imageFile.isEmpty()) {

            String oldImage =
                    existingTransport.getImage();

            String newImage =
                    saveImage(imageFile);

            existingTransport.setImage(
                    newImage
            );

            System.out.println(
                    "NEW IMAGE SAVED: "
                    + newImage
            );

            /*
             * Delete old image only if
             * old and new names are different.
             */
            if (oldImage != null &&
                !oldImage.isBlank() &&
                !oldImage.equals(newImage)) {

                deleteOldImage(oldImage);
            }

        } else {

            /*
             * NO NEW IMAGE:
             * Keep existing image.
             */
            System.out.println(
                    "NO NEW IMAGE - KEEPING OLD IMAGE"
            );
        }

        // =====================================================
        // DATABASE UPDATE
        // =====================================================

        transportRepository.update(
                existingTransport
        );

        return existingTransport;
    }

    // =========================================================
    // DELETE
    // =========================================================

    public boolean deleteTransport(
            Integer id) {

        Transport existingTransport =
                transportRepository.findById(id);

        if (existingTransport == null) {

            return false;
        }

        int result =
                transportRepository.delete(id);

        if (result > 0) {

            deleteOldImage(
                    existingTransport.getImage()
            );

            return true;
        }

        return false;
    }

    // =========================================================
    // SEARCH
    // =========================================================

    public List<Transport> searchTransports(
            String keyword) {

        if (keyword == null ||
            keyword.trim().isEmpty()) {

            return transportRepository.findAll();
        }

        return transportRepository.search(
                keyword.trim()
        );
    }

    // =========================================================
    // SAVE IMAGE
    // =========================================================

    private String saveImage(
            MultipartFile file
    ) throws IOException {

        if (file == null ||
            file.isEmpty()) {

            throw new IOException(
                    "No image file received"
            );
        }

        // -----------------------------------------------------
        // CREATE FOLDER
        // -----------------------------------------------------

        Path uploadPath =
                Paths.get(uploadDir)
                        .toAbsolutePath()
                        .normalize();

        if (!Files.exists(uploadPath)) {

            Files.createDirectories(
                    uploadPath
            );
        }

        // -----------------------------------------------------
        // ORIGINAL FILE NAME
        // -----------------------------------------------------

        String originalFileName =
                file.getOriginalFilename();

        if (originalFileName == null ||
            originalFileName.isBlank()) {

            throw new IOException(
                    "Invalid image filename"
            );
        }

        /*
         * Remove path information.
         *
         * Example:
         * C:\fakepath\bus.jpg
         *
         * becomes:
         * bus.jpg
         */
        originalFileName =
                Paths.get(originalFileName)
                        .getFileName()
                        .toString();

        // -----------------------------------------------------
        // VALIDATE EXTENSION
        // -----------------------------------------------------

        String lowerName =
                originalFileName.toLowerCase();

        if (!lowerName.endsWith(".jpg") &&
            !lowerName.endsWith(".jpeg") &&
            !lowerName.endsWith(".png") &&
            !lowerName.endsWith(".webp")) {

            throw new IOException(
                    "Only JPG, JPEG, PNG and WEBP images are allowed"
            );
        }

        // -----------------------------------------------------
        // FINAL FILE PATH
        // -----------------------------------------------------

        Path filePath =
                uploadPath.resolve(
                        originalFileName
                ).normalize();

        /*
         * Security check
         */
        if (!filePath.startsWith(uploadPath)) {

            throw new IOException(
                    "Invalid file path"
            );
        }

        // -----------------------------------------------------
        // SAVE
        // -----------------------------------------------------

        Files.copy(
                file.getInputStream(),
                filePath,
                StandardCopyOption.REPLACE_EXISTING
        );

        System.out.println(
                "IMAGE FILE LOCATION: "
                + filePath
        );

        System.out.println(
                "IMAGE FILE NAME: "
                + originalFileName
        );

        // -----------------------------------------------------
        // RETURN ONLY FILE NAME
        // -----------------------------------------------------

        return originalFileName;
    }

    // =========================================================
    // DELETE IMAGE
    // =========================================================

    private void deleteOldImage(
            String fileName) {

        if (fileName == null ||
            fileName.isBlank()) {

            return;
        }

        try {

            Path uploadPath =
                    Paths.get(uploadDir)
                            .toAbsolutePath()
                            .normalize();

            Path oldImagePath =
                    uploadPath
                            .resolve(fileName)
                            .normalize();

            if (!oldImagePath.startsWith(
                    uploadPath)) {

                return;
            }

            Files.deleteIfExists(
                    oldImagePath
            );

            System.out.println(
                    "OLD IMAGE DELETED: "
                    + fileName
            );

        } catch (IOException e) {

            System.out.println(
                    "Unable to delete old image: "
                    + e.getMessage()
            );
        }
    }
}
