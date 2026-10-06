/* =========================================================
   TRANSPORT MANAGEMENT
   Backend : selected by apiConfig.js
========================================================= */

const API_URL = API_CONFIG.api("/api/transports");
const IMAGE_URL = API_CONFIG.api("/api/transports/images/");
let allTransports = [];
let filteredTransports = [];

let currentTransportId = null;

/* =========================================================
   PAGINATION
========================================================= */

let currentPage = 1;
const recordsPerPage = 6;


/* =========================================================
   PAGE LOAD
========================================================= */

document.addEventListener("DOMContentLoaded", function () {

    loadTransports();

    const form = document.getElementById("transportForm");

    if (form) {
        form.addEventListener("submit", saveTransport);
    }

});


/* =========================================================
   LOAD ALL TRANSPORTS
========================================================= */

async function loadTransports() {

    const loading = document.getElementById("loading");
    const grid = document.getElementById("transportGrid");
    const emptyState = document.getElementById("emptyState");

    if (loading) {
        loading.classList.remove("d-none");
    }

    if (grid) {
        grid.innerHTML = "";
    }

    if (emptyState) {
        emptyState.classList.add("d-none");
    }

    try {

        const response = await fetch(API_URL);

        if (!response.ok) {
            throw new Error("Unable to load transport data.");
        }

        allTransports = await response.json();

        /*
         * IMPORTANT:
         * Database fetching logic is unchanged.
         */
        filteredTransports = [...allTransports];

        currentPage = 1;

        if (loading) {
            loading.classList.add("d-none");
        }

        updateStatistics(allTransports);

        renderCurrentPage();

    } catch (error) {

        console.error("Error loading transports:", error);

        if (loading) {
            loading.classList.add("d-none");
        }

        if (grid) {
            grid.innerHTML = "";
        }

        if (emptyState) {
            emptyState.classList.remove("d-none");
        }

        showToast(
            "Unable to load transport data.",
            "error"
        );
    }
}


/* =========================================================
   RENDER CURRENT PAGE
========================================================= */

function renderCurrentPage() {

    const grid =
        document.getElementById("transportGrid");

    const emptyState =
        document.getElementById("emptyState");

    if (!grid) {
        return;
    }

    grid.innerHTML = "";

    if (
        !filteredTransports ||
        filteredTransports.length === 0
    ) {

        if (emptyState) {
            emptyState.classList.remove("d-none");
        }

        renderPagination(0);

        return;
    }

    if (emptyState) {
        emptyState.classList.add("d-none");
    }

    const totalPages =
        Math.ceil(
            filteredTransports.length /
            recordsPerPage
        );

    if (currentPage > totalPages) {
        currentPage = totalPages;
    }

    const startIndex =
        (currentPage - 1) *
        recordsPerPage;

    const endIndex =
        startIndex +
        recordsPerPage;

    const pageData =
        filteredTransports.slice(
            startIndex,
            endIndex
        );

    pageData.forEach(function (transport) {

        grid.appendChild(
            createTransportCard(transport)
        );

    });

    renderPagination(
        filteredTransports.length
    );
}


/* =========================================================
   CREATE TRANSPORT CARD
========================================================= */

