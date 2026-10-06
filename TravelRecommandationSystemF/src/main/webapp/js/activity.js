/* =========================================================
   ACTIVITY MANAGEMENT
   Frontend : current deployment
   Backend  : selected by apiConfig.js
========================================================= */

const API_URL = API_CONFIG.api("/api/activities");
const DESTINATION_API_URL = API_CONFIG.api("/api/destinations");
const IMAGE_BASE_URL = API_CONFIG.BASE_URL + "/images/";

let allActivities = [];
let filteredActivities = [];
let allDestinations = [];

let currentActivityId = null;
let currentPage = 1;

const recordsPerPage = 6;


/* =========================================================
   PAGE LOAD
========================================================= */

document.addEventListener("DOMContentLoaded", function () {

    console.log("Activity page loaded");

    loadDestinations()
        .then(function () {
            return loadActivities();
        })
        .catch(function (error) {
            console.error("Initial loading error:", error);
        });

    const form = document.getElementById("activityForm");

    if (form) {
        form.addEventListener("submit", saveActivity);
    }

});


/* =========================================================
   LOAD DESTINATIONS
========================================================= */

async function loadDestinations() {

    const select = document.getElementById("destinationId");

    if (!select) {
        console.error("destinationId select not found");
        return;
    }

    try {

        console.log("Loading destinations...");

        const response = await fetch(DESTINATION_API_URL, {
            method: "GET",
            headers: {
                "Accept": "application/json"
            }
        });

        console.log(
            "Destination response status:",
            response.status
        );

        if (!response.ok) {
            throw new Error(
                "Destination API HTTP " + response.status
            );
        }

        const result = await response.json();

        console.log(
            "Destination API response:",
            result
        );


        /* =================================================
           IMPORTANT

           Backend response:

           {
               success: true,
               message: "...",
               data: [...]
           }

           So actual array is result.data
        ================================================= */

        if (Array.isArray(result)) {

            allDestinations = result;

        } else if (result && Array.isArray(result.data)) {

            allDestinations = result.data;

        } else {

            allDestinations = [];

        }


        console.log(
            "Destinations array:",
            allDestinations
        );


        /* =================================================
           Store globally for destination name
        ================================================= */

        window.activityDestinations = allDestinations;


        /* =================================================
           Clear dropdown
        ================================================= */

        select.innerHTML = "";

        const defaultOption =
            document.createElement("option");

        defaultOption.value = "";
        defaultOption.textContent =
            "Select Destination";

        select.appendChild(defaultOption);


        /* =================================================
           Add destinations
        ================================================= */

        allDestinations.forEach(function (destination) {

            if (!destination) {
                return;
            }

            const option =
                document.createElement("option");

            /*
             * Actual destination ID
             */
            option.value =
                destination.id ||
                destination.destinationId ||
                "";


            /*
             * Actual destination name
             */
            option.textContent =
                destination.destinationName ||
                destination.name ||
                "Destination";


            select.appendChild(option);

        });


        console.log(
            "Destination dropdown options:",
            select.options.length
        );


        if (allDestinations.length === 0) {

            showToast(
                "No destinations found.",
                "error"
            );

        }


    } catch (error) {

        console.error(
            "Destination Load Error:",
            error
        );

        allDestinations = [];

        window.activityDestinations = [];

        select.innerHTML = `
            <option value="">
                Unable to load destinations
            </option>
        `;

        showToast(
            "Unable to load destinations.",
            "error"
        );

    }

}


/* =========================================================
   LOAD ACTIVITIES
========================================================= */

async function loadActivities() {

    const loading =
        document.getElementById("loading");

    const grid =
        document.getElementById("activityGrid");

    const empty =
        document.getElementById("emptyState");


    if (loading) {
        loading.classList.remove("d-none");
    }

    if (grid) {
        grid.innerHTML = "";
    }

    if (empty) {
        empty.classList.add("d-none");
    }


    try {

        console.log("Loading activities...");

        const response =
            await fetch(API_URL, {
                method: "GET",
                headers: {
                    "Accept": "application/json"
                }
            });


        if (!response.ok) {

            throw new Error(
                "Activity API HTTP " +
                response.status
            );

        }


        const result =
            await response.json();


        console.log(
            "Activity API response:",
            result
        );


        /*
         * Support both:
         *
         * [...]
         *
         * and
         *
         * {
         *    success:true,
         *    data:[...]
         * }
         */

        if (Array.isArray(result)) {

            allActivities = result;

        } else if (
            result &&
            Array.isArray(result.data)
        ) {

            allActivities = result.data;

        } else {

            allActivities = [];

        }


        filteredActivities =
            [...allActivities];


        currentPage = 1;


        updateStatistics(
            allActivities
        );


        renderCurrentPage();


    } catch (error) {

        console.error(
            "Load Activity Error:",
            error
        );


        if (empty) {
            empty.classList.remove("d-none");
        }


        showToast(
            "Unable to load activity data.",
            "error"
        );


    } finally {

        if (loading) {
            loading.classList.add("d-none");
        }

    }

}


