<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Transport Management</title>

    <!-- Bootstrap -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
        rel="stylesheet">

    <!-- Transport CSS -->
    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/transport.css">
</head>

<body>

<div class="transport-page">

    <!-- =====================================================
         SIDEBAR
    ====================================================== -->
    <aside class="sidebar-wrapper">
        <jsp:include page="sidebar.jsp"/>
    </aside>

    <!-- =====================================================
         MAIN CONTENT
    ====================================================== -->
    <main class="main-content">

        <!-- TOP HEADER -->
        <header class="top-header">
            <div>
                <span class="page-kicker">
                    TRAVEL MANAGEMENT
                </span>
                <h1>
                    Transport Management
                </h1>
                <p>
                    Manage transportation options, routes and providers.
                </p>
            </div>

            <button
                type="button"
                class="add-transport-btn"
                onclick="openAddModal()">
                <i class="bi bi-plus-lg"></i>
                <span>Add Transport</span>
            </button>
        </header>

        <!-- =================================================
             STATISTICS
        ================================================== -->
        <section class="statistics-grid">

            <div class="stat-card">
                <div class="stat-icon purple">
                    <i class="bi bi-bus-front-fill"></i>
                </div>
                <div>
                    <span class="stat-label">
                        Total Transport
                    </span>
                    <strong id="totalTransport">
                        0
                    </strong>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon green">
                    <i class="bi bi-check-circle-fill"></i>
                </div>
                <div>
                    <span class="stat-label">
                        Active
                    </span>
                    <strong id="activeTransport">
                        0
                    </strong>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon red">
                    <i class="bi bi-x-circle-fill"></i>
                </div>
                <div>
                    <span class="stat-label">
                        Inactive
                    </span>
                    <strong id="inactiveTransport">
                        0
                    </strong>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon blue">
                    <i class="bi bi-signpost-split-fill"></i>
                </div>
                <div>
                    <span class="stat-label">
                        Total Routes
                    </span>
                    <strong id="totalRoutes">
                        0
                    </strong>
                </div>
            </div>

        </section>

        <!-- =================================================
             FILTER BAR
        ================================================== -->
        <section class="filter-glass-card">

            <div class="filter-search">
                <i class="bi bi-search"></i>
                <input
                    type="text"
                    id="searchInput"
                    placeholder="Search route, provider, transport..."
                    oninput="searchTransport()">
            </div>

            <div class="filter-select">
                <i class="bi bi-circle-half"></i>
                <select
                    id="statusFilter"
                    onchange="filterTransport()">
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

            <div class="filter-select">
                <i class="bi bi-bus-front"></i>
                <select
                    id="typeFilter"
                    onchange="filterTransport()">
                    <option value="">
                        All Types
                    </option>
                    <option value="Bus">
                        Bus
                    </option>
                    <option value="Train">
                        Train
                    </option>
                    <option value="Flight">
                        Flight
                    </option>
                    <option value="Cab">
                        Cab
                    </option>
                    <option value="Car">
                        Car
                    </option>
                </select>
            </div>

            <button
                type="button"
                class="reset-btn"
                onclick="resetFilters()">
                <i class="bi bi-arrow-clockwise"></i>
                Reset
            </button>

        </section>

        <!-- =================================================
             LOADING
        ================================================== -->
        <div
            id="loading"
            class="loading-state d-none">
            <div class="spinner-border"></div>
            <span>
                Loading transport data...
            </span>
        </div>

        <!-- =================================================
             TRANSPORT GRID
        ================================================== -->
        <section
            id="transportGrid"
            class="transport-grid">
        </section>

        <!-- =================================================
             EMPTY STATE
        ================================================== -->
        <section
            id="emptyState"
            class="empty-state d-none">
            <div class="empty-icon">
                <i class="bi bi-bus-front"></i>
            </div>
            <h3>
                No Transport Found
            </h3>
            <p>
                No transport records match your current search or filters.
            </p>
            <button
                type="button"
                onclick="openAddModal()"
                class="empty-add-btn">
                <i class="bi bi-plus-lg"></i>
                Add Transport
            </button>
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
     ADD / EDIT MODAL