function createTransportCard(transport) {

    const card =
        document.createElement("div");

    card.className = "transport-card";

    const imageHTML =
        createImageHTML(transport);

    const status =
        transport.status
            ? transport.status.toUpperCase()
            : "ACTIVE";

    const statusClass =
        status === "ACTIVE"
            ? "status-active"
            : "status-inactive";

    const pricingType =
        transport.pricingType ||
        "Price";

    const pricingValue =
        transport.pricingValue != null
            ? formatCurrency(
                transport.pricingValue
            )
            : "₹0";

    const fromLocation =
        escapeHTML(
            transport.fromLocation ||
            "Not specified"
        );

    const toLocation =
        escapeHTML(
            transport.toLocation ||
            "Not specified"
        );

    const transportType =
        escapeHTML(
            transport.transportType ||
            "Transport"
        );

    const provider =
        escapeHTML(
            transport.transportProvider ||
            "Provider not specified"
        );

    card.innerHTML = `

        <div class="transport-image">

            ${imageHTML}

            <span class="status-badge ${statusClass}">
                <i class="bi bi-circle-fill"></i>
                ${escapeHTML(status)}
            </span>

        </div>


        <div class="transport-card-body">

            <div class="transport-type">

                <i class="${getTransportIcon(
                    transport.transportType
                )}"></i>

                ${transportType}

            </div>


            <h3 class="route-title">

                ${fromLocation}

                <i class="bi bi-arrow-right"></i>

                ${toLocation}

            </h3>


            <div class="route">

                <i class="bi bi-geo-alt-fill"></i>

                <span>
                    ${fromLocation}
                </span>

                <div class="route-line"></div>

                <span>
                    ${toLocation}
                </span>

            </div>


            <div class="provider">

                <i class="bi bi-building"></i>

                <span>
                    ${provider}
                </span>

            </div>


            <div class="price-row">

                <div>

                    <div class="price-label">
                        ${escapeHTML(pricingType)}
                    </div>

                    <div class="price-value">
                        ${pricingValue}
                    </div>

                </div>

            </div>


            <div class="card-actions">

                <button
                    type="button"
                    class="card-action view-action"
                    onclick="viewTransport(${transport.transportId})">

                    <i class="bi bi-eye-fill"></i>
                    View

                </button>


                <button
                    type="button"
                    class="card-action edit-action"
                    onclick="editTransport(${transport.transportId})">

                    <i class="bi bi-pencil-fill"></i>
                    Edit

                </button>


                <button
                    type="button"
                    class="card-action delete delete-action"
                    onclick="openDeleteModal(${transport.transportId})">

                    <i class="bi bi-trash3-fill"></i>
                    Delete

                </button>

            </div>

        </div>
    `;

    return card;
}


/* =========================================================
   IMAGE
========================================================= */

function createImageHTML(transport) {

    if (
        !transport.image ||
        transport.image.trim() === ""
    ) {

        return `

            <div class="image-placeholder">

                <i class="${getTransportIcon(
                    transport.transportType
                )}"></i>

                <span>No Image</span>

            </div>

        `;
    }

    const imagePath =
        IMAGE_URL +
        encodeURIComponent(
            transport.image
        );

    return `

        <img
            src="${imagePath}"
            alt="Transport Image"
            onerror="
                this.style.display='none';
                this.nextElementSibling.style.display='flex';
            "
        >

        <div
            class="image-placeholder"
            style="display:none;">

            <i class="${getTransportIcon(
                transport.transportType
            )}"></i>

            <span>No Image</span>

        </div>
    `;
}


/* =========================================================
   ICON
========================================================= */

function getTransportIcon(type) {

    if (!type) {
        return "bi bi-truck";
    }

    const value =
        type.toLowerCase();

    if (value.includes("bus")) {
        return "bi bi-bus-front";
    }

    if (value.includes("train")) {
        return "bi bi-train-front";
    }

    if (
        value.includes("flight") ||
        value.includes("air")
    ) {
        return "bi bi-airplane";
    }

    if (
        value.includes("cab") ||
        value.includes("taxi")
    ) {
        return "bi bi-taxi-front";
    }

    if (
        value.includes("car")
    ) {
        return "bi bi-car-front";
    }

    return "bi bi-truck";
}


/* =========================================================
   STATISTICS
========================================================= */

