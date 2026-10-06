"use strict";

/* =========================================================
   ADMIN DESTINATION MANAGEMENT
   ========================================================= */

const API_BASE_URL =
    API_CONFIG.api("/api/destinations");


/* =========================================================
   GLOBAL VARIABLES
   ========================================================= */

let destinations = [];
let currentDestinationId = null;
let deleteDestinationId = null;
let destinationModal = null;
let viewDestinationModal = null;
let deleteModal = null;


/* =========================================================
   PAGINATION VARIABLES
   ========================================================= */

let currentPage = 1;
const itemsPerPage = 6;


/* =========================================================
   DOCUMENT READY
   ========================================================= */

document.addEventListener("DOMContentLoaded", function () {

    console.log("=================================");
    console.log("Admin Destination JS Loaded");
    console.log("API:", API_BASE_URL);
    console.log("=================================");

    initializeModals();
    initializeEventListeners();
    loadDestinations();

});


/* =========================================================
   INITIALIZE BOOTSTRAP MODALS
   ========================================================= */

function initializeModals() {

    /* -----------------------------------------------------
       ADD / EDIT MODAL
       ----------------------------------------------------- */

    const formModalElement =
        document.getElementById(
            "destinationFormModal"
        );

    if (
        formModalElement &&
        typeof bootstrap !== "undefined"
    ) {

        destinationModal =
            bootstrap.Modal.getOrCreateInstance(
                formModalElement
            );

    } else {

        console.error(
            "destinationFormModal not found or Bootstrap not loaded."
        );

    }


    /* -----------------------------------------------------
       VIEW MODAL
       ----------------------------------------------------- */

    const viewModalElement =
        document.getElementById(
            "viewDestinationModal"
        );

    if (
        viewModalElement &&
        typeof bootstrap !== "undefined"
    ) {

        viewDestinationModal =
            bootstrap.Modal.getOrCreateInstance(
                viewModalElement
            );

    } else {

        console.error(
            "viewDestinationModal not found or Bootstrap not loaded."
        );

    }


    /* -----------------------------------------------------
       DELETE MODAL
       ----------------------------------------------------- */

    const deleteModalElement =
        document.getElementById(
            "deleteDestinationModal"
        );

    if (
        deleteModalElement &&
        typeof bootstrap !== "undefined"
    ) {

        deleteModal =
            bootstrap.Modal.getOrCreateInstance(
                deleteModalElement
            );

    } else {

        console.error(
            "deleteDestinationModal not found or Bootstrap not loaded."
        );

    }

}


/* =========================================================
   EVENT LISTENERS
   ========================================================= */

function initializeEventListeners() {

    /* -----------------------------------------------------
       SEARCH
       ----------------------------------------------------- */

    const searchInput =
        document.getElementById(
            "searchInput"
        );

    if (searchInput) {

        searchInput.addEventListener(
            "input",
            debounce(function () {

                currentPage = 1;
                loadDestinations();

            }, 300)
        );

    }


    /* -----------------------------------------------------
       COUNTRY FILTER
       ----------------------------------------------------- */

    const countryFilter =
        document.getElementById(
            "countryFilter"
        );

    if (countryFilter) {

        countryFilter.addEventListener(
            "change",
            function () {

                currentPage = 1;
                loadDestinations();

            }
        );

    }


    /* -----------------------------------------------------
       STATUS FILTER
       ----------------------------------------------------- */

    const statusFilter =
        document.getElementById(
            "statusFilter"
        );

    if (statusFilter) {

        statusFilter.addEventListener(
            "change",
            function () {

                currentPage = 1;
                loadDestinations();

            }
        );

    }


    /* -----------------------------------------------------
       DELETE CONFIRM BUTTON
       ----------------------------------------------------- */

    const deleteButton =
        document.getElementById(
            "confirmDeleteDestinationBtn"
        );

    if (deleteButton) {

        deleteButton.addEventListener(
            "click",
            function () {

                confirmDeleteDestination();

            }
        );

    }

}


/* =========================================================
   LOAD ALL DESTINATIONS
   ========================================================= */

