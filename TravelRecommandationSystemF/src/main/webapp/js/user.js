/* =========================================================
   TRIPNEXA USER DASHBOARD JAVASCRIPT
   ========================================================= */


/* =========================================================
   API CONFIGURATION
   ========================================================= */

const USER_DASHBOARD_BACKEND =
    API_CONFIG.BASE_URL;

const DESTINATIONS_API =
    USER_DASHBOARD_BACKEND + "/api/destinations";

const RECOMMENDATIONS_API =
    USER_DASHBOARD_BACKEND + "/api/recommendations";

const TRAVEL_PROFILE_API =
    USER_DASHBOARD_BACKEND + "/api/travel-profile";

const UPLOADS_API =
    USER_DASHBOARD_BACKEND + "/uploads/";


/* =========================================================
   GLOBAL VARIABLES
   ========================================================= */

let allDashboardDestinations = [];

let allRecommendedDestinations = [];

let selectedExploreCategory = "";

const MAX_RECOMMENDED_CARDS = 4;
const MAX_POPULAR_CARDS = 6;


/* =========================================================
   INITIALIZATION
   ========================================================= */

document.addEventListener("DOMContentLoaded", function () {

    loadDashboardUserName();

    loadDashboardDestinations();

    loadRecommendedDestinations();

    loadTravelProfile();

    setupQuickFilters();

    setupNotificationCount();

});



/* =========================================================
   USER NAME
   ========================================================= */

function getLoggedInUserId() {

    const possibleKeys = [
        "userId",
        "user_id",
        "loggedInUserId",
        "currentUserId",
        "id"
    ];

    for (const key of possibleKeys) {

        const localValue =
            localStorage.getItem(key);

        const sessionValue =
            sessionStorage.getItem(key);

        if (localValue) {
            return localValue;
        }

        if (sessionValue) {
            return sessionValue;
        }

    }

    return null;

}


function loadDashboardUserName() {

    const possibleNameKeys = [
        "userName",
        "username",
        "name",
        "fullName",
        "loggedInUserName"
    ];

    let userName = null;

    for (const key of possibleNameKeys) {

        userName =
            localStorage.getItem(key) ||
            sessionStorage.getItem(key);

        if (userName) {
            break;
        }

    }

    if (!userName) {
        userName = "Traveler";
    }

    const firstName =
        userName.trim().split(" ")[0];


    const welcomeName =
        document.getElementById(
            "dashboardUserName"
        );

    const headerName =
        document.getElementById(
            "dashboardHeaderUserName"
        );


    if (welcomeName) {
        welcomeName.textContent = firstName;
    }

    if (headerName) {
        headerName.textContent = userName;
    }

}



/* =========================================================
   LOAD DESTINATIONS FROM DATABASE
   ========================================================= */

function loadDashboardDestinations() {

    fetch(DESTINATIONS_API, {
        method: "GET",
        headers: {
            "Accept": "application/json"
        }
    })
    .then(function (response) {

        if (!response.ok) {
            throw new Error(
                "Unable to load destinations. Status: " +
                response.status
            );
        }

        return response.json();

    })
    .then(function (result) {

        /*
         Supports both:

         [
           {...},
           {...}
         ]

         and:

         {
           data: [...]
         }
        */

        if (Array.isArray(result)) {
            allDashboardDestinations = result;
        } else if (
            result &&
            Array.isArray(result.data)
        ) {
            allDashboardDestinations = result.data;
        } else if (
            result &&
            Array.isArray(result.destinations)
        ) {
            allDashboardDestinations =
                result.destinations;
        } else {
            allDashboardDestinations = [];
        }


        renderExploreCategories();

        renderPopularDestinations();

        populateQuickFilterOptions();

    })
    .catch(function (error) {

        console.error(
            "Destination loading error:",
            error
        );


        showDashboardMessage(
            "exploreCategoryGrid",
            "Unable to load destination categories."
        );


        showDashboardMessage(
            "popularDestinationGrid",
            "Unable to load popular destinations."
        );

    });

}



/* =========================================================
   LOAD RECOMMENDATIONS
   ========================================================= */

