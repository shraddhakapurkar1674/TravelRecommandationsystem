// ============================================================
// HOTEL MANAGEMENT - FRONTEND ONLY
// BACKEND IS NOT MODIFIED
// ============================================================

let allHotels = [];
let filteredHotels = [];

let currentPage = 1;
const itemsPerPage = 8;

let hotelFormModal;
let hotelViewModal;
let deleteModal;

let deleteHotelId = null;


// ============================================================
// API
// ============================================================

const HOTEL_API =
    API_CONFIG.api("/api/hotels");


// ============================================================
// BACKEND IMAGE URL
// ============================================================

const BACKEND_UPLOAD_URL =
    API_CONFIG.BASE_URL + "/uploads/";


// ============================================================
// FRONTEND FALLBACK
// ============================================================

const FRONTEND_BASE_URL =
    API_CONFIG.FRONTEND_BASE_URL;

const DEFAULT_HOTEL_IMAGE =
    FRONTEND_BASE_URL +
    "/images/background.webp";


// ============================================================
// INITIALIZE
// ============================================================

document.addEventListener(
    "DOMContentLoaded",
    function () {

        console.log(
            "Hotel Management initialized"
        );

        hotelFormModal =
            new bootstrap.Modal(
                document.getElementById(
                    "hotelFormModal"
                )
            );

        hotelViewModal =
            new bootstrap.Modal(
                document.getElementById(
                    "hotelViewModal"
                )
            );

        deleteModal =
            new bootstrap.Modal(
                document.getElementById(
                    "deleteHotelModal"
                )
            );


        const form =
            document.getElementById(
                "hotelForm"
            );

        if (form) {

            form.addEventListener(
                "submit",
                function (event) {

                    event.preventDefault();

                    saveHotel();

                }
            );

        }


        const search =
            document.getElementById(
                "hotelSearch"
            );

        if (search) {

            search.addEventListener(
                "input",
                applyHotelFilters
            );

        }


        const status =
            document.getElementById(
                "statusFilter"
            );

        if (status) {

            status.addEventListener(
                "change",
                applyHotelFilters
            );

        }


        const rating =
            document.getElementById(
                "ratingFilter"
            );

        if (rating) {

            rating.addEventListener(
                "change",
                applyHotelFilters
            );

        }


        const clear =
            document.getElementById(
                "clearSearch"
            );

        if (clear) {

            clear.addEventListener(
                "click",
                function () {

                    document.getElementById(
                        "hotelSearch"
                    ).value = "";

                    applyHotelFilters();

                }
            );

        }


        const description =
            document.getElementById(
                "hotelDescription"
            );

        if (description) {

            description.addEventListener(
                "input",
                updateDescriptionCounter
            );

        }


        const image =
            document.getElementById(
                "hotelImage"
            );

        if (image) {

            image.addEventListener(
                "change",
                previewHotelImage
            );

        }


        const confirmDelete =
            document.getElementById(
                "confirmDeleteBtn"
            );

        if (confirmDelete) {

            confirmDelete.addEventListener(
                "click",
                confirmDeleteHotel
            );

        }


        loadHotels();

    }
);


// ============================================================
// LOAD HOTELS
// ============================================================

async function loadHotels() {

    showLoading();

    try {

        console.log(
            "GET:",
            HOTEL_API
        );


        const response =
            await fetch(
                HOTEL_API,
                {
                    method: "GET",
                    credentials: "include"
                }
            );


        console.log(
            "Hotel response:",
            response.status
        );


        if (!response.ok) {

            throw new Error(
                "HTTP " +
                response.status
            );

        }


        const result =
            await response.json();


        console.log(
            "Hotel API result:",
            result
        );


        if (
            result &&
            Array.isArray(
                result.data
            )
        ) {

            allHotels =
                result.data;

        }

        else if (
            Array.isArray(result)
        ) {

            allHotels =
                result;

        }

        else {

            allHotels = [];

        }


        filteredHotels =
            [...allHotels];

        currentPage = 1;

        hideLoading();

        applyHotelFilters();

    }

    catch (error) {

        console.error(
            "Hotel loading error:",
            error
        );

        hideLoading();

        showError();

    }

}


// ============================================================
// FILTER
// ============================================================