/* =========================================================
   RENDER CURRENT PAGE
========================================================= */

function renderCurrentPage() {

    const grid =
        document.getElementById("activityGrid");

    const empty =
        document.getElementById("emptyState");


    if (!grid) {
        return;
    }


    grid.innerHTML = "";


    if (
        !filteredActivities ||
        filteredActivities.length === 0
    ) {

        if (empty) {
            empty.classList.remove("d-none");
        }

        renderPagination(0);

        return;

    }


    if (empty) {
        empty.classList.add("d-none");
    }


    const totalPages =
        Math.ceil(
            filteredActivities.length /
            recordsPerPage
        );


    if (currentPage > totalPages) {
        currentPage = totalPages;
    }


    const start =
        (currentPage - 1) *
        recordsPerPage;


    const end =
        start +
        recordsPerPage;


    const pageData =
        filteredActivities.slice(
            start,
            end
        );


    pageData.forEach(function (activity) {

        grid.appendChild(
            createActivityCard(activity)
        );

    });


    renderPagination(
        filteredActivities.length
    );

}


/* =========================================================
   CREATE ACTIVITY CARD
========================================================= */

function createActivityCard(activity) {

    const card =
        document.createElement("div");

    card.className =
        "activity-card";


    const status =
        activity.status
            ? String(activity.status).toUpperCase()
            : "ACTIVE";


    const statusClass =
        status === "ACTIVE"
            ? "status-active"
            : "status-inactive";


    const activityName =
        escapeHTML(
            activity.activityName ||
            "Activity"
        );


    const activityType =
        escapeHTML(
            activity.activityType ||
            "Activity"
        );


    const location =
        escapeHTML(
            activity.location ||
            "Not specified"
        );


    const description =
        escapeHTML(
            activity.description ||
            "No description available."
        );


    const price =
        formatCurrency(
            activity.price || 0
        );


    const duration =
        escapeHTML(
            activity.duration ||
            "Not specified"
        );


    const destination =
        getDestinationName(
            activity.destinationId
        );


    const imageHTML =
        createImageHTML(activity);


    const activityId =
        activity.activityId ||
        activity.id;


    card.innerHTML = `

        <div class="activity-image">

            ${imageHTML}

            <span class="status-badge ${statusClass}">

                <i class="bi bi-circle-fill"></i>

                ${escapeHTML(status)}

            </span>

        </div>


        <div class="activity-card-body">


            <div class="activity-type">

                <i class="${getActivityIcon(
                    activity.activityType
                )}"></i>

                ${activityType}

            </div>


            <h3 class="activity-title">

                ${activityName}

            </h3>


            <div class="activity-location">

                <i class="bi bi-geo-alt-fill"></i>

                ${location}

            </div>


            <div class="destination-name">

                <i class="bi bi-map-fill"></i>

                <span>
                    ${escapeHTML(destination)}
                </span>

            </div>


            <div class="activity-description-label">
                Description
            </div>

            <div class="activity-description"
                 title="${description}">

                ${description}

            </div>


            <div class="price-row">

                <div>

                    <div class="price-label">
                        Activity Price
                    </div>

                    <div class="price-value">
                        ${price}
                    </div>

                </div>


                <div class="duration-value">

                    <i class="bi bi-clock"></i>

                    ${duration}

                </div>

            </div>


            <div class="card-actions">


                <button
                    type="button"
                    class="card-action view-action"
                    onclick="viewActivity(${activityId})">

                    <i class="bi bi-eye-fill"></i>

                    View

                </button>


                <button
                    type="button"
                    class="card-action edit-action"
                    onclick="editActivity(${activityId})">

                    <i class="bi bi-pencil-fill"></i>

                    Edit

                </button>


                <button
                    type="button"
                    class="card-action delete-action"
                    onclick="openDeleteModal(${activityId})">

                    <i class="bi bi-trash3-fill"></i>

                    Delete

                </button>


            </div>

        </div>

    `;


    return card;

}


