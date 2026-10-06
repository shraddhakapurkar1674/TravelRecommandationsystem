/* =========================================================
   TRIP NETRA
   RECOMMENDATION MODULE
   ========================================================= */

const RECOMMENDATION_API =
    API_CONFIG.api("/api/recommendations");

const DESTINATION_API =
    API_CONFIG.api("/api/destinations");

const BACKEND_UPLOAD =
    API_CONFIG.BASE_URL + "/uploads/";

const FRONTEND_BASE =
    API_CONFIG.FRONTEND_BASE_URL;

const ITEMS_PER_PAGE = 6;


/* =========================================================
   GLOBAL VARIABLES
   ========================================================= */

let currentMode = "forYou";
let currentRecommendations = [];
let currentPage = 1;
let currentSeason = "";
let currentMood = "";
let currentRecommendationReason = "";
let currentUserId = null;


/* =========================================================
   PAGE LOAD
   ========================================================= */

document.addEventListener(
    "DOMContentLoaded",
    function () {
        currentUserId = getLoggedInUserId();
        initFromQuickFilterParams();
    }
);


/* =========================================================
   DEEP-LINK FROM DASHBOARD QUICK FILTERS
   Reads ?mode=&minBudget=&maxBudget=&category=&companion=&
   location=&season=&mood= (all optional) set by the
   dashboard's Quick Filters / mode tiles, pre-fills the
   matching form and auto-runs the search. Falls back to the
   normal "forYou" tab when no params are present.
   ========================================================= */
function initFromQuickFilterParams() {
    const params = new URLSearchParams(window.location.search);
    const mode = params.get("mode") || "forYou";

    switchRecommendationMode(mode);

    if (mode === "personalized") {
        if (params.get("minBudget")) document.getElementById("personalMinBudget").value = params.get("minBudget");
        if (params.get("maxBudget")) document.getElementById("personalMaxBudget").value = params.get("maxBudget");
        if (params.get("season")) document.getElementById("personalSeason").value = params.get("season");
        if (params.get("mood")) document.getElementById("personalMood").value = params.get("mood");
        if (params.get("category")) document.getElementById("personalCategory").value = params.get("category");
        if (params.get("companion")) document.getElementById("personalCompanion").value = params.get("companion");

        const hasAnyParam = ["minBudget", "maxBudget", "season", "mood", "category", "companion"]
            .some(key => params.get(key));

        if (hasAnyParam) {
            findPersonalizedDestinations();
        }
    } else if (mode === "budget" && params.get("minBudget") && params.get("maxBudget")) {
        document.getElementById("minBudget").value = params.get("minBudget");
        document.getElementById("maxBudget").value = params.get("maxBudget");
        findBudgetDestinations();
    } else if (mode === "mood" && params.get("mood")) {
        findMoodDestinations(params.get("mood"));
    } else if (mode === "season" && params.get("season")) {
        findSeasonDestinations(params.get("season"));
    }
}


/* =========================================================
   GET USER ID
   ========================================================= */

function getLoggedInUserId() {
    const keys = ["userId", "loggedInUserId", "user_id", "currentUserId", "USER_ID", "USERID"];
    for (const key of keys) {
        const value = localStorage.getItem(key);
        if (value !== null && String(value).trim() !== "") {
            return String(value).trim();
        }
    }
    for (const key of keys) {
        const value = sessionStorage.getItem(key);
        if (value !== null && String(value).trim() !== "") {
            return String(value).trim();
        }
    }
    const objectKeys = ["loggedInUser", "user", "currentUser"];
    for (const key of objectKeys) {
        try {
            const raw = localStorage.getItem(key);
            if (!raw) continue;
            const user = JSON.parse(raw);
            if (user?.userId != null) return String(user.userId);
            if (user?.id != null) return String(user.id);
        } catch (e) {
            console.warn("User object parse error", e);
        }
    }
    return null;
}


/* =========================================================
   SWITCH MODE
   ========================================================= */

function switchRecommendationMode(mode) {
    currentMode = mode;
    currentPage = 1;

    document.querySelectorAll(".recommendation-tab").forEach(function (tab) {
        tab.classList.remove("active");
    });

    const activeTab = document.querySelector('[data-mode="' + mode + '"]');
    if (activeTab) {
        activeTab.classList.add("active");
    }

    document.querySelectorAll(".recommendation-section").forEach(function (section) {
        section.classList.remove("active");
    });

    const section = document.getElementById(mode + "-section");
    if (section) {
        section.classList.add("active");
    }

    if (mode === "forYou") {
        loadForYouRecommendations();
    }
}