function applyHotelFilters() {

    const searchElement =
        document.getElementById(
            "hotelSearch"
        );

    const statusElement =
        document.getElementById(
            "statusFilter"
        );

    const ratingElement =
        document.getElementById(
            "ratingFilter"
        );


    const search =
        searchElement
            ? searchElement.value
                .trim()
                .toLowerCase()
            : "";


    const status =
        statusElement
            ? statusElement.value
            : "";


    const rating =
        ratingElement
            ? ratingElement.value
            : "";


    filteredHotels =
        allHotels.filter(
            function (hotel) {


                const name =
                    String(
                        hotel.hotelName ||
                        ""
                    ).toLowerCase();


                const location =
                    String(
                        hotel.location ||
                        ""
                    ).toLowerCase();


                const city =
                    String(
                        hotel.city ||
                        ""
                    ).toLowerCase();


                const state =
                    String(
                        hotel.state ||
                        ""
                    ).toLowerCase();


                const hotelStatus =
                    String(
                        hotel.status ||
                        "Active"
                    ).toLowerCase();


                const hotelRating =
                    Number(
                        hotel.rating ||
                        0
                    );


                const searchMatch =
                    !search ||
                    name.includes(search) ||
                    location.includes(search) ||
                    city.includes(search) ||
                    state.includes(search);


                const statusMatch =
                    !status ||
                    hotelStatus ===
                    status.toLowerCase();


                let ratingMatch = true;


                if (rating) {

                    ratingMatch =
                        hotelRating >=
                        Number(rating);

                }


                return (
                    searchMatch &&
                    statusMatch &&
                    ratingMatch
                );

            }
        );


    currentPage = 1;

    renderHotels();

}


// ============================================================
// RENDER
// ============================================================

function renderHotels() {

    const grid =
        document.getElementById(
            "hotelGrid"
        );


    if (!grid) {

        return;

    }


    grid.innerHTML = "";


    const total =
        filteredHotels.length;


    updateHotelCount(total);


    if (total === 0) {

        showEmpty();

        renderPagination(0);

        return;

    }


    hideEmpty();


    const totalPages =
        Math.ceil(
            total /
            itemsPerPage
        );


    const start =
        (currentPage - 1) *
        itemsPerPage;


    const end =
        Math.min(
            start +
            itemsPerPage,
            total
        );


    const hotels =
        filteredHotels.slice(
            start,
            end
        );


    hotels.forEach(
        function (hotel) {

            grid.appendChild(
                createHotelCard(
                    hotel
                )
            );

        }
    );


    renderPagination(
        totalPages
    );

}


// ============================================================
// HOTEL CARD
// DESCRIPTION IS NOT DISPLAYED
// ============================================================