========================================================== -->
<div
    class="modal fade"
    id="transportModal"
    tabindex="-1"
    aria-hidden="true">

    <div
        class="modal-dialog modal-dialog-centered modal-xl">

        <div class="modal-content glass-modal">

            <!-- MODAL HEADER -->
            <div class="modal-header modern-modal-header">
                <div class="modal-title-area">
                    <div class="modal-title-icon">
                        <i class="bi bi-bus-front-fill"></i>
                    </div>
                    <div>
                        <span>
                            TRANSPORT MANAGEMENT
                        </span>
                        <h2 id="modalTitle">
                            Add Transport
                        </h2>
                    </div>
                </div>

                <button
                    type="button"
                    class="btn-close custom-close"
                    data-bs-dismiss="modal">
                </button>
            </div>

            <!-- FORM -->
            <form
                id="transportForm"
                enctype="multipart/form-data">

                <div class="modal-body">

                    <input
                        type="hidden"
                        id="transportId"
                        name="transportId">

                    <div class="form-section-title">
                        <i class="bi bi-signpost-split-fill"></i>
                        Route Information
                    </div>

                    <div class="form-grid">

                        <div class="form-group">
                            <label for="fromLocation">
                                From Location
                                <span>*</span>
                            </label>
                            <div class="input-wrapper">
                                <i class="bi bi-geo-alt"></i>
                                <input
                                    type="text"
                                    id="fromLocation"
                                    name="fromLocation"
                                    placeholder="Enter departure location"
                                    required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="toLocation">
                                To Location
                                <span>*</span>
                            </label>
                            <div class="input-wrapper">
                                <i class="bi bi-geo-alt-fill"></i>
                                <input
                                    type="text"
                                    id="toLocation"
                                    name="toLocation"
                                    placeholder="Enter destination"
                                    required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="transportType">
                                Transport Type
                                <span>*</span>
                            </label>
                            <div class="input-wrapper">
                                <i class="bi bi-bus-front"></i>
                                <select
                                    id="transportType"
                                    name="transportType"
                                    required>
                                    <option value="">
                                        Select Transport Type
                                    </option>
                                    <option value="Bus">
                                        Bus
                                    </option>
                                    <option value="Train">
                                        Train
                                    </option>
                                    <option value="Flight">
                                        Flight
                                    </option>
                                    <option value="Cab">
                                        Cab
                                    </option>
                                    <option value="Car">
                                        Car
                                    </option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="transportProvider">
                                Transport Provider
                                <span>*</span>
                            </label>
                            <div class="input-wrapper">
                                <i class="bi bi-building"></i>
                                <input
                                    type="text"
                                    id="transportProvider"
                                    name="transportProvider"
                                    placeholder="Enter provider name"
                                    required>
                            </div>
                        </div>

                    </div>

                    <!-- PRICING -->
                    <div class="form-section-title pricing-title">
                        <i class="bi bi-cash-stack"></i>
                        Pricing Information
                    </div>

                    <div class="form-grid">

                        <div class="form-group">
                            <label for="pricingType">
                                Pricing Type
                            </label>
                            <div class="input-wrapper">
                                <i class="bi bi-tag"></i>
                                <select
                                    id="pricingType"
                                    name="pricingType">
                                    <option value="">
                                        Select Pricing Type
                                    </option>
                                    <option value="Per Person">
                                        Per Person
                                    </option>
                                    <option value="Per Seat">
                                        Per Seat
                                    </option>
                                    <option value="Per Trip">
                                        Per Trip
                                    </option>
                                    <option value="Starting From">
                                        Starting From
                                    </option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="pricingValue">
                                Pricing Value
                            </label>
                            <div class="input-wrapper">
                                <i class="bi bi-currency-rupee"></i>
                                <input
                                    type="number"
                                    id="pricingValue"
                                    name="pricingValue"
                                    min="0"
                                    step="0.01"
                                    placeholder="Enter price">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="facilityCharge">
                                Facility Charge
                            </label>
                            <div class="input-wrapper">
                                <i class="bi bi-wallet2"></i>
                                <input
                                    type="number"
                                    id="facilityCharge"
                                    name="facilityCharge"
                                    min="0"
                                    step="0.01"
                                    value="0"
                                    placeholder="Enter facility charge">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="status">
                                Status
                            </label>
                            <div class="input-wrapper">
                                <i class="bi bi-toggle-on"></i>
                                <select
                                    id="status"
                                    name="status">
                                    <option value="ACTIVE">
                                        Active
                                    </option>
                                    <option value="INACTIVE">
                                        Inactive
                                    </option>
                                </select>
                            </div>
                        </div>

                    </div>

                    <!-- FACILITIES -->
                    <div class="form-section-title">
                        <i class="bi bi-stars"></i>
                        Facilities
                    </div>

                    <div class="form-group full-width">
                        <label for="facilities">
                            Available Facilities
                        </label>
                        <div class="textarea-wrapper">
                            <i class="bi bi-list-stars"></i>
                            <textarea
                                id="facilities"
                                name="facilities"
                                rows="3"
                                placeholder="Example: WiFi, AC, Charging Port, Comfortable Seats..."></textarea>
                        </div>
                    </div>

                    <!-- IMAGE -->
                    <div class="form-section-title">
                        <i class="bi bi-image"></i>
                        Transport Image
                    </div>

                    <div class="image-upload-layout">

                        <div class="image-upload-box">
                            <input
                                type="file"
                                id="imageFile"
                                name="imageFile"
                                accept="image/*"
                                onchange="previewImage(event)">
                            <label for="imageFile">
                                <div class="upload-icon">
                                    <i class="bi bi-cloud-arrow-up-fill"></i>
                                </div>
                                <strong>
                                    Upload Transport Image
                                </strong>
                                <span>
                                    JPG, PNG, WEBP · Maximum 10MB
                                </span>
                                <div class="upload-button">
                                    <i class="bi bi-folder2-open"></i>
                                    Choose Image
                                </div>
                            </label>
                        </div>

                        <div
                            id="imagePreview"
                            class="image-preview">
                            <i class="bi bi-image"></i>
                            <span>
                                Image Preview
                            </span>
                        </div>

                    </div>

                </div>

                <!-- MODAL FOOTER -->
                <div class="modern-modal-footer">
                    <button
                        type="button"
                        class="cancel-btn"
                        data-bs-dismiss="modal">
                        <i class="bi bi-x-lg"></i>
                        Cancel
                    </button>
                    <button
                        type="submit"
                        class="save-btn">
                        <i class="bi bi-check2-circle"></i>
                        <span id="saveButtonText">
                            Save Transport
                        </span>
                    </button>
                </div>

            </form>

        </div>

    </div>

