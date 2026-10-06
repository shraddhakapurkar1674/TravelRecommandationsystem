/* =========================================================
   DESTINATION DETAILS
   FRONTEND ONLY VERSION
========================================================= */

const API_BASE_URL =
    API_CONFIG.BASE_URL;

const DESTINATION_API_URL =
    API_BASE_URL + "/api/destinations";

const HOTEL_API_URL =
    API_BASE_URL + "/api/hotels";

const TRANSPORT_API_URL =
    API_BASE_URL + "/api/transports";

const ACTIVITY_API_URL =
    API_BASE_URL + "/api/activities";

const FRONTEND_BASE_URL =
    window.location.origin +
    API_CONFIG.FRONTEND_BASE_URL;

const DEFAULT_IMAGE =
    FRONTEND_BASE_URL +
    "/images/background.webp";

let selectedDestination = null;
let allDestinations = [];
let stateDestinations = [];

document.addEventListener(
    "DOMContentLoaded",
    function () {
        loadDestination();
    }
);

function getUrlParams() {
    return new URLSearchParams(
        window.location.search
    );
}

function getDestinationIdFromUrl() {
    const params = getUrlParams();
    return (
        params.get("id") ||
        params.get("destinationId")
    );
}

function isRecommendationMode() {
    return (
        getUrlParams().get("source") ===
        "recommendation"
    );
}

function getLoggedInUserId() {
    let userId = localStorage.getItem("userId");
    if (userId) return userId;

    userId = sessionStorage.getItem("userId");
    if (userId) return userId;

    const keys = ["loggedInUser", "user", "currentUser"];
    for (const key of keys) {
        try {
            const user = JSON.parse(localStorage.getItem(key));
            if (!user) continue;
            if (user.id != null) return user.id;
            if (user.userId != null) return user.userId;
        } catch (error) {}
    }

    for (const key of keys) {
        try {
            const user = JSON.parse(sessionStorage.getItem(key));
            if (!user) continue;
            if (user.id != null) return user.id;
            if (user.userId != null) return user.userId;
        } catch (error) {}
    }
    return null;
}

async function loadDestination() {
    const loading = document.getElementById("loading");
    const mainContent = document.getElementById("mainContent");
    const errorBox = document.getElementById("errorBox");
    const errorMessage = document.getElementById("errorMessage");

    try {
        const id = getDestinationIdFromUrl();
        if (!id) {
            throw new Error("Destination ID is missing from URL.");
        }

        const response = await fetch(
            DESTINATION_API_URL + "/" + encodeURIComponent(id),
            {
                method: "GET",
                credentials: "include",
                headers: { "Accept": "application/json" }
            }
        );

        if (!response.ok) {
            throw new Error("Destination API returned " + response.status);
        }

        const data = await response.json();
        selectedDestination = extractSingleDestination(data);

        if (!selectedDestination) {
            throw new Error("Destination data is empty.");
        }

        renderSelectedDestination(selectedDestination);
        updateBackButton();

        if (loading) loading.style.display = "none";
        if (mainContent) mainContent.style.display = "block";
        if (errorBox) errorBox.style.display = "none";

        if (isRecommendationMode()) {
            hideNormalSections();
            renderMap();
            await loadAllDestinations();
            
            // Priority 1: Check URL parameters passed directly from recommendation.js
            const params = getUrlParams();
            if (params.has("match") || params.has("budgetMatch") || params.has("reason")) {
                loadRecommendationFromUrlParams();
            } else {
                // Priority 2: Fallback to fetching recommendation analysis API if URL params are missing
                await loadRecommendationAnalysis(id);
            }
            return;
        }

        hideRecommendation();

        await Promise.allSettled([
            loadHotelsByDestinationName(),
            loadTransport(),
            loadAllDestinations()
        ]);

    } catch (error) {
        console.error("Destination loading error:", error);
        if (loading) loading.style.display = "none";
        if (mainContent) mainContent.style.display = "none";
        if (errorBox) errorBox.style.display = "block";
        if (errorMessage) {
            errorMessage.textContent = error.message || "Unable to load destination.";
        }
    }
}

