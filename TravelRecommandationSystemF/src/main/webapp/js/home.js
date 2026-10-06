/* =========================================================
   TRIPWISE - HOME PAGE
   Dynamic Popular Destinations + Traveller Type cards,
   in-page Trip Planner preview, search bar, demo video modal.
 
   NAVIGATION RULE FOR THIS PAGE:
   There is NO direct access to any destination from the home
   page for anyone, logged in or not. Clicking ANY destination
   card - in Popular Destinations, in the Trip Planner results
   preview, or in "What Kind of Traveller Are You?" - always
   sends the visitor to login.jsp. Only after logging in (from
   inside the app itself) can a user reach destination details.
   ========================================================= */
 
const BACKEND_BASE_URL = API_CONFIG.BASE_URL;
const FRONTEND_BASE_URL = API_CONFIG.FRONTEND_BASE_URL;
const LOGIN_URL = FRONTEND_BASE_URL + "/login.jsp";
 
// Local images shipped in /images/home_page/ (used for traveller-type cards
// instead of external Unsplash URLs).
const HOME_PAGE_IMAGE_BASE = FRONTEND_BASE_URL + "/images/home_page/";
 
// Curated "mood" traveller types - these are NOT stored as a destination.category
// in the database. They are matched client-side against each destination's
// category + description + name (see moodMatchesDestination below).
const MOOD_TRAVELLER_TYPES = [
    {
        mood: "Romantic",
        title: "Romantic Escapes",
        description: "Honeymoon spots, sunset points and cozy retreats.",
        image: HOME_PAGE_IMAGE_BASE + "Romatic.jpg",
        keywords: ["romantic", "honeymoon", "sunset", "couple", "beach"]
    },
    {
        mood: "Party",
        title: "Nightlife & Party",
        description: "Clubs, beach parties and high-energy nightlife.",
        image: HOME_PAGE_IMAGE_BASE + "party.jpg",
        keywords: ["party", "nightlife", "club", "beach"]
    },
    {
        mood: "Adventure",
        title: "Adventure Seeker",
        description: "Thrill-seeking activities, trekking and high energy.",
        image: HOME_PAGE_IMAGE_BASE + "Moutains.jpg",
        keywords: ["adventure", "trek", "trekking", "hiking", "wildlife", "sport"]
    }
];
 
// Local home_page images matched by KEYWORD (not exact category string), so
// "Lake", "Lake District", "Spiritual", "Spiritual Retreat", "Hill Station",
// "Hillstation", etc. all resolve correctly regardless of exact DB wording.
// Ordered most-specific-first. There is deliberately NO generic/default entry
// here - see getLocalImageForCategory() below, which returns null (not a
// wrong guess) when nothing matches.
const LOCAL_CATEGORY_IMAGES = [
    { keywords: ["hill station", "hillstation", "hill"], image: HOME_PAGE_IMAGE_BASE + "hillstation.jpg" },
    { keywords: ["lake"], image: HOME_PAGE_IMAGE_BASE + "lake.jpg" },
    { keywords: ["spiritual", "temple", "religious", "pilgrimage", "shrine"], image: HOME_PAGE_IMAGE_BASE + "temple.jpg" },
    { keywords: ["historical", "heritage", "monument", "fort", "palace"], image: HOME_PAGE_IMAGE_BASE + "histrorical.jpg" },
    { keywords: ["wildlife", "safari", "jungle", "national park", "sanctuary"], image: HOME_PAGE_IMAGE_BASE + "Wlidlife.jpg" },
    { keywords: ["tropical"], image: HOME_PAGE_IMAGE_BASE + "tropical-beach.jpg" },
    { keywords: ["beach", "coastal", "coast", "island", "seaside"], image: HOME_PAGE_IMAGE_BASE + "beach.jpg" },
    { keywords: ["desert"], image: HOME_PAGE_IMAGE_BASE + "desert.jpg" },
    { keywords: ["waterfall"], image: HOME_PAGE_IMAGE_BASE + "Waterfall.jpg" },
    { keywords: ["mountain", "trek", "hiking", "adventure", "forest"], image: HOME_PAGE_IMAGE_BASE + "Moutains.jpg" },
    { keywords: ["romantic", "honeymoon"], image: HOME_PAGE_IMAGE_BASE + "Romatic.jpg" },
    { keywords: ["party", "nightlife", "club"], image: HOME_PAGE_IMAGE_BASE + "party.jpg" },
    { keywords: ["city", "urban", "metro"], image: HOME_PAGE_IMAGE_BASE + "city.jpg" }
];
 