/* =========================================================
   IMAGE URL
========================================================= */

function getImageURL(image) {

    if (!image) {
        return "";
    }


    let fileName =
        String(image).trim();


    if (!fileName) {
        return "";
    }


    /*
     * If backend already returns full URL
     */

    if (
        fileName.startsWith("http://") ||
        fileName.startsWith("https://")
    ) {

        return fileName;

    }


    /*
     * If database contains:
     *
     * /images/file.jpg
     */

    if (
        fileName.startsWith("/images/")
    ) {

        return (
            API_CONFIG.BASE_URL +
            fileName
        );

    }


    /*
     * If database contains:
     *
     * images/file.jpg
     */

    if (
        fileName.startsWith("images/")
    ) {

        return (
            API_CONFIG.BASE_URL +
            "/" +
            fileName
        );

    }


    /*
     * Normal case:
     *
     * Welcome.png
     *
     * becomes:
     *
     * selected backend/images/Welcome.png
     */

    return (
        IMAGE_BASE_URL +
        encodeURIComponent(fileName)
    );

}


/* =========================================================
   CREATE IMAGE HTML
========================================================= */

function createImageHTML(activity) {

    if (
        !activity.image ||
        String(activity.image).trim() === ""
    ) {

        return `

            <div class="image-placeholder">

                <i class="${getActivityIcon(
                    activity.activityType
                )}"></i>

                <span>
                    No Image
                </span>

            </div>

        `;

    }


    const imageURL =
        getImageURL(activity.image);


    return `

        <img
            src="${escapeHTML(imageURL)}"
            alt="Activity Image"
            onerror="handleImageError(this)"
        >

        <div
            class="image-placeholder"
            style="display:none;">

            <i class="${getActivityIcon(
                activity.activityType
            )}"></i>

            <span>
                Image unavailable
            </span>

        </div>

    `;

}


/* =========================================================
   IMAGE ERROR
========================================================= */

function handleImageError(image) {

    console.error(
        "Image failed:",
        image.src
    );


    image.style.display = "none";


    const placeholder =
        image.nextElementSibling;


    if (placeholder) {
        placeholder.style.display = "flex";
    }

}


/* =========================================================
   ACTIVITY ICON
========================================================= */

function getActivityIcon(type) {

    if (!type) {
        return "bi bi-stars";
    }


    const value =
        String(type).toLowerCase();


    if (value.includes("water")) {
        return "bi bi-water";
    }


    if (
        value.includes("trek") ||
        value.includes("adventure")
    ) {
        return "bi bi-person-hiking";
    }


    if (value.includes("wildlife")) {
        return "bi bi-tree";
    }


    if (value.includes("cultural")) {
        return "bi bi-bank";
    }


    if (value.includes("sight")) {
        return "bi bi-binoculars";
    }


    if (value.includes("shopping")) {
        return "bi bi-bag";
    }


    if (value.includes("entertainment")) {
        return "bi bi-controller";
    }


    return "bi bi-stars";

}


/* =========================================================
   DESTINATION NAME
========================================================= */

function getDestinationName(destinationId) {

    if (
        destinationId === null ||
        destinationId === undefined ||
        destinationId === ""
    ) {

        return "Destination not specified";

    }


    const destination =
        allDestinations.find(
            function (item) {

                const id =
                    item.id ||
                    item.destinationId;

                return String(id) ===
                    String(destinationId);

            }
        );


    if (destination) {

        return (
            destination.destinationName ||
            destination.name ||
            "Destination"
        );

    }


    return "Destination #" +
        destinationId;

}


/* =========================================================
   STATISTICS
========================================================= */