function loadRecommendedDestinations() {

    const userId =
        getLoggedInUserId();


    const grid =
        document.getElementById(
            "recommendedDestinationGrid"
        );

    if (!grid) {
        return;
    }


    if (!userId) {

        grid.innerHTML = `
            <div class="dashboard-empty">
                Please
                <a href="login.jsp">login</a>
                to view personalized recommendations.
            </div>
        `;

        return;
    }


    fetch(
        RECOMMENDATIONS_API +
        "/" +
        encodeURIComponent(userId),
        {
            method: "GET",
            headers: {
                "Accept": "application/json"
            }
        }
    )
    .then(function (response) {

        if (!response.ok) {
            throw new Error(
                "Recommendation request failed"
            );
        }

        return response.json();

    })
    .then(function (result) {

        if (Array.isArray(result)) {
            allRecommendedDestinations = result;
        } else if (
            result &&
            Array.isArray(result.data)
        ) {
            allRecommendedDestinations = result.data;
        } else if (
            result &&
            Array.isArray(result.recommendations)
        ) {
            allRecommendedDestinations =
                result.recommendations;
        } else {
            allRecommendedDestinations = [];
        }


        renderRecommendedDestinations();

    })
    .catch(function (error) {

        console.error(
            "Recommendation loading error:",
            error
        );


        /*
         * If recommendation API fails,
         * display top database destinations
         * instead of leaving the section empty.
         */

        allRecommendedDestinations =
            allDashboardDestinations.slice(
                0,
                MAX_RECOMMENDED_CARDS
            );

        renderRecommendedDestinations();

    });

}



/* =========================================================
   RENDER RECOMMENDED DESTINATIONS
   Maximum 4 cards
   ========================================================= */

function renderRecommendedDestinations() {

    const grid =
        document.getElementById(
            "recommendedDestinationGrid"
        );

    if (!grid) {
        return;
    }


    let destinations =
        allRecommendedDestinations.slice(
            0,
            MAX_RECOMMENDED_CARDS
        );


    if (destinations.length === 0) {

        destinations =
            allDashboardDestinations.slice(
                0,
                MAX_RECOMMENDED_CARDS
            );

    }


    if (destinations.length === 0) {

        grid.innerHTML = `
            <div class="dashboard-empty">
                No recommendations available yet.
            </div>
        `;

        return;
    }


    grid.innerHTML = "";


    destinations.forEach(function (destination, index) {

        grid.appendChild(
            createDestinationCard(
                destination,
                false,
                index
            )
        );

    });

}



/* =========================================================
   EXPLORE CATEGORY CARDS
   Categories are dynamically generated from database
   ========================================================= */

function renderExploreCategories() {

    const grid =
        document.getElementById(
            "exploreCategoryGrid"
        );

    if (!grid) {
        return;
    }


    if (
        !Array.isArray(allDashboardDestinations) ||
        allDashboardDestinations.length === 0
    ) {

        grid.innerHTML = `
            <div class="dashboard-empty">
                No destination categories found.
            </div>
        `;

        return;
    }


    const categoryMap = new Map();


    allDashboardDestinations.forEach(function (destination) {

        const category =
            getDestinationCategory(destination);


        if (!category) {
            return;
        }


        const categoryKey =
            category.toLowerCase();


        if (!categoryMap.has(categoryKey)) {

            categoryMap.set(
                categoryKey,
                {
                    name: category,
                    destination: destination
                }
            );

        }

    });


    const categories =
        Array.from(categoryMap.values());


    /*
     * Display maximum 6 Explore category cards.
     * If you want 7, change 6 to 7 here.
     */

    const visibleCategories =
        categories.slice(0, 6);


    grid.innerHTML = "";


    if (visibleCategories.length === 0) {

        grid.innerHTML = `
            <div class="dashboard-empty">
                No categories available.
            </div>
        `;

        return;
    }


    visibleCategories.forEach(function (categoryData) {

        const categoryName =
            categoryData.name;

        const destination =
            categoryData.destination;


        const card =
            document.createElement("button");

        card.type = "button";

        card.className =
            "explore-category-card";


        if (
            selectedExploreCategory &&
            selectedExploreCategory.toLowerCase() ===
            categoryName.toLowerCase()
        ) {
            card.classList.add("active");
        }


        const image =
            resolveDestinationImage(
                getDestinationImage(destination)
            );


        card.style.backgroundImage =
            `url("${image}")`;


        card.innerHTML = `

            <div class="explore-category-content">

                <i class="${getCategoryIcon(categoryName)}
                    explore-category-icon"></i>

                <span class="explore-category-name">
                    ${escapeHtml(categoryName)}
                </span>

            </div>

        `;


        card.addEventListener("click", function () {

            selectedExploreCategory =
                categoryName;

            renderExploreCategories();

            renderPopularDestinations(categoryName);

        });


        grid.appendChild(card);

    });

}



