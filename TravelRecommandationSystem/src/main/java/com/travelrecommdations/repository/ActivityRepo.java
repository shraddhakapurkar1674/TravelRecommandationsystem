package com.travelrecommdations.repository;
import com.travelrecommdations.model.Activity;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;


@Repository
public class ActivityRepo{

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // =========================
    // GET ALL ACTIVITIES
    // =========================
    public List<Activity> getAllActivities() {

        String sql = "SELECT * FROM Activity ORDER BY activity_id DESC";

        return jdbcTemplate.query(sql, (rs, rowNum) -> {

            Activity activity = new Activity();

            activity.setActivityId(rs.getLong("activity_id"));
            activity.setDestinationId(rs.getLong("destination_id"));
            activity.setActivityName(rs.getString("activity_name"));
            activity.setActivityType(rs.getString("activity_type"));
            activity.setLocation(rs.getString("location"));
            activity.setPrice(rs.getDouble("price"));
            activity.setDuration(rs.getString("duration"));
            activity.setDescription(rs.getString("description"));
            activity.setImage(rs.getString("image"));
            activity.setStatus(rs.getString("status"));

            return activity;
        });
    }

    // =========================
    // GET ACTIVITY BY ID
    // =========================
    public Activity getActivityById(Long id) {

        String sql = "SELECT * FROM Activity WHERE activity_id = ?";

        List<Activity> list = jdbcTemplate.query(sql, new Object[]{id},
                (rs, rowNum) -> {

                    Activity activity = new Activity();

                    activity.setActivityId(rs.getLong("activity_id"));
                    activity.setDestinationId(rs.getLong("destination_id"));
                    activity.setActivityName(rs.getString("activity_name"));
                    activity.setActivityType(rs.getString("activity_type"));
                    activity.setLocation(rs.getString("location"));
                    activity.setPrice(rs.getDouble("price"));
                    activity.setDuration(rs.getString("duration"));
                    activity.setDescription(rs.getString("description"));
                    activity.setImage(rs.getString("image"));
                    activity.setStatus(rs.getString("status"));

                    return activity;
                });

        if (list.isEmpty()) {
            return null;
        }

        return list.get(0);
    }

    // =========================
    // ADD ACTIVITY
    // =========================
    public int addActivity(Activity activity) {

        String sql = """
                INSERT INTO Activity
                (
                    destination_id,
                    activity_name,
                    activity_type,
                    location,
                    price,
                    duration,
                    description,
                    image,
                    status
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        return jdbcTemplate.update(
                sql,
                activity.getDestinationId(),
                activity.getActivityName(),
                activity.getActivityType(),
                activity.getLocation(),
                activity.getPrice(),
                activity.getDuration(),
                activity.getDescription(),
                activity.getImage(),
                activity.getStatus()
        );
    }

    // =========================
    // UPDATE ACTIVITY
    // =========================
    public int updateActivity(Activity activity) {

        String sql = """
                UPDATE Activity
                SET
                    destination_id = ?,
                    activity_name = ?,
                    activity_type = ?,
                    location = ?,
                    price = ?,
                    duration = ?,
                    description = ?,
                    image = ?,
                    status = ?
                WHERE activity_id = ?
                """;

        return jdbcTemplate.update(
                sql,
                activity.getDestinationId(),
                activity.getActivityName(),
                activity.getActivityType(),
                activity.getLocation(),
                activity.getPrice(),
                activity.getDuration(),
                activity.getDescription(),
                activity.getImage(),
                activity.getStatus(),
                activity.getActivityId()
        );
    }

    // =========================
    // DELETE ACTIVITY
    // =========================
    public int deleteActivity(Long id) {

        String sql = "DELETE FROM Activity WHERE activity_id = ?";

        return jdbcTemplate.update(sql, id);
    }
}