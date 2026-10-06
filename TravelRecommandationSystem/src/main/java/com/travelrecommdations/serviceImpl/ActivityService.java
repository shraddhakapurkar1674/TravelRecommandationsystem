package com.travelrecommdations.serviceImpl;

import com.travelrecommdations.repository.ActivityRepo;
import com.travelrecommdations.model.Activity;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class ActivityService {

    @Autowired
    private ActivityRepo activityDao;

    // =====================================================
    // IMAGE UPLOAD DIRECTORY
    // =====================================================

    private final String UPLOAD_DIR =
            "D:/TravelRecommandationSystem/images/";


    // =====================================================
    // GET ALL ACTIVITIES
    // =====================================================

    public List<Activity> getAllActivities() {

        return activityDao.getAllActivities();
    }


    // =====================================================
    // GET ACTIVITY BY ID
    // =====================================================

    public Activity getActivityById(Long id) {

        return activityDao.getActivityById(id);
    }


    // =====================================================
    // ADD ACTIVITY
    // =====================================================

    public boolean addActivity(
            Activity activity,
            MultipartFile image
    ) throws IOException {

        // ---------------------------------------------
        // Save image
        // ---------------------------------------------

        if (image != null && !image.isEmpty()) {

            String fileName = saveImage(image);

            // Database मध्ये फक्त filename save होईल
            // Example: Booting.jpg
            activity.setImage(fileName);
        }

        // ---------------------------------------------
        // Save activity into database
        // ---------------------------------------------

        int result =
                activityDao.addActivity(activity);

        return result > 0;
    }


    // =====================================================
    // UPDATE ACTIVITY
    // =====================================================

    public boolean updateActivity(
            Activity activity,
            MultipartFile image
    ) throws IOException {

        // ---------------------------------------------
        // Get old activity
        // ---------------------------------------------

        Activity oldActivity =
                activityDao.getActivityById(
                        activity.getActivityId()
                );


        // ---------------------------------------------
        // If new image selected
        // ---------------------------------------------

        if (image != null && !image.isEmpty()) {

            String fileName = saveImage(image);

            // New image filename
            activity.setImage(fileName);

        } else {

            // -----------------------------------------
            // No new image selected
            // Keep old image
            // -----------------------------------------

            if (oldActivity != null) {

                activity.setImage(
                        oldActivity.getImage()
                );
            }
        }


        // ---------------------------------------------
        // Update database
        // ---------------------------------------------

        int result =
                activityDao.updateActivity(activity);

        return result > 0;
    }


    // =====================================================
    // DELETE ACTIVITY
    // =====================================================

    public boolean deleteActivity(Long id) {

        int result =
                activityDao.deleteActivity(id);

        return result > 0;
    }


    // =====================================================
    // SAVE IMAGE
    // =====================================================

    private String saveImage(
            MultipartFile image
    ) throws IOException {


        // ---------------------------------------------
        // Create upload directory
        // ---------------------------------------------

        Path uploadPath =
                Paths.get(UPLOAD_DIR);

        if (!Files.exists(uploadPath)) {

            Files.createDirectories(
                    uploadPath
            );
        }


        // ---------------------------------------------
        // Get original filename
        // ---------------------------------------------

        String originalName =
                image.getOriginalFilename();


        if (originalName == null ||
            originalName.trim().isEmpty()) {

            throw new IOException(
                    "Invalid image filename"
            );
        }


        // ---------------------------------------------
        // Remove any path from filename
        // Example:
        // C:\Users\Admin\Pictures\Booting.jpg
        //
        // Result:
        // Booting.jpg
        // ---------------------------------------------

        String fileName =
                Paths.get(originalName)
                     .getFileName()
                     .toString();


        // ---------------------------------------------
        // Create final file path
        // ---------------------------------------------

        Path filePath =
                uploadPath.resolve(fileName);


        // ---------------------------------------------
        // Save image
        // ---------------------------------------------

        Files.copy(
                image.getInputStream(),
                filePath,
                StandardCopyOption.REPLACE_EXISTING
        );


        // ---------------------------------------------
        
        // ---------------------------------------------

        return fileName;
    }
}