function updateStatistics(activities) {

    const total =
        activities.length;


    const active =
        activities.filter(
            function (item) {

                return (
                    String(
                        item.status || ""
                    ).toUpperCase() ===
                    "ACTIVE"
                );

            }
        ).length;


    const inactive =
        total - active;


    const destinations =
        new Set(
            activities
                .map(function (item) {
                    return item.destinationId;
                })
                .filter(function (id) {
                    return id !== null &&
                           id !== undefined &&
                           id !== "";
                })
        ).size;


    const totalElement =
        document.getElementById(
            "totalActivity"
        );


    const activeElement =
        document.getElementById(
            "activeActivity"
        );


    const inactiveElement =
        document.getElementById(
            "inactiveActivity"
        );


    const destinationElement =
        document.getElementById(
            "totalDestinations"
        );


    if (totalElement) {
        totalElement.textContent = total;
    }


    if (activeElement) {
        activeElement.textContent = active;
    }


    if (inactiveElement) {
        inactiveElement.textContent = inactive;
    }


    if (destinationElement) {
        destinationElement.textContent =
            destinations;
    }

}


/* =========================================================
   SEARCH
========================================================= */

function searchActivity() {

    currentPage = 1;

    applyFilters();

}


/* =========================================================
   FILTER
========================================================= */

function filterActivity() {

    currentPage = 1;

    applyFilters();

}


/* =========================================================
   APPLY FILTERS
========================================================= */

function applyFilters() {

    const searchElement =
        document.getElementById(
            "searchInput"
        );


    const statusElement =
        document.getElementById(
            "statusFilter"
        );


    const typeElement =
        document.getElementById(
            "typeFilter"
        );


    const search =
        searchElement
            ? searchElement.value
                .toLowerCase()
                .trim()
            : "";


    const status =
        statusElement
            ? statusElement.value
                .toUpperCase()
            : "";


    const type =
        typeElement
            ? typeElement.value
                .toLowerCase()
            : "";


    filteredActivities =
        allActivities.filter(
            function (activity) {

                const text = (

                    (activity.activityName || "") +
                    " " +
                    (activity.activityType || "") +
                    " " +
                    (activity.location || "") +
                    " " +
                    (activity.description || "") +
                    " " +
                    getDestinationName(
                        activity.destinationId
                    )

                ).toLowerCase();


                const matchesSearch =
                    !search ||
                    text.includes(search);


                const matchesStatus =
                    !status ||
                    String(
                        activity.status || ""
                    ).toUpperCase() ===
                    status;


                const matchesType =
                    !type ||
                    String(
                        activity.activityType || ""
                    ).toLowerCase() ===
                    type;


                return (
                    matchesSearch &&
                    matchesStatus &&
                    matchesType
                );

            }
        );


    renderCurrentPage();

}


/* =========================================================
   RESET FILTERS
========================================================= */

function resetFilters() {

    const search =
        document.getElementById(
            "searchInput"
        );


    const status =
        document.getElementById(
            "statusFilter"
        );


    const type =
        document.getElementById(
            "typeFilter"
        );


    if (search) {
        search.value = "";
    }


    if (status) {
        status.value = "";
    }


    if (type) {
        type.value = "";
    }


    filteredActivities =
        [...allActivities];


    currentPage = 1;


    renderCurrentPage();


    showToast(
        "Filters have been reset.",
        "success"
    );

}


/* =========================================================
   PAGINATION
========================================================= */

function renderPagination(totalRecords) {

    const container =
        document.getElementById(
            "paginationContainer"
        );


    if (!container) {
        return;
    }


    container.innerHTML = "";


    if (
        totalRecords <=
        recordsPerPage
    ) {

        return;

    }


    const totalPages =
        Math.ceil(
            totalRecords /
            recordsPerPage
        );


    const wrapper =
        document.createElement("div");


    wrapper.className =
        "pagination-wrapper";


    /* Previous */

    const previous =
        document.createElement("button");


    previous.className =
        "pagination-btn";


    previous.innerHTML =
        `<i class="bi bi-chevron-left"></i>`;


    previous.disabled =
        currentPage === 1;


    previous.onclick =
        function () {

            if (currentPage > 1) {

                currentPage--;

                renderCurrentPage();

            }

        };


    wrapper.appendChild(
        previous
    );


    /* Pages */

    for (
        let page = 1;
        page <= totalPages;
        page++
    ) {

        const button =
            document.createElement("button");


        button.className =
            "pagination-btn";


        if (page === currentPage) {

            button.classList.add(
                "active"
            );

        }


        button.textContent =
            page;


        button.onclick =
            function () {

                currentPage =
                    page;

                renderCurrentPage();

            };


        wrapper.appendChild(
            button
        );

    }


    /* Next */

    const next =
        document.createElement("button");


    next.className =
        "pagination-btn";


    next.innerHTML =
        `<i class="bi bi-chevron-right"></i>`;


    next.disabled =
        currentPage === totalPages;


    next.onclick =
        function () {

            if (
                currentPage <
                totalPages
            ) {

                currentPage++;

                renderCurrentPage();

            }

        };


    wrapper.appendChild(
        next
    );


    container.appendChild(
        wrapper
    );

}