/* =========================================================
   POPULAR DESTINATIONS
   Maximum 6 cards
   ========================================================= */

function renderPopularDestinations(category) {

    const grid =
        document.getElementById(
            "popularDestinationGrid"
        );

    const title =
        document.getElementById(
            "popularSectionTitle"
        );

    const subtitle =
        document.getElementById(
            "popularSectionSubtitle"
        );

    const showAllButton =
        document.getElementById(
            "showAllPopularButton"
        );


    if (!grid) {
        return;
    }


    if (category !== undefined) {
        selectedExploreCategory = category || "";
    }


    let destinations =
        [...allDashboardDestinations];


    if (selectedExploreCategory) {

        const selectedCategory =
            selectedExploreCategory
                .trim()
                .toLowerCase();


        destinations =
            destinations.filter(function (destination) {

                return (
                    getDestinationCategory(destination)
                        .toLowerCase() ===
                    selectedCategory
                );

            });


        if (title) {
            title.textContent =
                "Popular " +
                selectedExploreCategory +
                " Destinations";
        }

        if (subtitle) {
            subtitle.textContent =
                "Top destinations in this category";
        }

        if (showAllButton) {
            showAllButton.style.display =
                "inline-flex";
        }

    } else {

        if (title) {
            title.textContent =
                "Popular Destinations";
        }

        if (subtitle) {
            subtitle.textContent =
                "Explore popular destinations from our database";
        }

        if (showAllButton) {
            showAllButton.style.display =
                "none";
        }

    }


    /*
     * Sort highest rating first.
     */

    destinations.sort(function (a, b) {

        const ratingA =
            Number(
                a.rating ||
                a.averageRating ||
                a.reviewRating ||
                0
            );

        const ratingB =
            Number(
                b.rating ||
                b.averageRating ||
                b.reviewRating ||
                0
            );

        return ratingB - ratingA;

    });


    /*
     * Only display 6 cards.
     */

    destinations =
        destinations.slice(
            0,
            MAX_POPULAR_CARDS
        );


    if (destinations.length === 0) {

        grid.innerHTML = `
            <div class="dashboard-empty">
                No destinations found for this category.
            </div>
        `;

        return;
    }


    grid.innerHTML = "";


    destinations.forEach(function (destination, index) {

        grid.appendChild(
            createDestinationCard(
                destination,
                true,
                index
            )
        );

    });


    if (category) {

        const popularSection =
            document.querySelector(
                ".popular-section"
            );

        if (popularSection) {

            setTimeout(function () {

                popularSection.scrollIntoView({
                    behavior: "smooth",
                    block: "start"
                });

            }, 150);

        }

    }

}



/* =========================================================
   RESET POPULAR FILTER
   ========================================================= */

document.addEventListener("DOMContentLoaded", function () {

    const resetButton =
        document.getElementById(
            "showAllPopularButton"
        );


    if (resetButton) {

        resetButton.addEventListener(
            "click",
            function () {

                selectedExploreCategory = "";

                renderExploreCategories();

                renderPopularDestinations("");

            }
        );

    }

});



/* =========================================================
   CREATE DESTINATION CARD
   ========================================================= */

