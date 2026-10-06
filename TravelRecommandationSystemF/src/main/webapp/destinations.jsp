<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Destination Management</title>


    <!-- =====================================================
         GOOGLE FONT
    ====================================================== -->

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">


    <!-- =====================================================
         BOOTSTRAP
    ====================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- =====================================================
         FONT AWESOME
    ====================================================== -->

    <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


    <!-- =====================================================
         DESTINATION CSS
    ====================================================== -->

    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/destinations.css">

</head>


<body>


<!-- =========================================================
     MAIN APPLICATION
========================================================= -->

<div class="app-layout">


    <!-- SIDEBAR -->

    <jsp:include page="sidebar.jsp"></jsp:include>


    <!-- =====================================================
         MAIN
    ====================================================== -->

    <main class="main-wrapper">


        <!-- =================================================
             PAGE HEADER
        ================================================== -->

        <div class="destination-page-header">


            <div>


                <!-- BREADCRUMB -->

                <div class="destination-breadcrumb">

                    <span>ADMIN</span>

                    <i class="fas fa-chevron-right"></i>

                    <span>DESTINATIONS</span>

                </div>


                <!-- TITLE -->

                <h2>
                    Destination Management
                </h2>


                <p>
                    Manage travel destinations,
                    locations and travel information.
                </p>


            </div>


            <!-- ADD BUTTON -->

            <button
                type="button"
                class="add-destination-btn"
                onclick="openAddModal()"
                title="Add Destination">

                <i class="fas fa-plus"></i>

            </button>


        </div>



        <!-- =================================================
             SEARCH / FILTER
        ================================================== -->

        <div class="table-card p-3 mb-4">


            <div class="row g-3 align-items-center">


                <!-- SEARCH -->

                <div class="col-12 col-md-5">

                    <div class="input-group">

                        <span
                            class="input-group-text bg-transparent border-end-0">

                            <i class="fas fa-search text-muted"></i>

                        </span>


                        <input
                            type="text"
                            id="searchInput"
                            class="form-control border-start-0"
                            placeholder="Search destination or state...">

                    </div>

                </div>



                <!-- COUNTRY -->

                <div class="col-12 col-md-3">

                    <select
                        id="countryFilter"
                        class="form-select">

                        <option value="">
                            All Countries
                        </option>

                        <option value="India">
                            India
                        </option>

                        <option value="USA">
                            USA
                        </option>

                        <option value="UK">
                            UK
                        </option>

                        <option value="UAE">
                            UAE
                        </option>

                    </select>

                </div>



                <!-- STATUS -->

                <div class="col-12 col-md-2">

                    <select
                        id="statusFilter"
                        class="form-select">

                        <option value="">
                            All Status
                        </option>

                        <option value="ACTIVE">
                            Active
                        </option>

                        <option value="INACTIVE">
                            Inactive
                        </option>

                    </select>

                </div>



                <!-- DESTINATION COUNT -->

                <div class="col-12 col-md-2 text-md-end">

                    <span
                        class="badge rounded-pill bg-light text-dark px-3 py-2">

                        <i class="fas fa-location-dot me-1"></i>

                        Destinations

                    </span>

                </div>


            </div>

        </div>



        <!-- =================================================
             DESTINATION GRID
        ================================================== -->

        <div
            id="destinationsGrid"
            class="row g-4">

            <!-- JavaScript cards -->

        </div>



        <!-- =================================================
             PAGINATION
        ================================================== -->

        <div
            class="d-flex
                   flex-column
                   flex-md-row
                   justify-content-between
                   align-items-center
                   gap-3
                   mt-4">


            <!-- INFORMATION -->

            <div
                id="paginationInfo"
                class="text-muted fs-8">

                Showing 0 results

            </div>



            <!-- PAGINATION -->

            <nav aria-label="Destination pagination">

                <ul
                    id="paginationContainer"
                    class="pagination mb-0 gap-1">

                </ul>

            </nav>


        </div>


    </main>

</div>



<!-- =========================================================
     ADD / EDIT DESTINATION MODAL
========================================================= -->