/* =========================================================
   OPEN ADD MODAL
========================================================= */

function openAddModal() {

    currentActivityId = null;


    const form =
        document.getElementById(
            "activityForm"
        );


    if (form) {
        form.reset();
    }


    document.getElementById(
        "modalTitle"
    ).textContent =
        "Add Activity";


    document.getElementById(
        "saveButtonText"
    ).textContent =
        "Save Activity";


    document.getElementById(
        "activityId"
    ).value = "";


    document.getElementById(
        "status"
    ).value =
        "ACTIVE";


    resetImagePreview();


    /*
     * Make sure destination dropdown
     * is populated.
     */

    populateDestinationDropdown();


    const modal =
        new bootstrap.Modal(
            document.getElementById(
                "activityModal"
            )
        );


    modal.show();

}


/* =========================================================
   POPULATE DESTINATION DROPDOWN
========================================================= */

function populateDestinationDropdown() {

    const select =
        document.getElementById(
            "destinationId"
        );


    if (!select) {
        return;
    }


    if (
        !allDestinations ||
        allDestinations.length === 0
    ) {

        console.warn(
            "No destinations available."
        );

        return;

    }


    select.innerHTML = `
        <option value="">
            Select Destination
        </option>
    `;


    allDestinations.forEach(
        function (destination) {

            const option =
                document.createElement(
                    "option"
                );


            option.value =
                destination.id ||
                destination.destinationId;


            option.textContent =
                destination.destinationName ||
                destination.name ||
                "Destination";


            select.appendChild(
                option
            );

        }
    );

}


/* =========================================================
   IMAGE PREVIEW
========================================================= */

function previewImage(event) {

    const file =
        event.target.files[0];


    if (!file) {

        resetImagePreview();

        return;

    }


    if (
        !file.type.startsWith("image/")
    ) {

        showToast(
            "Please select a valid image.",
            "error"
        );


        event.target.value = "";


        resetImagePreview();


        return;

    }


    if (
        file.size >
        10 * 1024 * 1024
    ) {

        showToast(
            "Image size must be less than 10MB.",
            "error"
        );


        event.target.value = "";


        resetImagePreview();


        return;

    }


    const reader =
        new FileReader();


    reader.onload =
        function (e) {

            const preview =
                document.getElementById(
                    "imagePreview"
                );


            if (preview) {

                preview.innerHTML = `

                    <img
                        src="${e.target.result}"
                        alt="Preview">

                `;

            }

        };


    reader.readAsDataURL(file);

}


/* =========================================================
   RESET IMAGE PREVIEW
========================================================= */

function resetImagePreview() {

    const preview =
        document.getElementById(
            "imagePreview"
        );


    if (preview) {

        preview.innerHTML = `

            <i class="bi bi-image"></i>

            <span>
                Image Preview
            </span>

        `;

    }

}


/* =========================================================
   SAVE ACTIVITY
========================================================= */