function createDestinationCard(
    destination,
    isPopular,
    index
) {

    const card =
        document.createElement("article");

    card.className =
        "dashboard-destination-card";


    const id =
        getDestinationId(destination);

    const name =
        getDestinationName(destination);

    const location =
        getDestinationLocation(destination);

    const category =
        getDestinationCategory(destination);

    const image =
        resolveDestinationImage(
            getDestinationImage(destination)
        );

    const budget =
        getDestinationBudget(destination);

    const season =
        getDestinationSeason(destination);

    const rating =
        getDestinationRating(destination);


    let matchPercentage =
        destination.matchPercentage ||
        destination.matchPercent ||
        destination.match ||
        85;


    matchPercentage =
        Math.max(
            0,
            Math.min(
                100,
                Math.round(Number(matchPercentage) || 85)
            )
        );


    card.innerHTML = `

        <div class="destination-card-image-wrapper">

            <img
                class="destination-card-image"
                src="${image}"
                alt="${escapeHtml(name)}"
                onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1500534623283-312aade485b7?w=600';"
            >


            ${
                isPopular
                    ? `
                        <span class="destination-popular-label">
                            <i class="fa-solid fa-fire"></i>
                            Popular
                        </span>

                        ${
                            rating
                                ? `
                                    <span class="destination-rating-label">
                                        <i class="fa-solid fa-star"></i>
                                        ${escapeHtml(rating)}
                                    </span>
                                  `
                                : ""
                        }
                      `
                    : `
                        <span class="destination-match-badge">
                            ${matchPercentage}% Match
                        </span>

                        <button
                            type="button"
                            class="destination-heart-button"
                            title="Save destination">

                            <i class="fa-regular fa-heart"></i>

                        </button>
                      `
            }

        </div>


        <div class="destination-card-body">

            <h3 class="destination-card-name">
                ${escapeHtml(name)}
            </h3>


            ${
                location
                    ? `
                        <div class="destination-card-location">

                            <i class="fa-solid fa-location-dot"></i>

                            ${escapeHtml(location)}

                        </div>
                      `
                    : ""
            }


            <div class="destination-card-tags">

                ${
                    category
                        ? `
                            <span class="destination-card-tag">
                                ${escapeHtml(category)}
                            </span>
                          `
                        : ""
                }

            </div>


            <div class="destination-card-footer">

                <span>
                    <i class="fa-solid fa-wallet"></i>
                    ${escapeHtml(budget)}
                </span>

                <span>
                    <i class="fa-regular fa-calendar"></i>
                    ${escapeHtml(season)}
                </span>

            </div>


            <button
                type="button"
                class="destination-view-button">

                View Destination
                <i class="fa-solid fa-arrow-right"></i>

            </button>

        </div>

    `;


    const viewButton =
        card.querySelector(
            ".destination-view-button"
        );


    if (viewButton) {

        viewButton.addEventListener(
            "click",
            function () {

                window.location.href =
                    "destination-details.jsp?id=" +
                    encodeURIComponent(id) +
                    "&destinationId=" +
                    encodeURIComponent(id);

            }
        );

    }


    return card;

}



/* =========================================================
   DESTINATION FIELD HELPERS
   Supports different backend property names
   ========================================================= */

function getDestinationId(destination) {

    return (
        destination.destinationId ||
        destination.id ||
        destination.destId ||
        ""
    );

}


function getDestinationName(destination) {

    return (
        destination.destinationName ||
        destination.name ||
        destination.title ||
        "Unknown Destination"
    );

}


function getDestinationCategory(destination) {

    return String(
        destination.category ||
        destination.destinationCategory ||
        destination.type ||
        "Other"
    ).trim();

}


function getDestinationLocation(destination) {

    return (
        destination.location ||
        destination.state ||
        destination.city ||
        destination.place ||
        destination.country ||
        ""
    );

}


function getDestinationImage(destination) {

    return (
        destination.image ||
        destination.imageUrl ||
        destination.imagePath ||
        destination.photo ||
        destination.thumbnail ||
        ""
    );

}


function getDestinationBudget(destination) {

    const budget =
        destination.budget ||
        destination.averageBudget ||
        destination.price ||
        destination.cost;


    if (
        budget === null ||
        budget === undefined ||
        budget === ""
    ) {
        return "Budget unavailable";
    }


    if (!isNaN(Number(budget))) {

        return "₹" +
            Number(budget).toLocaleString("en-IN");

    }


    return String(budget);

}


