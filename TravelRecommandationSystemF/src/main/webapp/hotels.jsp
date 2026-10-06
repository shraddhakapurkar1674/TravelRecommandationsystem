<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Hotel Management | TripWise Admin</title>

    <!-- Bootstrap -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- Hotel CSS -->
    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/Hotels.css">

</head>


<body>


<div class="admin-layout">


    <!-- =====================================================
         SIDEBAR
    ====================================================== -->

    <aside class="sidebar-wrapper">

        <jsp:include page="sidebar.jsp" />

    </aside>



    <!-- =====================================================
         MAIN
    ====================================================== -->

    <main class="hotel-main">


        <!-- =================================================
             HEADER
        ================================================== -->

        <header class="hotel-header">

            <div>

                <div class="breadcrumb-text">

                    <span>ADMIN</span>

                    <i class="bi bi-chevron-right"></i>

                    <strong>HOTELS</strong>

                </div>

                <h1 class="page-title">
                    Hotel Management
                </h1>

                <p class="page-subtitle">
                    Manage hotels, accommodation details
                    and hotel information.
                </p>

            </div>


            <button
                type="button"
                class="add-hotel-btn"
                onclick="openAddHotel()">

                <i class="bi bi-plus-lg"></i>

                <span>Add Hotel</span>

            </button>

        </header>



        <!-- =================================================
             FILTER
        ================================================== -->

        <section class="hotel-filter-panel">


            <div class="search-wrapper">

                <i class="bi bi-search search-icon"></i>

                <input
                    type="text"
                    id="hotelSearch"
                    class="hotel-search"
                    placeholder="Search hotel or location..."
                    autocomplete="off">

                <button
                    type="button"
                    id="clearSearch"
                    class="clear-search-btn">

                    <i class="bi bi-x-lg"></i>

                </button>

            </div>



            <div class="filter-select-wrapper">

                <i class="bi bi-circle-half"></i>

                <select
                    id="statusFilter"
                    class="hotel-filter">

                    <option value="">
                        All Status
                    </option>

                    <option value="Active">
                        Active
                    </option>

                    <option value="Inactive">
                        Inactive
                    </option>

                </select>

            </div>



            <div class="filter-select-wrapper">

                <i class="bi bi-star"></i>

                <select
                    id="ratingFilter"
                    class="hotel-filter">

                    <option value="">
                        All Ratings
                    </option>

                    <option value="5">
                        5 Star
                    </option>

                    <option value="4">
                        4+ Rating
                    </option>

                    <option value="3">
                        3+ Rating
                    </option>

                </select>

            </div>



            <div class="hotel-count-box">

                <i class="bi bi-buildings"></i>

                <span id="hotelCount">
                    0 Hotels
                </span>

            </div>

        </section>



        <!-- =================================================
             LOADING
        ================================================== -->

        <section
            id="hotelLoading"
            class="hotel-loading">

            <div class="loading-spinner"></div>

            <p>
                Loading hotels...
            </p>

        </section>



        <!-- =================================================
             ERROR
        ================================================== -->

        <section
            id="hotelError"
            class="hotel-error d-none">

            <div class="error-icon">
                <i class="bi bi-exclamation-triangle"></i>
            </div>

            <h3>
                Unable to load hotels
            </h3>

            <p>
                Please check the backend connection
                and try again.
            </p>

            <button
                type="button"
                class="retry-btn"
                onclick="loadHotels()">

                <i class="bi bi-arrow-clockwise"></i>

                Try Again

            </button>

        </section>



        <!-- =================================================
             EMPTY
        ================================================== -->

        <section
            id="hotelEmpty"
            class="hotel-empty d-none">

            <div class="empty-icon">

                <i class="bi bi-building"></i>

            </div>

            <h3>
                No hotels found
            </h3>

            <p id="emptyMessage">
                There are no hotels available.
            </p>

            <button
                type="button"
                class="empty-add-btn"
                onclick="openAddHotel()">

                <i class="bi bi-plus-lg"></i>

                Add Hotel

            </button>

        </section>



        <!-- =================================================
             HOTEL GRID
        ================================================== -->

        <section
            id="hotelGrid"
            class="hotel-grid">

        </section>



        <!-- =================================================
             PAGINATION
        ================================================== -->

        <div
            id="paginationContainer"
            class="pagination-container">

        </div>


    </main>

</div>



<!-- =========================================================
     ADD / EDIT HOTEL MODAL
========================================================= -->

