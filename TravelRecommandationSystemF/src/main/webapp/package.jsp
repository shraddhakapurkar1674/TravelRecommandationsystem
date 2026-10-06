<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Package Management</title>


    <!-- Bootstrap -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- Bootstrap Icons -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
        rel="stylesheet">


    <!-- Package CSS -->
    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/package.css">

</head>


<body>


<div class="app-wrapper">


    <!-- =====================================================
         SIDEBAR
    ====================================================== -->

    <jsp:include page="sidebar.jsp" />



    <!-- =====================================================
         MAIN CONTENT
    ====================================================== -->

    <main class="main-content">


        <div class="container-fluid package-page">


            <!-- =================================================
                 HEADER
            ================================================== -->

            <div class="package-header">


                <div>

                    <div class="page-small-title s">
                        PACKAGE MANAGEMENT
                    </div>


                    <h1>

                        <i class="bi bi-box-seam"></i>

                        Travel Packages

                    </h1>


                    <p>
                        Create, manage and organize your travel packages.
                    </p>

                </div>



                <button
                    type="button"
                    class="add-package-btn"
                    data-bs-toggle="modal"
                    data-bs-target="#packageModal"
                    onclick="resetForm()">

                    <i class="bi bi-plus-lg"></i>

                    Add Travel Package

                </button>


            </div>



            <!-- =================================================
                 STATISTICS
            ================================================== -->

            <div class="row g-4 stats-row">


                <!-- TOTAL -->

                <div class="col-xl-4 col-md-4">

                    <div class="stat-card">

                        <div class="stat-icon total-icon">

                            <i class="bi bi-box-seam"></i>

                        </div>


                        <div class="stat-content">

                            <span>
                                Total Packages
                            </span>

                            <h2 id="totalCount">
                                0
                            </h2>

                        </div>

                    </div>

                </div>



                <!-- ACTIVE -->

                <div class="col-xl-4 col-md-4">

                    <div class="stat-card">

                        <div class="stat-icon active-icon">

                            <i class="bi bi-check-circle"></i>

                        </div>


                        <div class="stat-content">

                            <span>
                                Active Packages
                            </span>

                            <h2
                                id="activeCount"
                                class="active-number">

                                0

                            </h2>

                        </div>

                    </div>

                </div>



                <!-- INACTIVE -->

                <div class="col-xl-4 col-md-4">

                    <div class="stat-card">

                        <div class="stat-icon inactive-icon">

                            <i class="bi bi-pause-circle"></i>

                        </div>


                        <div class="stat-content">

                            <span>
                                Inactive Packages
                            </span>

                            <h2
                                id="inactiveCount"
                                class="inactive-number">

                                0

                            </h2>

                        </div>

                    </div>

                </div>


            </div>



            <!-- =================================================
                 SEARCH + FILTER + RESET
            ================================================== -->

            <div class="filter-section">


                <!-- SEARCH -->

                <div class="search-box">

                    <i class="bi bi-search"></i>

                    <input
                        type="text"
                        id="searchInput"
                        placeholder="Search packages...">

                </div>



                <!-- STATUS -->

                <div class="status-box">

                    <i class="bi bi-funnel"></i>

                    <select id="statusFilter">

                        <option value="">
                            All Statuses
                        </option>

                        <option value="Active">
                            Active
                        </option>

                        <option value="Inactive">
                            Inactive
                        </option>

                    </select>

                </div>



                <!-- RESET -->

                <button
                    type="button"
                    class="reset-filter-btn"
                    onclick="resetPackageFilters()">

                    <i class="bi bi-arrow-counterclockwise"></i>

                    Reset

                </button>


            </div>



            <!-- =================================================
                 SECTION TITLE
            ================================================== -->

            <div class="section-heading">


                <div>

                    <span class="section-label">
                        TRAVEL COLLECTION
                    </span>


                   

                </div>


                <span class="package-count-label">
                    Manage your travel packages
                </span>


            </div>



            <!-- =================================================
                 PACKAGE GRID
            ================================================== -->

            <div
                class="row package-grid"
                id="packageGrid">

            </div>


        </div>

    </main>

</div>



<!-- =========================================================
     TOAST
========================================================= -->

<div id="toastContainer"></div>



<!-- =========================================================
     ADD / EDIT PACKAGE MODAL
