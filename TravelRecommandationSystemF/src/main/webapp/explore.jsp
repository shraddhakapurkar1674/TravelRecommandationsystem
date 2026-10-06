<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Explore Destinations - TripNexa</title>


    <!-- ================= BOOTSTRAP ================= -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- ================= FONT AWESOME ================= -->

    <link
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
        rel="stylesheet">


    <!-- ================= GOOGLE FONT ================= -->

    <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
        rel="stylesheet">


    <!-- ================= USER DASHBOARD CSS ================= -->

    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/user.css?v=5">


    <!-- ================= EXPLORE CSS ================= -->

    

    <!-- ================= PAGE LAYOUT CSS ================= -->

    <style>

        * {
            box-sizing: border-box;
        }


        html,
        body {
            margin: 0;
            padding: 0;
            width: 100%;
            min-height: 100%;
        }


        body {
            font-family: 'Inter', sans-serif;
            background: #f8fafc;
        }


        /* =====================================================
           MAIN USER LAYOUT
           ===================================================== */

        .user-app-layout {

            display: flex;

            width: 100%;

            min-height: 100vh;

        }


        /* =====================================================
           LEFT SIDEBAR
           ===================================================== */

        .user-app-layout > .user-sidebar {

            width: 260px;

            min-width: 260px;

            height: 100vh;

            flex-shrink: 0;

            position: fixed;

            left: 0;

            top: 0;

            z-index: 1000;

        }


        /* =====================================================
           RIGHT MAIN AREA
           ===================================================== */

        .user-main-content {

            width: calc(100% - 260px);

            min-height: 100vh;

            margin-left: 260px;

            flex: 1;

            min-width: 0;

        }


        /* =====================================================
           HEADER
           ===================================================== */

        .user-main-content .user-header {

            width: 100%;

            position: sticky;

            top: 0;

            z-index: 900;

        }


        /* =====================================================
           EXPLORE CONTENT
           ===================================================== */

        .user-main-content .content {

            width: 100%;

            padding: 28px 32px 40px;

        }


        /* =====================================================
           PAGE HEADING
           ===================================================== */

        .page-heading {

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 20px;

            margin-bottom: 25px;

        }


        .heading-left {

            display: flex;

            align-items: center;

            gap: 15px;

        }


        .heading-icon {

            width: 52px;

            height: 52px;

            border-radius: 14px;

            display: flex;

            align-items: center;

            justify-content: center;

            background: #e0f2fe;

            color: #0284c7;

            font-size: 22px;

        }


        .heading-left h2 {

            margin: 0;

            font-size: 25px;

            font-weight: 700;

            color: #0f172a;

        }


        .heading-left p {

            margin: 5px 0 0;

            color: #64748b;

            font-size: 14px;

        }


        /* =====================================================
           MAP BUTTON
           ===================================================== */

        .map-btn {

            border: none;

            background: #0284c7;

            color: white;

            padding: 11px 18px;

            border-radius: 10px;

            font-weight: 600;

            display: flex;

            align-items: center;

            gap: 8px;

            cursor: pointer;

        }


        .map-btn:hover {

            background: #0369a1;

        }


        /* =====================================================
           FILTER BOX
           ===================================================== */

        .filter-box {

            width: 100%;

            display: grid;

            grid-template-columns:
                minmax(220px, 2fr)
                minmax(150px, 1fr)
                minmax(150px, 1fr)
                minmax(150px, 1fr)
                auto
                auto;

            gap: 14px;

            align-items: end;

            padding: 20px;

            background: white;

            border-radius: 16px;

            border: 1px solid #e2e8f0;

            box-shadow:
                0 4px 18px rgba(15, 23, 42, 0.05);

            margin-bottom: 25px;

        }


        /* =====================================================
           DESTINATION SEARCH
           ===================================================== */

        .destination-search {

            position: relative;

        }


        .destination-search input {

            width: 100%;

            height: 45px;

            padding: 0 42px 0 14px;

            border: 1px solid #dbe3ec;

            border-radius: 9px;

            outline: none;

            font-size: 14px;

        }


        .destination-search input:focus {

            border-color: #0284c7;

        }


        .destination-search i {

            position: absolute;

            right: 14px;

            top: 50%;

            transform: translateY(-50%);

            color: #64748b;

        }


        /* =====================================================
           FILTER FIELD
           ===================================================== */

        .filter-field {

            display: flex;

            flex-direction: column;

            gap: 6px;

        }


        .filter-field label {

            font-size: 12px;

            font-weight: 600;

            color: #475569;

        }


        .filter-field select {

            width: 100%;

            height: 45px;

            padding: 0 12px;

            border: 1px solid #dbe3ec;

            border-radius: 9px;

            background: white;

            color: #334155;

            outline: none;

            cursor: pointer;

        }


        .filter-field select:focus {

            border-color: #0284c7;

        }


        /* =====================================================
           FILTER BUTTON
           ===================================================== */

        .filter-btn,
        .reset-btn {

            height: 45px;

            padding: 0 16px;

            border-radius: 9px;

            font-size: 13px;

            font-weight: 600;

            display: flex;

            align-items: center;

            justify-content: center;

            gap: 7px;

            cursor: pointer;

            white-space: nowrap;

        }


        .filter-btn {

            border: none;

            background: #0284c7;

            color: white;

        }


        .filter-btn:hover {

            background: #0369a1;

        }


        .reset-btn {

            border: 1px solid #cbd5e1;

            background: white;

            color: #475569;

        }


        .reset-btn:hover {

            background: #f1f5f9;

        }


        /* =====================================================
           RESULT HEADER
           ===================================================== */

        .result-header {

            display: flex;

            align-items: center;

            justify-content: space-between;

            margin-bottom: 18px;

        }


        .result-header p {

            margin: 0;

            color: #64748b;

            font-size: 14px;

        }


        .result-header strong {

            color: #0f172a;

        }


        .result-header select {

            height: 40px;

            padding: 0 12px;

            border: 1px solid #dbe3ec;

            border-radius: 8px;

            background: white;

            color: #475569;

            outline: none;

        }


        /* =====================================================
           DESTINATION GRID
           ===================================================== */

        .destination-grid {

            width: 100%;

            display: grid;

            grid-template-columns:
                repeat(4, minmax(0, 1fr));

            gap: 20px;

        }


        /* =====================================================
           DESTINATION CARD
           ===================================================== */

        .destination-card {

            background: white;

            border-radius: 16px;

            overflow: hidden;

            border: 1px solid #e2e8f0;

            box-shadow:
                0 4px 15px rgba(15, 23, 42, 0.06);

            transition:
                transform 0.2s ease,
                box-shadow 0.2s ease;

        }


        .destination-card:hover {

            transform: translateY(-4px);

            box-shadow:
                0 10px 25px rgba(15, 23, 42, 0.10);

        }


        .card-image {

            height: 190px;

            position: relative;

            overflow: hidden;

        }


        .card-image img {

            width: 100%;

            height: 100%;

            object-fit: cover;

        }


        .favorite-btn {

            position: absolute;

            top: 12px;

            right: 12px;

            width: 38px;

            height: 38px;

            border: none;

            border-radius: 50%;

            background: rgba(255, 255, 255, 0.95);

            display: flex;

            align-items: center;

            justify-content: center;

            cursor: pointer;

            color: #475569;

        }


        .favorite-btn:hover {

            color: #ef4444;

        }


        .card-body {

            padding: 16px;

        }


        .card-body h3 {

            margin: 0 0 9px;

            font-size: 17px;

            font-weight: 700;

            color: #0f172a;

        }


        .location-row {

            display: flex;

            align-items: center;

            flex-wrap: wrap;

            gap: 6px;

            color: #64748b;

            font-size: 12px;

        }


        .location-row i {

            color: #0284c7;

        }


        .category-badge {

            padding: 4px 8px;

            border-radius: 20px;

            background: #e0f2fe;

            color: #0369a1;

            font-size: 10px;

            font-weight: 600;

        }


        .price {

            margin-top: 14px;

            color: #0f172a;

            font-size: 18px;

            font-weight: 700;

        }


        .price-text {

            font-size: 11px;

            color: #94a3b8;

        }


        .card-footer {

            margin-top: 14px;

            padding-top: 12px;

            border-top: 1px solid #f1f5f9;

        }


        .view-details {

            border: none;

            background: transparent;

            color: #0284c7;

            font-size: 13px;

            font-weight: 600;

            cursor: pointer;

            padding: 0;

        }


        .view-details i {

            margin-left: 5px;

        }


        /* =====================================================
           PAGINATION
           ===================================================== */

        .pagination {

            display: flex;

            align-items: center;

            justify-content: center;

            gap: 7px;

            margin-top: 30px;

        }


        .pagination button {

            min-width: 38px;

            height: 38px;

            border: 1px solid #dbe3ec;

            background: white;

            color: #475569;

            border-radius: 8px;

            cursor: pointer;

        }


        .pagination button:hover {

            border-color: #0284c7;

            color: #0284c7;

        }


        .pagination button.active {

            background: #0284c7;

            border-color: #0284c7;

            color: white;

        }


        .pagination button:disabled {

            opacity: 0.5;

            cursor: not-allowed;

        }


        /* =====================================================
           RESPONSIVE
           ===================================================== */

        @media (max-width: 1200px) {

            .destination-grid {

                grid-template-columns:
                    repeat(3, minmax(0, 1fr));

            }


            .filter-box {

                grid-template-columns:
                    repeat(3, 1fr);

            }

        }


        @media (max-width: 900px) {

            .user-app-layout > .user-sidebar {

                transform: translateX(-100%);

                transition: transform 0.3s ease;

            }


            .user-app-layout > .user-sidebar.mobile-open {

                transform: translateX(0);

            }


            .user-main-content {

                width: 100%;

                margin-left: 0;

            }


            .destination-grid {

                grid-template-columns:
                    repeat(2, minmax(0, 1fr));

            }


            .filter-box {

                grid-template-columns:
                    repeat(2, 1fr);

            }

        }


        @media (max-width: 600px) {

            .user-main-content .content {

                padding: 20px 15px;

            }


            .page-heading {

                align-items: flex-start;

                flex-direction: column;

            }


            .filter-box {

                grid-template-columns: 1fr;

            }


            .destination-grid {

                grid-template-columns: 1fr;

            }


            .result-header {

                align-items: flex-start;

                gap: 12px;

                flex-direction: column;

            }

        }
        
        
        <style>