function updateBackButton() {
    const element = document.getElementById("backButtonText");
    if (!element) return;
    element.textContent = isRecommendationMode()
        ? "Back to Recommendations"
        : "Back to Explore";
}

function goBack() {
    if (isRecommendationMode()) {
        window.location.href = "recommendation.jsp";
        return;
    }
    window.location.href = "explore.jsp";
}

function extractSingleDestination(data) {
    if (!data) return null;
    if (Array.isArray(data)) return data[0] || null;
    if (data.data && !Array.isArray(data.data)) return data.data;
    if (data.destination && !Array.isArray(data.destination)) return data.destination;
    if (data.result && !Array.isArray(data.result)) return data.result;
    return data;
}

function extractArray(data) {
    if (!data) return [];
    if (Array.isArray(data)) return data;
    const keys = ["data", "content", "results", "destinations", "hotels", "transports", "activities"];
    for (const key of keys) {
        if (Array.isArray(data[key])) return data[key];
    }
    return [];
}

function getName(destination) {
    if (!destination) return "";
    return destination.destinationName || destination.destination_name || destination.name || destination.title || "";
}

function getState(destination) {
    if (!destination) return "";
    return destination.state || destination.stateName || destination.state_name || "";
}

function getCountry(destination) {
    if (!destination) return "";
    return destination.country || destination.countryName || destination.country_name || "";
}

function getImage(destination) {
    if (!destination) return "";
    return destination.image || destination.imageUrl || destination.imageURL || destination.image_url || destination.photo || "";
}

function getBudget(destination) {
    if (!destination) return null;
    return destination.budget ?? destination.minBudget ?? destination.min_budget ?? destination.price ?? null;
}

function renderSelectedDestination(destination) {
    const name = getName(destination);
    const state = getState(destination);
    const country = getCountry(destination);
    const image = getImage(destination);
    const description = destination.description || destination.details || destination.about || "No description available.";
    const season = destination.bestSeason || destination.best_season || destination.season || "Not specified";
    const budget = getBudget(destination);

    setText("destinationName", name || "Destination");
    setText("selectedImageName", name || "Destination");
    setText("locationText", [state, country].filter(Boolean).join(", "));
    setText("destinationDescription", description);
    setText("country", country || "India");
    setText("state", state || "Not specified");
    setText("bestSeason", season);
    setText("budget", formatBudget(budget));

    const imageElement = document.getElementById("selectedDestinationImage");
    if (imageElement) {
        imageElement.src = getImageUrl(image);
        imageElement.alt = name || "Destination";
        imageElement.onerror = function () {
            this.onerror = null;
            this.src = getDefaultImage();
        };
    }
    renderCategories(destination);
}

function renderCategories(destination) {
    const container = document.getElementById("categoryList");
    if (!container) return;
    container.innerHTML = "";
    const value = destination.category || destination.categories || "";
    let categories = Array.isArray(value) ? value : String(value).split(",");

    categories.map(item => String(item).trim()).filter(Boolean).forEach(category => {
        const span = document.createElement("span");
        span.className = "category-chip";
        span.textContent = category;
        container.appendChild(span);
    });
}

function getDefaultImage() {
    return DEFAULT_IMAGE;
}

function getImageUrl(value) {
    if (!value) return getDefaultImage();
    let image = String(value).trim();
    if (image.startsWith("http://") || image.startsWith("https://") || image.startsWith("data:")) {
        return image;
    }
    if (image.startsWith("/uploads/")) return API_BASE_URL + image;
    if (image.startsWith("uploads/")) return API_BASE_URL + "/" + image;
    return API_BASE_URL + "/uploads/" + encodeURIComponent(image);
}