function updateStatistics(transports) {

    const total =
        transports.length;

    const active =
        transports.filter(function (item) {

            return (
                item.status &&
                item.status.toUpperCase() === "ACTIVE"
            );

        }).length;

    const inactive =
        total - active;

    const routes =
        new Set(
            transports.map(function (item) {

                return (
                    (item.fromLocation || "")
                        .toLowerCase()
                        .trim()
                    +
                    "->"
                    +
                    (item.toLocation || "")
                        .toLowerCase()
                        .trim()
                );

            })
        ).size;

    const totalElement =
        document.getElementById(
            "totalTransport"
        );

    const activeElement =
        document.getElementById(
            "activeTransport"
        );

    const inactiveElement =
        document.getElementById(
            "inactiveTransport"
        );

    const routesElement =
        document.getElementById(
            "totalRoutes"
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

    if (routesElement) {
        routesElement.textContent = routes;
    }
}


/* =========================================================
   SEARCH
========================================================= */

function searchTransport() {

    currentPage = 1;

    applyFilters();

}


/* =========================================================
   FILTER
========================================================= */

function filterTransport() {

    currentPage = 1;

    applyFilters();

}


/* =========================================================
   APPLY FILTERS
========================================================= */

function applyFilters() {

    const searchElement =
        document.getElementById("searchInput");

    const statusElement =
        document.getElementById("statusFilter");

    const typeElement =
        document.getElementById("typeFilter");

    const keyword =
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

    filteredTransports =
        allTransports.filter(
            function (transport) {

                const searchableText = (

                    (transport.fromLocation || "") +
                    " " +
                    (transport.toLocation || "") +
                    " " +
                    (transport.transportType || "") +
                    " " +
                    (transport.transportProvider || "") +
                    " " +
                    (transport.facilities || "")

                ).toLowerCase();

                const matchesKeyword =
                    !keyword ||
                    searchableText.includes(keyword);

                const matchesStatus =
                    !status ||
                    (
                        transport.status &&
                        transport.status.toUpperCase()
                            === status
                    );

                const matchesType =
                    !type ||
                    (
                        transport.transportType &&
                        transport.transportType
                            .toLowerCase()
                            === type
                    );

                return (
                    matchesKeyword &&
                    matchesStatus &&
                    matchesType
                );

            }
        );

    renderCurrentPage();
}


/* =========================================================
   RESET FILTER
========================================================= */

function resetFilters() {

    const searchInput =
        document.getElementById("searchInput");

    const statusFilter =
        document.getElementById("statusFilter");

    const typeFilter =
        document.getElementById("typeFilter");

    if (searchInput) {
        searchInput.value = "";
    }

    if (statusFilter) {
        statusFilter.value = "";
    }

    if (typeFilter) {
        typeFilter.value = "";
    }

    filteredTransports =
        [...allTransports];

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
        totalRecords <= recordsPerPage
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

                window.scrollTo({
                    top: 0,
                    behavior: "smooth"
                });
            }
        };

    wrapper.appendChild(previous);


    /* Pages */

    for (
        let page = 1;
        page <= totalPages;
        page++
    ) {

        const pageButton =
            document.createElement("button");

        pageButton.className =
            "pagination-btn";

        if (
            page === currentPage
        ) {

            pageButton.classList.add(
                "active"
            );
        }

        pageButton.textContent =
            page;

        pageButton.onclick =
            function () {

                currentPage = page;

                renderCurrentPage();

                window.scrollTo({
                    top: 0,
                    behavior: "smooth"
                });

            };

        wrapper.appendChild(
            pageButton
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

                window.scrollTo({
                    top: 0,
                    behavior: "smooth"
                });
            }
        };

    wrapper.appendChild(next);


    container.appendChild(wrapper);
}


/* =========================================================
   ADD MODAL
========================================================= */

function openAddModal() {

    currentTransportId = null;

    document.getElementById(
        "modalTitle"
    ).textContent = "Add Transport";

    document.getElementById(
        "saveButtonText"
    ).textContent = "Save Transport";

    document.getElementById(
        "transportForm"
    ).reset();

    document.getElementById(
        "transportId"
    ).value = "";

    document.getElementById(
        "facilityCharge"
    ).value = "0";

    document.getElementById(
        "status"
    ).value = "ACTIVE";

    resetImagePreview();

    const modal =
        new bootstrap.Modal(
            document.getElementById(
                "transportModal"
            )
        );

    modal.show();
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

            document.getElementById(
                "imagePreview"
            ).innerHTML = `

                <img
                    src="${e.target.result}"
                    alt="Preview">

            `;
        };

    reader.readAsDataURL(file);
}


function resetImagePreview() {

    const preview =
        document.getElementById(
            "imagePreview"
        );

    if (preview) {

        preview.innerHTML = `

            <i class="bi bi-image"></i>

            <span>Image Preview</span>

        `;
    }
}


/* =========================================================
   SAVE
========================================================= */

async function saveTransport(event) {

    event.preventDefault();

    const id =
        document.getElementById(
            "transportId"
        ).value;

    const isEdit =
        id &&
        id.trim() !== "";

    const form =
        document.getElementById(
            "transportForm"
        );

    const formData =
        new FormData(form);

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
        saveText.textContent;

    saveButton.disabled = true;

    saveText.textContent = "Saving...";

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

        if (!response.ok) {

            throw new Error(
                responseText ||
                "Unable to save transport."
            );
        }

        showToast(
            isEdit
                ? "Transport updated successfully."
                : "Transport added successfully.",
            "success"
        );

        const modalElement =
            document.getElementById(
                "transportModal"
            );

        const modal =
            bootstrap.Modal.getInstance(
                modalElement
            );

        if (modal) {
            modal.hide();
        }

        await loadTransports();

    } catch (error) {

        console.error(
            "Save error:",
            error
        );

        showToast(
            error.message ||
            "Unable to save transport.",
            "error"
        );

    } finally {

        saveButton.disabled = false;

        saveText.textContent =
            originalText;
    }
}