// Returns a matching local home_page image for a category, or null if none of
// the keyword groups above match - callers decide their own non-generic
// fallback (an actual DB destination image, or a neutral placeholder).
function getLocalImageForCategory(category) {
    const text = (category || "").toLowerCase();
    for (let i = 0; i < LOCAL_CATEGORY_IMAGES.length; i++) {
        const entry = LOCAL_CATEGORY_IMAGES[i];
        for (let j = 0; j < entry.keywords.length; j++) {
            if (text.indexOf(entry.keywords[j]) !== -1) return entry.image;
        }
    }
    return null;
}
 
let allDestinationsCache = [];
 
document.addEventListener("DOMContentLoaded", function () {
    loadHomePageData();
    wireSearchForm();
    wireViewAllLink();
    wireDemoVideoModal();
    scrollToHashTarget();
});
 
 
/* =========================================================
   NAVIGATION - everything on this page funnels to login.jsp
   ========================================================= */
 
function goToLogin() {
    window.location.href = LOGIN_URL;
}
 
 
/* =========================================================
   SMOOTH SCROLL TO AN IN-PAGE SECTION (used by the header
   nav links "Destinations" / "Trip Planner", and by direct
   links such as home.jsp#popularDestinations)
   ========================================================= */
 
function scrollToHashTarget() {
    if (!window.location.hash) return;
    const el = document.getElementById(window.location.hash.substring(1));
    if (el) {
        el.scrollIntoView({ behavior: "smooth", block: "start" });
    }
}
 
 
/* =========================================================
   LOAD DATA
   ========================================================= */
 
function loadHomePageData() {
    fetch(BACKEND_BASE_URL + "/api/destinations", {
        method: "GET",
        headers: { "Accept": "application/json" }
    })
        .then(function (response) {
            if (!response.ok) throw new Error("Destinations API failed: " + response.status);
            return response.json();
        })
        .then(function (data) {
            let destinations = [];
            if (Array.isArray(data)) {
                destinations = data;
            } else if (data && Array.isArray(data.data)) {
                destinations = data.data;
            }
            allDestinationsCache = destinations;
 
            renderPopularDestinations(destinations);
            renderTravellerTypes(destinations);
        })
        .catch(function (err) {
            console.error("Error loading destinations from " + BACKEND_BASE_URL + "/api/destinations:", err);
            renderPopularDestinationsError();
            renderTravellerTypesError();
        });
}
 
 
/* =========================================================
   POPULAR DESTINATIONS
   ========================================================= */
 
function renderPopularDestinations(destinations) {
    const container = document.getElementById("popularDestinationsRow");
    if (!container) return;
 
    if (!destinations.length) {
        renderPopularDestinationsError();
        return;
    }
 
    const popular = destinations.slice(0, 5);
    container.innerHTML = popular.map(buildDestinationCardHtml).join("");
}
 
function renderPopularDestinationsError() {
    const container = document.getElementById("popularDestinationsRow");
    if (!container) return;
    container.innerHTML = '<div class="col-12 text-center text-muted py-4"><p class="mb-0">Unable to load destinations right now. Please make sure the backend is running at ' + BACKEND_BASE_URL + ' and try again.</p></div>';
}
 
// Shared card markup, used for both the Popular Destinations row and the
// Trip Planner results preview row. Clicking the card ALWAYS goes to login.jsp
// - see handleDestinationCardClick below.
function buildDestinationCardHtml(dest) {
    const id = dest.id;
    const name = dest.destinationName || "Unknown Destination";
    const category = dest.category || "Travel";
    const location = [dest.state, dest.country].filter(Boolean).join(", ");
    const budget = formatPrice(dest.budget);
    const imageUrl = getDestinationImageUrl(dest.image, category);
 
    return (
        '<div class="col">' +
            '<div class="destination-card shadow-sm" data-destination-id="' + id + '" onclick="handleDestinationCardClick(' + id + ')">' +
                '<img src="' + imageUrl + '" alt="' + escapeHtml(name) + '" onerror="this.src=\'' + FRONTEND_BASE_URL + '/images/background.webp\'">' +
                '<div class="destination-overlay">' +
                    '<span class="rating-badge"><i class="fas fa-star text-warning me-1"></i>4.5</span>' +
                    '<div>' +
                        '<h5 class="text-white fw-bold mb-0"><i class="fas fa-map-marker-alt me-1"></i> ' + escapeHtml(name) + '</h5>' +
                        '<p class="text-white-50 small mb-1">' + escapeHtml(category) + (location ? " &bull; " + escapeHtml(location) : "") + '</p>' +
                        '<span class="text-white fw-bold">From &#8377;' + budget + ' <i class="fas fa-chevron-right fs-6 ms-1"></i></span>' +
                    '</div>' +
                '</div>' +
            '</div>' +
        '</div>'
    );
}
 