async function loadDestinations() {

    const container =
        document.getElementById(
            "destinationsGrid"
        );

    try {

        if (container) {

            container.innerHTML = `

                <div class="col-12 text-center py-5">

                    <div class="spinner-border text-primary"
                         role="status">

                    </div>

                    <p class="text-muted mt-3">

                        Loading destinations...

                    </p>

                </div>

            `;

        }


        /* -------------------------------------------------
           FILTER VALUES
           ------------------------------------------------- */

        const searchInput =
            document.getElementById(
                "searchInput"
            );

        const countryFilter =
            document.getElementById(
                "countryFilter"
            );

        const statusFilter =
            document.getElementById(
                "statusFilter"
            );


        const search =
            searchInput
                ? searchInput.value.trim()
                : "";


        const country =
            countryFilter
                ? countryFilter.value
                : "";


        const status =
            statusFilter
                ? statusFilter.value
                : "";


        /* -------------------------------------------------
           BUILD URL
           ------------------------------------------------- */

        const params =
            new URLSearchParams();


        if (search) {

            params.append(
                "search",
                search
            );

        }


        if (country) {

            params.append(
                "country",
                country
            );

        }


        if (status) {

            params.append(
                "status",
                status
            );

        }


        let url =
            API_BASE_URL;


        const query =
            params.toString();


        if (query) {

            url += "?" + query;

        }


        console.log(
            "Loading destinations from:",
            url
        );


        /* -------------------------------------------------
           API REQUEST
           ------------------------------------------------- */

        const response =
            await fetch(
                url,
                {
                    method: "GET",

                    headers: {

                        "Accept":
                            "application/json"

                    },

                    credentials: "include"

                }
            );


        console.log(
            "Destination API status:",
            response.status
        );


        if (!response.ok) {

            const errorText =
                await response.text();


            console.error(
                "Destination API error:",
                errorText
            );


            throw new Error(
                "Failed to load destinations. HTTP " +
                response.status
            );

        }


        const result =
            await response.json();


        console.log(
            "Destination API response:",
            result
        );


        /* -------------------------------------------------
           READ API RESPONSE
           ------------------------------------------------- */

        if (
            result &&
            Array.isArray(result.data)
        ) {

            destinations =
                result.data;

        }

        else if (
            Array.isArray(result)
        ) {

            destinations =
                result;

        }

        else {

            destinations = [];

        }


        console.log(
            "Destinations loaded:",
            destinations.length
        );


        /*
         * If current page is greater than
         * available pages after delete/filter,
         * automatically move to last page.
         */

        const totalPages =
            Math.ceil(
                destinations.length /
                itemsPerPage
            );


        if (
            totalPages > 0 &&
            currentPage > totalPages
        ) {

            currentPage =
                totalPages;

        }


        if (totalPages === 0) {

            currentPage = 1;

        }


        renderDestinations();


    } catch (error) {

        console.error(
            "Error loading destinations:",
            error
        );


        destinations = [];


        if (container) {

            container.innerHTML = `

                <div class="col-12">

                    <div class="empty-destination-state">

                        <div class="empty-icon">

                            <i class="fas fa-triangle-exclamation"></i>

                        </div>

                        <h5>

                            Failed to load destinations

                        </h5>

                        <p class="text-muted mb-3">

                            ${escapeHtml(error.message)}

                        </p>

                        <button
                            type="button"
                            class="btn btn-primary"
                            onclick="loadDestinations()">

                            <i class="fas fa-rotate-right me-2"></i>

                            Try Again

                        </button>

                    </div>

                </div>

            `;

        }


        updatePaginationInfo(
            0,
            0,
            0
        );


        renderPagination(0);


        showToast(
            error.message ||
            "Failed to load destinations.",
            "danger"
        );

    }

}


/* =========================================================
   RENDER DESTINATIONS
   ========================================================= */

function renderDestinations() {

    const container =
        document.getElementById(
            "destinationsGrid"
        );


    if (!container) {

        console.error(
            "ERROR: #destinationsGrid not found."
        );

        return;

    }


    container.innerHTML = "";


    /* -----------------------------------------------------
       EMPTY STATE
       ----------------------------------------------------- */

    if (
        !destinations ||
        destinations.length === 0
    ) {

        container.innerHTML = `

            <div class="col-12">

                <div class="empty-destination-state">

                    <div class="empty-icon">

                        <i class="fas fa-map-location-dot"></i>

                    </div>

                    <h5>

                        No destinations found

                    </h5>

                    <p class="text-muted">

                        Add a destination or change your filters.

                    </p>

                </div>

            </div>

        `;


        updatePaginationInfo(
            0,
            0,
            0
        );


        renderPagination(0);


        return;

    }


    /* =====================================================
       PAGINATION CALCULATION
       ===================================================== */

    const totalDestinations =
        destinations.length;


    const totalPages =
        Math.ceil(
            totalDestinations /
            itemsPerPage
        );


    /* -----------------------------------------------------
       VALIDATE CURRENT PAGE
       ----------------------------------------------------- */

    if (currentPage < 1) {

        currentPage = 1;

    }


    if (currentPage > totalPages) {

        currentPage =
            totalPages;

    }


    /* -----------------------------------------------------
       CALCULATE START / END
       ----------------------------------------------------- */

    const startIndex =
        (currentPage - 1) *
        itemsPerPage;


    const endIndex =
        Math.min(
            startIndex + itemsPerPage,
            totalDestinations
        );


    /* -----------------------------------------------------
       GET ONLY CURRENT PAGE DATA
       ----------------------------------------------------- */

    const currentDestinations =
        destinations.slice(
            startIndex,
            endIndex
        );


    /* =====================================================
       CREATE CARDS
       
       IMPORTANT:
       ORIGINAL CARD FUNCTION IS NOT CHANGED.
       ===================================================== */

    currentDestinations.forEach(
        function (destination) {

            container.insertAdjacentHTML(

                "beforeend",

                createDestinationCard(
                    destination
                )

            );

        }
    );


    /* -----------------------------------------------------
       PAGINATION INFORMATION
       ----------------------------------------------------- */

    updatePaginationInfo(
        startIndex + 1,
        endIndex,
        totalDestinations
    );


    /* -----------------------------------------------------
       PAGINATION BUTTONS
       ----------------------------------------------------- */

    renderPagination(
        totalPages
    );

}