/* =========================================================
   VIEW TRANSPORT
========================================================= */

async function viewTransport(id) {

    try {

        const response =
            await fetch(
                `${API_URL}/${id}`
            );

        if (!response.ok) {

            throw new Error(
                "Unable to fetch transport."
            );
        }

        const transport =
            await response.json();

        displayTransportDetails(
            transport
        );

        const modal =
            new bootstrap.Modal(
                document.getElementById(
                    "viewTransportModal"
                )
            );

        modal.show();

    } catch (error) {

        console.error(error);

        showToast(
            "Unable to load transport details.",
            "error"
        );
    }
}


/* =========================================================
   PROFESSIONAL VIEW
   IMAGE LEFT + INFORMATION RIGHT
========================================================= */

function displayTransportDetails(transport) {

    const container =
        document.getElementById(
            "viewTransportContent"
        );

    if (!container) {
        return;
    }

    let imageHTML = `

        <div class="view-image-panel">

            <div class="view-image-placeholder">

                <i class="${getTransportIcon(
                    transport.transportType
                )}"></i>

                <span>No Image Available</span>

            </div>

        </div>

    `;


    if (
        transport.image &&
        transport.image.trim() !== ""
    ) {

        imageHTML = `

            <div class="view-image-panel">

                <img
                    src="${IMAGE_URL}${encodeURIComponent(
                        transport.image
                    )}"
                    alt="Transport Image"
                    onerror="
                        this.style.display='none';
                        this.nextElementSibling.style.display='flex';
                    "
                >

                <div
                    class="view-image-placeholder"
                    style="display:none;">

                    <i class="${getTransportIcon(
                        transport.transportType
                    )}"></i>

                    <span>
                        Image unavailable
                    </span>

                </div>

                <div class="view-image-overlay">

                    <span>
                        ${escapeHTML(
                            transport.transportType ||
                            "Transport"
                        )}
                    </span>

                </div>

            </div>

        `;
    }


    const status =
        transport.status || "ACTIVE";

    container.innerHTML = `

        <div class="professional-view">

            ${imageHTML}


            <div class="view-details-panel">

                <div class="view-heading">

                    <div>

                        <span class="view-kicker">
                            TRANSPORT DETAILS
                        </span>

                        <h3>

                            ${escapeHTML(
                                transport.transportProvider ||
                                "Transport"
                            )}

                        </h3>

                    </div>

                    <span class="
                        view-status
                        ${
                            status.toUpperCase() === "ACTIVE"
                                ? "active"
                                : "inactive"
                        }
                    ">

                        <i class="bi bi-circle-fill"></i>

                        ${escapeHTML(status)}

                    </span>

                </div>


                <div class="view-route-card">

                    <div class="route-location">

                        <span>FROM</span>

                        <strong>
                            ${escapeHTML(
                                transport.fromLocation ||
                                "Not specified"
                            )}
                        </strong>

                    </div>


                    <div class="route-arrow">

                        <i class="bi bi-arrow-right"></i>

                    </div>


                    <div class="route-location">

                        <span>TO</span>

                        <strong>
                            ${escapeHTML(
                                transport.toLocation ||
                                "Not specified"
                            )}
                        </strong>

                    </div>

                </div>


                <div class="view-info-grid">


                    <div class="detail-box">

                        <div class="detail-icon purple">
                            <i class="${getTransportIcon(
                                transport.transportType
                            )}"></i>
                        </div>

                        <div>

                            <span class="detail-label">
                                Transport Type
                            </span>

                            <div class="detail-value">
                                ${escapeHTML(
                                    transport.transportType ||
                                    "Not specified"
                                )}
                            </div>

                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-icon blue">
                            <i class="bi bi-building"></i>
                        </div>

                        <div>

                            <span class="detail-label">
                                Provider
                            </span>

                            <div class="detail-value">
                                ${escapeHTML(
                                    transport.transportProvider ||
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
                                Pricing
                            </span>

                            <div class="detail-value">
                                ${escapeHTML(
                                    transport.pricingType ||
                                    "Price"
                                )}
                                -
                                ${formatCurrency(
                                    transport.pricingValue || 0
                                )}
                            </div>

                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-icon orange">
                            <i class="bi bi-wallet2"></i>
                        </div>

                        <div>

                            <span class="detail-label">
                                Facility Charge
                            </span>

                            <div class="detail-value">
                                ${formatCurrency(
                                    transport.facilityCharge || 0
                                )}
                            </div>

                        </div>

                    </div>


                    <div class="detail-box full">

                        <div class="detail-icon purple">
                            <i class="bi bi-stars"></i>
                        </div>

                        <div>

                            <span class="detail-label">
                                Facilities
                            </span>

                            <div class="detail-value">
                                ${escapeHTML(
                                    transport.facilities ||
                                    "No facilities specified"
                                )}
                            </div>

                        </div>

                    </div>


                    <div class="detail-box full">

                        <div class="detail-icon blue">
                            <i class="bi bi-image"></i>
                        </div>

                        <div>

                            <span class="detail-label">
                                Image File
                            </span>

                            <div class="detail-value image-file-name">

                                ${escapeHTML(
                                    transport.image ||
                                    "No image"
                                )}

                            </div>

                        </div>

                    </div>

                </div>


                <div class="view-id">

                    <span>
                        Transport ID
                    </span>

                    <strong>
                        #${transport.transportId}
                    </strong>

                </div>

            </div>

        </div>
    `;
}