// No direct access from the home page - every destination card click goes to login.jsp.
function handleDestinationCardClick(id) {
    goToLogin();
}
 
function wireViewAllLink() {
    const link = document.getElementById("viewAllDestinationsLink");
    if (!link) return;
    link.addEventListener("click", function (e) {
        e.preventDefault();
        goToLogin();
    });
}
 
 
/* =========================================================
   WHAT KIND OF TRAVELLER ARE YOU? (DB categories + moods)
   ========================================================= */
 
function renderTravellerTypes(destinations) {
    const wrapper = document.getElementById("travellerSwiperWrapper");
    if (!wrapper) return;
 
    // Categories actually present in the database right now.
    const dbCategories = [...new Set(
        destinations
            .map(function (d) { return (d.category || "").trim(); })
            .filter(function (c) { return c !== ""; })
    )];
 
    const categorySlides = dbCategories.map(function (category) {

        /*
         * IMPORTANT:
         * Category cards use the actual image stored in the database.
         * We do not replace the database image with a generic
         * category image such as hillstation.jpg or beach.jpg.
         */
        const sample = destinations.find(function (d) {
            return (
                (d.category || "").trim().toLowerCase()
                === category.toLowerCase()
                && d.image
            );
        });

        const image = sample
            ? getDestinationImageUrl(sample.image, category)
            : (FRONTEND_BASE_URL + "/images/background.webp");

        return {
            type: "category",
            value: category,
            title: category,
            description: "Explore our " + category.toLowerCase() + " destinations.",
            image: image
        };
    });

    const moodSlides = MOOD_TRAVELLER_TYPES.map(function (m) {
        return {
            type: "mood",
            value: m.mood,
            title: m.title,
            description: m.description,
            image: m.image
        };
    });
 
    const slides = categorySlides.concat(moodSlides);
 
    if (!slides.length) {
        renderTravellerTypesError();
        return;
    }
 
    wrapper.innerHTML = slides.map(function (slide) {
        return (
            '<div class="swiper-slide">' +
                '<div class="traveller-card" onclick="handleTravellerTypeClick()">' +
                    '<div class="img-wrapper">' +
                        '<img src="' + slide.image + '" alt="' + escapeHtml(slide.title) + '" onerror="this.src=\'' + FRONTEND_BASE_URL + '/images/background.webp\'">' +
                    '</div>' +
                    '<div class="p-3">' +
                        '<h6 class="fw-bold text-dark mb-1">' + escapeHtml(slide.title) + '</h6>' +
                        '<p class="text-muted mb-0 small">' + escapeHtml(slide.description) + '</p>' +
                    '</div>' +
                '</div>' +
            '</div>'
        );
    }).join("");
 
    initTravellerSwiper();
}
 
function renderTravellerTypesError() {
    const wrapper = document.getElementById("travellerSwiperWrapper");
    if (!wrapper) return;
    wrapper.innerHTML = '<div class="swiper-slide"><p class="text-muted text-center py-4">Unable to load traveller types right now.</p></div>';
}
 
// Clicking ANY traveller-type card always goes straight to login.jsp - no
// in-page search/preview for this section.
function handleTravellerTypeClick() {
    goToLogin();
}
 
let travellerSwiperInstance = null;
 
function initTravellerSwiper() {
    if (travellerSwiperInstance) {
        travellerSwiperInstance.destroy(true, true);
        travellerSwiperInstance = null;
    }
 
    travellerSwiperInstance = new Swiper(".traveller-swiper", {
        slidesPerView: 1,
        spaceBetween: 16,
        loop: true,
        autoplay: {
            delay: 3500,
            disableOnInteraction: false
        },
        pagination: {
            el: ".swiper-pagination",
            clickable: true
        },
        navigation: {
            nextEl: ".swiper-button-next-custom",
            prevEl: ".swiper-button-prev-custom"
        },
        breakpoints: {
            576: { slidesPerView: 2, spaceBetween: 16 },
            768: { slidesPerView: 3, spaceBetween: 20 },
            992: { slidesPerView: 4, spaceBetween: 20 },
            1200: { slidesPerView: 5, spaceBetween: 24 }
        }
    });
}
 
 
/* =========================================================
   SEARCH / TRIP PLANNER BAR
   "Plan My Trip" filters the destinations already loaded from
   the database and shows a preview right here on the home
   page. Everyone can see this preview list; clicking a
   specific destination card in it goes to login.jsp, same as
   every other card on this page (see buildDestinationCardHtml
   / handleDestinationCardClick above).
   ========================================================= */
 