/* =========================================================
   CREATE DESTINATION CARD
   ========================================================= */

function createDestinationCard(destination) {

    const id =
        destination.id;


    const name =
        escapeHtml(
            destination.destinationName ||
            ""
        );


    const state =
        escapeHtml(
            destination.state ||
            ""
        );


    const country =
        escapeHtml(
            destination.country ||
            ""
        );


    const category =
        escapeHtml(
            destination.category ||
            "General"
        );


    const budget =
        destination.budget !== null &&
        destination.budget !== undefined

            ? Number(
                destination.budget
              ).toLocaleString(

                "en-IN",

                {
                    minimumFractionDigits: 0,

                    maximumFractionDigits: 2
                }

              )

            : "N/A";


    const status =
        String(
            destination.status ||
            "ACTIVE"
        ).toUpperCase();


    const statusClass =
        status === "ACTIVE"
            ? "status-active"
            : "status-inactive";


    const categoryClass =
        getCategoryClass(
            destination.category
        );


    /* -----------------------------------------------------
       IMAGE URL
       ----------------------------------------------------- */

    let imageUrl = "";


    if (destination.image) {

        imageUrl =
            `${API_BASE_URL}/images/${encodeURIComponent(
                destination.image
            )}`;

    }


    /* -----------------------------------------------------
       IMAGE HTML
       ----------------------------------------------------- */

    const imageHtml =
        imageUrl

            ? `

                <div class="card-img-wrapper">

                    <img
                        src="${imageUrl}"
                        class="destination-card-image"
                        alt="${name}"
                        loading="lazy"
                        onerror="handleImageError(this)"
                    >

                    <div class="status-badge ${statusClass}">

                        <span class="status-dot"></span>

                        ${escapeHtml(status)}

                    </div>

                </div>

            `

            : `

                <div class="card-img-wrapper">

                    <div
                        class="d-flex
                               align-items-center
                               justify-content-center
                               h-100">

                        <i class="fas fa-image fa-3x text-muted"></i>

                    </div>

                    <div class="status-badge ${statusClass}">

                        <span class="status-dot"></span>

                        ${escapeHtml(status)}

                    </div>

                </div>

            `;


    /* -----------------------------------------------------
       CARD
       ----------------------------------------------------- */

    return `

        <div class="destination-grid-item">

            <div class="destination-card">

                ${imageHtml}


                <div class="destination-card-body">

                    <div class="destination-card-heading">

                        <div>

                            <h3 class="destination-title">

                                ${name}

                            </h3>


                            <p class="destination-location">

                                <i class="fas fa-location-dot"></i>

                                ${state}, ${country}

                            </p>

                        </div>


                        <span class="badge-cat ${categoryClass}">

                            ${category}

                        </span>

                    </div>


                    <div class="destination-budget">

                        <div>

                            <span class="budget-label">

                                Estimated Budget

                            </span>


                            <strong>

                                ₹${budget}

                            </strong>

                        </div>


                        <i class="fas fa-wallet"></i>

                    </div>


                    <div class="destination-actions">

                        <button
                            type="button"
                            class="destination-action-btn view-btn"
                            onclick="viewDestination(${id})">

                            <i class="fas fa-eye me-1"></i>

                            View

                        </button>


                        <button
                            type="button"
                            class="destination-action-btn edit-btn"
                            onclick="editDestination(${id})">

                            <i class="fas fa-pen me-1"></i>

                            Edit

                        </button>


                        <button
                            type="button"
                            class="destination-action-btn delete-btn"
                            onclick="openDeleteConfirmation(${id})">

                            <i class="fas fa-trash me-1"></i>

                            Delete

                        </button>

                    </div>

                </div>

            </div>

        </div>

    `;

}