function createHotelCard(
    hotel
) {

    const card =
        document.createElement(
            "article"
        );


    card.className =
        "hotel-card";


    const id =
        hotel.id;


    const name =
        hotel.hotelName ||
        "Unnamed Hotel";


    const location =
        hotel.location ||
        hotel.city ||
        hotel.state ||
        "Location unavailable";


    const rating =
        Number(
            hotel.rating || 0
        );


    const price =
        hotel.pricePerNight ??
        hotel.price ??
        0;


    const contact =
        hotel.contactNumber ||
        hotel.contact ||
        "";


    const status =
        String(
            hotel.status ||
            "Active"
        );


    const active =
        status.toLowerCase() ===
        "active";


    const image =
        resolveHotelImage(
            hotel
        );


    card.innerHTML = `

        <!-- IMAGE -->

        <div class="hotel-card-image-wrapper">

            <img
                src="${escapeAttribute(image)}"
                alt="${escapeAttribute(name)}"
                class="hotel-card-image"
                loading="lazy"
                onerror="hotelImageError(this)"
            >


            <div class="hotel-image-gradient"></div>


            <!-- STATUS -->

            <span
                class="
                    hotel-status-badge
                    ${active
                        ? "hotel-status-active"
                        : "hotel-status-inactive"}
                "
            >

                <span class="status-dot"></span>

                ${active
                    ? "Active"
                    : "Inactive"}

            </span>


            <!-- RATING -->

            <div class="hotel-rating-badge">

                <i class="bi bi-star-fill"></i>

                ${rating > 0
                    ? rating.toFixed(1)
                    : "N/A"}

            </div>

        </div>



        <!-- BODY -->

        <div class="hotel-card-body">


            <div class="hotel-card-title-row">

                <div>

                    <h3 class="hotel-card-title">

                        ${escapeHtml(name)}

                    </h3>


                    <p class="hotel-card-location">

                        <i class="bi bi-geo-alt-fill"></i>

                        ${escapeHtml(location)}

                    </p>

                </div>

            </div>



            <!-- QUICK INFO -->

            <div class="hotel-card-info">


                <div class="hotel-info-item">

                    <div class="hotel-info-icon">

                        <i class="bi bi-star-fill"></i>

                    </div>

                    <div>

                        <span>Rating</span>

                        <strong>
                            ${rating > 0
                                ? rating.toFixed(1)
                                : "N/A"}
                        </strong>

                    </div>

                </div>



                <div class="hotel-info-item">

                    <div class="hotel-info-icon">

                        <i class="bi bi-currency-rupee"></i>

                    </div>

                    <div>

                        <span>Per Night</span>

                        <strong>
                            ${formatPrice(price)}
                        </strong>

                    </div>

                </div>

            </div>



            <!-- CONTACT -->

            ${
                contact
                    ? `
                    <div class="hotel-contact">

                        <i class="bi bi-telephone-fill"></i>

                        ${escapeHtml(contact)}

                    </div>
                    `
                    : ""
            }



            <!-- ACTIONS -->

            <div class="hotel-card-actions">


                <button
                    type="button"
                    class="hotel-action view-action"
                    onclick="viewHotel(${Number(id)})"
                    title="View hotel">

                    <i class="bi bi-eye"></i>

                    <span>View</span>

                </button>


                <button
                    type="button"
                    class="hotel-action edit-action"
                    onclick="editHotel(${Number(id)})"
                    title="Edit hotel">

                    <i class="bi bi-pencil-square"></i>

                    <span>Edit</span>

                </button>


                <button
                    type="button"
                    class="hotel-action delete-action"
                    onclick="openDeleteHotel(${Number(id)})"
                    title="Delete hotel">

                    <i class="bi bi-trash3"></i>

                    <span>Delete</span>

                </button>

            </div>


        </div>

    `;


    return card;

}


// ============================================================
// IMAGE RESOLVER
// ============================================================

function resolveHotelImage(
    hotel
) {

    let image =
        hotel.image ||
        hotel.hotelImage ||
        hotel.imageUrl ||
        "";


    if (!image) {

        return DEFAULT_HOTEL_IMAGE;

    }


    image =
        String(image)
            .trim()
            .replace(
                /\\/g,
                "/"
            );


    if (
        image.startsWith(
            "data:image/"
        )
    ) {

        return image;

    }


    if (
        image.startsWith(
            "http://"
        ) ||
        image.startsWith(
            "https://"
        )
    ) {

        return image;

    }


    if (
        image.startsWith(
            "/uploads/"
        )
    ) {

        return (
            API_CONFIG.BASE_URL +
            image
        );

    }


    if (
        image.startsWith(
            "uploads/"
        )
    ) {

        return (
            API_CONFIG.BASE_URL +
            "/" +
            image
        );

    }


    if (
        image.startsWith(
            "/"
        )
    ) {

        return (
            API_CONFIG.BASE_URL +
            image
        );

    }


    image =
        image.substring(
            image.lastIndexOf("/") + 1
        );


    return (
        BACKEND_UPLOAD_URL +
        encodeURIComponent(
            image
        )
    );

}


// ============================================================
// IMAGE ERROR
// ============================================================

function hotelImageError(
    img
) {

    if (
        img.dataset.fallback ===
        "true"
    ) {

        return;

    }


    img.dataset.fallback =
        "true";


    img.onerror = null;

    img.src =
        DEFAULT_HOTEL_IMAGE;

}


// ============================================================
// ADD HOTEL
// ============================================================