/* =========================================================
   EXPLORE PAGE
========================================================= */

.explore-page {
    width: 100%;
    min-height: 100vh;
    background: #f7f9fc;
    padding-bottom: 60px;
}

/* =========================================================
   PAGE HEADER
========================================================= */

.explore-header {
    padding: 40px 5% 25px;
}

.explore-header h1 {
    margin: 0;
    font-size: 34px;
    font-weight: 700;
    color: #1f2937;
}

.explore-header p {
    margin-top: 8px;
    color: #6b7280;
    font-size: 15px;
}

/* =========================================================
   FILTER / SEARCH AREA
========================================================= */

.explore-controls {
    width: 90%;
    max-width: 1400px;
    margin: 0 auto 30px;
    background: #ffffff;
    border-radius: 16px;
    padding: 20px;
    box-shadow: 0 4px 18px rgba(0, 0, 0, 0.06);

    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    align-items: center;
}

.explore-controls input,
.explore-controls select {
    height: 44px;
    border: 1px solid #dfe3e8;
    border-radius: 8px;
    padding: 0 13px;
    font-size: 14px;
    background: #ffffff;
    color: #333;
    outline: none;
    transition: 0.2s ease;
}

.explore-controls input {
    flex: 1;
    min-width: 220px;
}

.explore-controls select {
    min-width: 150px;
}