<div
    class="modal fade hotel-modal"
    id="hotelFormModal"
    tabindex="-1">

    <div class="modal-dialog modal-dialog-centered modal-lg">

        <div class="modal-content glass-modal">


            <!-- HEADER -->

            <div class="modal-header">

                <div>

                    <div class="modal-small-title">

                        <i class="bi bi-buildings"></i>

                        TRIPWISE HOTEL

                    </div>

                    <h2
                        id="hotelFormTitle"
                        class="modal-title">

                        Add Hotel

                    </h2>

                    <p
                        id="hotelFormSubtitle"
                        class="modal-subtitle">

                        Add complete hotel information.

                    </p>

                </div>


                <button
                    type="button"
                    class="modal-close-btn"
                    data-bs-dismiss="modal">

                    <i class="bi bi-x-lg"></i>

                </button>

            </div>



            <!-- FORM -->

            <form
                id="hotelForm"
                enctype="multipart/form-data">

                <div class="modal-body">


                    <input
                        type="hidden"
                        id="hotelId">


                    <!-- HOTEL NAME -->

                    <div class="form-group-modern">

                        <label>

                            <i class="bi bi-building"></i>

                            Hotel Name

                            <span>*</span>

                        </label>

                        <input
                            type="text"
                            id="hotelName"
                            class="modern-input"
                            placeholder="Enter hotel name"
                            required>

                    </div>



                    <!-- LOCATION -->

                    <div class="form-group-modern">

                        <label>

                            <i class="bi bi-geo-alt"></i>

                            Location

                        </label>

                        <input
                            type="text"
                            id="hotelLocation"
                            class="modern-input"
                            placeholder="e.g. Pune, Maharashtra">

                    </div>



                    <!-- RATING PRICE -->

                    <div class="form-row">


                        <div class="form-group-modern">

                            <label>

                                <i class="bi bi-star-fill"></i>

                                Rating

                            </label>

                            <input
                                type="number"
                                id="hotelRating"
                                class="modern-input"
                                min="0"
                                max="5"
                                step="0.1"
                                placeholder="0 - 5">

                            <small>
                                Enter rating between 0 and 5.
                            </small>

                        </div>



                        <div class="form-group-modern">

                            <label>

                                <i class="bi bi-currency-rupee"></i>

                                Price Per Night

                            </label>

                            <input
                                type="number"
                                id="hotelPrice"
                                class="modern-input"
                                min="0"
                                step="0.01"
                                placeholder="Enter price">

                        </div>

                    </div>



                    <!-- CONTACT -->

                    <div class="form-group-modern">

                        <label>

                            <i class="bi bi-telephone"></i>

                            Contact Number

                        </label>

                        <input
                            type="tel"
                            id="hotelContact"
                            class="modern-input"
                            placeholder="Enter contact number"
                            maxlength="20">

                    </div>



                    <!-- DESCRIPTION -->

                    <div class="form-group-modern">

                        <label>

                            <i class="bi bi-text-paragraph"></i>

                            Description

                        </label>

                        <textarea
                            id="hotelDescription"
                            class="modern-input modern-textarea"
                            rows="5"
                            maxlength="1000"
                            placeholder="Write a short description about this hotel..."></textarea>

                        <div class="textarea-counter">

                            <span id="descriptionCounter">
                                0
                            </span>

                            / 1000 characters

                        </div>

                    </div>



                    <!-- IMAGE -->

                    <div class="form-group-modern">

                        <label>

                            <i class="bi bi-image"></i>

                            Hotel Image

                        </label>


                        <div
                            id="imageDropArea"
                            class="image-upload-area">

                            <i class="bi bi-cloud-arrow-up"></i>

                            <h6>
                                Choose hotel image
                            </h6>

                            <p>
                                JPG, JPEG, PNG or WEBP
                            </p>

                            <input
                                type="file"
                                id="hotelImage"
                                accept="image/*">

                            <button
                                type="button"
                                class="choose-image-btn"
                                onclick="document.getElementById('hotelImage').click()">

                                <i class="bi bi-upload"></i>

                                Choose Image

                            </button>

                        </div>



                        <div
                            id="imagePreviewWrapper"
                            class="image-preview-wrapper d-none">

                            <img
                                id="imagePreview"
                                class="image-preview"
                                alt="Hotel preview">

                            <button
                                type="button"
                                class="remove-image-btn"
                                onclick="removeSelectedImage()">

                                <i class="bi bi-x"></i>

                            </button>

                        </div>

                    </div>



                    <!-- STATUS -->

                    <div class="form-group-modern">

                        <label>

                            <i class="bi bi-toggle-on"></i>

                            Status

                        </label>

                        <select
                            id="hotelStatus"
                            class="modern-input">

                            <option value="Active">
                                Active
                            </option>

                            <option value="Inactive">
                                Inactive
                            </option>

                        </select>

                    </div>


                </div>



                <!-- FOOTER -->

                <div class="modal-footer-modern">

                    <button
                        type="button"
                        class="secondary-btn"
                        data-bs-dismiss="modal">

                        Cancel

                    </button>


                    <button
                        type="submit"
                        id="saveHotelBtn"
                        class="primary-btn">

                        <i class="bi bi-check2-circle"></i>

                        <span>
                            Save Hotel
                        </span>

                    </button>

                </div>

            </form>

        </div>

    </div>