/* =========================================================
   FOR YOU
   ========================================================= */

async function loadForYouRecommendations() {
    showLoading();
    hideError();
    hideEmpty();

    const userId = getLoggedInUserId();
    if (!userId) {
        showError("Please login first to get personalized recommendations.");
        return;
    }
    currentUserId = userId;

    try {
        const response = await fetch(RECOMMENDATION_API + "/" + encodeURIComponent(userId), {
            method: "GET",
            headers: { "Accept": "application/json" }
        });

        if (!response.ok) {
            throw new Error("Recommendation API error: " + response.status);
        }

        const data = await response.json();
        let destinations = normalizeDestinationArray(data);

        destinations = destinations.map(function (destination) {
            return normalizeRecommendation(destination);
        });

        destinations.sort(function (a, b) {
            return b.matchPercentage - a.matchPercentage;
        });

        currentRecommendations = destinations;
        currentPage = 1;
        currentRecommendationReason = "These destinations are recommended using the information saved in your travel profile.";

        displayDestinations(destinations, "Recommended For You", currentRecommendationReason);
    } catch (error) {
        console.error("For You error:", error);
        showError("Unable to load personalized recommendations.");
    }
}


/* =========================================================
   PERSONALIZED (Factor selection logic added as requested)
   ========================================================= */

async function findPersonalizedDestinations() {
    const min = getNumberValue("personalMinBudget");
    const max = getNumberValue("personalMaxBudget");
    const season = getValue("personalSeason");
    const mood = getValue("personalMood");
    const category = getValue("personalCategory");
    const companion = getValue("personalCompanion");

    if (min !== null && max !== null && min > max) {
        showError("Minimum budget cannot be greater than maximum budget.");
        return;
    }

    if (min === null && max === null && !season && !mood && !category && !companion) {
        showError("Please select at least one factor/preference.");
        return;
    }

    showLoading();
    hideError();
    hideEmpty();

    try {
        const params = new URLSearchParams();
        if (min !== null) params.append("minBudget", min);
        if (max !== null) params.append("maxBudget", max);
        if (season) params.append("season", season);
        if (mood) params.append("mood", mood);
        if (category) params.append("category", category);
        if (companion) params.append("companion", companion);

        const url = RECOMMENDATION_API + "/personalized?" + params.toString();
        const response = await fetch(url, {
            method: "GET",
            headers: { "Accept": "application/json" }
        });

        if (!response.ok) {
            throw new Error("Personalized API error: " + response.status);
        }

        const data = await response.json();
        let destinations = normalizeDestinationArray(data);

        destinations = destinations.map(function (destination) {
            const d = normalizeRecommendation(destination);
            d.recommendationReason = buildPersonalReason(min, max, season, mood, category, companion);
            return d;
        });

        destinations.sort(function (a, b) {
            return b.matchPercentage - a.matchPercentage;
        });

        currentRecommendations = destinations;
        currentPage = 1;

        displayDestinations(destinations, "Filtered Recommendations by Factors", "Showing destinations matching your chosen factors.");
    } catch (error) {
        console.error("Personalized recommendation error:", error);
        showError("Unable to generate recommendations based on selected factors.");
    }
}


/* =========================================================
   BUDGET
   ========================================================= */

async function findBudgetDestinations() {
    const min = getNumberValue("minBudget");
    const max = getNumberValue("maxBudget");

    if (min === null || max === null) {
        showError("Please enter both minimum and maximum budget.");
        return;
    }
    if (min < 0 || max < 0) {
        showError("Budget cannot be negative.");
        return;
    }
    if (min > max) {
        showError("Minimum budget cannot be greater than maximum budget.");
        return;
    }

    showLoading();
    hideError();
    hideEmpty();

    try {
        const url = RECOMMENDATION_API + "/budget?minBudget=" + encodeURIComponent(min) + "&maxBudget=" + encodeURIComponent(max);
        const response = await fetch(url, {
            method: "GET",
            headers: { "Accept": "application/json" }
        });

        if (!response.ok) {
            throw new Error("Budget API error: " + response.status);
        }

        const data = await response.json();
        let destinations = normalizeDestinationArray(data);

        destinations = destinations.map(function (destination) {
            const d = normalizeRecommendation(destination);
            d.budgetMatch = 100;
            d.matchPercentage = 100;
            d.recommendationType = "BUDGET";
            d.recommendationReason = "This destination is within your selected budget range (₹" + formatNumber(min) + " - ₹" + formatNumber(max) + ").";
            return d;
        });

        currentRecommendations = destinations;
        currentPage = 1;

        displayDestinations(destinations, "Budget Recommendations", "Destinations available between ₹" + formatNumber(min) + " and ₹" + formatNumber(max) + ".");
    } catch (error) {
        console.error("Budget error:", error);
        showError("Unable to load budget recommendations.");
    }
}