.explore-controls input:focus,
.explore-controls select:focus {
    border-color: #2563eb;
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.10);
}

/* Buttons */

.explore-controls button {
    height: 44px;
    border: none;
    border-radius: 8px;
    padding: 0 18px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    transition: 0.2s ease;
}

#filterBtn {
    background: #2563eb;
    color: #ffffff;
}

#filterBtn:hover {
    background: #1d4ed8;
}

#resetBtn {
    background: #eef2f7;
    color: #374151;
}

#resetBtn:hover {
    background: #e2e8f0;
}

/* =========================================================
   RESULT HEADER
========================================================= */

.destination-result-header {
    width: 90%;
    max-width: 1400px;
    margin: 0 auto 18px;

    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
}

.destination-result-header h2 {
    margin: 0;
    color: #1f2937;
    font-size: 21px;
}

.destination-result-header span {
    color: #6b7280;
    font-size: 14px;
}

/* Sort */

#sortFilter {
    height: 40px;
    padding: 0 12px;
    border: 1px solid #dfe3e8;
    border-radius: 8px;
    background: #ffffff;
    color: #374151;
    outline: none;
}

/* =========================================================
   DESTINATION GRID
========================================================= */

.destination-grid {
    width: 90%;
    max-width: 1400px;
    margin: 0 auto;

    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 24px;
}

