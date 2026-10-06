<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Destination Details</title>

    <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link
        rel="stylesheet"
        href="css/destination-details.css?v=6">

    <link
        rel="stylesheet"
        href="css/user-sidebar.css">

</head>

<body>

<div class="app-layout">

    <!-- =====================================================
         LEFT : EXISTING USER SIDEBAR
         ===================================================== -->

    <jsp:include page="sidebaruser.jsp" />


    <!-- =====================================================
         RIGHT : DESTINATION DETAILS
         ===================================================== -->

    <main class="destination-area">

        <div class="destination-page">


            <!-- BACK -->

            <button
                type="button"
                class="back-button"
                onclick="goBack()">

                <i class="fa-solid fa-arrow-left"></i>

                <span id="backButtonText">
                    Back to Explore
                </span>

            </button>


            <!-- LOADING -->

            <div
                id="loading"
                class="loading">

                <i class="fa-solid fa-spinner fa-spin"></i>

                <span>
                    Loading destination...
                </span>

            </div>


            <!-- ERROR -->

            <div
                id="errorBox"
                class="error-box"
                style="display:none;">

                <i
                    class="fa-solid
                           fa-circle-exclamation">
                </i>

                <h2>
                    Destination could not be loaded
                </h2>

                <p id="errorMessage">
                    Something went wrong.
                </p>

                <button
                    type="button"
                    class="back-button"
                    onclick="goBack()">

                    <i class="fa-solid fa-arrow-left"></i>

                    Back

                </button>

            </div>


            <!-- =================================================
                 MAIN CONTENT
                 ================================================= -->

            <div
                id="mainContent"
                style="display:none;">


                <!-- =================================================
                     DESTINATION
                     ================================================= -->

                <section class="destination-top">

   
                    <!-- MAIN IMAGE -->

                    <div
                        class="selected-image-container">

                        <img
                            id="selectedDestinationImage"
                            src=""
                            alt="Destination">

                        <div
                            class="image-overlay">
                        </div>

                        <div
                            class="selected-image-label">

                            <small>
                                Destination
                            </small>

                            <h2
                                id="selectedImageName">
                                -
                            </h2>

                        </div>

                    </div>


                    <!-- DESTINATION INFO -->

                    <div
                        class="destination-information">

                        <div
                            class="location-line">

                            <i
                                class="fa-solid
                                       fa-location-dot">
                            </i>

                            <span
                                id="locationText">
                                -
                            </span>

                        </div>


                        <h1
                            id="destinationName">
                            -
                        </h1>

                        <!-- Add to Bucketlist Button -->
                        <div style="margin: 15px 0;">
                            <button type="button" id="bucketlistBtn" onclick="toggleBucketlist()" style="background: #2563eb; color: white; border: none; padding: 10px 20px; border-radius: 8px; cursor: pointer; font-weight: 600; display: inline-flex; align-items: center; gap: 8px;">
                                <i class="fa-regular fa-heart" id="bucketlistIcon"></i> 
                                <span id="bucketlistText">Add to Bucketlist</span>
                            </button>
                        </div>


                        <div
                            id="destinationDescription"
                            class="description">
                            -
                        </div>


                        <!-- INFO -->

                        <div
                            class="information-grid">


                            <div
                                class="info-card">

                                <div
                                    class="info-card-title">

                                    <i
                                        class="fa-solid
                                               fa-earth-americas">
                                    </i>

                                    Country

                                </div>

                                <div
                                    id="country"
                                    class="info-card-value">
                                    -
                                </div>

                            </div>


                            <div
                                class="info-card">

                                <div
                                    class="info-card-title">

                                    <i
                                        class="fa-solid
                                               fa-location-dot">
                                    </i>

                                    State

                                </div>

                                <div
                                    id="state"
                                    class="info-card-value">
                                    -
                                </div>

                            </div>


                            <div
                                class="info-card">

                                <div
                                    class="info-card-title">

                                    <i
                                        class="fa-solid
                                               fa-calendar-days">
                                    </i>

                                    Best Season

                                </div>

                                <div
                                    id="bestSeason"
                                    class="info-card-value">
                                    -
                                </div>

                            </div>


                            <div
                                class="info-card">

                                <div
                                    class="info-card-title">

                                    <i
                                        class="fa-solid
                                               fa-wallet">
                                    </i>

                                    Budget

                                </div>

                                <div
                                    id="budget"
                                    class="info-card-value">
                                    -
                                </div>

                            </div>

                        </div>


                        <!-- CATEGORY -->

                        <div
                            class="category-section">

                            <h3>
                                Categories
                            </h3>

                            <div
                                id="categoryList"
                                class="category-list">
                            </div>

                        </div>

                    </div>

                </section>


                <!-- =================================================
                     RECOMMENDATION ANALYSIS (Only for Recommendation Mode)
                     ================================================= -->

                <section id="recommendationAnalysis" class="recommendation-analysis-section" style="display: none; margin-top: 30px;">
                    <div class="section-heading">
                        <div>
                            <span class="section-eyebrow">AI MATCHING</span>
                            <h2>Why Recommended This Destination</h2>
                            <p>Here is why this destination matches your preferences</p>
                        </div>
                    </div>

                    <div class="recommendation-content-grid" style="display: flex; gap: 20px; flex-wrap: wrap; margin-bottom: 30px;">
                        
                        <!-- Overall Match & Details Card -->
                        <div class="recommendation-card" style="flex: 1; min-width: 300px; background: #fff; padding: 20px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05);">
                            <h3>Overall Match Score: <span id="overallMatch" style="color: #2563eb;">0%</span></h3>
                            <p id="recommendationReason" style="margin-top: 10px; color: #4b5563; font-size: 15px; line-height: 1.6;"></p>
                        </div>

                        <!-- Match Breakdown Progress Bars -->
                        <div class="match-breakdown-card" style="flex: 1; min-width: 300px; background: #fff; padding: 20px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05);">
                            <h3>Match Breakdown</h3>
                            
                            <div style="margin-top: 12px;">
                                <div style="display: flex; justify-content: space-between; font-size: 14px; margin-bottom: 4px;">
                                    <span>Budget Match</span><span id="budgetMatchValue">0%</span>
                                </div>
                                <div style="background: #e5e7eb; height: 8px; border-radius: 4px; overflow: hidden;">
                                    <div id="budgetMatchBar" style="background: #2563eb; width: 0%; height: 100%;"></div>
                                </div>
                            </div>

                            <div style="margin-top: 10px;">
                                <div style="display: flex; justify-content: space-between; font-size: 14px; margin-bottom: 4px;">
                                    <span>Season Match</span><span id="seasonMatchValue">0%</span>
                                </div>
                                <div style="background: #e5e7eb; height: 8px; border-radius: 4px; overflow: hidden;">
                                    <div id="seasonMatchBar" style="background: #10b981; width: 0%; height: 100%;"></div>
                                </div>
                            </div>

                            <div style="margin-top: 10px;">
                                <div style="display: flex; justify-content: space-between; font-size: 14px; margin-bottom: 4px;">
                                    <span>Interest Match</span><span id="interestMatchValue">0%</span>
                                </div>
                                <div style="background: #e5e7eb; height: 8px; border-radius: 4px; overflow: hidden;">
                                    <div id="interestMatchBar" style="background: #f59e0b; width: 0%; height: 100%;"></div>
                                </div>
                            </div>

                            <div style="margin-top: 10px;">
                                <div style="display: flex; justify-content: space-between; font-size: 14px; margin-bottom: 4px;">
                                    <span>Category Match</span><span id="categoryMatchValue">0%</span>
                                </div>
                                <div style="background: #e5e7eb; height: 8px; border-radius: 4px; overflow: hidden;">
                                    <div id="categoryMatchBar" style="background: #8b5cf6; width: 0%; height: 100%;"></div>
                                </div>
                            </div>

                            <div style="margin-top: 10px;">
                                <div style="display: flex; justify-content: space-between; font-size: 14px; margin-bottom: 4px;">
                                    <span>Location Match</span><span id="locationMatchValue">0%</span>
                                </div>
                                <div style="background: #e5e7eb; height: 8px; border-radius: 4px; overflow: hidden;">
                                    <div id="locationMatchBar" style="background: #ec4899; width: 0%; height: 100%;"></div>
                                 </div>
                            </div>

                        </div>

                    </div>
                </section>


                <!-- =================================================
                     MAP + RELATED DESTINATIONS
                     ================================================= -->

                <div
                    class="location-photo-row">


                    <!-- MAP -->

                    <section
                        class="map-section">

                        <div
                            class="section-heading">

                            <div>

                                <span
                                    class="section-eyebrow">
                                    LOCATION
                                </span>

                                <h2>
                                    Where Is It?
                                </h2>

                                <p>
                                    Destination location
                                </p>

                            </div>

                        </div>


                        <div
                            class="map-container">

                            <iframe
                                id="destinationMap"
                                src=""
                                loading="lazy"
                                allowfullscreen>
                            </iframe>

                        </div>


                        <a
                            id="openMapLink"
                            class="open-map-link"
                            href="#"
                            target="_blank">

                            <i
                                class="fa-solid
                                       fa-map-location-dot">
                            </i>

                            Open in Google Maps

                        </a>

                    </section>


                    <!-- RELATED DESTINATIONS -->

                    <section
                        class="gallery-section">

                        <div
                            class="section-heading">

                            <div>

                                <span
                                    class="section-eyebrow">
                                    EXPLORE MORE
                                </span>

                                <h2>
                                    Related Destinations
                                </h2>

                                <p>
                                    Destinations from the same state
                                </p>

                            </div>


                            <span
                                id="photoCount"
                                class="photo-count">

                                0 Photos

                            </span>

                        </div>


                        <div
                            id="destinationGallery"
                            class="destination-gallery">
                        </div>

                    </section>

                </div>


                <!-- =================================================
                     TRANSPORT
                     ================================================= -->

                <section
                    class="transport-section">

                    <div
                        class="section-heading">

                        <div>

                            <span
                                class="section-eyebrow">
                                TRAVEL OPTIONS
                            </span>

                            <h2>
                                How Can You Reach?
                            </h2>

                            <p>
                                Available transport options
                            </p>

                        </div>

                    </div>


                    <div
                        id="transportContainer"
                        class="transport-container">
                    </div>

                </section>


                <!-- =================================================
                     HOTELS
                     ================================================= -->

                <section
                    class="hotels-section">

                    <div
                        class="section-heading">

                        <div>

                            <span
                                class="section-eyebrow">
                                STAY NEARBY
                            </span>

                            <h2>
                                Hotels Near This Destination
                            </h2>

                            <p>
                                Hotels related to this destination
                            </p>

                        </div>

                    </div>


                    <div
                        id="hotelsContainer"
                        class="hotels-container">
                    </div>

                </section>

            </div>

        </div>

    </main>

</div>


<script src="${pageContext.request.contextPath}/js/apiConfig.js"></script>
<script src="${pageContext.request.contextPath}/js/destination-details.js"></script>

</body>

</html>