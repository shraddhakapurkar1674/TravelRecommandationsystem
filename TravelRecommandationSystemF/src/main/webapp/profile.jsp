<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0">

    <title>
        My Profile - TripNexa
    </title>


    <!-- Bootstrap -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- Font Awesome -->

    <link
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
        rel="stylesheet">


    <!-- Google Font -->

    <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
        rel="stylesheet">


    <!-- Existing User CSS -->

    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/user.css?v=50">


    <!-- Profile CSS -->

    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/profile.css?v=50">


</head>


<body>


<!-- =========================================================
     SIDEBAR
========================================================= -->

<jsp:include page="sidebaruser.jsp">

    <jsp:param
        name="activePage"
        value="profile"/>

</jsp:include>



<!-- =========================================================
     MAIN WRAPPER
========================================================= -->

<div class="profile-page-wrapper">


    <!-- =====================================================
         EXISTING USER HEADER
    ====================================================== -->

    <jsp:include page="user-header.jsp"/>



    <!-- =====================================================
         PROFILE MAIN
    ====================================================== -->

    <main class="profile-main">


        <!-- =================================================
             PAGE INTRO
        ================================================== -->

        <section class="profile-page-intro">

            <div>

                <span class="profile-eyebrow">

                    <i class="fa-solid fa-sparkles"></i>

                    MY ACCOUNT

                </span>


                <h1>
                    My Profile
                </h1>


                <p>
                    Your personal information and travel
                    preferences — all in one place.
                </p>

            </div>


            <div class="profile-intro-badge">

                <i class="fa-solid fa-shield-heart"></i>

                Personalized Travel

            </div>

        </section>



        <!-- =================================================
             ERROR
        ================================================== -->

        <div
            id="profileError"
            class="profile-error d-none">

            <i class="fa-solid fa-circle-exclamation"></i>

            <span id="profileErrorText">
                Unable to load profile.
            </span>

        </div>



        <!-- =================================================
             PROFILE HERO
        ================================================== -->

        <section class="profile-hero">


            <div class="hero-glow glow-one"></div>

            <div class="hero-glow glow-two"></div>


            <!-- =================================================
                 PHOTO
            ================================================== -->

            <div class="profile-photo-area">

                <div class="profile-photo-ring">

                    <img
                        id="profilePhoto"
                        class="profile-photo"
                        src="${pageContext.request.contextPath}/images/TripNexa_logo.png"
                        alt="Profile Photo">

                    <span class="photo-status">

                        <i class="fa-solid fa-check"></i>

                    </span>

                </div>


                <span class="photo-caption">
                    Your profile photo
                </span>

            </div>



            <!-- =================================================
                 USER DETAILS
            ================================================== -->

            <div class="hero-user-info">


                <span class="profile-complete-badge">

                    <i class="fa-solid fa-circle-check"></i>

                    Profile Completed

                </span>


                <h2 id="profileName">
                    Travel Explorer
                </h2>


                <p id="profileEmail">
                    -
                </p>


                <div class="hero-location">

                    <i class="fa-solid fa-location-dot"></i>

                    <span id="profileLocation">
                        -
                    </span>

                </div>


                <div class="hero-mini-info">

                    <span>

                        <i class="fa-solid fa-heart"></i>

                        Travel Lover

                    </span>


                    <span>

                        <i class="fa-solid fa-wand-magic-sparkles"></i>

                        Personalized Recommendations

                    </span>

                </div>

            </div>



            <!-- =================================================
                 EDIT
            ================================================== -->

            <div class="hero-actions">

                <button
                    type="button"
                    id="editProfileButton"
                    class="profile-edit-btn">

                    <i class="fa-solid fa-pen-to-square"></i>

                    Edit Profile

                </button>

            </div>


        </section>



        <!-- =================================================
             QUICK STATS
        ================================================== -->

        <section class="profile-stats">


            <div class="stat-card">

                <div class="stat-icon purple">

                    <i class="fa-solid fa-cake-candles"></i>

                </div>

                <div>

                    <span>
                        AGE
                    </span>

                    <strong id="profileAge">
                        -
                    </strong>

                </div>

            </div>


            <div class="stat-card">

                <div class="stat-icon blue">

                    <i class="fa-solid fa-user-group"></i>

                </div>

                <div>

                    <span>
                        TRAVEL WITH
                    </span>

                    <strong id="profileCompanion">
                        -
                    </strong>

                </div>

            </div>


            <div class="stat-card">

                <div class="stat-icon green">

                    <i class="fa-solid fa-wallet"></i>

                </div>

                <div>

                    <span>
                        TRIP BUDGET
                    </span>

                    <strong id="profileBudget">
                        -
                    </strong>

                </div>

            </div>


            <div class="stat-card">

                <div class="stat-icon orange">

                    <i class="fa-solid fa-clock"></i>

                </div>

                <div>

                    <span>
                        DURATION
                    </span>

                    <strong id="profileDuration">
                        -
                    </strong>

                </div>

            </div>


        </section>



        <!-- =================================================
             INFORMATION GRID
        ================================================== -->

        <section class="profile-information-grid">


            <!-- =================================================
                 PERSONAL
            ================================================== -->

            <article class="profile-glass-card">


                <div class="card-title-row">

                    <div class="card-title-icon purple">

                        <i class="fa-solid fa-user"></i>

                    </div>

                    <div>

                        <h3>
                            Personal Information
                        </h3>

                        <p>
                            Your basic profile details
                        </p>

                    </div>

                </div>


                <div class="profile-info-list">


                    <div class="profile-info-row">

                        <div>

                            <i class="fa-solid fa-user"></i>

                            <span>
                                Full Name
                            </span>

                        </div>

                        <strong id="profileFullName">
                            -
                        </strong>

                    </div>


                    <div class="profile-info-row">

                        <div>

                            <i class="fa-solid fa-location-dot"></i>

                            <span>
                                Location
                            </span>

                        </div>

                        <strong id="infoLocation">
                            -
                        </strong>

                    </div>


                    <div class="profile-info-row">

                        <div>

                            <i class="fa-solid fa-calendar-days"></i>

                            <span>
                                Age
                            </span>

                        </div>

                        <strong id="infoAge">
                            -
                        </strong>

                    </div>


                    <div class="profile-info-row">

                        <div>

                            <i class="fa-solid fa-people-group"></i>

                            <span>
                                Travel Companion
                            </span>

                        </div>

                        <strong id="infoCompanion">
                            -
                        </strong>

                    </div>


                    <div class="profile-info-row">

                        <div>

                            <i class="fa-solid fa-utensils"></i>

                            <span>
                                Food Preference
                            </span>

                        </div>

                        <strong id="infoFood">
                            -
                        </strong>

                    </div>


                </div>

            </article>



            <!-- =================================================
                 TRAVEL STYLE
            ================================================== -->

            <article class="profile-glass-card">


                <div class="card-title-row">

                    <div class="card-title-icon blue">

                        <i class="fa-solid fa-plane-departure"></i>

                    </div>

                    <div>

                        <h3>
                            Travel Style
                        </h3>

                        <p>
                            Your preferred travel choices
                        </p>

                    </div>

                </div>


                <div class="profile-info-list">


                    <div class="profile-info-row">

                        <div>

                            <i class="fa-solid fa-wallet"></i>

                            <span>
                                Budget
                            </span>

                        </div>

                        <strong id="infoBudget">
                            -
                        </strong>

                    </div>


                    <div class="profile-info-row">

                        <div>

                            <i class="fa-solid fa-calendar-week"></i>

                            <span>
                                Trip Duration
                            </span>

                        </div>

                        <strong id="infoDuration">
                            -
                        </strong>

                    </div>


                    <div class="profile-info-row">

                        <div>

                            <i class="fa-solid fa-train"></i>

                            <span>
                                Transportation
                            </span>

                        </div>

                        <strong id="infoTransportation">
                            -
                        </strong>

                    </div>


                    <div class="profile-info-row">

                        <div>

                            <i class="fa-solid fa-hotel"></i>

                            <span>
                                Accommodation
                            </span>

                        </div>

                        <strong id="infoAccommodation">
                            -
                        </strong>

                    </div>


                </div>

            </article>



            <!-- =================================================
                 INTERESTS
            ================================================== -->

            <article
                class="profile-glass-card full-card">


                <div class="card-title-row">

                    <div class="card-title-icon pink">

                        <i class="fa-solid fa-heart"></i>

                    </div>

                    <div>

                        <h3>
                            Travel Interests
                        </h3>

                        <p>
                            Experiences you enjoy
                        </p>

                    </div>

                </div>


                <div class="tag-section">

                    <label>

                        <i class="fa-solid fa-star"></i>

                        Your Interests

                    </label>


                    <div
                        id="interestsContainer"
                        class="profile-tags">

                    </div>

                </div>


                <div class="tag-section">

                    <label>

                        <i class="fa-solid fa-map-location-dot"></i>

                        Destination Categories

                    </label>


                    <div
                        id="categoriesContainer"
                        class="profile-tags">

                    </div>

                </div>


            </article>



            <!-- =================================================
                 PREFERENCES
            ================================================== -->

            <article class="profile-glass-card">


                <div class="card-title-row">

                    <div class="card-title-icon orange">

                        <i class="fa-solid fa-sliders"></i>

                    </div>

                    <div>

                        <h3>
                            Trip Preferences
                        </h3>

                        <p>
                            Your ideal travel experience
                        </p>

                    </div>

                </div>


                <div class="preference-item">

                    <span>
                        <i class="fa-solid fa-cloud-sun"></i>
                        Preferred Season
                    </span>

                    <strong id="infoSeason">
                        -
                    </strong>

                </div>


                <div class="preference-item">

                    <span>
                        <i class="fa-solid fa-star"></i>
                        Trip Experience
                    </span>

                    <strong id="infoExperience">
                        -
                    </strong>

                </div>


            </article>



            <!-- =================================================
                 PROFILE STATUS
            ================================================== -->

            <article class="profile-glass-card">


                <div class="card-title-row">

                    <div class="card-title-icon green">

                        <i class="fa-solid fa-shield-heart"></i>

                    </div>

                    <div>

                        <h3>
                            Recommendation Status
                        </h3>

                        <p>
                            Your profile is ready
                        </p>

                    </div>

                </div>


                <div class="recommendation-ready">

                    <div class="ready-icon">

                        <i class="fa-solid fa-check"></i>

                    </div>


                    <div>

                        <strong>
                            Personalized Recommendations Ready
                        </strong>

                        <p>
                            Your travel preferences can now
                            be used to find better destinations
                            for you.
                        </p>

                    </div>

                </div>


            </article>


        </section>


    </main>

</div>



<script>

const CONTEXT_PATH =
    "${pageContext.request.contextPath}";

</script>


<script src="${pageContext.request.contextPath}/js/apiConfig.js"></script>
<script src="${pageContext.request.contextPath}/js/profile.js"></script>
</body>

</html>