function openAddHotel() {

    const form =
        document.getElementById(
            "hotelForm"
        );


    if (form) {

        form.reset();

    }


    document.getElementById(
        "hotelId"
    ).value = "";


    document.getElementById(
        "hotelStatus"
    ).value = "Active";


    document.getElementById(
        "hotelFormTitle"
    ).innerText =
        "Add Hotel";


    document.getElementById(
        "hotelFormSubtitle"
    ).innerText =
        "Add complete hotel information.";


    document.getElementById(
        "saveHotelBtn"
    ).innerHTML = `

        <i class="bi bi-check2-circle"></i>

        <span>
            Save Hotel
        </span>

    `;


    removeSelectedImage();

    updateDescriptionCounter();


    hotelFormModal.show();

}


// ============================================================
// EDIT HOTEL
// ============================================================

function editHotel(
    id
) {

    const hotel =
        allHotels.find(
            function (item) {

                return Number(
                    item.id
                ) === Number(id);

            }
        );


    if (!hotel) {

        showToast(
            "Hotel not found.",
            true
        );

        return;

    }


    document.getElementById(
        "hotelId"
    ).value =
        hotel.id;


    document.getElementById(
        "hotelName"
    ).value =
        hotel.hotelName ||
        "";


    document.getElementById(
        "hotelLocation"
    ).value =
        hotel.location ||
        hotel.city ||
        hotel.state ||
        "";


    document.getElementById(
        "hotelRating"
    ).value =
        hotel.rating ??
        "";


    document.getElementById(
        "hotelPrice"
    ).value =
        hotel.pricePerNight ??
        hotel.price ??
        "";


    document.getElementById(
        "hotelContact"
    ).value =
        hotel.contactNumber ||
        hotel.contact ||
        "";


    document.getElementById(
        "hotelDescription"
    ).value =
        hotel.description ||
        "";


    document.getElementById(
        "hotelStatus"
    ).value =
        normalizeStatus(
            hotel.status
        );


    updateDescriptionCounter();


    // EXISTING IMAGE

    const preview =
        document.getElementById(
            "imagePreview"
        );

    const wrapper =
        document.getElementById(
            "imagePreviewWrapper"
        );


    const image =
        resolveHotelImage(
            hotel
        );


    if (
        hotel.image ||
        hotel.hotelImage ||
        hotel.imageUrl
    ) {

        preview.src =
            image;

        wrapper.classList.remove(
            "d-none"
        );

    }

    else {

        wrapper.classList.add(
            "d-none"
        );

    }


    document.getElementById(
        "hotelFormTitle"
    ).innerText =
        "Edit Hotel";


    document.getElementById(
        "hotelFormSubtitle"
    ).innerText =
        "Update hotel information.";


    document.getElementById(
        "saveHotelBtn"
    ).innerHTML = `

        <i class="bi bi-save2"></i>

        <span>
            Update Hotel
        </span>

    `;


    hotelFormModal.show();

}


// ============================================================
// SAVE HOTEL
// ============================================================