<div
    class="modal fade"
    id="destinationFormModal"
    tabindex="-1"
    aria-hidden="true">


    <div
        class="modal-dialog modal-dialog-centered modal-xl">


        <div class="modal-content glass-modal">


            <!-- =================================================
                 HEADER
            ================================================== -->

            <div class="destination-modal-header">


                <div class="d-flex align-items-center gap-3">


                    <div class="destination-modal-icon">

                        <i class="fas fa-map-location-dot"></i>

                    </div>


                    <div>

                        <h4
                            id="formModalTitle"
                            class="fw-bold mb-1">

                            Add New Destination

                        </h4>


                        <p
                            id="formModalSubtitle"
                            class="text-muted small mb-0">

                            Create a new destination
                            with travel information
                            and a beautiful cover image.

                        </p>

                    </div>


                    <button
                        type="button"
                        class="btn-close ms-auto"
                        data-bs-dismiss="modal">
                    </button>


                </div>

            </div>



            <!-- =================================================
                 BODY
            ================================================== -->

            <div class="modal-body p-4">


                <form
                    id="destinationForm"
                    onsubmit="event.preventDefault(); saveDestination();">


                    <input
                        type="hidden"
                        id="destId">


                    <div class="row g-4">


                        <!-- =================================================
                             LEFT FORM
                        ================================================== -->

                        <div class="col-lg-7">


                            <div class="destination-form-section">


                                <div class="row g-3">


                                    <!-- NAME -->

                                    <div class="col-md-6">

                                        <label class="form-label fw-semibold">

                                            Destination Name
                                            <span class="text-danger">*</span>

                                        </label>

                                        <div class="input-glass-group">

                                            <input
                                                type="text"
                                                id="destName"
                                                class="form-control"
                                                placeholder="e.g. Goa">

                                        </div>

                                    </div>



                                    <!-- STATE -->

                                    <div class="col-md-6">

                                        <label class="form-label fw-semibold">

                                            State / Region
                                            <span class="text-danger">*</span>

                                        </label>

                                        <div class="input-glass-group">

                                            <input
                                                type="text"
                                                id="destState"
                                                class="form-control"
                                                placeholder="e.g. Maharashtra">

                                        </div>

                                    </div>



                                    <!-- COUNTRY -->

                                    <div class="col-md-6">

                                        <label class="form-label fw-semibold">

                                            Country
                                            <span class="text-danger">*</span>

                                        </label>

                                        <div class="input-glass-group">

                                            <input
                                                type="text"
                                                id="destCountry"
                                                class="form-control"
                                                placeholder="e.g. India">

                                        </div>

                                    </div>



                                    <!-- CATEGORY -->

                                    <div class="col-md-6">

                                        <label class="form-label fw-semibold">

                                            Category
                                            <span class="text-danger">*</span>

                                        </label>

                                        <div class="input-glass-group">

                                            <select
                                                id="destCategory"
                                                class="form-select">


                                                <option value="Mountains">
                                                    Mountains
                                                </option>

                                                <option value="Beach">
                                                    Beach
                                                </option>

                                                <option value="Heritage">
                                                    Heritage
                                                </option>

                                                <option value="Nature">
                                                    Nature
                                                </option>

                                                <option value="Adventure">
                                                    Adventure
                                                </option>

                                                <option value="City">
                                                    City & Urban
                                                </option>

                                                <option value="Wildlife">
                                                    Wildlife
                                                </option>

                                                <option value="Spiritual">
                                                    Spiritual
                                                </option>

                                                <option value="Island">
                                                    Island
                                                </option>

                                                <option value="Desert">
                                                    Desert
                                                </option>

                                                <option value="Hillstation">
                                                    Hill Station
                                                </option>

                                                <option value="Cultural">
                                                    Cultural
                                                </option>


                                            </select>

                                        </div>

                                    </div>



                                    <!-- BUDGET -->

                                    <div class="col-md-6">

                                        <label class="form-label fw-semibold">

                                            Estimated Budget
                                            <span class="text-danger">*</span>

                                        </label>


                                        <div class="input-glass-group">

                                            <div class="input-group">

                                                <span
                                                    class="input-group-text bg-transparent border-end-0">

                                                    ₹

                                                </span>


                                                <input
                                                    type="number"
                                                    id="destBudget"
                                                    class="form-control border-start-0"
                                                    min="0"
                                                    step="0.01"
                                                    placeholder="25000">

                                            </div>

                                        </div>

                                    </div>



                                    <!-- SEASON -->

                                    <div class="col-md-6">

                                        <label class="form-label fw-semibold">

                                            Best Season
                                            <span class="text-danger">*</span>

                                        </label>

                                        <div class="input-glass-group">

                                            <input
                                                type="text"
                                                id="destSeason"
                                                class="form-control"
                                                placeholder="e.g. October - March">

                                        </div>

                                    </div>



                                    <!-- STATUS -->

                                    <div class="col-md-6">

                                        <label class="form-label fw-semibold">

                                            Status

                                        </label>

                                        <div class="input-glass-group">

                                            <select
                                                id="destStatus"
                                                class="form-select">

                                                <option value="ACTIVE">
                                                    Active
                                                </option>

                                                <option value="INACTIVE">
                                                    Inactive
                                                </option>

                                            </select>

                                        </div>

                                    </div>



                                    <!-- DESCRIPTION -->

                                    <div class="col-12">

                                        <label class="form-label fw-semibold">

                                            Description
                                            <span class="text-danger">*</span>

                                        </label>

                                        <div class="input-glass-group">

                                            <textarea
                                                id="destDescription"
                                                class="form-control"
                                                rows="5"
                                                placeholder="Enter destination description..."></textarea>

                                        </div>

                                    </div>


                                </div>

                            </div>

                        </div>



                        <!-- =================================================
                             RIGHT IMAGE
                        ================================================== -->

                        <div class="col-lg-5">


                            <div class="destination-image-section">


                                <label class="form-label fw-semibold">

                                    Destination Image

                                </label>


                                <!-- UPLOAD -->

                                <div
                                    class="custom-file-upload"
                                    onclick="document.getElementById('destImageFile').click();">


                                    <div class="upload-icon">

                                        <i class="fas fa-cloud-arrow-up"></i>

                                    </div>


                                    <h6 class="fw-bold mb-1">

                                        Upload Destination Image

                                    </h6>


                                    <p
                                        class="text-muted small mb-1">

                                        JPG, JPEG, PNG or WEBP

                                    </p>


                                    <span
                                        id="fileNameDisplay"
                                        class="text-muted fs-8">

                                    </span>


                                    <input
                                        type="file"
                                        id="destImageFile"
                                        accept="image/*"
                                        class="d-none"
                                        onchange="previewSelectedFileName(this);">


                                </div>



                                <!-- PREVIEW -->

                                <img
                                    id="imagePreview"
                                    class="destination-image-preview"
                                    src=""
                                    alt="Destination Preview">



                                <!-- IMAGE INFO -->

                                <div class="image-upload-info mt-3">

                                    <strong>

                                        <i class="fas fa-circle-info me-1"></i>

                                        Image Recommendation

                                    </strong>

                                    Use a high-quality landscape
                                    destination image for better
                                    card and view display.

                                </div>

                           </div>

                        </div>

                    </div>

                </form>

            </div>
            <!-- =================================================
                 FOOTER
            ================================================== -->

            <div
                class="modal-footer
                       border-0
                       px-4
                       pb-4">


                <button
                    type="button"
                    class="btn btn-light rounded-3 px-4"
                    data-bs-dismiss="modal">

                    Cancel

                </button>


                <button
                    type="button"
                    class="btn btn-primary rounded-3 px-4"
                    onclick="saveDestination()">

                    <i class="fas fa-save me-2"></i>

                    Save Destination

                </button>


            </div>


        </div>

    </div>

