const API_BASE_URL = API_CONFIG.BASE_URL;

let allDestinations = [];
let filteredDestinations = [];

let currentPage = 1;
const cardsPerPage = 8;


/* =====================================================
   PAGE LOAD / SCROLL FIX
===================================================== */

document.addEventListener("DOMContentLoaded", function () {

    /*
     * Prevent browser from restoring the previous
     * scroll position when opening Explore.
     */
    if ("scrollRestoration" in history) {
        history.scrollRestoration = "manual";
    }

    /*
     * If Explore was opened with something like:
     * explore.jsp#destinationContainer
     *
     * remove the hash so the browser does not jump
     * directly to the destination section.
     */
    if (window.location.hash) {
        history.replaceState(
            null,
            document.title,
            window.location.pathname + window.location.search
        );
    }

    /*
     * Always start Explore at the top.
     */
    window.scrollTo({
        top: 0,
        left: 0,
        behavior: "auto"
    });

    /*
     * Run once more after the browser finishes layout.
     * This prevents delayed browser scroll restoration.
     */
    requestAnimationFrame(function () {
        window.scrollTo({
            top: 0,
            left: 0,
            behavior: "auto"
        });
    });

    loadDestinations();

    setupSearchEvents();

    setupFilterEvents();

    setupSortEvent();

    setupMapButton();

});


/*
 * Handle browser back/forward cache.
 */
window.addEventListener("pageshow", function () {

    window.scrollTo({
        top: 0,
        left: 0,
        behavior: "auto"
    });

});


/* =====================================================
   SEARCH EVENTS
===================================================== */

function setupSearchEvents() {

    const destinationSearch =
        document.getElementById("destinationSearch");

    const globalSearch =
        document.getElementById("globalSearch");


    if (destinationSearch) {

        destinationSearch.addEventListener(
            "input",
            function () {

                applyFilters();

            }
        );

    }


    if (globalSearch) {

        globalSearch.addEventListener(
            "input",
            function () {

                if (destinationSearch) {

                    destinationSearch.value =
                        this.value;

                }

                applyFilters();

            }
        );

    }

}


/* =====================================================
   FILTER EVENTS
===================================================== */

function setupFilterEvents() {

    const filterBtn =
        document.getElementById("filterBtn");

    const resetBtn =
        document.getElementById("resetBtn");


    if (filterBtn) {

        filterBtn.addEventListener(
            "click",
            function () {

                applyFilters();

            }
        );

    }


    if (resetBtn) {

        resetBtn.addEventListener(
            "click",
            function () {

                resetFilters();

            }
        );

    }

}


/* =====================================================
   SORT EVENT
===================================================== */

function setupSortEvent() {

    const sortFilter =
        document.getElementById("sortFilter");


    if (sortFilter) {

        sortFilter.addEventListener(
            "change",
            function () {

                sortDestinations();

            }
        );

    }

}


/* =====================================================
   MAP BUTTON
===================================================== */

function setupMapButton() {

    const mapBtn =
        document.getElementById("viewMapBtn");


    if (mapBtn) {

        mapBtn.addEventListener(
            "click",
            function () {

                alert(
                    "Map feature will be available soon."
                );

            }
        );

    }

}


/* =====================================================
   LOAD DESTINATIONS
===================================================== */

