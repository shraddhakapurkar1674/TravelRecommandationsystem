package com.travelrecommdations.repository;

import com.travelrecommdations.model.TravelProfile;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;

@Repository
public class TravelProfileRepo {

    @Autowired
    private JdbcTemplate jdbcTemplate;


    // =====================================================
    // FIND BY USER ID
    // =====================================================

    public Optional<TravelProfile> findByUserId(Long userId) {

        String sql =
            "SELECT " +
            "profile_id, " +
            "user_id, " +
            "profile_photo, " +
            "age, " +
            "location, " +
            "travel_companion, " +
            "budget, " +
            "trip_duration, " +
            "transportation, " +
            "accommodation, " +
            "interests, " +
            "destination_categories, " +
            "food_preference, " +
            "preferred_season, " +
            "trip_experience, " +
            "profile_completed " +
            "FROM travel_profile " +
            "WHERE user_id = ?";

        try {

            TravelProfile profile =
                jdbcTemplate.queryForObject(
                    sql,
                    this::mapRow,
                    userId
                );

            return Optional.ofNullable(profile);

        } catch (Exception e) {

            return Optional.empty();
        }
    }


    // =====================================================
    // CHECK PROFILE COMPLETED
    // =====================================================

    public boolean isProfileCompleted(Long userId) {

        String sql =
            "SELECT profile_completed " +
            "FROM travel_profile " +
            "WHERE user_id = ?";

        try {

            Boolean completed =
                jdbcTemplate.queryForObject(
                    sql,
                    Boolean.class,
                    userId
                );

            return Boolean.TRUE.equals(completed);

        } catch (Exception e) {

            return false;
        }
    }


    // =====================================================
    // SAVE
    // =====================================================

    public int save(TravelProfile profile) {

        String sql =
            "INSERT INTO travel_profile (" +
            "user_id, " +
            "profile_photo, " +
            "age, " +
            "location, " +
            "travel_companion, " +
            "budget, " +
            "trip_duration, " +
            "transportation, " +
            "accommodation, " +
            "interests, " +
            "destination_categories, " +
            "food_preference, " +
            "preferred_season, " +
            "trip_experience, " +
            "profile_completed" +
            ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        return jdbcTemplate.update(
            sql,
            profile.getUserId(),
            profile.getProfilePhoto(),
            profile.getAge(),
            profile.getLocation(),
            profile.getTravelCompanion(),
            profile.getBudget(),
            profile.getTripDuration(),
            profile.getTransportation(),
            profile.getAccommodation(),
            profile.getInterests(),
            profile.getDestinationCategories(),
            profile.getFoodPreference(),
            profile.getPreferredSeason(),
            profile.getTripExperience(),
            profile.getProfileCompleted()
        );
    }


    // =====================================================
    // UPDATE
    // =====================================================

    public int update(TravelProfile profile) {

        String sql =
            "UPDATE travel_profile SET " +
            "profile_photo = ?, " +
            "age = ?, " +
            "location = ?, " +
            "travel_companion = ?, " +
            "budget = ?, " +
            "trip_duration = ?, " +
            "transportation = ?, " +
            "accommodation = ?, " +
            "interests = ?, " +
            "destination_categories = ?, " +
            "food_preference = ?, " +
            "preferred_season = ?, " +
            "trip_experience = ?, " +
            "profile_completed = ? " +
            "WHERE user_id = ?";

        return jdbcTemplate.update(
            sql,
            profile.getProfilePhoto(),
            profile.getAge(),
            profile.getLocation(),
            profile.getTravelCompanion(),
            profile.getBudget(),
            profile.getTripDuration(),
            profile.getTransportation(),
            profile.getAccommodation(),
            profile.getInterests(),
            profile.getDestinationCategories(),
            profile.getFoodPreference(),
            profile.getPreferredSeason(),
            profile.getTripExperience(),
            profile.getProfileCompleted(),
            profile.getUserId()
        );
    }


    // =====================================================
    // DELETE
    // =====================================================

    public int deleteByUserId(Long userId) {

        String sql =
            "DELETE FROM travel_profile WHERE user_id = ?";

        return jdbcTemplate.update(
            sql,
            userId
        );
    }


    // =====================================================
    // UPDATE PHOTO
    // =====================================================

    public int updateProfilePhoto(
            Long userId,
            String fileName) {

        String sql =
            "UPDATE travel_profile " +
            "SET profile_photo = ? " +
            "WHERE user_id = ?";

        return jdbcTemplate.update(
            sql,
            fileName,
            userId
        );
    }


    // =====================================================
    // ROW MAPPER
    // =====================================================

    private TravelProfile mapRow(
            ResultSet rs,
            int rowNum) throws SQLException {

        TravelProfile profile =
            new TravelProfile();

        profile.setProfileId(
            rs.getLong("profile_id")
        );

        profile.setUserId(
            rs.getLong("user_id")
        );

        profile.setProfilePhoto(
            rs.getString("profile_photo")
        );

        profile.setAge(
            rs.getInt("age")
        );

        profile.setLocation(
            rs.getString("location")
        );

        profile.setTravelCompanion(
            rs.getString("travel_companion")
        );

        profile.setBudget(
            rs.getDouble("budget")
        );

        profile.setTripDuration(
            rs.getString("trip_duration")
        );

        profile.setTransportation(
            rs.getString("transportation")
        );

        profile.setAccommodation(
            rs.getString("accommodation")
        );

        profile.setInterests(
            rs.getString("interests")
        );

        profile.setDestinationCategories(
            rs.getString("destination_categories")
        );

        profile.setFoodPreference(
            rs.getString("food_preference")
        );

        profile.setPreferredSeason(
            rs.getString("preferred_season")
        );

        profile.setTripExperience(
            rs.getString("trip_experience")
        );

        profile.setProfileCompleted(
            rs.getBoolean("profile_completed")
        );

        return profile;
    }
}