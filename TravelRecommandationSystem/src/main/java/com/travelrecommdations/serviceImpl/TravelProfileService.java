package com.travelrecommdations.serviceImpl;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.travelrecommdations.dto.TravelProfileDTO;
import com.travelrecommdations.model.TravelProfile;
import com.travelrecommdations.repository.TravelProfileRepo;

@Service
public class TravelProfileService {

    @Autowired
    private TravelProfileRepo travelProfileRepository;


    // =====================================================
    // GET PROFILE
    // =====================================================

    public Optional<TravelProfile> getProfileByUserId(
            Long userId) {

        return travelProfileRepository
                .findByUserId(userId);
    }


    // =====================================================
    // CHECK PROFILE
    // =====================================================

    public boolean isProfileCompleted(Long userId) {

        return travelProfileRepository
                .isProfileCompleted(userId);
    }


    // =====================================================
    // SAVE PROFILE
    // =====================================================

    public boolean saveProfile(
            TravelProfileDTO dto) {

        TravelProfile profile =
                convertToModel(dto);

        profile.setProfileCompleted(true);

        int result =
                travelProfileRepository.save(profile);

        return result > 0;
    }


    // =====================================================
    // UPDATE PROFILE
    // =====================================================

    public boolean updateProfile(
            TravelProfileDTO dto) {

        TravelProfile profile =
                convertToModel(dto);

        profile.setProfileCompleted(true);

        int result =
                travelProfileRepository.update(profile);

        return result > 0;
    }


    // =====================================================
    // SAVE OR UPDATE
    // =====================================================

    public boolean saveOrUpdateProfile(
            TravelProfileDTO dto) {

        Optional<TravelProfile> existing =
                travelProfileRepository
                        .findByUserId(dto.getUserId());

        if (existing.isPresent()) {

            return updateProfile(dto);

        } else {

            return saveProfile(dto);
        }
    }


    // =====================================================
    // DELETE PROFILE
    // =====================================================

    public int deleteProfile(Long userId) {

        return travelProfileRepository
                .deleteByUserId(userId);
    }


    // =====================================================
    // UPDATE PROFILE PHOTO
    // =====================================================

    public boolean updateProfilePhoto(
            Long userId,
            String fileName) {

        return travelProfileRepository
                .updateProfilePhoto(
                        userId,
                        fileName
                ) > 0;
    }


    // =====================================================
    // DTO -> MODEL
    // =====================================================

    private TravelProfile convertToModel(
            TravelProfileDTO dto) {

        TravelProfile profile =
                new TravelProfile();

        profile.setProfileId(
                dto.getProfileId()
        );

        profile.setUserId(
                dto.getUserId()
        );

        profile.setProfilePhoto(
                dto.getProfilePhoto()
        );

        profile.setAge(
                dto.getAge()
        );

        profile.setLocation(
                dto.getLocation()
        );

        profile.setTravelCompanion(
                dto.getTravelCompanion()
        );

        profile.setBudget(
                dto.getBudget()
        );

        profile.setTripDuration(
                dto.getTripDuration()
        );

        profile.setTransportation(
                dto.getTransportation()
        );

        profile.setAccommodation(
                dto.getAccommodation()
        );

        profile.setInterests(
                dto.getInterests()
        );

        profile.setDestinationCategories(
                dto.getDestinationCategories()
        );

        profile.setFoodPreference(
                dto.getFoodPreference()
        );

        profile.setPreferredSeason(
                dto.getPreferredSeason()
        );

        profile.setTripExperience(
                dto.getTripExperience()
        );

        profile.setProfileCompleted(
                dto.getProfileCompleted()
        );

        return profile;
    }


    // =====================================================
    // MODEL -> DTO
    // =====================================================

    public TravelProfileDTO convertToDTO(
            TravelProfile profile) {

        TravelProfileDTO dto =
                new TravelProfileDTO();

        dto.setProfileId(
                profile.getProfileId()
        );

        dto.setUserId(
                profile.getUserId()
        );

        dto.setProfilePhoto(
                profile.getProfilePhoto()
        );

        dto.setAge(
                profile.getAge()
        );

        dto.setLocation(
                profile.getLocation()
        );

        dto.setTravelCompanion(
                profile.getTravelCompanion()
        );

        dto.setBudget(
                profile.getBudget()
        );

        dto.setTripDuration(
                profile.getTripDuration()
        );

        dto.setTransportation(
                profile.getTransportation()
        );

        dto.setAccommodation(
                profile.getAccommodation()
        );

        dto.setInterests(
                profile.getInterests()
        );

        dto.setDestinationCategories(
                profile.getDestinationCategories()
        );

        dto.setFoodPreference(
                profile.getFoodPreference()
        );

        dto.setPreferredSeason(
                profile.getPreferredSeason()
        );

        dto.setTripExperience(
                profile.getTripExperience()
        );

        dto.setProfileCompleted(
                profile.getProfileCompleted()
        );

        return dto;
    }
}