async function loadDestinations() {

    try {

        showLoading(true);


        const response = await fetch(
            API_BASE_URL + "/api/destinations",
            {
                method: "GET",
                credentials: "include",
                headers: {
                    "Accept": "application/json"
                }
            }
        );


        if (!response.ok) {

            throw new Error(
                "Destination API failed: " +
                response.status
            );

        }


        const data =
            await response.json();


        console.log(
            "Destination API Response:",
            data
        );


        /* ==========================================
           BACKEND RESPONSE HANDLING
        ========================================== */

        if (Array.isArray(data)) {

            allDestinations = data;

        }

        else if (
            data &&
            Array.isArray(data.data)
        ) {

            allDestinations = data.data;

        }

        else if (
            data &&
            Array.isArray(data.content)
        ) {

            allDestinations = data.content;

        }

        else {

            allDestinations = [];

        }


        console.log(
            "Total Destinations:",
            allDestinations.length
        );


        /* ==========================================
           COPY FOR FILTERING
        ========================================== */

        filteredDestinations =
            [...allDestinations];


        /* ==========================================
           CREATE FILTER OPTIONS
        ========================================== */

        populateFilters();


        /* ==========================================
           DISPLAY CARDS
        ========================================== */

        currentPage = 1;

        renderDestinations();


    }

    catch (error) {

        console.error(
            "Destination loading error:",
            error
        );


        const container =
            document.getElementById(
                "destinationContainer"
            );


        if (container) {

            container.innerHTML = `

                <div style="
                    grid-column:1/-1;
                    text-align:center;
                    padding:50px;
                    color:#777;
                ">

                    <i
                        class="fa-solid fa-triangle-exclamation"
                        style="
                            font-size:40px;
                            margin-bottom:15px;
                        ">
                    </i>

                    <h3>
                        Unable to load destinations
                    </h3>

                    <p>
                        Please try again later.
                    </p>

                    <button
                        type="button"
                        onclick="loadDestinations()"
                        style="
                            margin-top:15px;
                            padding:10px 20px;
                            border:none;
                            border-radius:6px;
                            cursor:pointer;
                        "
                    >
                        Try Again
                    </button>

                </div>

            `;

        }

    }

    finally {

        showLoading(false);

    }

}


/* =====================================================
   POPULATE FILTERS
===================================================== */

function populateFilters() {

    const countrySelect =
        document.getElementById(
            "countryFilter"
        );

    const categorySelect =
        document.getElementById(
            "categoryFilter"
        );


    if (!countrySelect ||
        !categorySelect) {

        return;

    }


    /* ==========================================
       REMOVE OLD OPTIONS
    ========================================== */

    countrySelect.innerHTML = `
        <option value="">
            All Countries
        </option>
    `;


    categorySelect.innerHTML = `
        <option value="">
            All Categories
        </option>
    `;


    /* ==========================================
       COUNTRIES
    ========================================== */

    const countries = [
        ...new Set(

            allDestinations

                .map(function (destination) {

                    return getCountry(
                        destination
                    );

                })

                .filter(function (country) {

                    return country !== "";

                })

        )
    ];


    /* ==========================================
       CATEGORIES
    ========================================== */

    const categories = [
        ...new Set(

            allDestinations

                .map(function (destination) {

                    return getCategory(
                        destination
                    );

                })

                .filter(function (category) {

                    return category !== "";

                })

        )
    ];


    /* ==========================================
       ADD COUNTRIES
    ========================================== */

    countries
        .sort(function (a, b) {

            return a.localeCompare(b);

        })
        .forEach(function (country) {

            const option =
                document.createElement(
                    "option"
                );


            option.value = country;

            option.textContent = country;


            countrySelect.appendChild(
                option
            );

        });


    /* ==========================================
       ADD CATEGORIES
    ========================================== */

    categories
        .sort(function (a, b) {

            return a.localeCompare(b);

        })
        .forEach(function (category) {

            const option =
                document.createElement(
                    "option"
                );


            option.value = category;

            option.textContent = category;


            categorySelect.appendChild(
                option
            );

        });

}


/* =====================================================
   GET DESTINATION ID
===================================================== */

function getDestinationId(destination) {

    const id =

        destination.id ??

        destination.destinationId ??

        destination.destination_id ??

        destination._id ??

        "";


    return String(id);

}


/* =====================================================
   GET DESTINATION NAME
===================================================== */

function getDestinationName(destination) {

    return String(

        destination.destinationName ||

        destination.name ||

        destination.destination_name ||

        destination.title ||

        ""

    ).trim();

}


/* =====================================================
   GET COUNTRY
===================================================== */

function getCountry(destination) {

    return String(

        destination.country ||

        destination.countryName ||

        destination.country_name ||

        ""

    ).trim();

}


/* =====================================================
   GET CATEGORY
===================================================== */

function getCategory(destination) {

    return String(

        destination.category ||

        destination.categoryName ||

        destination.category_name ||

        destination.type ||

        ""

    ).trim();

}