async function saveHotel() {

    const id =
        document.getElementById(
            "hotelId"
        ).value.trim();


    const isEdit =
        id !== "";


    const name =
        document.getElementById(
            "hotelName"
        ).value.trim();


    const location =
        document.getElementById(
            "hotelLocation"
        ).value.trim();


    const rating =
        document.getElementById(
            "hotelRating"
        ).value.trim();


    const price =
        document.getElementById(
            "hotelPrice"
        ).value.trim();


    const contact =
        document.getElementById(
            "hotelContact"
        ).value.trim();


    const description =
        document.getElementById(
            "hotelDescription"
        ).value.trim();


    const status =
        document.getElementById(
            "hotelStatus"
        ).value;


    const fileInput =
        document.getElementById(
            "hotelImage"
        );


    const file =
        fileInput &&
        fileInput.files.length
            ? fileInput.files[0]
            : null;


    // ========================================================
    // VALIDATION
    // ========================================================

    if (!name) {

        showToast(
            "Hotel name is required.",
            true
        );

        return;

    }


    if (
        rating !== "" &&
        (
            Number(rating) < 0 ||
            Number(rating) > 5
        )
    ) {

        showToast(
            "Rating must be between 0 and 5.",
            true
        );

        return;

    }


    if (
        price !== "" &&
        Number(price) < 0
    ) {

        showToast(
            "Price cannot be negative.",
            true
        );

        return;

    }


    if (file) {

        if (
            !file.type.startsWith(
                "image/"
            )
        ) {

            showToast(
                "Please select a valid image.",
                true
            );

            return;

        }


        if (
            file.size >
            10 * 1024 * 1024
        ) {

            showToast(
                "Image must be less than 10 MB.",
                true
            );

            return;

        }

    }


    // ========================================================
    // IMPORTANT
    // JSON OBJECT
    // ========================================================

    const hotel = {

        hotelName:
            name,

        location:
            location,

        rating:
            rating === ""
                ? null
                : Number(rating),

        pricePerNight:
            price === ""
                ? null
                : Number(price),

        contactNumber:
            contact,

        description:
            description,

        status:
            status

    };


    console.log(
        "Hotel object:",
        hotel
    );


    // ========================================================
    // FORMDATA
    // ========================================================

    const formData =
        new FormData();


    formData.append(
        "hotel",
        new Blob(
            [
                JSON.stringify(
                    hotel
                )
            ],
            {
                type:
                    "application/json"
            }
        )
    );


    if (file) {

        formData.append(
            "file",
            file,
            file.name
        );

    }


    const url =
        isEdit
            ? HOTEL_API +
              "/" +
              encodeURIComponent(id)
            : HOTEL_API;


    const method =
        isEdit
            ? "PUT"
            : "POST";


    try {

        setSaveButtonLoading(
            true
        );


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


        let result = {};


        try {

            result =
                await response.json();

        }

        catch (error) {

            result = {};

        }


        console.log(
            "Save hotel response:",
            result
        );


        if (!response.ok) {

            throw new Error(
                result.message ||
                result.error ||
                "Failed to save hotel."
            );

        }


        showToast(
            isEdit
                ? "Hotel updated successfully!"
                : "Hotel added successfully!"
        );


        hotelFormModal.hide();


        await loadHotels();

    }

    catch (error) {

        console.error(
            "Save hotel error:",
            error
        );


        showToast(
            error.message ||
            "Failed to save hotel.",
            true
        );

    }

    finally {

        setSaveButtonLoading(
            false
        );

    }

}


// ============================================================
// VIEW HOTEL
// ============================================================

function viewHotel(
    id
) {

    const hotel =
        allHotels.find(
            function (item) {

                return Number(
                    item.id
                ) === Number(id);

            }
        );


    if (!hotel) {

        showToast(
            "Hotel not found.",
            true
        );

        return;

    }


    const name =
        hotel.hotelName ||
        "Hotel";


    const location =
        hotel.location ||
        hotel.city ||
        hotel.state ||
        "Location unavailable";


    const rating =
        Number(
            hotel.rating || 0
        );


    const price =
        hotel.pricePerNight ??
        hotel.price;


    const contact =
        hotel.contactNumber ||
        hotel.contact ||
        "Not available";


    const description =
        hotel.description ||
        "No description available.";


    const status =
        normalizeStatus(
            hotel.status
        );


    document.getElementById(
        "viewHotelName"
    ).innerText =
        name;


    document.getElementById(
        "viewHotelLocation"
    ).innerHTML = `

        <i class="bi bi-geo-alt-fill"></i>

        ${escapeHtml(location)}

    `;


    document.getElementById(
        "viewHotelRating"
    ).innerText =
        rating > 0
            ? rating.toFixed(1) +
              " / 5"
            : "Not rated";


    document.getElementById(
        "viewHotelPrice"
    ).innerText =
        price !== null &&
        price !== undefined &&
        price !== ""
            ? formatPrice(price)
            : "Not available";


    document.getElementById(
        "viewHotelContact"
    ).innerText =
        contact;


    document.getElementById(
        "viewHotelDescription"
    ).innerText =
        description;


    document.getElementById(
        "viewHotelStatusText"
    ).innerText =
        status;


    const statusBadge =
        document.getElementById(
            "viewHotelStatus"
        );


    statusBadge.innerText =
        status;


    statusBadge.className =
        "view-status-badge " +
        (
            status.toLowerCase() ===
            "active"
                ? "view-active"
                : "view-inactive"
        );


    const image =
        document.getElementById(
            "viewHotelImage"
        );


    image.dataset.fallback =
        "false";


    image.onerror =
        function () {

            hotelImageError(
                this
            );

        };


    image.src =
        resolveHotelImage(
            hotel
        );


    hotelViewModal.show();

}