function getHotelImageUrl(value) {
    if (!value) return getDefaultImage();
    const image = String(value).trim();
    if (image.startsWith("http://") || image.startsWith("https://")) return image;
    if (image.startsWith("/uploads/")) return API_BASE_URL + image;
    if (image.startsWith("uploads/")) return API_BASE_URL + "/" + image;
    return API_BASE_URL + "/api/hotels/images/" + encodeURIComponent(image);
}

async function loadHotelsByDestinationName() {
    const container = document.getElementById("hotelsContainer");
    if (!container) return;
    const destinationName = getName(selectedDestination);
    if (!destinationName) {
        hideSection(".hotels-section");
        return;
    }

    container.innerHTML = `<div class="service-empty"><i class="fa-solid fa-spinner fa-spin"></i><br>Loading hotels...</div>`;

    try {
        const response = await fetch(HOTEL_API_URL, {
            method: "GET",
            credentials: "include",
            headers: { "Accept": "application/json" }
        });
        if (!response.ok) throw new Error("Hotel API returned " + response.status);
        const data = await response.json();
        const hotels = extractArray(data);
        const matchedHotels = filterHotelsForDestination(hotels, destinationName);
        renderHotels(matchedHotels);
    } catch (error) {
        hideSection(".hotels-section");
    }
}

function filterHotelsForDestination(hotels, destinationName) {
    if (!Array.isArray(hotels) || hotels.length === 0) return [];
    const normalizedDestination = normalizeDestinationText(destinationName);
    if (!normalizedDestination) return [];
    const words = normalizedDestination.split(" ").filter(word => word.length >= 3);

    return hotels.filter(hotel => {
        if (!hotel) return false;
        const hotelName = normalizeDestinationText(hotel.hotelName || hotel.hotel_name || hotel.name || "");
        const location = normalizeDestinationText(hotel.location || hotel.address || hotel.city || "");
        const destination = normalizeDestinationText(hotel.destinationName || hotel.destination_name || "");

        if (hotelName.includes(normalizedDestination) || location.includes(normalizedDestination) || destination.includes(normalizedDestination)) {
            return true;
        }
        return words.some(word => hotelName.includes(word) || location.includes(word) || destination.includes(word));
    });
}

function renderHotels(hotels) {
    const container = document.getElementById("hotelsContainer");
    if (!container) return;
    container.innerHTML = "";
    if (!Array.isArray(hotels) || hotels.length === 0) {
        hideSection(".hotels-section");
        return;
    }
    const section = document.querySelector(".hotels-section");
    if (section) section.style.display = "block";

    hotels.forEach(hotel => {
        const card = document.createElement("article");
        card.className = "hotel-card";
        const name = hotel.hotelName || hotel.hotel_name || hotel.name || "Hotel";
        const location = hotel.location || hotel.address || "";
        const rating = hotel.rating ?? hotel.hotelRating ?? "";
        const price = hotel.pricePerNight ?? hotel.price_per_night ?? hotel.price ?? null;
        const image = hotel.image || hotel.imageUrl || "";

        card.innerHTML = `
            <div class="hotel-image-wrap">
                <img class="hotel-image" src="${escapeAttribute(getHotelImageUrl(image))}" alt="${escapeAttribute(name)}" loading="lazy">
            </div>
            <div class="hotel-content">
                <h3>${escapeHtml(name)}</h3>
                ${location ? `<p class="hotel-address"><i class="fa-solid fa-location-dot"></i> ${escapeHtml(location)}</p>` : ""}
                ${rating !== "" ? `<div class="hotel-rating"><i class="fa-solid fa-star"></i> ${escapeHtml(String(rating))}</div>` : ""}
                ${price != null ? `<div class="hotel-price">₹${Number(price).toLocaleString("en-IN")} / night</div>` : ""}
            </div>
        `;
        const imgEl = card.querySelector(".hotel-image");
        if (imgEl) {
            imgEl.onerror = function () {
                this.onerror = null;
                this.src = getDefaultImage();
            };
        }
        container.appendChild(card);
    });
}