/* =========================================================
   DESTINATION CARD
========================================================= */

.destination-card {
    background: #ffffff;
    border-radius: 16px;
    overflow: hidden;

    box-shadow: 0 5px 18px rgba(0, 0, 0, 0.07);

    transition:
        transform 0.25s ease,
        box-shadow 0.25s ease;

    display: flex;
    flex-direction: column;
    min-width: 0;
}

.destination-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 12px 28px rgba(0, 0, 0, 0.12);
}

/* =========================================================
   CARD IMAGE
========================================================= */

.destination-card .card-image,
.destination-card .destination-image {
    width: 100%;
    height: 220px;
    overflow: hidden;
    position: relative;
    background: #e5e7eb;
}

.destination-card .card-image img,
.destination-card .destination-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;

    transition: transform 0.35s ease;
}

.destination-card:hover .card-image img,
.destination-card:hover .destination-image img {
    transform: scale(1.05);
}

/* =========================================================
   CARD CONTENT
========================================================= */

.destination-card .card-content {
    padding: 18px;
    display: flex;
    flex-direction: column;
    flex: 1;
}

.destination-card h3 {
    margin: 0 0 10px;
    font-size: 20px;
    font-weight: 700;
    color: #1f2937;
}

.location-row {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 7px;

    color: #6b7280;
    font-size: 13px;
}

.location-row i {
    color: #ef4444;
}

/* =========================================================
   CATEGORY BADGE
========================================================= */

.category-badge {
    display: inline-flex;
    align-items: center;

    padding: 4px 9px;
    border-radius: 20px;

    background: #eff6ff;
    color: #2563eb;

    font-size: 11px;
    font-weight: 600;
}

/* =========================================================
   PRICE
========================================================= */

.destination-card .price {
    margin-top: 17px;

    color: #111827;
    font-size: 21px;
    font-weight: 700;
}

.destination-card .price-text {
    margin-top: 2px;
    color: #9ca3af;
    font-size: 12px;
}

/* =========================================================
   CARD FOOTER
========================================================= */

.card-footer {
    margin-top: auto;
    padding-top: 18px;
}

.view-details {
    width: 100%;
    height: 42px;

    border: none;
    border-radius: 8px;

    background: #2563eb;
    color: #ffffff;

    font-size: 14px;
    font-weight: 600;

    cursor: pointer;

    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;

    transition: 0.2s ease;
}

.view-details:hover {
    background: #1d4ed8;
}

.view-details i {
    transition: transform 0.2s ease;
}

.view-details:hover i {
    transform: translateX(4px);
}

/* =========================================================
   PAGINATION
========================================================= */

.pagination {
    width: 90%;
    max-width: 1400px;
    margin: 35px auto 0;

    display: flex;
    justify-content: center;
    align-items: center;
    gap: 8px;
}

.pagination button {
    min-width: 40px;
    height: 40px;

    padding: 0 12px;

    border: 1px solid #dfe3e8;
    border-radius: 8px;

    background: #ffffff;
    color: #374151;

    font-size: 14px;
    font-weight: 600;

    cursor: pointer;
    transition: 0.2s ease;
}

.pagination button:hover {
    background: #eff6ff;
    border-color: #2563eb;
    color: #2563eb;
}

.pagination button.active {
    background: #2563eb;
    border-color: #2563eb;
    color: #ffffff;
}

.pagination button:disabled {
    opacity: 0.45;
    cursor: not-allowed;
}

/* If your JS creates pagination links */
.pagination a {
    min-width: 40px;
    height: 40px;

    display: inline-flex;
    align-items: center;
    justify-content: center;

    border: 1px solid #dfe3e8;
    border-radius: 8px;

    background: #ffffff;
    color: #374151;

    text-decoration: none;
    font-size: 14px;
    font-weight: 600;
}