/* =========================================================
   PAGINATION
   ========================================================= */

function renderPagination(totalPages) {

    const paginationContainer =
        document.getElementById(
            "paginationContainer"
        );


    if (!paginationContainer) {

        console.error(
            "ERROR: #paginationContainer not found."
        );

        return;

    }


    paginationContainer.innerHTML = "";


    /* -----------------------------------------------------
       IF ONLY ONE PAGE
       ----------------------------------------------------- */

    if (totalPages <= 1) {

        return;

    }


    let html = `

        <nav
            aria-label="Destination pagination">

            <ul class="pagination justify-content-center">

    `;


    /* -----------------------------------------------------
       PREVIOUS BUTTON
       ----------------------------------------------------- */

    html += `

        <li class="page-item ${
            currentPage === 1
                ? "disabled"
                : ""
        }">

            <button
                type="button"
                class="page-link"
                onclick="changeDestinationPage(${currentPage - 1})"
                ${
                    currentPage === 1
                        ? "disabled"
                        : ""
                }>

                <i class="fas fa-chevron-left"></i>

                Previous

            </button>

        </li>

    `;


    /* -----------------------------------------------------
       PAGE NUMBERS
       ----------------------------------------------------- */

    for (
        let page = 1;
        page <= totalPages;
        page++
    ) {

        html += `

            <li class="page-item ${
                page === currentPage
                    ? "active"
                    : ""
            }">

                <button
                    type="button"
                    class="page-link"
                    onclick="changeDestinationPage(${page})">

                    ${page}

                </button>

            </li>

        `;

    }


    /* -----------------------------------------------------
       NEXT BUTTON
       ----------------------------------------------------- */

    html += `

        <li class="page-item ${
            currentPage === totalPages
                ? "disabled"
                : ""
        }">

            <button
                type="button"
                class="page-link"
                onclick="changeDestinationPage(${currentPage + 1})"
                ${
                    currentPage === totalPages
                        ? "disabled"
                        : ""
                }>

                Next

                <i class="fas fa-chevron-right"></i>

            </button>

        </li>

    `;


    html += `

            </ul>

        </nav>

    `;


    paginationContainer.innerHTML =
        html;

}


/* =========================================================
   CHANGE DESTINATION PAGE
   ========================================================= */

function changeDestinationPage(page) {

    const totalPages =
        Math.ceil(
            destinations.length /
            itemsPerPage
        );


    /* -----------------------------------------------------
       INVALID PAGE
       ----------------------------------------------------- */

    if (
        page < 1 ||
        page > totalPages
    ) {

        return;

    }


    /* -----------------------------------------------------
       CHANGE CURRENT PAGE
       ----------------------------------------------------- */

    currentPage =
        page;


    /* -----------------------------------------------------
       RENDER
       ----------------------------------------------------- */

    renderDestinations();


    /* -----------------------------------------------------
       SCROLL TO DESTINATION SECTION
       ----------------------------------------------------- */

    const container =
        document.getElementById(
            "destinationsGrid"
        );


    if (container) {

        container.scrollIntoView({

            behavior: "smooth",

            block: "start"

        });

    }

}


/* =========================================================
   OPEN ADD MODAL
   ========================================================= */

function openAddModal() {

    currentDestinationId = null;


    const form =
        document.getElementById(
            "destinationForm"
        );


    if (form) {

        form.reset();

    }


    /* Hidden ID */

    setFormValue(
        "destId",
        ""
    );


    /* Default values */

    setFormValue(
        "destStatus",
        "ACTIVE"
    );


    /* Clear file */

    const imageInput =
        document.getElementById(
            "destImageFile"
        );


    if (imageInput) {

        imageInput.value = "";

    }


    /* Clear filename */

    const fileNameDisplay =
        document.getElementById(
            "fileNameDisplay"
        );


    if (fileNameDisplay) {

        fileNameDisplay.textContent =
            "";

    }


    /* Clear image preview */

    clearImagePreview();


    /* Modal title */

    const title =
        document.getElementById(
            "formModalTitle"
        );


    if (title) {

        title.textContent =
            "Add New Destination";

    }


    const subtitle =
        document.getElementById(
            "formModalSubtitle"
        );


    if (subtitle) {

        subtitle.textContent =
            "Create a new destination with travel information and a beautiful cover image.";

    }


    /* Show modal */

    if (destinationModal) {

        destinationModal.show();

    } else {

        const modalElement =
            document.getElementById(
                "destinationFormModal"
            );


        if (
            modalElement &&
            typeof bootstrap !== "undefined"
        ) {

            destinationModal =
                bootstrap.Modal.getOrCreateInstance(
                    modalElement
                );


            destinationModal.show();

        }

    }

}