========================================================= -->

<div
    class="modal fade"
    id="packageModal"
    tabindex="-1"
    aria-hidden="true">


    <div
        class="modal-dialog modal-xl modal-dialog-centered">


        <div class="modal-content package-modal">


            <!-- HEADER -->

            <div class="modal-header">


                <div>

                    <span class="modal-small-title">
                        TRAVEL PACKAGE
                    </span>


                    <h4
                        class="modal-title"
                        id="modalTitle">

                        Add Travel Package

                    </h4>

                </div>


                <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="modal">
                </button>


            </div>



            <!-- BODY -->

            <div class="modal-body">


                <form id="packageForm">


                    <!-- PACKAGE INFORMATION -->

                    <div class="form-section-title">

                        <i class="bi bi-info-circle"></i>

                        Package Information

                    </div>



                    <div class="row g-3">


                        <!-- PACKAGE NAME -->

                        <div class="col-md-6">

                            <label class="custom-label">
                                Package Name
                            </label>


                            <div class="input-wrapper">

                                <i class="bi bi-box"></i>


                                <input
                                    type="text"
                                    id="packageName"
                                    class="form-control custom-input"
                                    placeholder="Enter package name"
                                    required>

                            </div>

                        </div>



                        <!-- DURATION -->

                        <div class="col-md-6">

                            <label class="custom-label">
                                Duration
                            </label>


                            <div class="input-wrapper">

                                <i class="bi bi-calendar3"></i>


                                <input
                                    type="text"
                                    id="duration"
                                    class="form-control custom-input"
                                    placeholder="Example: 5 Days / 4 Nights"
                                    required>

                            </div>

                        </div>



                        <!-- PRICE -->

                        <div class="col-md-6">

                            <label class="custom-label">
                                Price
                            </label>


                            <div class="input-wrapper">

                                <i class="bi bi-currency-rupee"></i>


                                <input
                                    type="number"
                                    id="price"
                                    class="form-control custom-input"
                                    placeholder="Enter package price"
                                    step="0.01"
                                    required>

                            </div>

                        </div>



                        <!-- PACKAGE TYPE -->

                        <div class="col-md-6">

                            <label class="custom-label">
                                Package Type
                            </label>


                            <div class="input-wrapper">

                                <i class="bi bi-tags"></i>


                                <input
                                    type="text"
                                    id="packageType"
                                    class="form-control custom-input"
                                    placeholder="Family / Honeymoon / Adventure">

                            </div>

                        </div>



                        <!-- DESCRIPTION -->

                        <div class="col-12">

                            <label class="custom-label">
                                Description
                            </label>


                            <textarea
                                id="description"
                                class="form-control custom-textarea"
                                rows="3"
                                placeholder="Enter package description"></textarea>

                        </div>



                        <!-- INCLUDED -->

                        <div class="col-md-6">

                            <label class="custom-label">
                                Included Services
                            </label>


                            <textarea
                                id="includedServices"
                                class="form-control custom-textarea"
                                rows="3"
                                placeholder="Hotel, Meals, Transport..."></textarea>

                        </div>



                        <!-- EXCLUDED -->

                        <div class="col-md-6">

                            <label class="custom-label">
                                Excluded Services
                            </label>


                            <textarea
                                id="excludedServices"
                                class="form-control custom-textarea"
                                rows="3"
                                placeholder="Flights, Personal expenses..."></textarea>

                        </div>


                    </div>



                    <!-- =================================================
                         DESTINATION SECTION
                    ================================================== -->

                    <div class="destination-section">


                        <div class="destination-heading">


                            <div>

                                <span class="modal-small-title">
                                    PACKAGE DESTINATIONS
                                </span>


                                <h5>
                                    Destinations & Images
                                </h5>

                            </div>



                            <button
                                type="button"
                                class="add-destination-btn"
                                onclick="addDestinationRow()">

                                <i class="bi bi-plus-lg"></i>

                                Add Destination

                            </button>


                        </div>



                        <div
                            id="destinationsContainer"
                            class="destinations-container">

                        </div>


                    </div>


                </form>


            </div>



            <!-- FOOTER -->

            <div class="modal-footer">


                <button
                    type="button"
                    class="cancel-btn"
                    data-bs-dismiss="modal">

                    Cancel

                </button>



                <button
                    type="button"
                    class="save-package-btn"
                    onclick="savePackage()">

                    <i class="bi bi-check2-circle"></i>

                    Save Package

                </button>


            </div>


        </div>

    </div>

