package com.travelrecommdations.serviceImpl;

import com.travelrecommdations.dto.RecommendationDTO;
import com.travelrecommdations.model.Destination;
import com.travelrecommdations.model.TravelProfile;
import com.travelrecommdations.repository.DestinationDao;
import com.travelrecommdations.repository.TravelProfileRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class RecommendationService {

    @Autowired
    private DestinationDao destinationDao;

    @Autowired
    private TravelProfileRepo travelProfileRepo;

    public List<RecommendationDTO> getRecommendationsForUser(Long userId) {
        List<RecommendationDTO> result = new ArrayList<>();
        if (userId == null) return result;

        Optional<TravelProfile> profileOptional = travelProfileRepo.findByUserId(userId);
        if (profileOptional.isEmpty()) return result;

        TravelProfile profile = profileOptional.get();
        List<Destination> destinations = destinationDao.getAllActiveDestinations();
        if (destinations == null) return result;

        for (Destination destination : destinations) {
            if (destination == null) continue;
            result.add(calculateProfileRecommendation(destination, profile));
        }

        result.sort((a, b) -> Double.compare(
                b.getMatchPercentage() == null ? 0 : b.getMatchPercentage(),
                a.getMatchPercentage() == null ? 0 : a.getMatchPercentage()));
        return result;
    }

    public RecommendationDTO getRecommendationDetails(Long destinationId, Long userId) {
        if (destinationId == null || userId == null) return null;

        Optional<Destination> destination = destinationDao.getDestinationById(destinationId);
        Optional<TravelProfile> profile = travelProfileRepo.findByUserId(userId);
        if (destination.isEmpty() || profile.isEmpty()) return null;

        return calculateProfileRecommendation(destination.get(), profile.get());
    }

    private RecommendationDTO calculateProfileRecommendation(Destination destination, TravelProfile profile) {
        double budgetMatch = calculateBudgetMatch(profile.getBudget(), destination.getBudget());
        double seasonMatch = calculateSeasonMatch(profile.getPreferredSeason(), destination.getBestSeason());
        double interestMatch = calculateInterestMatch(profile, destination);
        double categoryMatch = calculateCategoryMatch(profile, destination);
        double locationMatch = calculateLocationMatch(profile.getLocation(), destination);

        double overall = budgetMatch * .30
                + seasonMatch * .20
                + interestMatch * .25
                + categoryMatch * .20
                + locationMatch * .05;

        RecommendationDTO dto = convertToDTO(destination);
        dto.setBudgetMatch(round(budgetMatch));
        dto.setSeasonMatch(round(seasonMatch));
        dto.setInterestMatch(round(interestMatch));
        dto.setCategoryMatch(round(categoryMatch));
        dto.setLocationMatch(round(locationMatch));
        dto.setMatchPercentage(round(overall));
        dto.setRecommendationType("PROFILE");
        dto.setRecommendationReason(buildReason(profile, destination, budgetMatch, seasonMatch,
                interestMatch, categoryMatch, locationMatch));
        return dto;
    }

    private double calculateBudgetMatch(Double userBudget, Double destinationBudget) {
        if (userBudget == null || destinationBudget == null || userBudget <= 0 || destinationBudget < 0) return 0;
        if (destinationBudget <= userBudget) return 100;
        double difference = destinationBudget - userBudget;
        return Math.max(0, Math.min(100, 100 - ((difference / userBudget) * 100)));
    }

    private double calculateSeasonMatch(String profileSeason, String destinationSeason) {
        if (isBlank(profileSeason) || isBlank(destinationSeason)) return 0;
        String selected = profileSeason.trim().toLowerCase();
        String best = destinationSeason.trim().toLowerCase();
        if (best.contains(selected)) return 100;

        if (selected.equals("summer")) return containsAny(best, "march", "april", "may", "june") ? 100 : 0;
        if (selected.equals("rainy") || selected.equals("monsoon"))
            return containsAny(best, "june", "july", "august", "september", "monsoon", "rainy") ? 100 : 0;
        if (selected.equals("autumn")) return containsAny(best, "september", "october", "november", "autumn") ? 100 : 0;
        if (selected.equals("winter")) return containsAny(best, "november", "december", "january", "february", "winter") ? 100 : 0;
        return 0;
    }

    private double calculateInterestMatch(TravelProfile profile, Destination destination) {
        String interests = profile.getInterests();
        String category = safe(destination.getCategory());
        String description = safe(destination.getDescription());
        if (isBlank(interests)) return 0;

        int matched = 0;
        int total = 0;
        for (String value : interests.split(",")) {
            String item = value.trim().toLowerCase();
            if (item.isEmpty()) continue;
            total++;
            if (category.contains(item) || description.contains(item)
                    || isInterestRelated(item, category, description)) matched++;
        }

        // Food and transportation are also profile information. They are
        // used only when the destination's stored text/category supports it.
        if (!isBlank(profile.getFoodPreference())) {
            total++;
            if (description.contains(profile.getFoodPreference().toLowerCase())
                    || category.contains("food")) matched++;
        }
        if (!isBlank(profile.getTransportation())) {
            total++;
            String transport = profile.getTransportation().toLowerCase();
            if (description.contains(transport)) matched++;
        }
        return total == 0 ? 0 : Math.min(100, (matched * 100.0) / total);
    }

    private double calculateCategoryMatch(TravelProfile profile, Destination destination) {
        String categories = profile.getDestinationCategories();
        String category = safe(destination.getCategory());
        if (isBlank(categories)) return companionCategoryMatch(profile.getTravelCompanion(), category);

        double best = 0;
        for (String value : categories.split(",")) {
            String item = value.trim().toLowerCase();
            if (item.isEmpty()) continue;
            if (item.equals(category)) best = Math.max(best, 100);
            else if (category.contains(item) || item.contains(category)) best = Math.max(best, 80);
            else if (isRelatedCategory(item, category)) best = Math.max(best, 70);
        }
        best = Math.max(best, companionCategoryMatch(profile.getTravelCompanion(), category));
        best = Math.max(best, experienceCategoryMatch(profile.getTripExperience(), category));
        best = Math.max(best, accommodationCategoryMatch(profile.getAccommodation(), category));
        return best;
    }

    private boolean isInterestRelated(String interest, String category, String description) {
        String i = safe(interest).toLowerCase();
        if (i.equals("beaches") || i.equals("beach")) return category.contains("beach");
        if (i.contains("trek")) return containsAny(category, "trek", "mountain", "hill", "adventure");
        if (i.contains("hill station")) return containsAny(category, "hill", "mountain");
        if (i.contains("historical")) return containsAny(category, "historical", "heritage", "fort", "palace");
        if (i.contains("spiritual") || i.contains("religious")) return containsAny(category, "spiritual", "religious", "temple");
        if (i.contains("wildlife")) return containsAny(category, "wildlife", "forest", "nature");
        if (i.contains("nightlife")) return containsAny(category, "nightlife", "party", "city", "entertainment") || description.contains("nightlife");
        if (i.contains("shopping")) return containsAny(category, "city", "shopping") || description.contains("shopping");
        if (i.contains("photography")) return containsAny(category, "nature", "heritage", "beach", "mountain", "city");
        if (i.contains("food")) return description.contains("food") || description.contains("cuisine") || category.contains("food");
        return isRelatedCategory(i, category);
    }

    private double experienceCategoryMatch(String experience, String category) {
        if (isBlank(experience)) return 0;
        String e = experience.toLowerCase();
        if (e.contains("adventur")) return isRelatedCategory("adventure", category) ? 70 : 0;
        if (e.contains("cultural")) return isRelatedCategory("culture", category) ? 70 : 0;
        if (e.contains("party")) return isRelatedCategory("party", category) ? 70 : 0;
        return 0;
    }

    private double accommodationCategoryMatch(String accommodation, String category) {
        if (isBlank(accommodation)) return 0;
        String a = accommodation.toLowerCase();
        if (a.contains("resort") || a.contains("luxury"))
            return containsAny(category, "beach", "island", "resort", "lake", "nature") ? 60 : 0;
        if (a.contains("hostel") || a.contains("budget"))
            return containsAny(category, "adventure", "nature", "city", "hill") ? 60 : 0;
        return 0;
    }

    private double companionCategoryMatch(String companion, String category) {
        if (isBlank(companion)) return 0;
        String c = companion.toLowerCase();
        if (containsAny(c, "couple", "partner", "romantic"))
            return isRelatedCategory("romantic", category) ? 75 : 0;
        if (containsAny(c, "friend", "friends"))
            return isRelatedCategory("party", category) || isRelatedCategory("adventure", category) ? 75 : 0;
        if (containsAny(c, "family", "families"))
            return category.contains("nature") || category.contains("historical") || category.contains("spiritual") ? 75 : 0;
        if (c.contains("solo"))
            return isRelatedCategory("adventure", category) || isRelatedCategory("nature", category) ? 75 : 0;
        return 0;
    }

    private boolean isRelatedCategory(String profileValue, String destinationCategory) {
        String profile = safe(profileValue).toLowerCase();
        String category = safe(destinationCategory).toLowerCase();
        if (profile.contains("romantic") || profile.contains("couple"))
            return containsAny(category, "beach", "lake", "hill", "nature", "island", "romantic", "resort");
        if (profile.contains("relax") || profile.contains("peace"))
            return containsAny(category, "beach", "lake", "nature", "backwater", "hill", "resort");
        if (profile.contains("adventure"))
            return containsAny(category, "adventure", "mountain", "waterfall", "trek", "wildlife", "hill");
        if (profile.contains("nature"))
            return containsAny(category, "nature", "wildlife", "mountain", "lake", "waterfall", "hill");
        if (profile.contains("spiritual") || profile.contains("religious"))
            return containsAny(category, "spiritual", "religious", "historical", "temple");
        if (profile.contains("culture") || profile.contains("heritage"))
            return containsAny(category, "heritage", "historical", "spiritual", "culture", "city");
        if (profile.contains("party") || profile.contains("fun"))
            return containsAny(category, "beach", "city", "entertainment", "party", "nightlife");
        return false;
    }

    private double calculateLocationMatch(String profileLocation, Destination destination) {
        if (isBlank(profileLocation)) return 0;
        String location = profileLocation.trim().toLowerCase();
        String state = safe(destination.getState()).trim().toLowerCase();
        String country = safe(destination.getCountry()).trim().toLowerCase();
        if (location.equals(state) || location.equals(country)) return 100;
        if ((!state.isEmpty() && (state.contains(location) || location.contains(state))) ||
            (!country.isEmpty() && (country.contains(location) || location.contains(country)))) return 80;
        return 0;
    }

    public List<RecommendationDTO> getByBudget(Double minBudget, Double maxBudget) {
        List<RecommendationDTO> result = convertList(destinationDao.getDestinationsByBudget(minBudget, maxBudget));
        for (RecommendationDTO dto : result) {
            dto.setBudgetMatch(100.0);
            dto.setMatchPercentage(100.0);
            dto.setRecommendationType("BUDGET");
            dto.setRecommendationReason("This destination is within your selected budget range.");
        }
        return result;
    }

    public List<RecommendationDTO> getByMood(String mood) {
        // Kept for compatibility. The UI intentionally applies mood-to-category mapping in JavaScript
        // because mood values are not stored as a separate database field.
        List<RecommendationDTO> result = convertList(destinationDao.getDestinationsByCategory(mood));
        for (RecommendationDTO dto : result) {
            dto.setRecommendationType("MOOD");
            dto.setRecommendationReason("Recommended using the selected mood and destination category.");
        }
        return result;
    }

    public List<RecommendationDTO> getBySeason(String season) {
        List<RecommendationDTO> result = new ArrayList<>();
        if (isBlank(season)) return result;
        List<Destination> destinations = destinationDao.getAllActiveDestinations();
        for (Destination destination : destinations) {
            if (matchesSeason(destination.getBestSeason(), season)) {
                RecommendationDTO dto = convertToDTO(destination);
                dto.setSeasonMatch(100.0);
                dto.setMatchPercentage(100.0);
                dto.setRecommendationType("SEASON");
                dto.setRecommendationReason("Recommended because its best visiting period matches " + season + ".");
                result.add(dto);
            }
        }
        return result;
    }

    private boolean matchesSeason(String bestSeason, String selectedSeason) {
        return calculateSeasonMatch(selectedSeason, bestSeason) > 0;
    }

    private String buildReason(TravelProfile profile, Destination d, double budget, double season,
                               double interest, double category, double location) {
        List<String> reasons = new ArrayList<>();
        if (budget >= 100) reasons.add("fits your budget");
        else if (budget >= 60) reasons.add("is close to your budget");
        if (season >= 100) reasons.add("matches your preferred season");
        if (interest >= 60) reasons.add("matches your interests");
        if (category >= 70) reasons.add("matches your preferred destination type");
        if (profile.getTravelCompanion() != null && companionCategoryMatch(profile.getTravelCompanion(), safe(d.getCategory())) > 0)
            reasons.add("suits your travel companion preference");
        if (location >= 80) reasons.add("matches your location preference");
        if (reasons.isEmpty()) return "Recommended from the information available in your travel profile.";
        if (reasons.size() == 1) return "Why recommended: " + reasons.get(0) + ".";
        return "Why recommended: " + String.join(", ", reasons.subList(0, reasons.size() - 1))
                + " and " + reasons.get(reasons.size() - 1) + ".";
    }

    private RecommendationDTO convertToDTO(Destination destination) {
        RecommendationDTO dto = new RecommendationDTO();
        dto.setDestinationId(destination.getId());
        dto.setDestinationName(destination.getDestinationName());
        dto.setState(destination.getState());
        dto.setCountry(destination.getCountry());
        dto.setCategory(destination.getCategory());
        dto.setBudget(destination.getBudget());
        dto.setBestSeason(destination.getBestSeason());
        dto.setDescription(destination.getDescription());
        dto.setImage(destination.getImage());
        dto.setStatus(destination.getStatus());
        return dto;
    }

    private List<RecommendationDTO> convertList(List<Destination> destinations) {
        List<RecommendationDTO> result = new ArrayList<>();
        if (destinations == null) return result;
        for (Destination destination : destinations) if (destination != null) result.add(convertToDTO(destination));
        return result;
    }

    private boolean containsAny(String value, String... words) {
        if (value == null) return false;
        for (String word : words) if (value.contains(word)) return true;
        return false;
    }

    private boolean isBlank(String value) { return value == null || value.trim().isEmpty(); }
    private String safe(String value) { return value == null ? "" : value; }
    private double round(double value) { return Math.round(value * 100.0) / 100.0; }
    
    public List<RecommendationDTO> getPersonalizedDestinations(
            Double minBudget, 
            Double maxBudget, 
            String season, 
            String mood, 
            String category, 
            String companion) {
        
        List<Destination> destinations = destinationDao.getPersonalizedDestinations(
            minBudget, maxBudget, season, mood, category, companion
        );

        return destinations.stream().map(this::convertToDTO).collect(Collectors.toList());
    }
}