.pagination a:hover,
.pagination a.active {
    background: #2563eb;
    border-color: #2563eb;
    color: #ffffff;
}

/* =========================================================
   NO DESTINATION MESSAGE
========================================================= */

#noDestinationMessage {
    width: 90%;
    max-width: 1400px;
    margin: 40px auto;
    padding: 60px 20px;

    text-align: center;

    background: #ffffff;
    border-radius: 16px;

    color: #6b7280;

    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
}

#noDestinationMessage i {
    font-size: 42px;
    margin-bottom: 15px;
    color: #9ca3af;
}

#noDestinationMessage h3 {
    margin: 0 0 8px;
    color: #374151;
}

#noDestinationMessage p {
    margin: 0;
}

/* =========================================================
   LOADING
========================================================= */

.destination-loading {
    width: 90%;
    margin: 40px auto;
    text-align: center;
    color: #6b7280;
}

.destination-loading i {
    font-size: 30px;
    margin-bottom: 12px;
}

/* =========================================================
   RESPONSIVE
========================================================= */

/* Large tablet */
@media (max-width: 1200px) {

    .destination-grid {
        grid-template-columns: repeat(3, minmax(0, 1fr));
    }

}

/* Tablet */
@media (max-width: 900px) {

    .destination-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .explore-controls {
        width: 92%;
    }

    .destination-result-header {
        width: 92%;
    }

}

/* Mobile */
@media (max-width: 600px) {

    .explore-header {
        padding: 30px 5% 20px;
    }

    .explore-header h1 {
        font-size: 27px;
    }

    .explore-controls {
        width: 92%;
        padding: 15px;

        flex-direction: column;
        align-items: stretch;
    }

    .explore-controls input,
    .explore-controls select,
    .explore-controls button {
        width: 100%;
        min-width: 0;
    }

    .destination-result-header {
        width: 92%;
        flex-direction: column;
        align-items: flex-start;
    }

    .destination-grid {
        width: 92%;
        grid-template-columns: 1fr;
        gap: 18px;
    }

    .destination-card .card-image,
    .destination-card .destination-image {
        height: 220px;
    }

    .pagination {
        width: 92%;
        flex-wrap: wrap;
    }

}


/* =====================================================
   NORMAL FONT SIZE IMPROVEMENT
===================================================== */

.explore-header h1 {
    font-size: 36px;
}

.explore-header p {
    font-size: 16px;
}

.explore-controls input,
.explore-controls select,
.explore-controls button {
    font-size: 15px;
}

.destination-result-header h2 {
    font-size: 22px;
}

.destination-result-header span {
    font-size: 15px;
}

#sortFilter {
    font-size: 15px;
}

.destination-card h3 {
    font-size: 21px;
}

.location-row {
    font-size: 14px;
}

.category-badge {
    font-size: 12px;
}

.destination-card .price {
    font-size: 22px;
}

.destination-card .price-text {
    font-size: 13px;
}

.view-details {
    font-size: 15px;
}

.pagination button {
    font-size: 15px;
}

#noDestinationMessage {
    font-size: 15px;
}

#noDestinationMessage h3 {
    font-size: 20px;
}

#noDestinationMessage p {
    font-size: 15px;
}
/* =========================================================
   PREVENT HORIZONTAL OVERFLOW
========================================================= */

html,
body {
    max-width: 100%;
    overflow-x: hidden;
}

.explore-page,
.destination-grid,
.destination-card {
    box-sizing: border-box;
}
</style>

    </style>

</head>


<body>


<!-- =========================================================
     MAIN USER APPLICATION LAYOUT
     ========================================================= -->