</div>



<!-- =========================================================
     VIEW DESTINATION MODAL
========================================================= -->

<div
    class="modal fade"
    id="viewDestinationModal"
    tabindex="-1"
    aria-hidden="true">


    <div
        class="modal-dialog modal-dialog-centered modal-xl">


        <div class="modal-content glass-modal">


            <div class="view-modal-body">


                <div class="view-layout mt-5">


                    <!-- =================================================
                         LEFT IMAGE
                    ================================================== -->

                    <div class="view-image-side p-5">


                        <img
                            id="viewImage"
                            class="view-hero-img m-2 ps-3"
                            src=""
                            alt="Destination">


                        <!-- OVERLAY -->

                        <div
                            class="view-hero-overlay">
                        </div>


                        <!-- CLOSE -->

                        <button
                            type="button"
                            class="view-close-btn"
                            data-bs-dismiss="modal"
                            aria-label="Close">

                            <i class="fas fa-xmark"></i>

                        </button>


                        <!-- IMAGE CONTENT -->

                        <div class="view-image-content">


                            <span
                                id="viewCategory"
                                class="badge-cat">

                                General

                            </span>


                            <h2 id="viewName">

                                Destination

                            </h2>


                            <p id="viewLocation">

                                <i class="fas fa-location-dot me-1"></i>

                                Location

                            </p>


                        </div>


                    </div>



                    <!-- =================================================
                         RIGHT INFORMATION
                    ================================================== -->

                    <div class="view-info-side">


                        <!-- HEADER -->

                        <div class="view-info-header">

                            <span class="small-label">

                                Destination Information

                            </span>


                            <h3 id="viewNameRight">

                                Destination

                            </h3>


                            <p>

                                Complete travel information
                                and destination details.

                            </p>

                        </div>



                        <!-- INFO GRID -->

                        <div class="view-info-grid">


                            <!-- BUDGET -->

                            <div class="view-info-box">

                                <div class="info-icon">

                                    <i class="fas fa-wallet"></i>

                                </div>


                                <small>

                                    Estimated Budget

                                </small>


                                <strong id="viewBudget">

                                    N/A

                                </strong>

                            </div>



                            <!-- SEASON -->

                            <div class="view-info-box">

                                <div class="info-icon">

                                    <i class="fas fa-calendar-days"></i>

                                </div>


                                <small>

                                    Best Season

                                </small>


                                <strong id="viewSeason">

                                    N/A

                                </strong>

                            </div>



                            <!-- COUNTRY -->

                            <div class="view-info-box">

                                <div class="info-icon">

                                    <i class="fas fa-earth-americas"></i>

                                </div>


                                <small>

                                    Country

                                </small>


                                <strong id="viewCountry">

                                    N/A

                                </strong>

                            </div>



                            <!-- STATUS -->

                            <div class="view-info-box">

                                <div class="info-icon">

                                    <i class="fas fa-circle-check"></i>

                                </div>


                                <small>

                                    Status

                                </small>


                                <strong id="viewStatus">

                                    Active

                                </strong>

                            </div>


                        </div>



                        <!-- DESCRIPTION -->

                        <div class="view-description-box">


                            <div class="view-description-title">

                                <i class="fas fa-align-left"></i>

                                About Destination

                            </div>


                            <p id="viewDescription">

                                No description provided.

                            </p>


                        </div>


                    </div>


                </div>


            </div>



            <!-- FOOTER -->

            <div
                class="modal-footer
                       border-0
                       px-4
                       pb-4">

                <button
                    type="button"
                    class="btn btn-light rounded-3 px-4"
                    data-bs-dismiss="modal">

                    Close

                </button>

            </div>


        </div>

    </div>