// ============================================================
// DELETE
// ============================================================

function openDeleteHotel(
    id
) {

    const hotel =
        allHotels.find(
            function (item) {

                return Number(
                    item.id
                ) === Number(id);

            }
        );


    if (!hotel) {

        showToast(
            "Hotel not found.",
            true
        );

        return;

    }


    deleteHotelId =
        id;


    deleteModal.show();

}


// ============================================================
// CONFIRM DELETE
// ============================================================

async function confirmDeleteHotel() {

    if (!deleteHotelId) {

        return;

    }


    try {

        const response =
            await fetch(
                HOTEL_API +
                "/" +
                encodeURIComponent(
                    deleteHotelId
                ),
                {
                    method:
                        "DELETE",

                    credentials:
                        "include"
                }
            );


        let result = {};


        try {

            result =
                await response.json();

        }

        catch (error) {

            result = {};

        }


        if (!response.ok) {

            throw new Error(
                result.message ||
                result.error ||
                "Failed to delete hotel."
            );

        }


        deleteModal.hide();


        showToast(
            "Hotel deleted successfully!"
        );


        deleteHotelId =
            null;


        await loadHotels();

    }

    catch (error) {

        console.error(
            error
        );


        showToast(
            error.message ||
            "Failed to delete hotel.",
            true
        );

    }

}


// ============================================================
// IMAGE PREVIEW
// ============================================================

function previewHotelImage(
    event
) {

    const file =
        event.target.files[0];


    if (!file) {

        return;

    }


    if (
        !file.type.startsWith(
            "image/"
        )
    ) {

        showToast(
            "Please select an image.",
            true
        );

        event.target.value = "";

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


            const wrapper =
                document.getElementById(
                    "imagePreviewWrapper"
                );


            preview.src =
                e.target.result;


            wrapper.classList.remove(
                "d-none"
            );

        };


    reader.readAsDataURL(
        file
    );

}


// ============================================================
// REMOVE IMAGE
// ============================================================

function removeSelectedImage() {

    const file =
        document.getElementById(
            "hotelImage"
        );


    const wrapper =
        document.getElementById(
            "imagePreviewWrapper"
        );


    const preview =
        document.getElementById(
            "imagePreview"
        );


    if (file) {

        file.value = "";

    }


    if (wrapper) {

        wrapper.classList.add(
            "d-none"
        );

    }


    if (preview) {

        preview.src = "";

    }

}


// ============================================================
// DESCRIPTION COUNTER
// ============================================================

function updateDescriptionCounter() {

    const textarea =
        document.getElementById(
            "hotelDescription"
        );


    const counter =
        document.getElementById(
            "descriptionCounter"
        );


    if (!textarea ||
        !counter) {

        return;

    }


    counter.innerText =
        textarea.value.length;

}


// ============================================================
// PAGINATION
// ============================================================

function renderPagination(
    totalPages
) {

    const container =
        document.getElementById(
            "paginationContainer"
        );


    if (!container) {

        return;

    }


    container.innerHTML = "";


    if (
        totalPages <= 1
    ) {

        return;

    }


    const ul =
        document.createElement(
            "ul"
        );


    ul.className =
        "pagination";


    // PREVIOUS

    const previous =
        createPageButton(
            "‹",
            currentPage - 1,
            currentPage === 1
        );


    ul.appendChild(
        previous
    );


    for (
        let page = 1;
        page <= totalPages;
        page++
    ) {

        const li =
            createPageButton(
                page,
                page,
                false,
                page === currentPage
            );


        ul.appendChild(
            li
        );

    }


    const next =
        createPageButton(
            "›",
            currentPage + 1,
            currentPage === totalPages
        );


    ul.appendChild(
        next
    );


    container.appendChild(
        ul
    );

}


// ============================================================
// PAGE BUTTON
// ============================================================

function createPageButton(
    text,
    page,
    disabled,
    active = false
) {

    const li =
        document.createElement(
            "li"
        );


    li.className =
        "page-item " +
        (
            active
                ? "active"
                : ""
        ) +
        (
            disabled
                ? "disabled"
                : ""
        );


    const button =
        document.createElement(
            "button"
        );


    button.className =
        "page-link";


    button.innerText =
        text;


    button.disabled =
        disabled;


    button.onclick =
        function () {

            if (disabled) {

                return;

            }


            currentPage =
                page;


            renderHotels();

            window.scrollTo(
                {
                    top: 0,
                    behavior:
                        "smooth"
                }
            );

        };


    li.appendChild(
        button
    );


    return li;

}