/* =========================================================
   MOOD
   ========================================================= */

async function findMoodDestinations(mood) {
    if (!mood) return;
    currentMood = mood;

    showLoading();
    hideError();
    hideEmpty();

    try {
        const response = await fetch(DESTINATION_API, {
            method: "GET",
            headers: { "Accept": "application/json" }
        });

        if (!response.ok) {
            throw new Error("Destination API error: " + response.status);
        }

        const data = await response.json();
        let destinations = normalizeDestinationArray(data);

        destinations = destinations
            .filter(function (destination) {
                return moodMatchesDestination(mood, destination);
            })
            .map(function (destination) {
                const d = normalizeRecommendation(destination);
                d.matchPercentage = calculateMoodScore(mood, destination);
                d.categoryMatch = d.matchPercentage;
                d.recommendationType = "MOOD";
                d.recommendationReason = "Recommended because it fits your " + mood + " mood based on destination characteristics.";
                return d;
            });

        destinations.sort(function (a, b) {
            return b.matchPercentage - a.matchPercentage;
        });

        currentRecommendations = destinations;
        currentPage = 1;

        displayDestinations(destinations, mood + " Mood Recommendations", "Destinations selected according to your " + mood + " travel mood.");
    } catch (error) {
        console.error("Mood error:", error);
        showError("Unable to load mood recommendations.");
    }
}

function moodMatchesDestination(mood, destination) {
    const category = String(destination.category || "").toLowerCase();
    const description = String(destination.description || "").toLowerCase();
    const text = category + " " + description;
    
    const map = {
        Adventure: ["adventure", "mountain", "hill", "trek", "waterfall", "wildlife", "forest", "rafting", "camping"],
        Relaxation: ["beach", "lake", "nature", "resort", "backwater", "hill", "island"],
        Nature: ["nature", "wildlife", "forest", "mountain", "hill", "lake", "waterfall", "beach"],
        Romantic: ["beach", "lake", "hill", "nature", "island", "resort", "romantic"],
        Culture: ["historical", "heritage", "culture", "fort", "palace", "museum", "city"],
        Spiritual: ["spiritual", "religious", "temple", "pilgrimage", "historical"],
        Party: ["party", "nightlife", "entertainment", "city", "beach", "club", "fun"],
        Family: ["family", "park", "resort", "beach", "hill"]
    };

    const keywords = map[mood] || [];
    return keywords.some(function (keyword) {
        return text.includes(keyword);
    });
}

function calculateMoodScore(mood, destination) {
    const category = String(destination.category || "").toLowerCase();
    const description = String(destination.description || "").toLowerCase();
    const text = category + " " + description;
    const map = {
        Adventure: ["adventure", "mountain", "hill", "trek", "waterfall", "wildlife", "forest", "rafting", "camping"],
        Relaxation: ["beach", "lake", "nature", "resort", "backwater", "hill", "island"],
        Nature: ["nature", "wildlife", "forest", "mountain", "hill", "lake", "waterfall", "beach"],
        Romantic: ["beach", "lake", "hill", "nature", "island", "resort", "romantic"],
        Culture: ["historical", "heritage", "culture", "fort", "palace", "museum", "city"],
        Spiritual: ["spiritual", "religious", "temple", "pilgrimage", "historical"],
        Party: ["party", "nightlife", "entertainment", "city", "beach", "club", "fun"],
        Family: ["family", "park", "resort", "beach", "hill"]
    };
    const keywords = map[mood] || [];
    let matches = 0;
    keywords.forEach(function (keyword) {
        if (text.includes(keyword)) matches++;
    });
    if (matches >= 3) return 100;
    if (matches === 2) return 90;
    if (matches === 1) return 80;
    return 70;
}