async function loadTransport() {
    const container = document.getElementById("transportContainer");
    if (!container) return;
    const destinationName = getName(selectedDestination);
    if (!destinationName) {
        hideSection(".transport-section");
        return;
    }

    try {
        const url = TRANSPORT_API_URL + "/by-destination?destination=" + encodeURIComponent(destinationName);
        const response = await fetch(url, {
            method: "GET",
            credentials: "include",
            headers: { "Accept": "application/json" }
        });
        if (!response.ok) {
            hideSection(".transport-section");
            return;
        }
        const data = await response.json();
        renderTransport(extractArray(data));
    } catch (error) {
        hideSection(".transport-section");
    }
}

function renderTransport(transports) {
    const container = document.getElementById("transportContainer");
    if (!container) return;
    container.innerHTML = "";
    const available = new Set();

    if (!Array.isArray(transports)) {
        hideSection(".transport-section");
        return;
    }

    transports.forEach(item => {
        if (!item) return;
        const raw = item.transportType || item.transport_type || item.type || item.mode || "";
        const type = String(raw).trim().toLowerCase();
        if (type.includes("bus")) available.add("Bus");
        else if (type.includes("cab") || type.includes("taxi")) available.add("Cab");
        else if (type.includes("train")) available.add("Train");
        else if (type.includes("plane") || type.includes("flight") || type.includes("air")) available.add("Plane");
    });

    if (available.size === 0) {
        hideSection(".transport-section");
        return;
    }

    const section = document.querySelector(".transport-section");
    if (section) section.style.display = "block";

    const iconMap = { Bus: "fa-solid fa-bus", Cab: "fa-solid fa-taxi", Train: "fa-solid fa-train", Plane: "fa-solid fa-plane" };

    available.forEach(type => {
        const card = document.createElement("div");
        card.className = "transport-card";
        card.innerHTML = `<div class="transport-icon"><i class="${iconMap[type]}"></i></div><div class="transport-name">${escapeHtml(type)}</div>`;
        container.appendChild(card);
    });
}

async function loadAllDestinations() {
    try {
        const response = await fetch(DESTINATION_API_URL, {
            method: "GET",
            credentials: "include",
            headers: { "Accept": "application/json" }
        });
        if (!response.ok) throw new Error("Destination list failed");
        const data = await response.json();
        allDestinations = extractArray(data);

        const selectedState = normalizeDestinationText(getState(selectedDestination));
        const selectedCountry = normalizeDestinationText(getCountry(selectedDestination));

        stateDestinations = allDestinations.filter(destination => {
            const destinationState = normalizeDestinationText(getState(destination));
            const destinationCountry = normalizeDestinationText(getCountry(destination));
            return destinationState === selectedState && (!selectedCountry || !destinationCountry || destinationCountry === selectedCountry);
        });

        const selectedId = getId(selectedDestination);
        const exists = stateDestinations.some(d => String(getId(d)) === String(selectedId));
        if (!exists) {
            stateDestinations.unshift(selectedDestination);
        }

        renderGallery(stateDestinations);
        renderMap();
    } catch (error) {
        stateDestinations = [selectedDestination];
        renderGallery(stateDestinations);
        renderMap();
    }
}

function renderGallery(destinations) {
    const gallery = document.getElementById("destinationGallery");
    const count = document.getElementById("photoCount");
    if (!gallery) return;
    gallery.innerHTML = "";
    let total = 0;

    if (!Array.isArray(destinations)) {
        if (count) count.textContent = "0 Photos";
        return;
    }

    destinations.forEach(destination => {
        const image = getImage(destination);
        if (!image) return;
        total++;

        const item = document.createElement("div");
        item.className = "gallery-item";
        const img = document.createElement("img");
        img.src = getImageUrl(image);
        img.alt = getName(destination) || "Destination";
        img.loading = "lazy";
        img.onerror = function () {
            this.onerror = null;
            this.src = getDefaultImage();
        };

        const caption = document.createElement("div");
        caption.className = "gallery-caption";
        caption.textContent = getName(destination);

        item.appendChild(img);
        item.appendChild(caption);
        gallery.appendChild(item);
    });

    if (count) {
        count.textContent = total + (total === 1 ? " Photo" : " Photos");
    }
}