</div>


<!-- =========================================================
     VIEW MODAL
========================================================== -->
<div
    class="modal fade"
    id="viewTransportModal"
    tabindex="-1"
    aria-hidden="true">

    <div
        class="modal-dialog modal-dialog-centered modal-xl">

        <div class="modal-content view-glass-modal">

            <div class="view-modal-header">
                <div>
                    <span>
                        TRANSPORT INFORMATION
                    </span>
                    <h2>
                        Transport Details
                    </h2>
                </div>
                <button
                    type="button"
                    class="btn-close custom-close"
                    data-bs-dismiss="modal">
                </button>
            </div>

            <div
                id="viewTransportContent"
                class="view-modal-body">
            </div>

            <div class="view-modal-footer">
                <button
                    type="button"
                    class="view-close-btn"
                    data-bs-dismiss="modal">
                    <i class="bi bi-x-lg"></i>
                    Close
                </button>
            </div>

        </div>

    </div>

</div>


<!-- =========================================================
     DELETE MODAL
========================================================== -->
<div
    class="modal fade"
    id="deleteModal"
    tabindex="-1"
    aria-hidden="true">

    <div
        class="modal-dialog modal-dialog-centered">

        <div class="modal-content delete-glass-modal">

            <div class="delete-icon">
                <i class="bi bi-trash3-fill"></i>
            </div>

            <h3>
                Delete Transport?
            </h3>

            <p>
                Are you sure you want to delete this transport record?
                This action cannot be undone.
            </p>

            <input
                type="hidden"
                id="deleteTransportId">

            <div class="delete-actions">
                <button
                    type="button"
                    class="delete-cancel-btn"
                    data-bs-dismiss="modal">
                    Cancel
                </button>
                <button
                    type="button"
                    class="delete-confirm-btn"
                    onclick="confirmDelete()">
                    <i class="bi bi-trash3"></i>
                    Delete
                </button>
            </div>

        </div>

    </div>

</div>


<!-- =========================================================
     TOAST
========================================================== -->
<div
    id="toastContainer"
    class="toast-container-custom">
</div>

<!-- Bootstrap JS -->
<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

<!-- Transport JS -->
<script src="${pageContext.request.contextPath}/js/apiConfig.js"></script>
<script src="${pageContext.request.contextPath}/js/transport.js"></script>

</body>
</html>