/* =========================================================
   SEASON
   ========================================================= */

async function findSeasonDestinations(season) {
    if (!season) return;
    currentSeason = season;

    showLoading();
    hideError();
    hideEmpty();

    try {
        const response = await fetch(DESTINATION_API, {
            method: "GET",
            headers: { "Accept": "application/json" }
        });

        if (!response.ok) {
            throw new Error("Destination API error: " + response.status);
        }

        const data = await response.json();
        let destinations = normalizeDestinationArray(data);

        destinations = destinations
            .map(function (destination) {
                const d = normalizeRecommendation(destination);
                d.seasonMatch = calculateSeasonMatch(season, destination.bestSeason);
                d.matchPercentage = d.seasonMatch > 0 ? d.seasonMatch : 60;
                d.recommendationType = "SEASON";
                d.recommendationReason = "Recommended because this destination is ideal to visit during the " + season + " season.";
                return d;
            });

        destinations.sort(function (a, b) {
            return b.matchPercentage - a.matchPercentage;
        });

        currentRecommendations = destinations;
        currentPage = 1;

        displayDestinations(destinations, season + " Season Recommendations", "Destinations suitable for your selected " + season + " season.");
    } catch (error) {
        console.error("Season error:", error);
        showError("Unable to load season recommendations.");
    }
}

function calculateSeasonMatch(selectedSeason, bestSeason) {
    const selected = String(selectedSeason || "").toLowerCase().trim();
    const best = String(bestSeason || "").toLowerCase().trim();
    if (!selected || !best) return 0;
    if (best.includes(selected)) return 100;
    return 80;
}


/* =========================================================
   NORMALIZE RECOMMENDATION
   ========================================================= */

function normalizeRecommendation(destination) {
    const d = Object.assign({}, destination);
    d.destinationId = getNumber(d.destinationId, d.destination_id, d.id);
    d.destinationName = d.destinationName || d.destination_name || d.name || "Unknown Destination";
    d.category = d.category || d.categories || d.destinationType || "Travel";
    d.budget = getNumber(d.budget, d.price, d.averageBudget, d.estimatedBudget);
    d.bestSeason = d.bestSeason || d.best_season || d.bestTimeToVisit || "All Season";
    d.image = d.image || d.destinationImage || d.destination_image || "";
    d.state = d.state || "";
    d.country = d.country || "";
    d.description = d.description || "";
    
    d.budgetMatch = normalizePercentage(getNumber(d.budgetMatch, 85));
    d.seasonMatch = normalizePercentage(getNumber(d.seasonMatch, 90));
    d.interestMatch = normalizePercentage(getNumber(d.interestMatch, 80));
    d.categoryMatch = normalizePercentage(getNumber(d.categoryMatch, 85));
    d.locationMatch = normalizePercentage(getNumber(d.locationMatch, 75));
    d.matchPercentage = normalizePercentage(getNumber(d.matchPercentage, 88));
    
    if (!d.recommendationReason) {
        d.recommendationReason = "Recommended based on overall popularity, matching features, and your preferences.";
    }
    return d;
}


/* =========================================================
   DISPLAY & CARDS
   ========================================================= */

function displayDestinations(destinations, title, subtitle) {
    const grid = document.getElementById("destination-grid");
    if (!grid) return;

    currentRecommendations = Array.isArray(destinations) ? destinations : [];
    currentPage = 1;

    const titleElement = document.getElementById("results-title");
    if (titleElement) titleElement.textContent = title || "Recommended Destinations";

    const subtitleElement = document.getElementById("results-subtitle");
    if (subtitleElement) subtitleElement.textContent = subtitle || "";

    const countElement = document.getElementById("result-count");
    if (countElement) countElement.textContent = currentRecommendations.length + " destinations";

    hideLoading();
    hideError();

    if (currentRecommendations.length === 0) {
        showEmpty();
        renderPagination();
        return;
    }

    hideEmpty();
    renderCurrentPage();
}

function renderCurrentPage() {
    const grid = document.getElementById("destination-grid");
    if (!grid) return;
    grid.innerHTML = "";

    const start = (currentPage - 1) * ITEMS_PER_PAGE;
    const end = start + ITEMS_PER_PAGE;
    const pageItems = currentRecommendations.slice(start, end);

    pageItems.forEach(function (destination) {
        grid.appendChild(createDestinationCard(destination));
    });

    renderPagination();
}