/* =====================================================
   GET BUDGET
===================================================== */

function getBudget(destination) {

    const possibleValues = [

        destination.budget,

        destination.price,

        destination.cost,

        destination.totalBudget,

        destination.total_budget,

        destination.budgetValue,

        destination.budget_value

    ];


    for (
        let i = 0;
        i < possibleValues.length;
        i++
    ) {

        const value =
            possibleValues[i];


        if (
            value !== null &&
            value !== undefined &&
            value !== ""
        ) {

            const number =
                Number(
                    String(value)
                        .replace(/,/g, "")
                        .replace(/[₹$]/g, "")
                        .trim()
                );


            if (!isNaN(number)) {

                return number;

            }

        }

    }


    return 0;

}


/* =====================================================
   NORMALIZE TEXT
===================================================== */

function normalizeText(value) {

    return String(value || "")
        .trim()
        .toLowerCase();

}


/* =====================================================
   APPLY FILTERS
===================================================== */

function applyFilters() {

    const searchInput =
        document.getElementById(
            "destinationSearch"
        );

    const countrySelect =
        document.getElementById(
            "countryFilter"
        );

    const categorySelect =
        document.getElementById(
            "categoryFilter"
        );

    const budgetSelect =
        document.getElementById(
            "budgetFilter"
        );


    const search =
        searchInput
            ? normalizeText(
                searchInput.value
            )
            : "";


    const selectedCountry =
        countrySelect
            ? normalizeText(
                countrySelect.value
            )
            : "";


    const selectedCategory =
        categorySelect
            ? normalizeText(
                categorySelect.value
            )
            : "";


    const selectedBudget =
        budgetSelect
            ? budgetSelect.value
            : "";


    filteredDestinations =
        allDestinations.filter(
            function (destination) {

                const name =
                    normalizeText(
                        getDestinationName(
                            destination
                        )
                    );


                const country =
                    normalizeText(
                        getCountry(
                            destination
                        )
                    );


                const category =
                    normalizeText(
                        getCategory(
                            destination
                        )
                    );


                const budget =
                    getBudget(
                        destination
                    );


                /* SEARCH */

                const searchMatch =

                    !search ||

                    name.includes(search) ||

                    country.includes(search) ||

                    category.includes(search);


                /* COUNTRY */

                const countryMatch =

                    !selectedCountry ||

                    country === selectedCountry;


                /* CATEGORY */

                const categoryMatch =

                    !selectedCategory ||

                    category === selectedCategory;


                /* BUDGET */

                const budgetMatch =

                    !selectedBudget ||

                    (
                        budget > 0 &&
                        budget <=
                        Number(
                            selectedBudget
                        )
                    );


                return (

                    searchMatch &&

                    countryMatch &&

                    categoryMatch &&

                    budgetMatch

                );

            }
        );


    currentPage = 1;

    renderDestinations();

}


/* =====================================================
   RESET FILTERS
===================================================== */

function resetFilters() {

    const destinationSearch =
        document.getElementById(
            "destinationSearch"
        );

    const globalSearch =
        document.getElementById(
            "globalSearch"
        );

    const countryFilter =
        document.getElementById(
            "countryFilter"
        );

    const categoryFilter =
        document.getElementById(
            "categoryFilter"
        );

    const budgetFilter =
        document.getElementById(
            "budgetFilter"
        );


    if (destinationSearch) {

        destinationSearch.value = "";

    }


    if (globalSearch) {

        globalSearch.value = "";

    }


    if (countryFilter) {

        countryFilter.value = "";

    }


    if (categoryFilter) {

        categoryFilter.value = "";

    }


    if (budgetFilter) {

        budgetFilter.value = "";

    }


    filteredDestinations =
        [...allDestinations];


    currentPage = 1;


    renderDestinations();

}


/* =====================================================
   RENDER DESTINATIONS
===================================================== */