/* =========================================================
   COMPATIBILITY FUNCTION
   ========================================================= */

function openAddDestinationModal() {

    openAddModal();

}


/* =========================================================
   PREVIEW SELECTED IMAGE
   ========================================================= */

function previewSelectedFileName(input) {

    const fileNameDisplay =
        document.getElementById(
            "fileNameDisplay"
        );


    const preview =
        document.getElementById(
            "imagePreview"
        );


    if (
        !input ||
        !input.files ||
        input.files.length === 0
    ) {

        if (fileNameDisplay) {

            fileNameDisplay.textContent =
                "";

        }


        clearImagePreview();

        return;

    }


    const file =
        input.files[0];


    if (fileNameDisplay) {

        fileNameDisplay.textContent =
            file.name;

    }


    /* -----------------------------------------------------
       IMAGE PREVIEW
       ----------------------------------------------------- */

    if (preview) {

        const reader =
            new FileReader();


        reader.onload =
            function (event) {

                preview.src =
                    event.target.result;

                preview.style.display =
                    "block";

            };


        reader.readAsDataURL(file);

    }

}


/* =========================================================
   CLEAR IMAGE PREVIEW
   ========================================================= */

function clearImagePreview() {

    const preview =
        document.getElementById(
            "imagePreview"
        );


    if (preview) {

        preview.removeAttribute(
            "src"
        );


        preview.style.display =
            "none";

    }

}


/* =========================================================
   EDIT DESTINATION
   ========================================================= */

async function editDestination(id) {

    try {

        console.log(
            "Editing destination:",
            id
        );


        const response =
            await fetch(
                `${API_BASE_URL}/${id}`,
                {
                    method: "GET",

                    headers: {

                        "Accept":
                            "application/json"

                    },

                    credentials: "include"

                }
            );


        if (!response.ok) {

            throw new Error(
                "Failed to fetch destination. HTTP " +
                response.status
            );

        }


        const result =
            await response.json();


        const destination =
            result.data ||
            result;


        if (!destination) {

            throw new Error(
                "Destination data not found."
            );

        }


        currentDestinationId =
            Number(destination.id);


        /* -------------------------------------------------
           SET FORM VALUES
           ------------------------------------------------- */

        setFormValue(
            "destId",
            destination.id
        );


        setFormValue(
            "destName",
            destination.destinationName
        );


        setFormValue(
            "destState",
            destination.state
        );


        setFormValue(
            "destCountry",
            destination.country
        );


        setFormValue(
            "destCategory",
            destination.category
        );


        setFormValue(
            "destBudget",
            destination.budget
        );


        setFormValue(
            "destSeason",
            destination.bestSeason
        );


        setFormValue(
            "destStatus",
            destination.status ||
            "ACTIVE"
        );


        setFormValue(
            "destDescription",
            destination.description
        );


        /* -------------------------------------------------
           CLEAR NEW IMAGE INPUT
           ------------------------------------------------- */

        const imageInput =
            document.getElementById(
                "destImageFile"
            );


        if (imageInput) {

            imageInput.value =
                "";

        }


        const fileNameDisplay =
            document.getElementById(
                "fileNameDisplay"
            );


        if (fileNameDisplay) {

            fileNameDisplay.textContent =
                destination.image
                    ? "Current image: " +
                      destination.image
                    : "";

        }


        /* -------------------------------------------------
           SHOW EXISTING IMAGE
           ------------------------------------------------- */

        const preview =
            document.getElementById(
                "imagePreview"
            );


        if (
            preview &&
            destination.image
        ) {

            preview.src =
                `${API_BASE_URL}/images/${encodeURIComponent(
                    destination.image
                )}`;


            preview.style.display =
                "block";

        } else {

            clearImagePreview();

        }


        /* -------------------------------------------------
           MODAL TITLE
           ------------------------------------------------- */

        const title =
            document.getElementById(
                "formModalTitle"
            );


        if (title) {

            title.textContent =
                "Edit Destination";

        }


        const subtitle =
            document.getElementById(
                "formModalSubtitle"
            );


        if (subtitle) {

            subtitle.textContent =
                "Update destination information and optionally replace the cover image.";

        }


        /* -------------------------------------------------
           SHOW MODAL
           ------------------------------------------------- */

        if (!destinationModal) {

            const modalElement =
                document.getElementById(
                    "destinationFormModal"
                );


            if (
                modalElement &&
                typeof bootstrap !== "undefined"
            ) {

                destinationModal =
                    bootstrap.Modal.getOrCreateInstance(
                        modalElement
                    );

            }

        }


        if (destinationModal) {

            destinationModal.show();

        }


    } catch (error) {

        console.error(
            "Error editing destination:",
            error
        );


        showToast(
            error.message ||
            "Failed to load destination.",
            "danger"
        );

    }

}