<div class="user-app-layout">


    <!-- =====================================================
         ONLY LEFT SIDEBAR
         ===================================================== -->

    <jsp:include page="sidebaruser.jsp">

        <jsp:param
            name="activePage"
            value="explore"/>

    </jsp:include>



    <!-- =====================================================
         RIGHT SIDE MAIN CONTENT
         ===================================================== -->

    <main class="user-main-content">


        <!-- =================================================
             COMMON USER HEADER
             ================================================= -->

        <jsp:include page="user-header.jsp"/>



        <!-- =================================================
             EXPLORE CONTENT
             ================================================= -->

        <section class="content">


            <!-- =================================================
                 PAGE HEADING
                 ================================================= -->

            <div class="page-heading">

                <div class="heading-left">

                    <div class="heading-icon">

                        <i class="fa-regular fa-compass"></i>

                    </div>


                    <div>

                        <h2>
                            Explore Destinations
                        </h2>

                        <p>
                            Find the best places to visit and create your next adventure
                        </p>

                    </div>

                </div>


                <button
                    type="button"
                    class="map-btn"
                    id="viewMapBtn">

                    <i class="fa-solid fa-map"></i>

                    View Map

                </button>

            </div>



            <!-- =================================================
                 FILTER BOX
                 ================================================= -->

            <div class="filter-box">


                <!-- SEARCH -->

                <div class="destination-search">

                    <input
                        type="text"
                        id="destinationSearch"
                        placeholder="Search destinations...">

                    <i class="fa-solid fa-magnifying-glass"></i>

                </div>



                <!-- COUNTRY -->

                <div class="filter-field">

                    <label for="countryFilter">
                        Country
                    </label>

                    <select id="countryFilter">

                        <option value="">
                            All Countries
                        </option>

                    </select>

                </div>



                <!-- CATEGORY -->

                <div class="filter-field">

                    <label for="categoryFilter">
                        Category
                    </label>

                    <select id="categoryFilter">

                        <option value="">
                            All Categories
                        </option>

                    </select>

                </div>



                <!-- BUDGET -->

                <div class="filter-field">

                    <label for="budgetFilter">
                        Budget
                    </label>

                    <select id="budgetFilter">

                        <option value="">
                            All Budgets
                        </option>

                        <option value="5000">
                            Below ₹5,000
                        </option>

                        <option value="10000">
                            Below ₹10,000
                        </option>

                        <option value="20000">
                            Below ₹20,000
                        </option>

                        <option value="50000">
                            Below ₹50,000
                        </option>

                    </select>

                </div>



                <!-- FILTER -->

                <button
                    type="button"
                    class="filter-btn"
                    id="filterBtn">

                    <i class="fa-solid fa-filter"></i>

                    Filter

                </button>



                <!-- RESET -->

                <button
                    type="button"
                    class="reset-btn"
                    id="resetBtn">

                    <i class="fa-solid fa-rotate-right"></i>

                    Reset

                </button>


            </div>



            <!-- =================================================
                 RESULT HEADER
                 ================================================= -->

            <div class="result-header">

                <p>

                    Showing

                    <strong id="destinationCount">
                        0
                    </strong>

                    destinations

                </p>


                <select id="sortFilter">

                    <option value="popular">
                        Sort by: Popular
                    </option>

                    <option value="low">
                        Price: Low to High
                    </option>

                    <option value="high">
                        Price: High to Low
                    </option>

                </select>

            </div>



            <!-- =================================================
                 LOADING
                 ================================================= -->

            <div
                id="loadingMessage"
                class="text-center py-5"
                style="display:none;">

                <div
                    class="spinner-border"
                    role="status">
                </div>

                <p class="mt-2">
                    Loading destinations...
                </p>

            </div>



            <!-- =================================================
                 DESTINATION CARDS
                 ================================================= -->

            <div
                id="destinationContainer"
                class="destination-grid">

            </div>



            <!-- =================================================
                 NO DESTINATION MESSAGE
                 ================================================= -->

            <div
                id="noDestinationMessage"
                class="text-center py-5"
                style="display:none;">

                <i
                    class="fa-regular fa-compass fa-2x mb-3">
                </i>

                <h5>
                    No destinations found
                </h5>

                <p>
                    Try changing your search or filters.
                </p>

            </div>



            <!-- =================================================
                 PAGINATION
                 ================================================= -->

            <div
                class="pagination"
                id="pagination">

            </div>


        </section>


    </main>


</div>



<!-- =========================================================
     EXPLORE JS
     ========================================================= -->

<script
    src="${pageContext.request.contextPath}/js/explore.js?v=10">
</script>


<!-- =========================================================
     USER JS
     ========================================================= -->

<script src="${pageContext.request.contextPath}/js/apiConfig.js"></script>
<script src="${pageContext.request.contextPath}/js/explore.js"></script>
</body>

</html>