/* =========================================================
   EDIT
========================================================= */

async function editTransport(id) {

    try {

        const response =
            await fetch(
                `${API_URL}/${id}`
            );

        if (!response.ok) {

            throw new Error(
                "Unable to fetch transport."
            );
        }

        const transport =
            await response.json();

        currentTransportId = id;

        document.getElementById(
            "modalTitle"
        ).textContent =
            "Edit Transport";

        document.getElementById(
            "saveButtonText"
        ).textContent =
            "Update Transport";

        document.getElementById(
            "transportId"
        ).value =
            transport.transportId;

        document.getElementById(
            "fromLocation"
        ).value =
            transport.fromLocation || "";

        document.getElementById(
            "toLocation"
        ).value =
            transport.toLocation || "";

        document.getElementById(
            "transportType"
        ).value =
            transport.transportType || "";

        document.getElementById(
            "transportProvider"
        ).value =
            transport.transportProvider || "";

        document.getElementById(
            "pricingType"
        ).value =
            transport.pricingType || "";

        document.getElementById(
            "pricingValue"
        ).value =
            transport.pricingValue ?? "";

        document.getElementById(
            "facilities"
        ).value =
            transport.facilities || "";

        document.getElementById(
            "facilityCharge"
        ).value =
            transport.facilityCharge ?? 0;

        document.getElementById(
            "status"
        ).value =
            transport.status || "ACTIVE";

        if (
            transport.image &&
            transport.image.trim() !== ""
        ) {

            document.getElementById(
                "imagePreview"
            ).innerHTML = `

                <img
                    src="${IMAGE_URL}${encodeURIComponent(
                        transport.image
                    )}"
                    alt="Current Image">

            `;

        } else {

            resetImagePreview();
        }

        const modal =
            new bootstrap.Modal(
                document.getElementById(
                    "transportModal"
                )
            );

        modal.show();

    } catch (error) {

        console.error(
            "Edit error:",
            error
        );

        showToast(
            "Unable to load transport for editing.",
            "error"
        );
    }
}


/* =========================================================
   DELETE
========================================================= */

function openDeleteModal(id) {

    document.getElementById(
        "deleteTransportId"
    ).value = id;

    const modal =
        new bootstrap.Modal(
            document.getElementById(
                "deleteModal"
            )
        );

    modal.show();
}


async function confirmDelete() {

    const id =
        document.getElementById(
            "deleteTransportId"
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

        if (!response.ok) {

            throw new Error(
                responseText ||
                "Unable to delete transport."
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
            "Transport deleted successfully.",
            "success"
        );

        await loadTransports();

    } catch (error) {

        console.error(
            "Delete error:",
            error
        );

        showToast(
            error.message ||
            "Unable to delete transport.",
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
        document.createElement("div");

    toast.className =
        `transport-toast ${type}`;

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

    container.appendChild(toast);

    setTimeout(function () {

        toast.classList.add("hide");

        setTimeout(function () {

            toast.remove();

        }, 300);

    }, 3000);
}