/* =========================================================
   SAVE DESTINATION
   ========================================================= */

async function saveDestination() {

    try {

        /* -------------------------------------------------
           GET FORM
           ------------------------------------------------- */

        const form =
            document.getElementById(
                "destinationForm"
            );


        if (!form) {

            throw new Error(
                "Destination form not found."
            );

        }


        /* -------------------------------------------------
           GET VALUES
           ------------------------------------------------- */

        const destinationName =
            getFormValue(
                "destName"
            ).trim();


        const state =
            getFormValue(
                "destState"
            ).trim();


        const country =
            getFormValue(
                "destCountry"
            ).trim();


        const category =
            getFormValue(
                "destCategory"
            ).trim();


        const budgetValue =
            getFormValue(
                "destBudget"
            ).trim();


        const bestSeason =
            getFormValue(
                "destSeason"
            ).trim();


        const description =
            getFormValue(
                "destDescription"
            ).trim();


        const status =
            getFormValue(
                "destStatus"
            ) ||
            "ACTIVE";


        /* -------------------------------------------------
           CLIENT VALIDATION
           ------------------------------------------------- */

        if (!destinationName) {

            showToast(
                "Destination name is required.",
                "danger"
            );

            return;

        }


        if (!state) {

            showToast(
                "State is required.",
                "danger"
            );

            return;

        }


        if (!country) {

            showToast(
                "Country is required.",
                "danger"
            );

            return;

        }


        if (!category) {

            showToast(
                "Category is required.",
                "danger"
            );

            return;

        }


        if (!budgetValue) {

            showToast(
                "Budget is required.",
                "danger"
            );

            return;

        }


        if (!bestSeason) {

            showToast(
                "Best season is required.",
                "danger"
            );

            return;

        }


        if (!description) {

            showToast(
                "Description is required.",
                "danger"
            );

            return;

        }


        const budget =
            Number(
                budgetValue
            );


        if (
            Number.isNaN(budget) ||
            budget < 0
        ) {

            showToast(
                "Please enter a valid budget.",
                "danger"
            );

            return;

        }


        /* -------------------------------------------------
           CREATE DESTINATION OBJECT
           ------------------------------------------------- */

        const destination = {

            destinationName:
                destinationName,

            state:
                state,

            country:
                country,

            category:
                category,

            budget:
                budget,

            bestSeason:
                bestSeason,

            description:
                description,

            status:
                status

        };


        console.log(
            "Destination to save:",
            destination
        );


        /* -------------------------------------------------
           FORM DATA
           ------------------------------------------------- */

        const formData =
            new FormData();


        const destinationBlob =
            new Blob(
                [
                    JSON.stringify(
                        destination
                    )
                ],
                {
                    type:
                        "application/json"
                }
            );


        formData.append(
            "destination",
            destinationBlob
        );


        /* -------------------------------------------------
           IMAGE
           ------------------------------------------------- */

        const imageInput =
            document.getElementById(
                "destImageFile"
            );


        if (
            imageInput &&
            imageInput.files &&
            imageInput.files.length > 0
        ) {

            formData.append(
                "file",
                imageInput.files[0]
            );

        }


        /* -------------------------------------------------
           ADD OR EDIT
           ------------------------------------------------- */

        const isEdit =
            currentDestinationId !== null;


        const url =
            isEdit
                ? `${API_BASE_URL}/${currentDestinationId}`
                : API_BASE_URL;


        const method =
            isEdit
                ? "PUT"
                : "POST";


        console.log(
            "Saving destination:",
            method,
            url
        );


        /* -------------------------------------------------
           SEND REQUEST
           ------------------------------------------------- */

        const response =
            await fetch(
                url,
                {
                    method:
                        method,

                    body:
                        formData,

                    credentials:
                        "include"

                }
            );


        const result =
            await response.json();


        console.log(
            "Save response:",
            result
        );


        if (!response.ok) {

            throw new Error(
                result.message ||
                "Failed to save destination."
            );

        }


        /* -------------------------------------------------
           CLOSE MODAL
           ------------------------------------------------- */

        if (destinationModal) {

            destinationModal.hide();

        }


        /* -------------------------------------------------
           SUCCESS
           ------------------------------------------------- */

        showToast(
            isEdit
                ? "Destination updated successfully!"
                : "Destination added successfully!",
            "success"
        );


        currentDestinationId =
            null;


        /* -------------------------------------------------
           RELOAD
           ------------------------------------------------- */

        await loadDestinations();


    } catch (error) {

        console.error(
            "Error saving destination:",
            error
        );


        showToast(
            error.message ||
            "Failed to save destination.",
            "danger"
        );

    }

}