async function saveActivity(event) {

    event.preventDefault();


    const id =
        document.getElementById(
            "activityId"
        ).value;


    const isEdit =
        id &&
        id.trim() !== "";


    const form =
        document.getElementById(
            "activityForm"
        );


    if (!form) {

        showToast(
            "Activity form not found.",
            "error"
        );

        return;

    }


    const destinationSelect =
        document.getElementById(
            "destinationId"
        );


    const destinationId =
        destinationSelect
            ? destinationSelect.value
            : "";


    /* =====================================================
       IMPORTANT VALIDATION
    ===================================================== */

    if (
        !destinationId ||
        destinationId.trim() === ""
    ) {

        showToast(
            "Please select a destination.",
            "error"
        );

        return;

    }


    const formData =
        new FormData(form);


    /*
     * Make absolutely sure destinationId
     * is present.
     */

    formData.set(
        "destinationId",
        destinationId
    );


    console.log(
        "========== ACTIVITY FORM DATA =========="
    );


    for (
        const [key, value]
        of formData.entries()
    ) {

        if (value instanceof File) {

            console.log(
                key,
                value.name,
                value.size
            );

        } else {

            console.log(
                key,
                value
            );

        }

    }


    console.log(
        "========================================"
    );


    const url =
        isEdit
            ? `${API_URL}/${id}`
            : API_URL;


    const method =
        isEdit
            ? "PUT"
            : "POST";


    const saveButton =
        document.querySelector(
            ".save-btn"
        );


    const saveText =
        document.getElementById(
            "saveButtonText"
        );


    const originalText =
        saveText
            ? saveText.textContent
            : "Save Activity";


    if (saveButton) {
        saveButton.disabled = true;
    }


    if (saveText) {
        saveText.textContent =
            "Saving...";
    }


    try {

        const response =
            await fetch(
                url,
                {
                    method: method,
                    body: formData
                }
            );


        const responseText =
            await response.text();


        console.log(
            "Save response:",
            response.status,
            responseText
        );


        if (!response.ok) {

            throw new Error(
                responseText ||
                "Unable to save activity."
            );

        }


        showToast(
            isEdit
                ? "Activity updated successfully."
                : "Activity added successfully.",
            "success"
        );


        const modalElement =
            document.getElementById(
                "activityModal"
            );


        const modal =
            bootstrap.Modal.getInstance(
                modalElement
            );


        if (modal) {
            modal.hide();
        }


        await loadActivities();


    } catch (error) {

        console.error(
            "Activity Save Error:",
            error
        );


        showToast(
            error.message ||
            "Unable to save activity.",
            "error"
        );


    } finally {

        if (saveButton) {
            saveButton.disabled = false;
        }


        if (saveText) {
            saveText.textContent =
                originalText;
        }

    }

}


/* =========================================================
   VIEW ACTIVITY
========================================================= */

async function viewActivity(id) {

    try {

        const response =
            await fetch(
                `${API_URL}/${id}`
            );


        if (!response.ok) {

            throw new Error(
                "Unable to fetch activity."
            );

        }


        const result =
            await response.json();


        const activity =
            result &&
            result.data
                ? result.data
                : result;


        displayActivityDetails(
            activity
        );


        const modal =
            new bootstrap.Modal(
                document.getElementById(
                    "viewActivityModal"
                )
            );


        modal.show();


    } catch (error) {

        console.error(
            "View Activity Error:",
            error
        );


        showToast(
            "Unable to load activity details.",
            "error"
        );

    }

}


/* =========================================================
   DISPLAY ACTIVITY DETAILS
========================================================= */