function renderMap() {
    const iframe = document.getElementById("destinationMap");
    const link = document.getElementById("openMapLink");
    if (!iframe) return;

    const name = getName(selectedDestination);
    const state = getState(selectedDestination);
    const country = getCountry(selectedDestination);
    const query = [name, state, country].filter(Boolean).join(", ");

    if (!query) {
        iframe.src = "";
        if (link) link.href = "#";
        return;
    }

    const encoded = encodeURIComponent(query);
    iframe.src = "https://www.google.com/maps?q=" + encoded + "&output=embed";
    if (link) {
        link.href = "https://www.google.com/maps/search/?api=1&query=" + encoded;
    }
}

function hideNormalSections() {
    hideSection(".hotels-section");
    hideSection(".transport-section");
    const gallery = document.getElementById("destinationGallery");
    if (gallery) gallery.innerHTML = "";
}

function hideRecommendation() {
    const section = document.getElementById("recommendationAnalysis");
    if (section) section.style.display = "none";
}

// Added support to read recommendation scores directly from URL parameters sent via recommendation.js
function loadRecommendationFromUrlParams() {
    const section = document.getElementById("recommendationAnalysis");
    if (!section) return;
    section.style.display = "block";

    const params = getUrlParams();
    const overall = numberOrZero(params.get("match") || 88);
    const budget = numberOrZero(params.get("budgetMatch") || 85);
    const season = numberOrZero(params.get("seasonMatch") || 90);
    const interest = numberOrZero(params.get("interestMatch") || 80);
    const category = numberOrZero(params.get("categoryMatch") || 85);
    const location = numberOrZero(params.get("locationMatch") || 75);
    const reason = params.get("reason") || "Recommended based on your preferences and profile details.";

    setText("overallMatch", formatScore(overall));
    setText("budgetMatchValue", formatScore(budget));
    setText("seasonMatchValue", formatScore(season));
    setText("interestMatchValue", formatScore(interest));
    setText("categoryMatchValue", formatScore(category));
    setText("locationMatchValue", formatScore(location));

    setText("recommendationReason", reason);

    setBar("budgetMatchBar", budget);
    setBar("seasonMatchBar", season);
    setBar("interestMatchBar", interest);
    setBar("categoryMatchBar", category);
    setBar("locationMatchBar", location);
}

async function loadRecommendationAnalysis(destinationId) {
    const section = document.getElementById("recommendationAnalysis");
    if (!section) return;

    const userId = getLoggedInUserId();
    if (!userId) {
        renderRecommendationFallback();
        return;
    }

    try {
        const response = await fetch(
            API_BASE_URL + "/api/recommendations/" + encodeURIComponent(userId),
            {
                method: "GET",
                credentials: "include",
                headers: { "Accept": "application/json" }
            }
        );
        if (!response.ok) throw new Error("Recommendation API returned " + response.status);

        const data = await response.json();
        const recommendations = extractArray(data);
        const recommendation = recommendations.find(item => {
            const recommendationId = item.destinationId ?? item.destination_id ?? item.id ?? null;
            return String(recommendationId) === String(destinationId);
        });

        if (recommendation) {
            renderRecommendation(recommendation);
        } else {
            renderRecommendationFallback();
        }
    } catch (error) {
        renderRecommendationFallback();
    }
}