function renderDestinations(
    shouldScroll = false
) {

    const container =
        document.getElementById(
            "destinationContainer"
        );


    if (!container) {

        console.warn(
            "destinationContainer not found."
        );

        return;

    }


    /*
     * Clear old cards safely.
     */
    container.replaceChildren();


    const start =
        (currentPage - 1) *
        cardsPerPage;


    const end =
        start + cardsPerPage;


    const pageDestinations =
        filteredDestinations.slice(
            start,
            end
        );


    const countElement =
        document.getElementById(
            "destinationCount"
        );


    if (countElement) {

        countElement.textContent =
            filteredDestinations.length;

    }


    /* ==========================================
       NO RESULTS
    ========================================== */

    if (
        pageDestinations.length === 0
    ) {

        const emptyMessage =
            document.createElement("div");


        emptyMessage.style.gridColumn =
            "1 / -1";

        emptyMessage.style.textAlign =
            "center";

        emptyMessage.style.padding =
            "60px";

        emptyMessage.style.color =
            "#777";


        emptyMessage.innerHTML = `

            <i
                class="fa-solid fa-location-dot"
                style="
                    font-size:35px;
                    margin-bottom:15px;
                ">
            </i>

            <h3>
                No destinations found
            </h3>

            <p>
                Try changing your search or filters.
            </p>

        `;


        container.appendChild(
            emptyMessage
        );


        renderPagination();

        return;

    }


    /* ==========================================
       CREATE CARDS
    ========================================== */

    pageDestinations.forEach(
        function (destination) {

            const card =
                createDestinationCard(
                    destination
                );


            container.appendChild(
                card
            );

        }
    );


    renderPagination();


    /*
     * Only scroll when the user has changed
     * pagination, NOT when Explore initially opens.
     */
    if (shouldScroll) {

        setTimeout(function () {

            const top =
                container.getBoundingClientRect().top +
                window.pageYOffset -
                120;


            window.scrollTo({
                top: Math.max(0, top),
                left: 0,
                behavior: "smooth"
            });

        }, 50);

    }

}


/* =====================================================
   CREATE DESTINATION CARD
===================================================== */

function createDestinationCard(
    destination
) {

    const id =
        getDestinationId(destination);


    const name =
        getDestinationName(
            destination
        ) ||
        "Unknown Destination";


    const country =
        getCountry(
            destination
        ) ||
        "India";


    const category =
        getCategory(
            destination
        ) ||
        "Travel";


    const budget =
        getBudget(
            destination
        );


    const image =

        destination.image ||

        destination.imageUrl ||

        destination.imageURL ||

        destination.imageName ||

        destination.image_name;


    const imageUrl =
        getDestinationImageUrl(
            image
        );


    /*
     * Main card
     */
    const card =
        document.createElement(
            "div"
        );


    card.className =
        "destination-card";


    /* ==========================================
       IMAGE SECTION
    ========================================== */

    const imageContainer =
        document.createElement(
            "div"
        );


    imageContainer.className =
        "card-image";


    const img =
        document.createElement(
            "img"
        );


    img.src =
        imageUrl;


    img.alt =
        name;


    img.loading =
        "lazy";


    img.onerror =
        function () {

            this.onerror = null;

            this.src =
                API_BASE_URL +
                "/images/default-destination.jpg";

        };


    /* ==========================================
       FAVORITE BUTTON
    ========================================== */

    const favoriteButton =
        document.createElement(
            "button"
        );


    favoriteButton.type =
        "button";


    favoriteButton.className =
        "favorite-btn";


    favoriteButton.title =
        "Save destination";


    favoriteButton.innerHTML =
        `<i class="fa-regular fa-heart"></i>`;


    favoriteButton.addEventListener(
        "click",
        function (event) {

            event.preventDefault();

            event.stopPropagation();

            saveDestination(id);

        }
    );


    imageContainer.appendChild(
        img
    );


    imageContainer.appendChild(
        favoriteButton
    );


    /* ==========================================
       CARD BODY
    ========================================== */

    const body =
        document.createElement(
            "div"
        );


    body.className =
        "card-body";


    /* TITLE */

    const title =
        document.createElement(
            "h3"
        );


    title.textContent =
        name;


    /* LOCATION ROW */

    const locationRow =
        document.createElement(
            "div"
        );


    locationRow.className =
        "location-row";


    const locationIcon =
        document.createElement(
            "i"
        );


    locationIcon.className =
        "fa-solid fa-location-dot";


    const countrySpan =
        document.createElement(
            "span"
        );


    countrySpan.textContent =
        country;


    const categoryBadge =
        document.createElement(
            "span"
        );


    categoryBadge.className =
        "category-badge";


    categoryBadge.textContent =
        category;


    locationRow.appendChild(
        locationIcon
    );


    locationRow.appendChild(
        countrySpan
    );


    locationRow.appendChild(
        categoryBadge
    );


    /* PRICE */

    const price =
        document.createElement(
            "div"
        );


    price.className =
        "price";


    price.textContent =
        "₹" +
        formatPrice(budget);


    /* PRICE TEXT */

    const priceText =
        document.createElement(
            "div"
        );


    priceText.className =
        "price-text";


    priceText.textContent =
        "Per Person";


    /* ==========================================
       CARD FOOTER
    ========================================== */

    const footer =
        document.createElement(
            "div"
        );


    footer.className =
        "card-footer";


    const viewButton =
        document.createElement(
            "button"
        );


    viewButton.type =
        "button";


    viewButton.className =
        "view-details";


    viewButton.textContent =
        "View Details";


    const arrow =
        document.createElement(
            "i"
        );


    arrow.className =
        "fa-solid fa-arrow-right";


    viewButton.appendChild(
        document.createTextNode(" ")
    );


    viewButton.appendChild(
        arrow
    );


    viewButton.addEventListener(
        "click",
        function () {

            viewDestination(id);

        }
    );


    footer.appendChild(
        viewButton
    );


    /* ==========================================
       BUILD CARD
    ========================================== */

    body.appendChild(
        title
    );


    body.appendChild(
        locationRow
    );


    body.appendChild(
        price
    );


    body.appendChild(
        priceText
    );


    body.appendChild(
        footer
    );


    card.appendChild(
        imageContainer
    );


    card.appendChild(
        body
    );


    return card;

}