/* =========================================================
   VIEW DESTINATION
   ========================================================= */

async function viewDestination(id) {

    try {

        console.log(
            "Viewing destination:",
            id
        );


        const response =
            await fetch(
                `${API_BASE_URL}/${id}`,
                {
                    method: "GET",

                    headers: {

                        "Accept":
                            "application/json"

                    },

                    credentials: "include"

                }
            );


        if (!response.ok) {

            throw new Error(
                "Failed to fetch destination."
            );

        }


        const result =
            await response.json();


        const destination =
            result.data ||
            result;


        if (!destination) {

            throw new Error(
                "Destination not found."
            );

        }


        /* -------------------------------------------------
           VIEW TEXT
           ------------------------------------------------- */

        setElementText(
            "viewName",
            destination.destinationName ||
            "Destination"
        );


        setElementText(
            "viewNameRight",
            destination.destinationName ||
            "Destination"
        );


        setElementText(
            "viewCategory",
            destination.category ||
            "General"
        );


        setElementText(
            "viewLocation",
            `${destination.state || ""}, ${destination.country || ""}`
        );


        setElementText(
            "viewBudget",
            destination.budget !== null &&
            destination.budget !== undefined

                ? "₹" +
                  Number(
                      destination.budget
                  ).toLocaleString(
                      "en-IN"
                  )

                : "N/A"
        );


        setElementText(
            "viewSeason",
            destination.bestSeason ||
            "N/A"
        );


        setElementText(
            "viewCountry",
            destination.country ||
            "N/A"
        );


        setElementText(
            "viewStatus",
            destination.status ||
            "ACTIVE"
        );


        setElementText(
            "viewDescription",
            destination.description ||
            "No description provided."
        );


        /* -------------------------------------------------
           VIEW IMAGE
           ------------------------------------------------- */

        const viewImage =
            document.getElementById(
                "viewImage"
            );


        if (viewImage) {

            if (destination.image) {

                viewImage.src =
                    `${API_BASE_URL}/images/${encodeURIComponent(
                        destination.image
                    )}`;


                viewImage.style.display =
                    "block";

            } else {

                viewImage.removeAttribute(
                    "src"
                );

            }

        }


        /* -------------------------------------------------
           SHOW VIEW MODAL
           ------------------------------------------------- */

        if (!viewDestinationModal) {

            const modalElement =
                document.getElementById(
                    "viewDestinationModal"
                );


            if (
                modalElement &&
                typeof bootstrap !== "undefined"
            ) {

                viewDestinationModal =
                    bootstrap.Modal.getOrCreateInstance(
                        modalElement
                    );

            }

        }


        if (viewDestinationModal) {

            viewDestinationModal.show();

        }


    } catch (error) {

        console.error(
            "Error viewing destination:",
            error
        );


        showToast(
            error.message ||
            "Failed to load destination.",
            "danger"
        );

    }

}


/* =========================================================
   OPEN DELETE CONFIRMATION
   ========================================================= */

function openDeleteConfirmation(id) {

    console.log(
        "Delete destination:",
        id
    );


    deleteDestinationId =
        Number(id);


    const destination =
        destinations.find(
            function (item) {

                return Number(item.id) ===
                    Number(id);

            }
        );


    const deleteName =
        document.getElementById(
            "deleteDestinationName"
        );


    if (deleteName) {

        deleteName.textContent =
            destination
                ? destination.destinationName
                : "this destination";

    }


    const modalElement =
        document.getElementById(
            "deleteDestinationModal"
        );


    if (!modalElement) {

        console.error(
            "Delete modal not found."
        );

        return;

    }


    if (typeof bootstrap === "undefined") {

        console.error(
            "Bootstrap is not loaded."
        );

        return;

    }


    if (!deleteModal) {

        deleteModal =
            bootstrap.Modal.getOrCreateInstance(
                modalElement
            );

    }


    deleteModal.show();

}


/* =========================================================
   CONFIRM DELETE
   ========================================================= */