function displayActivityDetails(activity) {

    const container =
        document.getElementById(
            "viewActivityContent"
        );


    if (!container) {
        return;
    }


    const status =
        activity.status ||
        "ACTIVE";


    let imageHTML = `

        <div class="view-image-panel">

            <div class="view-image-placeholder">

                <i class="${getActivityIcon(
                    activity.activityType
                )}"></i>

                <span>
                    No Image Available
                </span>

            </div>

        </div>

    `;


    if (
        activity.image &&
        String(activity.image).trim() !== ""
    ) {

        const imageURL =
            getImageURL(activity.image);


        imageHTML = `

            <div class="view-image-panel">

                <img
                    src="${escapeHTML(imageURL)}"
                    alt="Activity Image"
                    onerror="handleImageError(this)"
                >


                <div
                    class="view-image-placeholder"
                    style="display:none;">

                    <i class="${getActivityIcon(
                        activity.activityType
                    )}"></i>

                    <span>
                        Image unavailable
                    </span>

                </div>


                <div class="view-image-overlay">

                    <span>
                        ${escapeHTML(
                            activity.activityType ||
                            "Activity"
                        )}
                    </span>

                </div>

            </div>

        `;

    }


    container.innerHTML = `

        <div class="professional-view">

            ${imageHTML}


            <div class="view-details-panel">


                <div class="view-heading">

                    <div>

                        <span class="view-kicker">
                            ACTIVITY DETAILS
                        </span>

                        <h3>
                            ${escapeHTML(
                                activity.activityName ||
                                "Activity"
                            )}
                        </h3>

                    </div>


                    <span class="
                        view-status
                        ${
                            String(status).toUpperCase()
                            === "ACTIVE"
                                ? "active"
                                : "inactive"
                        }
                    ">

                        <i class="bi bi-circle-fill"></i>

                        ${escapeHTML(status)}

                    </span>

                </div>


                <div class="view-info-grid">


                    <div class="detail-box">

                        <div class="detail-icon purple">

                            <i class="${getActivityIcon(
                                activity.activityType
                            )}"></i>

                        </div>


                        <div>

                            <span class="detail-label">
                                Activity Type
                            </span>

                            <div class="detail-value">

                                ${escapeHTML(
                                    activity.activityType ||
                                    "Not specified"
                                )}

                            </div>

                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-icon blue">

                            <i class="bi bi-geo-alt-fill"></i>

                        </div>


                        <div>

                            <span class="detail-label">
                                Location
                            </span>

                            <div class="detail-value">

                                ${escapeHTML(
                                    activity.location ||
                                    "Not specified"
                                )}

                            </div>

                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-icon green">

                            <i class="bi bi-cash-stack"></i>

                        </div>


                        <div>

                            <span class="detail-label">
                                Price
                            </span>

                            <div class="detail-value">

                                ${formatCurrency(
                                    activity.price || 0
                                )}

                            </div>

                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-icon orange">

                            <i class="bi bi-clock"></i>

                        </div>


                        <div>

                            <span class="detail-label">
                                Duration
                            </span>

                            <div class="detail-value">

                                ${escapeHTML(
                                    activity.duration ||
                                    "Not specified"
                                )}

                            </div>

                        </div>

                    </div>


                    <div class="detail-box full">

                        <div class="detail-icon purple">

                            <i class="bi bi-map"></i>

                        </div>


                        <div>

                            <span class="detail-label">
                                Destination
                            </span>

                            <div class="detail-value">

                                ${escapeHTML(
                                    getDestinationName(
                                        activity.destinationId
                                    )
                                )}

                            </div>

                        </div>

                    </div>


                    <div class="detail-box full">

                        <div class="detail-icon blue">

                            <i class="bi bi-card-text"></i>

                        </div>


                        <div>

                            <span class="detail-label">
                                Description
                            </span>

                            <div class="detail-value">

                                ${escapeHTML(
                                    activity.description ||
                                    "No description available."
                                )}

                            </div>

                        </div>

                    </div>


                    <div class="detail-box full">

                        <div class="detail-icon purple">

                            <i class="bi bi-image"></i>

                        </div>


                        <div>

                            <span class="detail-label">
                                Image File
                            </span>

                            <div class="detail-value">

                                ${escapeHTML(
                                    activity.image ||
                                    "No image"
                                )}

                            </div>

                        </div>

                    </div>


                </div>


                <div class="view-id">

                    <span>
                        Activity ID
                    </span>

                    <strong>
                        #${
                            activity.activityId ||
                            activity.id ||
                            ""
                        }
                    </strong>

                </div>


            </div>

        </div>

    `;

}


/* =========================================================
   EDIT ACTIVITY
========================================================= */