/* =====================================================
   DESTINATION IMAGE
===================================================== */

function getDestinationImageUrl(
    image
) {

    if (!image) {

        return (
            API_BASE_URL +
            "/images/default-destination.jpg"
        );

    }


    image =
        String(image).trim();


    if (
        image.startsWith("http://") ||
        image.startsWith("https://")
    ) {

        return image;

    }


    if (image.startsWith("/")) {

        return (
            API_BASE_URL +
            image
        );

    }


    return (
        API_BASE_URL +
        "/images/" +
        encodeURIComponent(image)
    );

}


/* =====================================================
   PAGINATION
===================================================== */

function renderPagination() {

    const pagination =
        document.getElementById(
            "pagination"
        );


    if (!pagination) {

        return;

    }


    pagination.innerHTML = "";


    const totalPages =
        Math.ceil(
            filteredDestinations.length /
            cardsPerPage
        );


    if (totalPages <= 1) {

        return;

    }


    /* ==========================================
       PREVIOUS
    ========================================== */

    const previous =
        document.createElement(
            "button"
        );


    previous.type =
        "button";


    previous.innerHTML =
        `<i class="fa-solid fa-chevron-left"></i>`;


    previous.disabled =
        currentPage === 1;


    previous.setAttribute(
        "aria-label",
        "Previous page"
    );


    previous.onclick =
        function () {

            if (
                currentPage > 1
            ) {

                currentPage--;

                renderDestinations(
                    true
                );

            }

        };


    pagination.appendChild(
        previous
    );


    /* ==========================================
       PAGE NUMBERS
    ========================================== */

    for (
        let i = 1;
        i <= totalPages;
        i++
    ) {

        const button =
            document.createElement(
                "button"
            );


        button.type =
            "button";


        button.textContent =
            i;


        button.setAttribute(
            "aria-label",
            "Page " + i
        );


        if (
            i === currentPage
        ) {

            button.classList.add(
                "active"
            );

            button.setAttribute(
                "aria-current",
                "page"
            );

        }


        button.onclick =
            function () {

                currentPage =
                    i;

                renderDestinations(
                    true
                );

            };


        pagination.appendChild(
            button
        );

    }


    /* ==========================================
       NEXT
    ========================================== */

    const next =
        document.createElement(
            "button"
        );


    next.type =
        "button";


    next.innerHTML =
        `<i class="fa-solid fa-chevron-right"></i>`;


    next.disabled =
        currentPage === totalPages;


    next.setAttribute(
        "aria-label",
        "Next page"
    );


    next.onclick =
        function () {

            if (
                currentPage <
                totalPages
            ) {

                currentPage++;

                renderDestinations(
                    true
                );

            }

        };


    pagination.appendChild(
        next
    );

}