async function confirmDeleteDestination() {

    if (
        deleteDestinationId === null ||
        deleteDestinationId === undefined
    ) {

        showToast(
            "No destination selected.",
            "danger"
        );

        return;

    }


    const id =
        deleteDestinationId;


    const confirmButton =
        document.getElementById(
            "confirmDeleteDestinationBtn"
        );


    try {

        /* -------------------------------------------------
           DISABLE BUTTON
           ------------------------------------------------- */

        if (confirmButton) {

            confirmButton.disabled =
                true;


            confirmButton.innerHTML = `

                <span
                    class="spinner-border spinner-border-sm me-2">

                </span>

                Deleting...

            `;

        }


        /* -------------------------------------------------
           DELETE API
           ------------------------------------------------- */

        const response =
            await fetch(
                `${API_BASE_URL}/${id}`,
                {
                    method: "DELETE",

                    headers: {

                        "Accept":
                            "application/json"

                    },

                    credentials:
                        "include"

                }
            );


        const result =
            await response.json();


        console.log(
            "Delete response:",
            result
        );


        if (!response.ok) {

            throw new Error(
                result.message ||
                "Failed to delete destination."
            );

        }


        /* -------------------------------------------------
           CLOSE MODAL
           ------------------------------------------------- */

        if (deleteModal) {

            deleteModal.hide();

        }


        deleteDestinationId =
            null;


        /* -------------------------------------------------
           SUCCESS
           ------------------------------------------------- */

        showToast(
            "Destination deleted successfully!",
            "success"
        );


        /* -------------------------------------------------
           RELOAD
           ------------------------------------------------- */

        await loadDestinations();


    } catch (error) {

        console.error(
            "Error deleting destination:",
            error
        );


        showToast(
            error.message ||
            "Failed to delete destination.",
            "danger"
        );


    } finally {

        if (confirmButton) {

            confirmButton.disabled =
                false;


            confirmButton.innerHTML = `

                <i class="fas fa-trash me-2"></i>

                Delete

            `;

        }

    }

}


/* =========================================================
   FORM VALUE HELPER
   ========================================================= */

function getFormValue(id) {

    const element =
        document.getElementById(id);


    if (!element) {

        return "";

    }


    return element.value || "";

}


/* =========================================================
   SET FORM VALUE
   ========================================================= */

function setFormValue(
    id,
    value
) {

    const element =
        document.getElementById(id);


    if (element) {

        element.value =
            value ?? "";

    }

}


/* =========================================================
   SET ELEMENT TEXT
   ========================================================= */

function setElementText(
    id,
    value
) {

    const element =
        document.getElementById(id);


    if (element) {

        element.textContent =
            value ?? "";

    }

}


/* =========================================================
   CATEGORY CLASS
   ========================================================= */

function getCategoryClass(category) {

    if (!category) {

        return "cat-city";

    }


    return "cat-" +

        String(category)

            .toLowerCase()

            .replace(
                /[^a-z0-9]/g,
                ""
            );

}


/* =========================================================
   IMAGE ERROR
   ========================================================= */

function handleImageError(image) {

    if (!image) {

        return;

    }


    const wrapper =
        image.closest(
            ".card-img-wrapper"
        );


    if (wrapper) {

        image.style.display =
            "none";

    }

}


/* =========================================================
   UPDATE PAGINATION INFO
   ========================================================= */

function updatePaginationInfo(
    start,
    end,
    total
) {

    const info =
        document.getElementById(
            "paginationInfo"
        );


    if (!info) {

        return;

    }


    if (total === 0) {

        info.textContent =
            "Showing 0 destinations";

        return;

    }


    info.textContent =
        `Showing ${start}-${end} of ${total} destinations`;

}


/* =========================================================
   TOAST
   ========================================================= */

function showToast(
    message,
    type = "success"
) {

    const toast =
        document.getElementById(
            "appToast"
        );


    const toastMessage =
        document.getElementById(
            "toastMessage"
        );


    if (
        toast &&
        toastMessage &&
        typeof bootstrap !== "undefined"
    ) {

        toastMessage.textContent =
            message;


        toast.classList.remove(
            "bg-success",
            "bg-danger",
            "bg-warning",
            "bg-info"
        );


        toast.classList.add(
            `bg-${type}`
        );


        const bsToast =
            bootstrap.Toast.getOrCreateInstance(
                toast
            );


        bsToast.show();


        return;

    }


    console.log(
        `[${type}] ${message}`
    );

}


/* =========================================================
   ESCAPE HTML
   ========================================================= */

function escapeHtml(value) {

    if (
        value === null ||
        value === undefined
    ) {

        return "";

    }


    return String(value)

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


/* =========================================================
   DEBOUNCE
   ========================================================= */

function debounce(
    func,
    delay
) {

    let timeout;


    return function () {

        const context =
            this;


        const args =
            arguments;


        clearTimeout(
            timeout
        );


        timeout =
            setTimeout(
                function () {

                    func.apply(
                        context,
                        args
                    );

                },
                delay
            );

    };

}


/* =========================================================
   END OF DESTINATION JS
   ========================================================= */