function renderRecommendation(recommendation) {
    const section = document.getElementById("recommendationAnalysis");
    if (!section) return;
    section.style.display = "block";

    const overall = numberOrZero(recommendation.matchPercentage);
    const budget = numberOrZero(recommendation.budgetMatch);
    const season = numberOrZero(recommendation.seasonMatch);
    const interest = numberOrZero(recommendation.interestMatch);
    const category = numberOrZero(recommendation.categoryMatch);
    const location = numberOrZero(recommendation.locationMatch);

    setText("overallMatch", formatScore(overall));
    setText("budgetMatchValue", formatScore(budget));
    setText("seasonMatchValue", formatScore(season));
    setText("interestMatchValue", formatScore(interest));
    setText("categoryMatchValue", formatScore(category));
    setText("locationMatchValue", formatScore(location));

    setText("recommendationReason", buildRecommendationReason(recommendation));

    setBar("budgetMatchBar", budget);
    setBar("seasonMatchBar", season);
    setBar("interestMatchBar", interest);
    setBar("categoryMatchBar", category);
    setBar("locationMatchBar", location);
}

function renderRecommendationFallback() {
    const section = document.getElementById("recommendationAnalysis");
    if (!section) return;
    section.style.display = "block";

    const name = getName(selectedDestination);
    const season = selectedDestination.bestSeason || selectedDestination.best_season || "";
    const category = selectedDestination.category || "";

    setText("overallMatch", "N/A");
    setText("recommendationReason", name ? name + " is recommended based on available destination details." : "This destination matches your travel preferences.");
    setText("budgetMatchValue", "N/A");
    setText("seasonMatchValue", season || "N/A");
    setText("interestMatchValue", "N/A");
    setText("categoryMatchValue", category || "N/A");
    setText("locationMatchValue", "N/A");

    setBar("budgetMatchBar", 0);
    setBar("seasonMatchBar", 0);
    setBar("interestMatchBar", 0);
    setBar("categoryMatchBar", 0);
    setBar("locationMatchBar", 0);
}

function buildRecommendationReason(item) {
    const name = getName(selectedDestination);
    const parts = [];

    if (numberOrZero(item.budgetMatch) >= 70) parts.push("your budget");
    if (numberOrZero(item.seasonMatch) >= 70) parts.push("your preferred season");
    if (numberOrZero(item.interestMatch) >= 70) parts.push("your interests");
    if (numberOrZero(item.categoryMatch) >= 70) parts.push("your preferred category");
    if (numberOrZero(item.locationMatch) >= 70) parts.push("your location preference");

    if (parts.length === 0) {
        return name + " matches your travel profile based on available recommendation factors.";
    }
    return name + " is recommended because it matches " + joinNatural(parts) + ".";
}

function joinNatural(items) {
    if (items.length === 1) return items[0];
    if (items.length === 2) return items[0] + " and " + items[1];
    return items.slice(0, -1).join(", ") + ", and " + items[items.length - 1];
}

function setBar(id, value) {
    const element = document.getElementById(id);
    if (!element) return;
    const safe = Math.max(0, Math.min(100, Number(value) || 0));
    element.style.width = safe + "%";
}

function numberOrZero(value) {
    const number = Number(value);
    return Number.isFinite(number) ? number : 0;
}

function formatScore(value) {
    const number = Number(value);
    if (!Number.isFinite(number)) return "N/A";
    return number.toFixed(1) + "%";
}

function normalizeDestinationText(value) {
    return String(value || "").toLowerCase().replace(/[^a-z0-9\s]/g, " ").replace(/\s+/g, " ").trim();
}

function setText(id, value) {
    const element = document.getElementById(id);
    if (element) {
        element.textContent = value == null ? "" : value;
    }
}

function hideSection(selector) {
    const element = document.querySelector(selector);
    if (element) element.style.display = "none";
}

function formatBudget(value) {
    if (value == null || value === "") return "Not specified";
    const number = Number(value);
    if (Number.isFinite(number)) {
        return "₹" + number.toLocaleString("en-IN");
    }
    return String(value);
}

function escapeHtml(value) {
    return String(value == null ? "" : value)
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
}

function escapeAttribute(value) {
    return escapeHtml(value);
}