function renderPagination() {
    const pagination = document.getElementById("pagination");
    if (!pagination) return;
    pagination.innerHTML = "";

    const totalPages = Math.ceil(currentRecommendations.length / ITEMS_PER_PAGE);
    if (totalPages <= 1) return;

    const previous = document.createElement("button");
    previous.type = "button";
    previous.className = "pagination-button";
    previous.textContent = "‹";
    previous.disabled = currentPage === 1;
    previous.onclick = function () {
        if (currentPage > 1) {
            currentPage--;
            renderCurrentPage();
            scrollToResults();
        }
    };
    pagination.appendChild(previous);

    for (let page = 1; page <= totalPages; page++) {
        const button = document.createElement("button");
        button.type = "button";
        button.className = "pagination-button" + (page === currentPage ? " active" : "");
        button.textContent = page;
        button.onclick = function () {
            currentPage = page;
            renderCurrentPage();
            scrollToResults();
        };
        pagination.appendChild(button);
    }

    const next = document.createElement("button");
    next.type = "button";
    next.className = "pagination-button";
    next.textContent = "›";
    next.disabled = currentPage === totalPages;
    next.onclick = function () {
        if (currentPage < totalPages) {
            currentPage++;
            renderCurrentPage();
            scrollToResults();
        }
    };
    pagination.appendChild(next);
}

function createDestinationCard(destination) {
    const card = document.createElement("article");
    card.className = "destination-card";

    const id = destination.destinationId;
    const name = destination.destinationName;
    const category = destination.category || "Travel";
    const budget = destination.budget;
    const bestSeason = destination.bestSeason || "All Season";
    const image = getDestinationImage(destination.image);
    const overall = normalizePercentage(destination.matchPercentage);

    card.innerHTML = `
        <div class="destination-image-wrapper">
            <img src="${image}" alt="${escapeHtml(name)}" class="destination-image" onerror="this.onerror=null; this.src='${FRONTEND_BASE}/images/background.webp';">
            <div class="match-badge">${overall}% Match</div>
        </div>
        <div class="destination-content">
            <h3 class="recommendation-destination-name">${escapeHtml(name)}</h3>
            <div class="recommendation-info-row">
                <span>Category</span>
                <strong>${escapeHtml(category)}</strong>
            </div>
            <div class="recommendation-info-row">
                <span>Best Time</span>
                <strong>${escapeHtml(bestSeason)}</strong>
            </div>
            <div class="recommendation-info-row">
                <span>Budget</span>
                <strong>₹${budget !== null ? formatNumber(budget) : "N/A"}</strong>
            </div>
            <div class="match-section">
                <div class="match-header">
                    <span>Overall Match</span>
                    <strong>${overall}%</strong>
                </div>
                <div class="match-progress">
                    <div class="match-progress-fill" style="width:${overall}%"></div>
                </div>
            </div>
            <button type="button" class="view-destination-button" onclick="viewDestinationDetails(${id})">
                View Destination
            </button>
        </div>
    `;
    return card;
}


/* =========================================================
   VIEW DESTINATION DETAILS (Passes Factors, Pie Chart data & Reason)
   ========================================================= */

function viewDestinationDetails(destinationId) {
    if (!destinationId) {
        alert("Destination information is not available.");
        return;
    }

    const destination = currentRecommendations.find(function (item) {
        return Number(item.destinationId) === Number(destinationId);
    });

    const userId = getLoggedInUserId();

    let url = "destination-details.jsp" +
        "?destinationId=" + encodeURIComponent(destinationId) +
        "&id=" + encodeURIComponent(destinationId) +
        "&source=recommendation";

    if (userId) {
        url += "&userId=" + encodeURIComponent(userId);
    }

    if (destination) {
        url += "&match=" + encodeURIComponent(destination.matchPercentage || 88);
        url += "&budgetMatch=" + encodeURIComponent(destination.budgetMatch || 85);
        url += "&seasonMatch=" + encodeURIComponent(destination.seasonMatch || 90);
        url += "&interestMatch=" + encodeURIComponent(destination.interestMatch || 80);
        url += "&categoryMatch=" + encodeURIComponent(destination.categoryMatch || 85);
        url += "&locationMatch=" + encodeURIComponent(destination.locationMatch || 75);
        url += "&reason=" + encodeURIComponent(destination.recommendationReason || "Recommended based on user profile factors and destination features.");
    }

    window.location.href = url;
}