/* =====================================================
   SORT
===================================================== */

function sortDestinations() {

    const sortFilter =
        document.getElementById(
            "sortFilter"
        );


    if (!sortFilter) {

        return;

    }


    const sort =
        sortFilter.value;


    if (sort === "low") {

        filteredDestinations.sort(
            function (a, b) {

                return (
                    getBudget(a) -
                    getBudget(b)
                );

            }
        );

    }


    else if (sort === "high") {

        filteredDestinations.sort(
            function (a, b) {

                return (
                    getBudget(b) -
                    getBudget(a)
                );

            }
        );

    }


    else {

        /*
         * Popular order =
         * original backend order.
         */

        const currentIds =
            new Set(
                filteredDestinations.map(
                    function (item) {

                        return getDestinationId(
                            item
                        );

                    }
                )
            );


        filteredDestinations =
            allDestinations.filter(
                function (item) {

                    return currentIds.has(
                        getDestinationId(
                            item
                        )
                    );

                }
            );

    }


    currentPage = 1;

    renderDestinations();

}


/* =====================================================
   GLOBAL SEARCH BUTTON
===================================================== */

function searchDestination() {

    const globalSearch =
        document.getElementById(
            "globalSearch"
        );


    const destinationSearch =
        document.getElementById(
            "destinationSearch"
        );


    if (
        globalSearch &&
        destinationSearch
    ) {

        destinationSearch.value =
            globalSearch.value;

    }


    applyFilters();

}


/* =====================================================
   VIEW DETAILS
===================================================== */

function viewDestination(id) {

    if (!id) {

        console.warn(
            "Destination ID is missing."
        );

        return;

    }


    window.location.href =
        "destination-details.jsp?id=" +
        encodeURIComponent(id);

}


/* =====================================================
   SAVE DESTINATION
===================================================== */

function saveDestination(id) {

    console.log(
        "Save destination:",
        id
    );

}


/* =====================================================
   CREATE TRIP
===================================================== */

function createTrip() {

    window.location.href =
        "create-trip.jsp";

}


/* =====================================================
   LOGOUT
===================================================== */

function logoutUser() {

    localStorage.removeItem(
        "token"
    );

    localStorage.removeItem(
        "userName"
    );

    localStorage.removeItem(
        "userEmail"
    );

    localStorage.removeItem(
        "userRole"
    );

    localStorage.removeItem(
        "currentUser"
    );

    localStorage.removeItem(
        "loggedInUser"
    );

    localStorage.removeItem(
        "user"
    );


    sessionStorage.clear();


    window.location.href =
        "login.jsp";

}


/* =====================================================
   LOADING
===================================================== */

function showLoading(show) {

    /*
     * Support both IDs so the JS works with
     * either version of your JSP.
     */

    const loading =
        document.getElementById(
            "loadingMessage"
        ) ||
        document.getElementById(
            "loading"
        );


    if (loading) {

        loading.style.display =
            show
                ? "block"
                : "none";

    }

}


/* =====================================================
   FORMAT PRICE
===================================================== */

function formatPrice(price) {

    const number =
        Number(price || 0);


    if (isNaN(number)) {

        return "0";

    }


    return number.toLocaleString(
        "en-IN"
    );

}


/* =====================================================
   HTML SECURITY
===================================================== */

function escapeHtml(value) {

    return String(value || "")

        .replace(
            /&/g,
            "&amp;"
        )

        .replace(
            /</g,
            "&lt;"
        )

        .replace(
            />/g,
            "&gt;"
        )

        .replace(
            /"/g,
            "&quot;"
        )

        .replace(
            /'/g,
            "&#039;"
        );

}