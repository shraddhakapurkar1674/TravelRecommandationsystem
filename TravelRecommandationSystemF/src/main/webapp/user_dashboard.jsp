<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>TripNexa - User Dashboard</title>

    <link
        href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&family=Pacifico&display=swap"
        rel="stylesheet">

    <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/user.css?v=20">

</head>

<body>

<div class="user-dashboard-layout">

    <!-- =====================================================
         LEFT SIDEBAR
         ===================================================== -->

    <jsp:include page="sidebaruser.jsp">
        <jsp:param name="activePage" value="dashboard"/>
    </jsp:include>


    <!-- =====================================================
         RIGHT DASHBOARD AREA
         ===================================================== -->

    <main class="user-dashboard-main">


        <!-- =================================================
             EXISTING USER HEADER
             ================================================= -->

        <jsp:include page="user-header.jsp"/>


        <!-- =================================================
             MAIN TWO-COLUMN CONTENT
             ================================================= -->

        <div class="dashboard-content-grid">


            <!-- =================================================
                 LEFT MAIN CONTENT
                 ================================================= -->

            <div class="dashboard-left-content">


                <!-- =================================================
                     TRAVEL SMARTER HERO BANNER
                     ================================================= -->

                <section class="travel-smarter-banner">

                    <div class="travel-banner-overlay"></div>

                    <div class="travel-banner-content">

                        <div class="travel-banner-script">
                            Travel Smarter
                        </div>

                        <h2>
                            with Personalized Recommendations
                        </h2>

                        <div class="travel-banner-equation">

                            <span>
                                <i class="fa-solid fa-heart"></i>
                                Your interests
                            </span>

                            <b>+</b>

                            <span>
                                <i class="fa-solid fa-gear"></i>
                                Your preferences
                            </span>

                            <b>=</b>

                            <span>
                                <i class="fa-solid fa-star"></i>
                                Perfect destinations
                            </span>

                        </div>

                    </div>

                </section>



                <!-- =================================================
                     RECOMMENDED FOR YOU
                     ================================================= -->

                <section class="dashboard-section recommended-section">

                    <div class="dashboard-section-header">

                        <div class="dashboard-section-title-wrapper">

                            <div class="dashboard-section-icon">
                                <i class="fa-solid fa-wand-magic-sparkles"></i>
                            </div>

                            <div>
                                <h2>Recommended For You</h2>

                                <p>
                                    Destinations that match your travel profile
                                </p>
                            </div>

                        </div>


                        <a
                            href="recommendation.jsp"
                            class="dashboard-view-all">

                            View All
                            <i class="fa-solid fa-arrow-right"></i>

                        </a>

                    </div>


                    <div
                        id="recommendedDestinationGrid"
                        class="recommended-destination-grid">

                        <div class="dashboard-loading">
                            Loading recommendations...
                        </div>

                    </div>

                </section>



                <!-- =================================================
                     EXPLORE MORE DESTINATIONS
                     ================================================= -->

                <section class="dashboard-section explore-section">

                    <div class="dashboard-section-header">

                        <div class="dashboard-section-title-wrapper">

                            <div class="dashboard-section-icon">
                                <i class="fa-solid fa-mountain-sun"></i>
                            </div>

                            <div>
                                <h2>Explore More Destinations</h2>

                                <p>
                                    Discover amazing places based on your interests
                                </p>
                            </div>

                        </div>


                        <a
                            href="destinations.jsp"
                            class="dashboard-view-all">

                            View All
                            <i class="fa-solid fa-arrow-right"></i>

                        </a>

                    </div>


                    <div
                        id="exploreCategoryGrid"
                        class="explore-category-grid">

                        <div class="dashboard-loading">
                            Loading categories...
                        </div>

                    </div>

                </section>



                <!-- =================================================
                     POPULAR DESTINATIONS
                     ================================================= -->

                <section class="dashboard-section popular-section">

                    <div class="dashboard-section-header">

                        <div class="dashboard-section-title-wrapper">

                            <div class="dashboard-section-icon">
                                <i class="fa-solid fa-fire"></i>
                            </div>

                            <div>

                                <h2 id="popularSectionTitle">
                                    Popular Destinations
                                </h2>

                                <p id="popularSectionSubtitle">
                                    Explore popular destinations from our database
                                </p>

                            </div>

                        </div>


                        <button
                            type="button"
                            id="showAllPopularButton"
                            class="show-all-popular-button"
                            style="display: none;">

                            <i class="fa-solid fa-rotate-left"></i>
                            Show All

                        </button>

                    </div>


                    <div
                        id="popularDestinationGrid"
                        class="popular-destination-grid">

                        <div class="dashboard-loading">
                            Loading popular destinations...
                        </div>

                    </div>

                </section>


            </div>



            <!-- =================================================
                 RIGHT SIDEBAR CONTENT
                 ================================================= -->

            <aside class="dashboard-right-content">


                <!-- =================================================
                     TRAVEL PROFILE CARD
                     ================================================= -->

                <section class="dashboard-widget profile-widget">

                    <div class="widget-heading">

                        <div class="widget-heading-icon">
                            <i class="fa-solid fa-user"></i>
                        </div>

                        <h2>Your Travel Profile</h2>

                    </div>


                    <div class="profile-summary">

                        <div class="profile-completion-wrapper">

                            <div class="profile-progress-ring">

                                <svg
                                    class="profile-progress-svg"
                                    width="112"
                                    height="112"
                                    viewBox="0 0 112 112">

                                    <circle
                                        class="profile-ring-background"
                                        cx="56"
                                        cy="56"
                                        r="46">
                                    </circle>

                                    <circle
                                        id="profileProgressCircle"
                                        class="profile-ring-progress"
                                        cx="56"
                                        cy="56"
                                        r="46">
                                    </circle>

                                </svg>


                                <div class="profile-progress-text">

                                    <strong id="profileCompletionPercent">
                                        0%
                                    </strong>

                                </div>

                            </div>


                            <p>
                                Profile<br>
                                Completed
                            </p>

                        </div>


                        <div class="profile-details">

                            <div class="profile-detail-row">

                                <i class="fa-solid fa-location-dot"></i>

                                <div>
                                    <span>Location</span>

                                    <strong id="profileLocation">
                                        Not set
                                    </strong>
                                </div>

                            </div>


                            <div class="profile-detail-row">

                                <i class="fa-solid fa-user-group"></i>

                                <div>
                                    <span>Travel Companion</span>

                                    <strong id="profileCompanion">
                                        Not set
                                    </strong>
                                </div>

                            </div>


                            <div class="profile-detail-row">

                                <i class="fa-solid fa-wallet"></i>

                                <div>
                                    <span>Budget Range</span>

                                    <strong id="profileBudget">
                                        Not set
                                    </strong>
                                </div>

                            </div>


                            <div class="profile-detail-row">

                                <i class="fa-solid fa-heart"></i>

                                <div>
                                    <span>Interests</span>

                                    <strong id="profileInterests">
                                        Not set
                                    </strong>
                                </div>

                            </div>

                        </div>

                    </div>


                    <a
                        href="profile.jsp"
                        class="profile-button">

                        View Full Profile
                        <i class="fa-solid fa-arrow-right"></i>

                    </a>

                </section>



                <!-- =================================================
                     QUICK FILTERS
                     ================================================= -->

                <section class="dashboard-widget quick-filter-widget">

                    <div class="widget-heading">

                        <div class="widget-heading-icon">
                            <i class="fa-solid fa-filter"></i>
                        </div>

                        <h2>Quick Filters</h2>

                    </div>


                    <div class="quick-filter-form">


                        <div class="quick-filter-row">

                            <label for="quickBudget">
                                Budget
                            </label>

                            <select id="quickBudget">

                                <option value="">
                                    All Budgets
                                </option>

                                <option value="10000">
                                    Under ₹10,000
                                </option>

                                <option value="25000">
                                    ₹10,000 - ₹25,000
                                </option>

                                <option value="50000">
                                    ₹25,000 - ₹50,000
                                </option>

                                <option value="100000">
                                    Above ₹50,000
                                </option>

                            </select>

                        </div>


                        <div class="quick-filter-row">

                            <label for="quickLocation">
                                Location
                            </label>

                            <select id="quickLocation">

                                <option value="">
                                    All Locations
                                </option>

                            </select>

                        </div>


                        <div class="quick-filter-row">

                            <label for="quickCategory">
                                Category
                            </label>

                            <select id="quickCategory">

                                <option value="">
                                    All Categories
                                </option>

                            </select>

                        </div>


                        <div class="quick-filter-row">

                            <label for="quickCompanion">
                                Travel Companion
                            </label>

                            <select id="quickCompanion">

                                <option value="">
                                    Any
                                </option>

                                <option value="Solo">
                                    Solo
                                </option>

                                <option value="Friends">
                                    Friends
                                </option>

                                <option value="Family">
                                    Family
                                </option>

                                <option value="Couple">
                                    Couple
                                </option>

                            </select>

                        </div>


                        <button
                            type="button"
                            id="applyQuickFilters"
                            class="apply-filter-button">

                            Explore Destinations
                            <i class="fa-solid fa-arrow-right"></i>

                        </button>

                    </div>

                </section>



                <!-- =================================================
                     RIGHT QUOTE IMAGE CARD
                     ================================================= -->

                <section class="dashboard-quote-card">

                    <div class="quote-card-overlay"></div>

                    <div class="quote-card-content">

                        <div class="quote-script">
                            Different<br>
                            Places<br>
                            Same You
                        </div>

                        <i class="fa-regular fa-heart quote-heart"></i>

                    </div>

                </section>


            </aside>

        </div>

    </main>

</div>


<script src="${pageContext.request.contextPath}/js/apiConfig.js"></script>
<script src="${pageContext.request.contextPath}/js/user.js"></script>
</body>
</html>