// ============================================================
// PRICE
// ============================================================

function formatPrice(
    price
) {

    const number =
        Number(price);


    if (
        isNaN(number)
    ) {

        return "₹ N/A";

    }


    return (
        "₹" +
        number.toLocaleString(
            "en-IN"
        )
    );

}


// ============================================================
// STATUS
// ============================================================

function normalizeStatus(
    status
) {

    if (
        String(status)
            .toLowerCase() ===
        "inactive"
    ) {

        return "Inactive";

    }


    return "Active";

}


// ============================================================
// COUNT
// ============================================================

function updateHotelCount(
    count
) {

    const element =
        document.getElementById(
            "hotelCount"
        );


    if (element) {

        element.innerText =
            count +
            (
                count === 1
                    ? " Hotel"
                    : " Hotels"
            );

    }

}


// ============================================================
// LOADING
// ============================================================

function showLoading() {

    document.getElementById(
        "hotelLoading"
    ).classList.remove(
        "d-none"
    );


    document.getElementById(
        "hotelError"
    ).classList.add(
        "d-none"
    );


    document.getElementById(
        "hotelEmpty"
    ).classList.add(
        "d-none"
    );


    document.getElementById(
        "hotelGrid"
    ).innerHTML = "";

}


// ============================================================
// HIDE LOADING
// ============================================================

function hideLoading() {

    document.getElementById(
        "hotelLoading"
    ).classList.add(
        "d-none"
    );

}


// ============================================================
// ERROR
// ============================================================

function showError() {

    document.getElementById(
        "hotelError"
    ).classList.remove(
        "d-none"
    );

}


// ============================================================
// EMPTY
// ============================================================

function showEmpty() {

    document.getElementById(
        "hotelEmpty"
    ).classList.remove(
        "d-none"
    );


    document.getElementById(
        "hotelGrid"
    ).innerHTML = "";

}


// ============================================================
// HIDE EMPTY
// ============================================================

function hideEmpty() {

    document.getElementById(
        "hotelEmpty"
    ).classList.add(
        "d-none"
    );

}


// ============================================================
// SAVE BUTTON
// ============================================================

function setSaveButtonLoading(
    loading
) {

    const button =
        document.getElementById(
            "saveHotelBtn"
        );


    if (!button) {

        return;

    }


    button.disabled =
        loading;


    if (loading) {

        button.innerHTML = `

            <span
                class="spinner-border spinner-border-sm me-2">
            </span>

            Saving...

        `;

    }

}


// ============================================================
// TOAST
// ============================================================

function showToast(
    message,
    error = false
) {

    const toast =
        document.getElementById(
            "hotelToast"
        );


    const title =
        document.getElementById(
            "toastTitle"
        );


    const text =
        document.getElementById(
            "toastMessage"
        );


    if (!toast) {

        alert(message);

        return;

    }


    title.innerText =
        error
            ? "Error"
            : "Success";


    text.innerText =
        message;


    toast.classList.toggle(
        "toast-error",
        error
    );


    toast.classList.add(
        "show"
    );


    setTimeout(
        function () {

            toast.classList.remove(
                "show"
            );

        },
        3000
    );

}


// ============================================================
// ESCAPE HTML
// ============================================================

function escapeHtml(
    value
) {

    return String(
        value ?? ""
    )
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


// ============================================================
// ESCAPE ATTRIBUTE
// ============================================================

function escapeAttribute(
    value
) {

    return escapeHtml(
        value
    );

}


// ============================================================
// GLOBAL FUNCTIONS
// ============================================================

window.openAddHotel =
    openAddHotel;

window.editHotel =
    editHotel;

window.viewHotel =
    viewHotel;

window.openDeleteHotel =
    openDeleteHotel;

window.confirmDeleteHotel =
    confirmDeleteHotel;

window.loadHotels =
    loadHotels;

window.removeSelectedImage =
    removeSelectedImage;