function wireSearchForm() {
    const form = document.getElementById("recommendationForm");
    if (!form) return;
 
    form.addEventListener("submit", function (e) {
        e.preventDefault();
        runTripPlannerSearch();
    });
 
    const closeBtn = document.getElementById("closeTripPlannerResults");
    if (closeBtn) {
        closeBtn.addEventListener("click", function () {
            const wrap = document.getElementById("tripPlannerResultsWrap");
            if (wrap) wrap.style.display = "none";
        });
    }
}
 
function runTripPlannerSearch() {
    const destinationQuery = ((document.getElementById("targetDestination") || {}).value || "").trim().toLowerCase();
    const budget = (document.getElementById("maxBudget") || {}).value || "";
    const tripType = (document.getElementById("tripType") || {}).value || "";
 
    let results = allDestinationsCache.slice();
    let label = "";
 
    if (tripType && tripType !== "Any") {
        results = results.filter(function (d) { return (d.category || "").toLowerCase() === tripType.toLowerCase(); });
        label = "in " + tripType;
    }
 
    if (destinationQuery) {
        results = results.filter(function (d) {
            return (d.destinationName || "").toLowerCase().includes(destinationQuery) ||
                   (d.state || "").toLowerCase().includes(destinationQuery) ||
                   (d.country || "").toLowerCase().includes(destinationQuery);
        });
    }
 
    if (budget) {
        const maxBudget = Number(budget);
        if (!isNaN(maxBudget) && maxBudget > 0) {
            results = results.filter(function (d) { return !d.budget || Number(d.budget) <= maxBudget; });
        }
    }
 
    renderTripPlannerResults(results, label);
}
 
function moodMatchesDestination(mood, dest) {
    const text = ((dest.category || "") + " " + (dest.description || "") + " " + (dest.destinationName || "")).toLowerCase();
    const moodDef = MOOD_TRAVELLER_TYPES.find(function (m) { return m.mood.toLowerCase() === String(mood).toLowerCase(); });
    const keywords = moodDef ? moodDef.keywords : [String(mood).toLowerCase()];
    return keywords.some(function (k) { return text.includes(k); });
}
 
function renderTripPlannerResults(destinations, label) {
    const wrap = document.getElementById("tripPlannerResultsWrap");
    const row = document.getElementById("tripPlannerResultsRow");
    const labelEl = document.getElementById("tripPlannerResultsLabel");
    if (!wrap || !row) return;
 
    if (labelEl) labelEl.textContent = label ? label : "";
 
    if (!destinations.length) {
        row.innerHTML = '<div class="col-12 text-center text-muted py-4"><p class="mb-0">No destinations match your search. Try a different budget or trip type.</p></div>';
    } else {
        row.innerHTML = destinations.map(buildDestinationCardHtml).join("");
    }
 
    wrap.style.display = "block";
    setTimeout(function () {
        wrap.scrollIntoView({ behavior: "smooth", block: "start" });
    }, 80);
}
 
 
/* =========================================================
   WATCH DEMO MODAL
   ========================================================= */
 
function wireDemoVideoModal() {
    const modalEl = document.getElementById("demoVideoModal");
    const frame = document.getElementById("demoVideoFrame");
    if (!modalEl || !frame) return;
 
    modalEl.addEventListener("shown.bs.modal", function () {
        const src = frame.getAttribute("data-src");
        if (src) frame.setAttribute("src", src + "?autoplay=1");
    });
 
    modalEl.addEventListener("hidden.bs.modal", function () {
        frame.setAttribute("src", "");
    });
}
 
 
/* =========================================================
   SHARED HELPERS
   ========================================================= */
 
function getDestinationImageUrl(image, category) {

    if (!image) {
        return getLocalImageForCategory(category)
            || (FRONTEND_BASE_URL + "/images/background.webp");
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
     * Database stores the destination image filename.
     * DestinationController serves it from:
     * /api/destinations/images/{fileName}
     */
    return API_CONFIG.destinationImage(value);
}
 
function formatPrice(value) {
    const num = Number(value);
    if (!value || isNaN(num)) return "0";
    return num.toLocaleString("en-IN");
}
 
function escapeHtml(str) {
    return String(str == null ? "" : str)
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#39;");
}
 