function getDestinationSeason(destination) {

    return (
        destination.bestSeason ||
        destination.season ||
        destination.bestTime ||
        "All season"
    );

}


function getDestinationRating(destination) {

    return (
        destination.rating ||
        destination.averageRating ||
        destination.reviewRating ||
        ""
    );

}



/* =========================================================
   IMAGE RESOLVER
   ========================================================= */

function resolveDestinationImage(image) {

    if (!image) {

        return "https://images.unsplash.com/photo-1500534623283-312aade485b7?w=600";

    }


    const imageValue =
        String(image).trim();


    if (
        imageValue.startsWith("http://") ||
        imageValue.startsWith("https://") ||
        imageValue.startsWith("data:image")
    ) {

        return imageValue;

    }


    return UPLOADS_API + imageValue;

}



/* =========================================================
   CATEGORY ICONS
   ========================================================= */

function getCategoryIcon(category) {

    const value =
        String(category).toLowerCase();


    if (
        value.includes("beach") ||
        value.includes("coastal")
    ) {
        return "fa-solid fa-umbrella-beach";
    }

    if (
        value.includes("mountain") ||
        value.includes("hill") ||
        value.includes("himalaya")
    ) {
        return "fa-solid fa-mountain";
    }

    if (
        value.includes("heritage") ||
        value.includes("culture") ||
        value.includes("histor")
    ) {
        return "fa-solid fa-landmark";
    }

    if (
        value.includes("adventure") ||
        value.includes("trek") ||
        value.includes("sport")
    ) {
        return "fa-solid fa-person-hiking";
    }

    if (
        value.includes("nature") ||
        value.includes("forest") ||
        value.includes("wildlife")
    ) {
        return "fa-solid fa-leaf";
    }

    if (
        value.includes("spiritual") ||
        value.includes("religious") ||
        value.includes("temple")
    ) {
        return "fa-solid fa-place-of-worship";
    }

    if (
        value.includes("city") ||
        value.includes("urban")
    ) {
        return "fa-solid fa-city";
    }

    if (
        value.includes("water") ||
        value.includes("lake") ||
        value.includes("waterfall")
    ) {
        return "fa-solid fa-water";
    }

    return "fa-solid fa-location-dot";

}



/* =========================================================
   PROFILE COMPLETION
   ========================================================= */

function loadTravelProfile() {

    const userId =
        getLoggedInUserId();


    if (!userId) {

        updateProfileCompletion(0);

        return;
    }


    fetch(
        TRAVEL_PROFILE_API +
        "/" +
        encodeURIComponent(userId),
        {
            method: "GET",
            headers: {
                "Accept": "application/json"
            }
        }
    )
    .then(function (response) {

        if (!response.ok) {
            throw new Error(
                "Profile API request failed"
            );
        }

        return response.json();

    })
    .then(function (result) {

        const profile =
            result && result.data
                ? result.data
                : result;


        if (!profile) {
            updateProfileCompletion(0);
            return;
        }


        const profileFields = [
            profile.location,
            profile.travelCompanion,
            profile.budget,
            profile.interests,
            profile.destinationCategories,
            profile.preferredSeason,
            profile.accommodation,
            profile.tripDuration
        ];


        const filledFields =
            profileFields.filter(function (value) {

                return (
                    value !== null &&
                    value !== undefined &&
                    String(value).trim() !== ""
                );

            }).length;


        const completion =
            Math.round(
                (
                    filledFields /
                    profileFields.length
                ) * 100
            );


        updateProfileCompletion(completion);


        setProfileValue(
            "profileLocation",
            profile.location
        );


        setProfileValue(
            "profileCompanion",
            profile.travelCompanion ||
            profile.companion
        );


        setProfileValue(
            "profileBudget",
            profile.budget
                ? "₹" +
                  Number(profile.budget)
                    .toLocaleString("en-IN")
                : null
        );


        setProfileValue(
            "profileInterests",
            profile.interests
        );

    })
    .catch(function (error) {

        console.error(
            "Profile loading error:",
            error
        );

        updateProfileCompletion(0);

    });

}