/* =========================================================
   HELPERS & REASONS
   ========================================================= */

function buildPersonalReason(min, max, season, mood, category, companion) {
    const factors = [];
    if (min !== null && max !== null) {
        factors.push("budget ₹" + formatNumber(min) + "–₹" + formatNumber(max));
    }
    if (season) factors.push(season + " season");
    if (mood) factors.push(mood + " mood");
    if (category) factors.push(category + " category");
    if (companion) factors.push(companion + " companion");

    if (factors.length === 0) return "Recommended based on your selected factors.";
    return "Recommended because it matches your selected " + factors.join(", ") + ".";
}

function getDestinationImage(image) {

    if (!image || String(image).trim() === "") {
        return API_CONFIG.image(
            "/images/background.webp"
        );
    }

    const value = String(image).trim();

    if (
        value.startsWith("http://") ||
        value.startsWith("https://") ||
        value.startsWith("data:") ||
        value.startsWith("blob:")
    ) {
        return value;
    }

    if (
        value.startsWith("/api/") ||
        value.startsWith("api/")
    ) {
        return API_CONFIG.api(value);
    }

    if (
        value.startsWith("/uploads/") ||
        value.startsWith("uploads/")
    ) {
        return API_CONFIG.upload(
            value.startsWith("/") ? value : "/" + value
        );
    }

    /*
     * Database destination image filename.
     */
    return API_CONFIG.destinationImage(value);
}

function normalizeDestinationArray(data) {
    if (Array.isArray(data)) return data;
    if (!data || typeof data !== "object") return [];
    const possibleArrays = [data.destinations, data.recommendations, data.results, data.content, data.data, data.result];
    for (const array of possibleArrays) {
        if (Array.isArray(array)) return array;
    }
    if (data.destinationId || data.destination_id || data.id) return [data];
    return [];
}

function getValue(id) {
    const element = document.getElementById(id);
    if (!element) return "";
    return String(element.value || "").trim();
}

function getNumberValue(id) {
    const value = getValue(id);
    if (!value) return null;
    const number = Number(value);
    return Number.isNaN(number) ? null : number;
}

function getNumber(...values) {
    for (const value of values) {
        if (value !== null && value !== undefined && value !== "") {
            const number = Number(value);
            if (!Number.isNaN(number)) return number;
        }
    }
    return null;
}

function normalizePercentage(value) {
    if (value === null || value === undefined || value === "") return 0;
    let number = Number(value);
    if (Number.isNaN(number)) return 0;
    return Math.round(Math.max(0, Math.min(100, number)));
}

function formatNumber(value) {
    if (value === null || value === undefined) return "N/A";
    return Number(value).toLocaleString("en-IN");
}

function escapeHtml(value) {
    if (value === null || value === undefined) return "";
    return String(value)
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
}

function showLoading() {
    const loading = document.getElementById("loading-state");
    const grid = document.getElementById("destination-grid");
    if (loading) loading.classList.remove("hidden");
    if (grid) grid.innerHTML = "";
    hideEmpty();
}

function hideLoading() {
    const loading = document.getElementById("loading-state");
    if (loading) loading.classList.add("hidden");
}

function showError(message) {
    hideLoading();
    hideEmpty();
    const error = document.getElementById("error-state");
    const errorMessage = document.getElementById("error-message");
    const grid = document.getElementById("destination-grid");
    if (grid) grid.innerHTML = "";
    if (errorMessage) errorMessage.textContent = message;
    if (error) error.classList.remove("hidden");
    const count = document.getElementById("result-count");
    if (count) count.textContent = "0 destinations";
    renderPagination();
}

function hideError() {
    const error = document.getElementById("error-state");
    if (error) error.classList.add("hidden");
}

function showEmpty() {
    hideLoading();
    hideError();
    const empty = document.getElementById("empty-state");
    const grid = document.getElementById("destination-grid");
    if (grid) grid.innerHTML = "";
    if (empty) empty.classList.remove("hidden");
}

function hideEmpty() {
    const empty = document.getElementById("empty-state");
    if (empty) empty.classList.add("hidden");
}

function scrollToResults() {
    const results = document.getElementById("results-section");
    if (results) {
        results.scrollIntoView({ behavior: "smooth", block: "start" });
    }
}