async function editActivity(id) {

    try {

        /*
         * Make sure destinations are loaded
         */

        if (
            !allDestinations ||
            allDestinations.length === 0
        ) {

            await loadDestinations();

        }


        const response =
            await fetch(
                `${API_URL}/${id}`
            );


        if (!response.ok) {

            throw new Error(
                "Unable to fetch activity."
            );

        }


        const result =
            await response.json();


        console.log(
            "Edit activity response:",
            result
        );


        const activity =
            result &&
            result.data
                ? result.data
                : result;


        console.log(
            "Activity for edit:",
            activity
        );


        currentActivityId =
            activity.activityId ||
            activity.id ||
            id;


        document.getElementById(
            "modalTitle"
        ).textContent =
            "Edit Activity";


        document.getElementById(
            "saveButtonText"
        ).textContent =
            "Update Activity";


        document.getElementById(
            "activityId"
        ).value =
            activity.activityId ||
            activity.id ||
            id;


        /*
         * Populate dropdown BEFORE
         * setting selected value.
         */

        populateDestinationDropdown();


        /*
         * IMPORTANT
         *
         * activity.destinationId
         * must match destination.id
         */

        const destinationSelect =
            document.getElementById(
                "destinationId"
            );


        if (destinationSelect) {

            destinationSelect.value =
                String(
                    activity.destinationId || ""
                );


            console.log(
                "Selected destination:",
                destinationSelect.value
            );

        }


        document.getElementById(
            "activityName"
        ).value =
            activity.activityName || "";


        document.getElementById(
            "activityType"
        ).value =
            activity.activityType || "";


        document.getElementById(
            "location"
        ).value =
            activity.location || "";


        document.getElementById(
            "price"
        ).value =
            activity.price ??
            "";


        document.getElementById(
            "duration"
        ).value =
            activity.duration || "";


        document.getElementById(
            "description"
        ).value =
            activity.description || "";


        document.getElementById(
            "status"
        ).value =
            activity.status ||
            "ACTIVE";


        /*
         * Existing image
         */

        if (
            activity.image &&
            String(activity.image).trim() !== ""
        ) {

            const imageURL =
                getImageURL(
                    activity.image
                );


            document.getElementById(
                "imagePreview"
            ).innerHTML = `

                <img
                    src="${escapeHTML(imageURL)}"
                    alt="Current Image"
                    onerror="handleImageError(this)"
                >

                <div
                    class="image-placeholder"
                    style="display:none;">

                    <i class="bi bi-image"></i>

                    <span>
                        Image unavailable
                    </span>

                </div>

            `;

        } else {

            resetImagePreview();

        }


        const modal =
            new bootstrap.Modal(
                document.getElementById(
                    "activityModal"
                )
            );


        modal.show();


    } catch (error) {

        console.error(
            "Edit Activity Error:",
            error
        );


        showToast(
            "Unable to load activity for editing.",
            "error"
        );

    }

}


/* =========================================================
   DELETE MODAL
========================================================= */

function openDeleteModal(id) {

    document.getElementById(
        "deleteActivityId"
    ).value =
        id;


    const modal =
        new bootstrap.Modal(
            document.getElementById(
                "deleteModal"
            )
        );


    modal.show();

}


/* =========================================================
   DELETE
========================================================= */

async function confirmDelete() {

    const id =
        document.getElementById(
            "deleteActivityId"
        ).value;


    if (!id) {
        return;
    }


    try {

        const response =
            await fetch(
                `${API_URL}/${id}`,
                {
                    method: "DELETE"
                }
            );


        const responseText =
            await response.text();


        console.log(
            "Delete response:",
            response.status,
            responseText
        );


        if (!response.ok) {

            throw new Error(
                responseText ||
                "Unable to delete activity."
            );

        }


        const modalElement =
            document.getElementById(
                "deleteModal"
            );


        const modal =
            bootstrap.Modal.getInstance(
                modalElement
            );


        if (modal) {
            modal.hide();
        }


        showToast(
            "Activity deleted successfully.",
            "success"
        );


        await loadActivities();


    } catch (error) {

        console.error(
            "Delete Activity Error:",
            error
        );


        showToast(
            error.message ||
            "Unable to delete activity.",
            "error"
        );

    }

}


/* =========================================================
   CURRENCY
========================================================= */

function formatCurrency(value) {

    const number =
        Number(value);


    if (isNaN(number)) {
        return "₹0";
    }


    return new Intl.NumberFormat(
        "en-IN",
        {
            style: "currency",
            currency: "INR",
            maximumFractionDigits: 2
        }
    ).format(number);

}


/* =========================================================
   ESCAPE HTML
========================================================= */

function escapeHTML(value) {

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


/* =========================================================
   TOAST
========================================================= */

function showToast(
    message,
    type = "success"
) {

    const container =
        document.getElementById(
            "toastContainer"
        );


    if (!container) {
        return;
    }


    const toast =
        document.createElement(
            "div"
        );


    toast.className =
        `activity-toast ${type}`;


    const icon =
        type === "success"
            ? "bi-check-circle-fill"
            : "bi-exclamation-circle-fill";


    toast.innerHTML = `

        <div class="toast-content">

            <div class="toast-icon">

                <i class="bi ${icon}"></i>

            </div>

            <span>
                ${escapeHTML(message)}
            </span>

        </div>

    `;


    container.appendChild(
        toast
    );


    setTimeout(
        function () {

            toast.style.opacity =
                "0";


            setTimeout(
                function () {

                    toast.remove();

                },
                300
            );

        },
        3000
    );

}