function updateProfileCompletion(percent) {

    const percentText =
        document.getElementById(
            "profileCompletionPercent"
        );

    const progressCircle =
        document.getElementById(
            "profileProgressCircle"
        );


    if (percentText) {
        percentText.textContent =
            percent + "%";
    }


    if (progressCircle) {

        const circumference = 289;

        const offset =
            circumference -
            (
                circumference *
                percent /
                100
            );

        progressCircle.style.strokeDashoffset =
            offset;

    }

}



function setProfileValue(id, value) {

    const element =
        document.getElementById(id);


    if (!element) {
        return;
    }


    if (
        value !== null &&
        value !== undefined &&
        String(value).trim() !== ""
    ) {
        element.textContent = value;
    } else {
        element.textContent = "Not set";
    }

}



/* =========================================================
   QUICK FILTERS
   ========================================================= */

function populateQuickFilterOptions() {

    const locationSelect =
        document.getElementById(
            "quickLocation"
        );

    const categorySelect =
        document.getElementById(
            "quickCategory"
        );


    const locations =
        [
            ...new Set(
                allDashboardDestinations
                    .map(function (destination) {
                        return getDestinationLocation(destination);
                    })
                    .filter(Boolean)
            )
        ].sort();


    const categories =
        [
            ...new Set(
                allDashboardDestinations
                    .map(function (destination) {
                        return getDestinationCategory(destination);
                    })
                    .filter(Boolean)
            )
        ].sort();


    if (locationSelect) {

        locations.forEach(function (location) {

            const option =
                document.createElement("option");

            option.value = location;
            option.textContent = location;

            locationSelect.appendChild(option);

        });

    }


    if (categorySelect) {

        categories.forEach(function (category) {

            const option =
                document.createElement("option");

            option.value = category;
            option.textContent = category;

            categorySelect.appendChild(option);

        });

    }

}



function setupQuickFilters() {

    const applyButton =
        document.getElementById(
            "applyQuickFilters"
        );


    if (!applyButton) {
        return;
    }


    applyButton.addEventListener(
        "click",
        function () {

            const budget =
                document.getElementById(
                    "quickBudget"
                ).value;

            const location =
                document.getElementById(
                    "quickLocation"
                ).value;

            const category =
                document.getElementById(
                    "quickCategory"
                ).value;

            const companion =
                document.getElementById(
                    "quickCompanion"
                ).value;


            const params =
                new URLSearchParams();


            if (budget) {
                params.set(
                    "maxBudget",
                    budget
                );
            }

            if (location) {
                params.set(
                    "location",
                    location
                );
            }

            if (category) {
                params.set(
                    "category",
                    category
                );
            }

            if (companion) {
                params.set(
                    "companion",
                    companion
                );
            }


            window.location.href =
                "recommendation.jsp?" +
                params.toString();

        }
    );

}



/* =========================================================
   NOTIFICATION COUNT
   ========================================================= */

function setupNotificationCount() {

    /*
     * This does not interfere with your existing
     * notification JavaScript.
     *
     * If your existing notification script updates
     * another ID, keep that script unchanged.
     */

    const notificationCount =
        localStorage.getItem(
            "unreadNotificationCount"
        );


    if (
        notificationCount &&
        Number(notificationCount) > 0
    ) {

        updateNotificationBadge(
            Number(notificationCount)
        );

    }

}


function updateNotificationBadge(count) {

    const badge =
        document.getElementById(
            "dashboardNotificationCount"
        );


    if (!badge) {
        return;
    }


    if (count > 0) {

        badge.textContent =
            count > 99 ? "99+" : count;

        badge.classList.add("show");

    } else {

        badge.classList.remove("show");

    }

}



/* =========================================================
   UTILITIES
   ========================================================= */

function showDashboardMessage(
    elementId,
    message
) {

    const element =
        document.getElementById(elementId);


    if (element) {

        element.innerHTML = `
            <div class="dashboard-empty">
                ${escapeHtml(message)}
            </div>
        `;

    }

}


function escapeHtml(value) {

    if (
        value === null ||
        value === undefined
    ) {
        return "";
    }


    return String(value)
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");

}