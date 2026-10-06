package com.travelrecommdations.serviceImpl;

import com.travelrecommdations.dto.DestinationDTO;
import com.travelrecommdations.exception.DestinationException;
import com.travelrecommdations.model.Destination;
import com.travelrecommdations.repository.DestinationDao;

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
public class DestinationService {

    @Autowired
    private DestinationDao destinationDao;
    @Autowired
    private NotificationService notificationService;


    /*
     * =========================================================
     * UPLOAD DIRECTORY
     * =========================================================
     *
     * Read upload directory from application.yml
     *
     * Example:
     *
     * file:
     *   upload-dir: uploads/images/
     *
     */

    @Value("${file.upload-dir}")
    private String uploadDir;


    /*
     * =========================================================
     * GET / FILTER DESTINATIONS
     * =========================================================
     */

    public List<Destination> getFilteredDestinations(
            String search,
            String country,
            String status) {

        return destinationDao.getFilteredDestinations(
                search,
                country,
                status
        );
    }


    /*
     * =========================================================
     * GET DESTINATION BY ID
     * =========================================================
     */

    public Destination getDestinationById(Long id)
            throws DestinationException {

        return destinationDao
                .getDestinationById(id)
                .orElseThrow(
                        () -> new DestinationException(
                                "Destination not found with ID: "
                                        + id
                        )
                );
    }


    /*
     * =========================================================
     * ADD DESTINATION
     * =========================================================
     */

    public boolean addDestination(
            DestinationDTO dto,
            MultipartFile file)
            throws IOException {

        if (dto == null) {

            throw new IllegalArgumentException(
                    "Destination data cannot be null."
            );
        }


        /*
         * Convert DTO to model
         */

        Destination destination =
                mapDtoToModel(dto);


        /*
         * Save uploaded image
         */

        if (file != null && !file.isEmpty()) {

            String imageFileName =
                    saveImage(file);

            /*
             * Database stores ONLY filename
             *
             * Example:
             *
             * Goa.jpg
             */

            destination.setImage(
                    imageFileName
            );
        }


        /*
         * Insert database record
         */

        int result =
                destinationDao.addDestination(
                        destination
                );
        if (result > 0) {

            notificationService
                    .notifyUsersAboutNewDestination(
                            destination.getDestinationName()
                    );
        }

        return result > 0;
    }


    /*
     * =========================================================
     * UPDATE DESTINATION
     * =========================================================
     */

    public boolean updateDestination(
            Long id,
            DestinationDTO dto,
            MultipartFile file)
            throws IOException, DestinationException {


        /*
         * Get existing destination
         */

        Destination existing =
                getDestinationById(id);


        /*
         * Convert DTO to model
         */

        Destination destination =
                mapDtoToModel(dto);


        /*
         * =====================================================
         * NEW IMAGE SELECTED
         * =====================================================
         */

        if (file != null && !file.isEmpty()) {

            String newImageFileName =
                    saveImage(file);

            destination.setImage(
                    newImageFileName
            );

        } else {

            /*
             * =================================================
             * NO NEW IMAGE
             * =================================================
             *
             * Keep existing image.
             *
             */

            destination.setImage(
                    existing.getImage()
            );
        }


        /*
         * Update database
         */

        int result =
                destinationDao.updateDestination(
                        id,
                        destination
                );


        return result > 0;
    }


    /*
     * =========================================================
     * DELETE DESTINATION
     * =========================================================
     */

    public boolean deleteDestination(
            Long id)
            throws DestinationException {


        /*
         * Check destination exists
         */

        Destination existing =
                getDestinationById(id);


        /*
         * Delete database record
         */

        int result =
                destinationDao.deleteDestination(
                        id
                );


        /*
         * Delete physical image
         */

        if (result > 0) {

            deleteImage(
                    existing.getImage()
            );
        }


        return result > 0;
    }


    /*
     * =========================================================
     * DTO -> MODEL
     * =========================================================
     */

    private Destination mapDtoToModel(
            DestinationDTO dto) {

        Destination destination =
                new Destination();


        destination.setDestinationName(
                dto.getDestinationName()
        );


        destination.setState(
                dto.getState()
        );


        destination.setCountry(
                dto.getCountry()
        );


        destination.setCategory(
                dto.getCategory()
        );


        destination.setBudget(
                dto.getBudget()
        );


        destination.setBestSeason(
                dto.getBestSeason()
        );


        destination.setDescription(
                dto.getDescription()
        );


        /*
         * Default status
         */

        if (dto.getStatus() == null ||
                dto.getStatus()
                        .trim()
                        .isEmpty()) {

            destination.setStatus(
                    "ACTIVE"
            );

        } else {

            destination.setStatus(
                    dto.getStatus()
                            .trim()
                            .toUpperCase()
            );
        }


        /*
         * If image is supplied in DTO,
         * keep filename.
         */

        destination.setImage(
                cleanFileName(
                        dto.getImage()
                )
        );


        return destination;
    }