</div>



<!-- =========================================================
     VIEW PACKAGE MODAL
========================================================= -->

<div
    class="modal fade"
    id="viewPackageModal"
    tabindex="-1"
    aria-hidden="true">


    <div
        class="modal-dialog modal-xl modal-dialog-centered">


        <div class="modal-content package-modal">


            <!-- HEADER -->

            <div class="modal-header">


                <div>

                    <span class="modal-small-title">
                        PACKAGE INFORMATION
                    </span>


                    <h4 class="modal-title">
                        Package Details
                    </h4>

                </div>


                <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="modal">
                </button>


            </div>



            <!-- BODY -->

            <div class="modal-body view-modal-body">


                <!-- CAROUSEL -->

                <div
                    id="packageCarousel"
                    class="carousel slide package-carousel">


                    <div
                        class="carousel-indicators"
                        id="carouselIndicators">
                    </div>



                    <div
                        class="carousel-inner"
                        id="carouselInnerImages">
                    </div>



                    <button
                        class="carousel-control-prev"
                        type="button"
                        data-bs-target="#packageCarousel"
                        data-bs-slide="prev">

                        <span
                            class="carousel-control-prev-icon">
                        </span>

                    </button>



                    <button
                        class="carousel-control-next"
                        type="button"
                        data-bs-target="#packageCarousel"
                        data-bs-slide="next">

                        <span
                            class="carousel-control-next-icon">
                        </span>

                    </button>


                </div>



                <!-- TITLE -->

                <div class="view-package-heading">

                    <span class="modal-small-title">
                        TRAVEL PACKAGE
                    </span>


                    <h2 id="viewPkgName">
                    </h2>

                </div>



                <!-- DETAILS -->

                <div class="row g-3">


                    <div class="col-md-4">

                        <div class="detail-box">

                            <div class="detail-icon purple">

                                <i class="bi bi-calendar3"></i>

                            </div>


                            <div>

                                <span>
                                    Duration
                                </span>


                                <strong id="viewDuration">
                                </strong>

                            </div>

                        </div>

                    </div>



                    <div class="col-md-4">

                        <div class="detail-box">

                            <div class="detail-icon green">

                                <i class="bi bi-currency-rupee"></i>

                            </div>


                            <div>

                                <span>
                                    Price
                                </span>


                                <strong id="viewPrice">
                                </strong>

                            </div>

                        </div>

                    </div>



                    <div class="col-md-4">

                        <div class="detail-box">

                            <div class="detail-icon orange">

                                <i class="bi bi-tags"></i>

                            </div>


                            <div>

                                <span>
                                    Package Type
                                </span>


                                <strong id="viewType">
                                </strong>

                            </div>

                        </div>

                    </div>


                </div>



                <!-- DESCRIPTION -->

                <div class="view-info-box">

                    <span>
                        DESCRIPTION
                    </span>


                    <p id="viewDescription">
                    </p>

                </div>



                <!-- SERVICES -->

                <div class="row g-3">


                    <div class="col-md-6">

                        <div class="service-box included-box">

                            <span>

                                <i class="bi bi-check-circle"></i>

                                INCLUDED SERVICES

                            </span>


                            <p id="viewIncluded">
                            </p>

                        </div>

                    </div>



                    <div class="col-md-6">

                        <div class="service-box excluded-box">

                            <span>

                                <i class="bi bi-x-circle"></i>

                                EXCLUDED SERVICES

                            </span>


                            <p id="viewExcluded">
                            </p>

                        </div>

                    </div>


                </div>


            </div>



            <!-- FOOTER -->

            <div class="modal-footer">


                <button
                    type="button"
                    class="cancel-btn"
                    data-bs-dismiss="modal">

                    Close

                </button>


            </div>


        </div>

    </div>

</div>



<!-- =========================================================
     BOOTSTRAP JS
========================================================= -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js">
</script>



<!-- =========================================================
     EXISTING PACKAGE JS
========================================================= -->

<script src="${pageContext.request.contextPath}/js/apiConfig.js"></script>
<script src="${pageContext.request.contextPath}/js/package.js"></script>

</body>

</html>