function getId(destination) {
    if (!destination) return null;
    return destination.id ?? destination.destinationId ?? destination.destination_id ?? null;
}

    let currentDestinationId = null;

    // Make function globally available to fix "not defined" error
    window.toggleBucketlist = function() {
        let userId = localStorage.getItem("userId");
        
        if (!userId) {
            alert("Please login first! (User ID not found in localStorage)");
            return;
        }
        
        if (!currentDestinationId) {
            const urlParams = new URLSearchParams(window.location.search);
            currentDestinationId = urlParams.get('id');
            if(!currentDestinationId) {
                alert("Destination ID not found!");
                return;
            }
        }

        let btnText = document.getElementById("bucketlistText").innerText;
        let isCurrentlyAdded = btnText.includes("Remove");

        let url = API_CONFIG.api(`/api/bucketlist/${isCurrentlyAdded ? "remove" : "add"}?userId=${userId}&destinationId=${currentDestinationId}`);
        let method = isCurrentlyAdded ? 'DELETE' : 'POST';

        fetch(url, { method: method })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    window.updateBucketlistUI(!isCurrentlyAdded);
                    alert(data.message);
                } else {
                    alert("Action failed: " + data.message);
                }
            })
            .catch(err => {
                console.error("Error:", err);
                alert("Something went wrong with the server connection!");
            });
    };

    window.updateBucketlistUI = function(isAdded) {
        let icon = document.getElementById("bucketlistIcon");
        let text = document.getElementById("bucketlistText");
        let btn = document.getElementById("bucketlistBtn");

        if (!btn) return;

        if (isAdded) {
            icon.className = "fa-solid fa-heart";
            text.innerText = "Remove from Bucketlist";
            btn.style.background = "#dc2626"; // Red
        } else {
            icon.className = "fa-regular fa-heart";
            text.innerText = "Add to Bucketlist";
            btn.style.background = "#2563eb"; // Blue
        }
    };

    // Page load zalyanantar check karaycha ki destination already bucketlist madhe ahe ka
    window.addEventListener('DOMContentLoaded', (event) => {
        const urlParams = new URLSearchParams(window.location.search);
        currentDestinationId = urlParams.get('id');
        
        let userId = localStorage.getItem("userId");
        if (userId && currentDestinationId) {
            fetch(API_CONFIG.api(`/api/bucketlist/user/${userId}`))
                .then(res => res.json())
                .then(response => {
                    if (response.success && response.data) {
                        let exists = response.data.some(dest => dest.id == currentDestinationId);
                        window.updateBucketlistUI(exists);
                    }
                }).catch(err => console.error("Error checking bucketlist:", err));
        }
    });

	
	
	
	
	window.toggleBucketlist = function() {
	    let userId = getLoggedInUserId();
	    
	    if (!userId) {
	        alert("Please login first!");
	        return;
	    }
	    
	    if (!currentDestinationId) {
	        const urlParams = new URLSearchParams(window.location.search);
	        currentDestinationId = urlParams.get('id');
	        if(!currentDestinationId) {
	            alert("Destination ID not found!");
	            return;
	        }
	    }

	    let btnText = document.getElementById("bucketlistText").innerText;
	    let isCurrentlyAdded = btnText.includes("Remove");

	    let url = `${API_BASE_URL}/api/bucketlist/${isCurrentlyAdded ? 'remove' : 'add'}?userId=${userId}&destinationId=${currentDestinationId}`;
	    let method = isCurrentlyAdded ? 'DELETE' : 'POST';

	    fetch(url, { method: method, credentials: "include" })
	        .then(res => res.json())
	        .then(data => {
	            if (data.success) {
	                window.updateBucketlistUI(!isCurrentlyAdded);
	                alert(data.message);
	            } else {
	                alert("Action failed: " + data.message);
	            }
	        })
	        .catch(err => {
	            console.error("Error:", err);
	            alert("Something went wrong with the server connection!");
	        });
	};