</div>



<!-- =========================================================
     VIEW HOTEL MODAL
========================================================= -->

<div
    class="modal fade hotel-modal"
    id="hotelViewModal"
    tabindex="-1">

    <div class="modal-dialog modal-dialog-centered modal-xl">

        <div class="modal-content glass-modal view-modal-content">


            <div class="modal-header">

                <div>

                    <div class="modal-small-title">

                        <i class="bi bi-eye"></i>

                        HOTEL DETAILS

                    </div>

                    <h2 class="modal-title">
                        Hotel Information
                    </h2>

                </div>


                <button
                    type="button"
                    class="modal-close-btn"
                    data-bs-dismiss="modal">

                    <i class="bi bi-x-lg"></i>

                </button>

            </div>



            <div class="view-hotel-body">


                <!-- IMAGE -->

                <div class="view-image-section">

                    <div class="view-image-container">

                        <img
                            id="viewHotelImage"
                            src=""
                            alt="Hotel"
                            class="view-hotel-image">

                        <span
                            id="viewHotelStatus"
                            class="view-status-badge">

                        </span>

                    </div>


                    <div class="view-image-caption">

                        <i class="bi bi-image"></i>

                        Hotel Image

                    </div>

                </div>



                <!-- INFORMATION -->

                <div class="view-info-section">


                    <div class="view-title-area">

                        <span class="view-label">
                            HOTEL
                        </span>

                        <h2 id="viewHotelName">
                            -
                        </h2>

                        <p id="viewHotelLocation">

                            <i class="bi bi-geo-alt"></i>

                            -

                        </p>

                    </div>



                    <div class="info-grid">


                        <div class="info-glass-box">

                            <div class="info-icon">
                                <i class="bi bi-star-fill"></i>
                            </div>

                            <div>

                                <span>
                                    Rating
                                </span>

                                <strong id="viewHotelRating">
                                    -
                                </strong>

                            </div>

                        </div>



                        <div class="info-glass-box">

                            <div class="info-icon">
                                <i class="bi bi-currency-rupee"></i>
                            </div>

                            <div>

                                <span>
                                    Price Per Night
                                </span>

                                <strong id="viewHotelPrice">
                                    -
                                </strong>

                            </div>

                        </div>



                        <div class="info-glass-box">

                            <div class="info-icon">
                                <i class="bi bi-telephone"></i>
                            </div>

                            <div>

                                <span>
                                    Contact Number
                                </span>

                                <strong id="viewHotelContact">
                                    -
                                </strong>

                            </div>

                        </div>



                        <div class="info-glass-box">

                            <div class="info-icon">
                                <i class="bi bi-toggle-on"></i>
                            </div>

                            <div>

                                <span>
                                    Status
                                </span>

                                <strong id="viewHotelStatusText">
                                    -
                                </strong>

                            </div>

                        </div>


                    </div>



                    <!-- DESCRIPTION ONLY HERE -->

                    <div class="description-box">

                        <div class="description-heading">

                            <i class="bi bi-file-text"></i>

                            About This Hotel

                        </div>

                        <p id="viewHotelDescription">

                            No description available.

                        </p>

                    </div>


                </div>

            </div>



            <div class="view-modal-footer">

                <button
                    type="button"
                    class="secondary-btn"
                    data-bs-dismiss="modal">

                    Close

                </button>

            </div>


        </div>

    </div>

</div>



<!-- =========================================================
     DELETE MODAL
========================================================= -->

<div
    class="modal fade"
    id="deleteHotelModal"
    tabindex="-1">

    <div class="modal-dialog modal-dialog-centered modal-sm">

        <div class="modal-content glass-modal delete-modal">

            <div class="delete-icon">

                <i class="bi bi-trash3"></i>

            </div>

            <h3>
                Delete Hotel?
            </h3>

            <p>
                Are you sure you want to delete this hotel?
            </p>

            <div class="delete-actions">

                <button
                    type="button"
                    class="secondary-btn"
                    data-bs-dismiss="modal">

                    Cancel

                </button>

                <button
                    type="button"
                    id="confirmDeleteBtn"
                    class="delete-confirm-btn">

                    Delete

                </button>

            </div>

        </div>

    </div>

</div>



<!-- =========================================================
     TOAST
========================================================= -->

<div id="hotelToast" class="hotel-toast">

    <div class="toast-icon">

        <i class="bi bi-check-lg"></i>

    </div>

    <div>

        <strong id="toastTitle">
            Success
        </strong>

        <p id="toastMessage">
            Operation completed.
        </p>

    </div>

</div>



<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>


<script src="${pageContext.request.contextPath}/js/apiConfig.js"></script>
<script src="${pageContext.request.contextPath}/js/Hotels.js"></script>

</body>

</html>