</div>



<!-- =========================================================
     DELETE DESTINATION CONFIRMATION MODAL
========================================================= -->

<div
    class="modal fade"
    id="deleteDestinationModal"
    tabindex="-1"
    aria-hidden="true">

    <div class="modal-dialog modal-dialog-centered">

        <div class="modal-content glass-modal">

            <div class="modal-header border-0 px-4 pt-4">

                <div>
                    <h5 class="modal-title fw-bold">
                        <i class="fas fa-triangle-exclamation text-danger me-2"></i>
                        Delete Destination
                    </h5>

                    <p class="text-muted mb-0 mt-1">
                        Please confirm this action.
                    </p>
                </div>

                <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="modal"
                    aria-label="Close">
                </button>

            </div>

            <div class="modal-body px-4 py-3">

                <div class="text-center py-3">

                    <div class="mb-3" style="font-size: 48px;">
                        <i class="fas fa-trash-can text-danger"></i>
                    </div>

                    <h5 class="fw-bold">
                        Are you sure?
                    </h5>

                    <p class="text-muted mb-2">
                        You are about to delete:
                    </p>

                    <div
                        id="deleteDestinationName"
                        class="fw-bold fs-5">
                        this destination
                    </div>

                    <p class="text-danger small mt-3 mb-0">
                        This action cannot be undone.
                    </p>

                </div>

            </div>

            <div class="modal-footer border-0 px-4 pb-4">

                <button
                    type="button"
                    class="btn btn-light rounded-3 px-4"
                    data-bs-dismiss="modal">
                    Cancel
                </button>

                <button
                    type="button"
                    id="confirmDeleteDestinationBtn"
                    class="btn btn-danger rounded-3 px-4">
                    <i class="fas fa-trash me-2"></i>
                    Delete
                </button>

            </div>

        </div>

    </div>

</div>


<!-- =========================================================
     TOAST
========================================================= -->

<div
    class="toast-container
           position-fixed
           top-0
           end-0
           p-3"
    style="z-index: 9999;">


    <div
        id="appToast"
        class="toast align-items-center
               text-white
               border-0"
        role="alert"
        aria-live="assertive"
        aria-atomic="true">


        <div class="d-flex">


            <div
                id="toastMessage"
                class="toast-body">

                Operation completed.

            </div>


            <button
                type="button"
                class="btn-close
                       btn-close-white
                       me-2
                       m-auto"
                data-bs-dismiss="toast">
            </button>


        </div>

    </div>

</div>

<!-- =========================================================
     BOOTSTRAP JS
========================================================= -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

<!-- =========================================================
     DESTINATION JS
========================================================= -->

<script src="${pageContext.request.contextPath}/js/apiConfig.js"></script>
<script src="${pageContext.request.contextPath}/js/destination.js"></script>

</body>

</html>