    /*
     * =========================================================
     * SAVE IMAGE
     * =========================================================
     */

    private String saveImage(
            MultipartFile file)
            throws IOException {


        /*
         * Validate file
         */

        if (file == null ||
                file.isEmpty()) {

            return null;
        }


        /*
         * Check content type
         */

        String contentType =
                file.getContentType();

        if (contentType == null ||
                !contentType.startsWith("image/")) {

            throw new IOException(
                    "Only image files are allowed."
            );
        }


        /*
         * =====================================================
         * USE application.yml UPLOAD DIRECTORY
         * =====================================================
         */

        Path uploadPath =
                Paths.get(uploadDir)
                        .toAbsolutePath()
                        .normalize();


        /*
         * Create upload directory
         */

        Files.createDirectories(
                uploadPath
        );


        /*
         * Get original filename
         */

        String originalName =
                file.getOriginalFilename();


        if (originalName == null ||
                originalName.trim().isEmpty()) {

            throw new IOException(
                    "Invalid image filename."
            );
        }


        /*
         * Remove browser path
         */

        originalName =
                Paths.get(originalName)
                        .getFileName()
                        .toString();


        /*
         * Clean filename
         */

        originalName =
                originalName
                        .replace("\\", "_")
                        .replace("/", "_");


        /*
         * Remove dangerous characters.
         *
         * Spaces are allowed.
         */

        originalName =
                originalName.replaceAll(
                        "[^a-zA-Z0-9._() -]",
                        "_"
                );


        /*
         * =====================================================
         * FINAL FILE PATH
         * =====================================================
         */

        Path targetPath =
                uploadPath
                        .resolve(originalName)
                        .normalize();


        /*
         * Security check
         */

        if (!targetPath.startsWith(uploadPath)) {

            throw new IOException(
                    "Invalid image path."
            );
        }


        /*
         * =====================================================
         * COPY ACTUAL UPLOADED FILE
         * =====================================================
         */

        try (var inputStream = file.getInputStream()) {

            Files.copy(
                    inputStream,
                    targetPath,
                    StandardCopyOption.REPLACE_EXISTING
            );
        }


        System.out.println(
                "DESTINATION IMAGE SAVED: "
                        + targetPath
        );


        /*
         * IMPORTANT:
         *
         * Database stores ONLY filename.
         *
         * Example:
         *
         * Goa.jpg
         */

        return originalName;
    }


    /*
     * =========================================================
     * CLEAN DATABASE IMAGE VALUE
     * =========================================================
     */

    private String cleanFileName(
            String imageName) {

        if (imageName == null ||
                imageName.trim().isEmpty()) {

            return null;
        }


        String value =
                imageName
                        .trim()
                        .replace("\\", "/");


        /*
         * If old data contains:
         *
         * images/Goa.jpg
         *
         * /uploads/Goa.jpg
         *
         * /images/Goa.jpg
         *
         * extract only:
         *
         * Goa.jpg
         */

        if (value.contains("/")) {

            value =
                    value.substring(
                            value.lastIndexOf("/") + 1
                    );
        }


        return value;
    }


    /*
     * =========================================================
     * DELETE IMAGE FILE
     * =========================================================
     */

    private void deleteImage(
            String imageName) {

        try {

            String fileName =
                    cleanFileName(
                            imageName
                    );


            if (fileName == null ||
                    fileName.isEmpty()) {

                return;
            }


            /*
             * Use same upload directory
             * used while saving image.
             */

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


            for (int attempt = 1; attempt <= 3; attempt++) {

                try {

                    if (!Files.exists(imagePath)) {
                        return;
                    }

                    Files.deleteIfExists(imagePath);

                    System.out.println(
                            "DESTINATION IMAGE DELETED: "
                                    + imagePath
                    );

                    return;

                } catch (Exception e) {

                    if (attempt == 3) {

                        System.err.println(
                                "Could not delete destination image: "
                                        + e.getMessage()
                        );

                    } else {

                        try {
                            Thread.sleep(200);
                        } catch (InterruptedException interruptedException) {

                            Thread.currentThread().interrupt();
                            return;
                        }
                    }
                }
            }


        } catch (Exception e) {

            /*
             * Do not stop database delete
             * if image deletion fails.
             */

            System.err.println(
                    "Could not delete destination image: "
                            + e.getMessage()
            );
        }
    }
}