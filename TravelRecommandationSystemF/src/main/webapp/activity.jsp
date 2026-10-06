<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Activity Management</title>

    <!-- Bootstrap -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
        rel="stylesheet">

    <!-- Activity CSS -->
    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/activity.css">
</head>

<body>

<div class="activity-page">

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

        <!-- HEADER -->
        <header class="top-header">
            <div>
                <span class="page-kicker">
                    TRAVEL MANAGEMENT
                </span>
                <h1>
                    Activity Management
                </h1>
                <p>
                    Manage activities, experiences and destination attractions.
                </p>
            </div>

            <button
                type="button"
                class="add-activity-btn"
                onclick="openAddModal()">
                <i class="bi bi-plus-lg"></i>
                <span>Add Activity</span>
            </button>
        </header>

        <!-- =================================================
             STATISTICS
        ================================================== -->
        <section class="statistics-grid">

            <div class="stat-card">
                <div class="stat-icon purple">
                    <i class="bi bi-stars"></i>
                </div>
                <div>
                    <span class="stat-label">
                        Total Activities
                    </span>
                    <strong id="totalActivity">
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
                    <strong id="activeActivity">
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
                    <strong id="inactiveActivity">
                        0
                    </strong>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon blue">
                    <i class="bi bi-geo-alt-fill"></i>
                </div>
                <div>
                    <span class="stat-label">
                        Destinations
                    </span>
                    <strong id="totalDestinations">
                        0
                    </strong>
                </div>
            </div>

        </section>

        <!-- =================================================
             FILTER
        ================================================== -->
        <section class="filter-glass-card">

            <div class="filter-search">
                <i class="bi bi-search"></i>
                <input
                    type="text"
                    id="searchInput"
                    placeholder="Search activity, location, destination..."
                    oninput="searchActivity()">
            </div>

            <div class="filter-select">
                <i class="bi bi-circle-half"></i>
                <select
                    id="statusFilter"
                    onchange="filterActivity()">
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
                <i class="bi bi-stars"></i>
                <select
                    id="typeFilter"
                    onchange="filterActivity()">
                    <option value="">
                        All Types
                    </option>
                    <option value="Adventure">
                        Adventure
                    </option>
                    <option value="Water Sports">
                        Water Sports
                    </option>
                    <option value="Sightseeing">
                        Sightseeing
                    </option>
                    <option value="Cultural">
                        Cultural
                    </option>
                    <option value="Wildlife">
                        Wildlife
                    </option>
                    <option value="Entertainment">
                        Entertainment
                    </option>
                    <option value="Trekking">
                        Trekking
                    </option>
                    <option value="Shopping">
                        Shopping
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

        <!-- LOADING -->
        <div
            id="loading"
            class="loading-state d-none">
            <div class="spinner-border"></div>
            <span>
                Loading activity data...
            </span>
        </div>

        <!-- ACTIVITY GRID -->
        <section
            id="activityGrid"
            class="activity-grid">
        </section>

        <!-- EMPTY -->
        <section
            id="emptyState"
            class="empty-state d-none">
            <div class="empty-icon">
                <i class="bi bi-stars"></i>
            </div>
            <h3>
                No Activity Found
            </h3>
            <p>
                No activities match your current search or filters.
            </p>
            <button
                type="button"
                onclick="openAddModal()"
                class="empty-add-btn">
                <i class="bi bi-plus-lg"></i>
                Add Activity
            </button>
        </section>

        <!-- PAGINATION -->
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
    id="activityModal"
    tabindex="-1"
    aria-hidden="true">

    <div
        class="modal-dialog modal-dialog-centered modal-xl">

        <div class="modal-content glass-modal">

            <!-- HEADER -->
            <div class="modal-header modern-modal-header">
                <div class="modal-title-area">
                    <div class="modal-title-icon">
                        <i class="bi bi-stars"></i>
                    </div>
                    <div>
                        <span>
                            ACTIVITY MANAGEMENT
                        </span>
                        <h2 id="modalTitle">
                            Add Activity
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
                id="activityForm"
                enctype="multipart/form-data">

                <div class="modal-body">

                    <input
                        type="hidden"
                        id="activityId"
                        name="activityId">

                    <!-- DESTINATION -->
                    <div class="form-section-title">
                        <i class="bi bi-geo-alt-fill"></i>
                        Destination Information
                    </div>

                    <div class="form-grid">

                        <div class="form-group">
                            <label for="destinationId">
                                Destination
                                <span>*</span>
                            </label>
                            <div class="input-wrapper">
                                <i class="bi bi-geo-alt"></i>
                                <select
                                    id="destinationId"
                                    name="destinationId"
                                    required>
                                    <option value="">
                                        Select Destination
                                    </option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="activityName">
                                Activity Name
                                <span>*</span>
                            </label>
                            <div class="input-wrapper">
                                <i class="bi bi-stars"></i>
                                <input
                                    type="text"
                                    id="activityName"
                                    name="activityName"
                                    placeholder="Enter activity name"
                                    required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="activityType">
                                Activity Type
                                <span>*</span>
                            </label>
                            <div class="input-wrapper">
                                <i class="bi bi-grid"></i>
                                <select
                                    id="activityType"
                                    name="activityType"
                                    required>
                                    <option value="">
                                        Select Activity Type
                                    </option>
                                    <option value="Adventure">
                                        Adventure
                                    </option>
                                    <option value="Water Sports">
                                        Water Sports
                                    </option>
                                    <option value="Sightseeing">
                                        Sightseeing
                                    </option>
                                    <option value="Cultural">
                                        Cultural
                                    </option>
                                    <option value="Wildlife">
                                        Wildlife
                                    </option>
                                    <option value="Entertainment">
                                        Entertainment
                                    </option>
                                    <option value="Trekking">
                                        Trekking
                                    </option>
                                    <option value="Shopping">
                                        Shopping
                                    </option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="location">
                                Location
                                <span>*</span>
                            </label>
                            <div class="input-wrapper">
                                <i class="bi bi-pin-map"></i>
                                <input
                                    type="text"
                                    id="location"
                                    name="location"
                                    placeholder="Enter activity location"
                                    required>
                            </div>
                        </div>

                    </div>

                    <!-- ACTIVITY INFORMATION -->
                    <div class="form-section-title pricing-title">
                        <i class="bi bi-info-circle"></i>
                        Activity Information
                    </div>

                    <div class="form-grid">

                        <div class="form-group">
                            <label for="price">
                                Price
                            </label>
                            <div class="input-wrapper">
                                <i class="bi bi-currency-rupee"></i>
                                <input
                                    type="number"
                                    id="price"
                                    name="price"
                                    min="0"
                                    step="0.01"
                                    placeholder="Enter activity price">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="duration">
                                Duration
                            </label>
                            <div class="input-wrapper">
                                <i class="bi bi-clock"></i>
                                <input
                                    type="text"
                                    id="duration"
                                    name="duration"
                                    placeholder="Example: 2 Hours">
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

                    <!-- DESCRIPTION -->
                    <div class="form-section-title">
                        <i class="bi bi-card-text"></i>
                        Description
                    </div>

                    <div class="form-group full-width">
                        <label for="description">
                            Activity Description
                        </label>
                        <div class="textarea-wrapper">
                            <i class="bi bi-text-paragraph"></i>
                            <textarea
                                id="description"
                                name="description"
                                rows="4"
                                placeholder="Enter activity description..."></textarea>
                        </div>
                    </div>

                    <!-- IMAGE -->
                    <div class="form-section-title">
                        <i class="bi bi-image"></i>
                        Activity Image
                    </div>

                    <div class="image-upload-layout">

                        <div class="image-upload-box">
                            <input
                                type="file"
                                id="image"
                                name="image"
                                accept="image/*"
                                onchange="previewImage(event)">
                            <label for="image">
                                <div class="upload-icon">
                                    <i class="bi bi-cloud-arrow-up-fill"></i>
                                </div>
                                <strong>
                                    Upload Activity Image
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

                <!-- FOOTER -->
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
                            Save Activity
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
    id="viewActivityModal"
    tabindex="-1"
    aria-hidden="true">

    <div
        class="modal-dialog modal-dialog-centered modal-xl">

        <div class="modal-content view-glass-modal">

            <div class="view-modal-header">
                <div>
                    <span>
                        ACTIVITY INFORMATION
                    </span>
                    <h2>
                        Activity Details
                    </h2>
                </div>
                <button
                    type="button"
                    class="btn-close custom-close"
                    data-bs-dismiss="modal">
                </button>
            </div>

            <div
                id="viewActivityContent"
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
                Delete Activity?
            </h3>

            <p>
                Are you sure you want to delete this activity record?
                This action cannot be undone.
            </p>

            <input
                type="hidden"
                id="deleteActivityId">

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


<!-- TOAST -->
<div
    id="toastContainer"
    class="toast-container-custom">
</div>

<!-- Bootstrap JS -->
<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

<!-- Activity JS -->
<script src="${pageContext.request.contextPath}/js/apiConfig.js"></script>
<script src="${pageContext.request.contextPath}/js/activity.js"></script>

</body>
</html>