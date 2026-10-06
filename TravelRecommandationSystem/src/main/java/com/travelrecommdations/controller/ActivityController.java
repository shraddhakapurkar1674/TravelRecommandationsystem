package com.travelrecommdations.controller;

import com.travelrecommdations.model.Activity;
import com.travelrecommdations.serviceImpl.ActivityService;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api")
public class ActivityController {

    @Autowired
    private ActivityService activityService;


    // =====================================================
    // TEST
    // =====================================================

    @GetMapping("/activities/test")
    public ResponseEntity<String> testActivityApi() {

        return ResponseEntity.ok(
                "Activity API is working"
        );
    }


    // =====================================================
    // GET ALL
    // =====================================================

    @GetMapping("/activities")public ResponseEntity<List<Activity>> getAllActivities() {

        return ResponseEntity.ok(
                activityService.getAllActivities()
        );
    }


    // =====================================================
    // GET BY ID
    // =====================================================

    @GetMapping("/activities/{id}")
    public ResponseEntity<?> getActivityById(
            @PathVariable Long id) {

        Activity activity =
                activityService.getActivityById(id);

        if (activity == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(activity);
    }


    // =====================================================
    // ADD ACTIVITY
    // =====================================================

    @PostMapping(value = "/activities",consumes = "multipart/form-data")
    public ResponseEntity<?> addActivity(

            @RequestParam Long destinationId,

            @RequestParam String activityName,

            @RequestParam String activityType,

            @RequestParam String location,

            @RequestParam(required = false) Double price,

            @RequestParam(required = false) String duration,

            @RequestParam(required = false) String description,

            @RequestParam(required = false) String status,

            @RequestPart(required = false) MultipartFile image

    ) {

        try {

            Activity activity =
                    new Activity();


            activity.setDestinationId(
                    destinationId
            );

            activity.setActivityName(
                    activityName
            );

            activity.setActivityType(
                    activityType
            );

            activity.setLocation(
                    location
            );

            activity.setPrice(
                    price
            );

            activity.setDuration(
                    duration
            );

            activity.setDescription(
                    description
            );

            activity.setStatus(
                    status
            );


            boolean result =
                    activityService.addActivity(
                            activity,
                            image
                    );


            if (result) {

                return ResponseEntity.ok(
                        activity
                );
            }


            return ResponseEntity
                    .badRequest()
                    .body("Activity not added");


        } catch (Exception e) {

            e.printStackTrace();

            return ResponseEntity
                    .internalServerError()
                    .body(
                        "Activity Save Error: "
                        + e.getMessage()
                    );
        }
    }


    // =====================================================
    // UPDATE ACTIVITY
    // =====================================================

    @PutMapping(
        value = "/activities/{id}",
        consumes = "multipart/form-data"
    )
    public ResponseEntity<?> updateActivity(

            @PathVariable Long id,

            @RequestParam Long destinationId,

            @RequestParam String activityName,

            @RequestParam String activityType,

            @RequestParam String location,

            @RequestParam(required = false) Double price,

            @RequestParam(required = false) String duration,

            @RequestParam(required = false) String description,

            @RequestParam(required = false) String status,

            @RequestPart(required = false) MultipartFile image

    ) {

        try {

            Activity activity =
                    new Activity();


            activity.setActivityId(id);

            activity.setDestinationId(
                    destinationId
            );

            activity.setActivityName(
                    activityName
            );

            activity.setActivityType(
                    activityType
            );

            activity.setLocation(
                    location
            );

            activity.setPrice(
                    price
            );

            activity.setDuration(
                    duration
            );

            activity.setDescription(
                    description
            );

            activity.setStatus(
                    status
            );


            boolean result =
                    activityService.updateActivity(
                            activity,
                            image
                    );


            if (result) {

                return ResponseEntity.ok(
                        activity
                );
            }


            return ResponseEntity
                    .badRequest()
                    .body("Activity not updated");


        } catch (Exception e) {

            e.printStackTrace();

            return ResponseEntity
                    .internalServerError()
                    .body(
                        "Activity Update Error: "
                        + e.getMessage()
                    );
        }
    }


    // =====================================================
    // DELETE
    // =====================================================

    @DeleteMapping("/activities/{id}")
    public ResponseEntity<?> deleteActivity(
            @PathVariable Long id) {

        try {

            boolean result =
                    activityService.deleteActivity(id);


            if (result) {

                return ResponseEntity.ok(
                    "Activity deleted successfully"
                );
            }


            return ResponseEntity
                    .badRequest()
                    .body(
                        "Activity not deleted"
                    );


        } catch (Exception e) {

            e.printStackTrace();

            return ResponseEntity
                    .internalServerError()
                    .body(
                        "Activity Delete Error: "
                        + e.getMessage()
                    );
        }
    }
}