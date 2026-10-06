<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
        content="width=device-width, initial-scale=1.0">

    <title>Create Your Travel Profile - TripNexa</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
        rel="stylesheet">

    <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
        rel="stylesheet">

    <link
        href="${pageContext.request.contextPath}/css/createprofile.css?v=5"
        rel="stylesheet">

</head>


<body>

<div class="onboarding-page">

    <!-- BACKGROUND DECORATION -->

    <div class="bg-orb orb-one"></div>
    <div class="bg-orb orb-two"></div>
    <div class="bg-orb orb-three"></div>


    <!-- MAIN CARD -->

    <main class="profile-container">


        <!-- =====================================================
             TOP BAR
        ====================================================== -->

        <div class="top-bar">

            <button
                type="button"
                class="top-back"
                onclick="history.back()">

                <i class="fa-solid fa-arrow-left"></i>

            </button>


            <div class="mini-logo">

                <img
                    src="${pageContext.request.contextPath}/images/TripNexa_logo.png"
                    alt="TripNexa">

            </div>


            <button
                type="button"
                class="skip-btn"
                id="skipProfileBtn">

                Skip

            </button>

        </div>


        <!-- =====================================================
             INTRO
        ====================================================== -->

        <div class="onboarding-heading">

            <h1>
                Create Your<br>
                <span>Travel Profile</span>
            </h1>

            <p>
                Let's personalize your travel experience
            </p>

        </div>


        <!-- =====================================================
             TRAVEL ROUTE
        ====================================================== -->

        <div class="travel-route">

            <div class="route-location route-start">
                <i class="fa-solid fa-location-dot"></i>
            </div>

            <svg
                class="route-svg"
                viewBox="0 0 600 100"
                preserveAspectRatio="none">

                <path
                    d="M10 70 C120 20, 190 90, 300 48
                       C410 10, 460 90, 590 30"
                    fill="none"
                    stroke="rgba(102,78,210,.45)"
                    stroke-width="2"
                    stroke-dasharray="6 8"/>

            </svg>


            <div class="route-plane">

                <i class="fa-solid fa-plane"></i>

            </div>


            <div class="route-location route-end">

                <i class="fa-solid fa-location-dot"></i>

            </div>

        </div>


        <!-- =====================================================
             STEPS
        ====================================================== -->

        <div class="progress-wrapper">

            <div class="progress-line">

                <div
                    class="progress-fill"
                    id="progressFill">
                </div>

            </div>


            <div
                class="step-item active"
                data-step="1">

                <div class="step-circle">
                    <span>1</span>
                </div>

                <small>About You</small>

            </div>


            <div
                class="step-item"
                data-step="2">

                <div class="step-circle">
                    <span>2</span>
                </div>

                <small>Travel Style</small>

            </div>


            <div
                class="step-item"
                data-step="3">

                <div class="step-circle">
                    <span>3</span>
                </div>

                <small>Interests</small>

            </div>


            <div
                class="step-item"
                data-step="4">

                <div class="step-circle">
                    <span>4</span>
                </div>

                <small>Preferences</small>

            </div>

        </div>


        <!-- =====================================================
             TOAST
        ====================================================== -->

        <div
            id="profileToast"
            class="profile-toast d-none">

            <div class="toast-icon">

                <i
                    id="profileToastIcon"
                    class="fa-solid fa-circle-info">
                </i>

            </div>

            <div>

                <strong id="profileToastTitle">
                    Information
                </strong>

                <p id="profileToastMessage">
                    Please check the form.
                </p>

            </div>

            <button
                type="button"
                onclick="closeProfileToast()">

                <i class="fa-solid fa-xmark"></i>

            </button>

        </div>


        <!-- =====================================================
             FORM
        ====================================================== -->

        <form
            id="travelProfileForm"
            enctype="multipart/form-data">


            <!-- =================================================
                 STEP 1
            ================================================== -->

            <section
                class="form-step active"
                data-step="1">


                <div class="glass-section">


                    <div class="section-title">

                        <div class="section-icon purple">

                            <i class="fa-solid fa-user"></i>

                        </div>

                        <div>

                            <h2>Tell us about yourself</h2>

                            <p>
                                Help us understand who you are.
                            </p>

                        </div>

                    </div>


                    <!-- PROFILE PHOTO -->

                    <div class="profile-upload">

                        <div class="photo-wrapper">

                            <img
                                id="profilePhotoPreview"
                                src="${pageContext.request.contextPath}/images/TripNexa_logo.png"
                                alt="Profile">

                            <label
                                for="profilePhoto"
                                class="camera-button">

                                <i class="fa-solid fa-camera"></i>

                            </label>

                        </div>


                        <div class="photo-text">

                            <h4>Profile Photo</h4>

                            <p>
                                Add a photo to personalize your
                                travel profile.
                            </p>

                            <label
                                for="profilePhoto"
                                class="choose-photo">

                                <i class="fa-solid fa-upload"></i>
                                Choose Photo

                            </label>

                            <input
                                type="file"
                                id="profilePhoto"
                                name="profilePhoto"
                                accept="image/*"
                                hidden>

                        </div>

                    </div>


                    <!-- FULL NAME -->

                    <div class="modern-input full-name-field">

                        <label>
                            <i class="fa-solid fa-user"></i>
                            Full Name
                        </label>

                        <input
                            type="text"
                            id="fullName"
                            readonly
                            placeholder="Your registered name">

                    </div>


                    <!-- AGE + LOCATION -->

                    <div class="form-row">

                        <div class="modern-input">

                            <label>
                                <i class="fa-solid fa-cake-candles"></i>
                                Age
                            </label>

                            <input
                                type="number"
                                id="age"
                                name="age"
                                min="1"
                                max="100"
                                placeholder="24">

                        </div>


                        <div class="modern-input location-input">

                            <label>
                                <i class="fa-solid fa-location-dot"></i>
                                Location
                            </label>

                            <input
                                type="text"
                                id="location"
                                name="location"
                                maxlength="100"
                                placeholder="Pune, Maharashtra">

                            <i class="fa-solid fa-location-crosshairs">
                            </i>

                        </div>

                    </div>


                    <!-- COMPANION -->

                    <div class="question">

                        <h3>
                            Who do you usually travel with?
                        </h3>


                        <div class="selection-grid four">


                            <label class="selection-card">

                                <input
                                    type="radio"
                                    name="travelCompanion"
                                    value="Solo">

                                <span class="selection-content">

                                    <i class="fa-solid fa-person"></i>

                                    <b>Solo</b>

                                    <small>Just me</small>

                                </span>

                            </label>


                            <label class="selection-card">

                                <input
                                    type="radio"
                                    name="travelCompanion"
                                    value="Friends">

                                <span class="selection-content">

                                    <i class="fa-solid fa-user-group"></i>

                                    <b>Friends</b>

                                    <small>With friends</small>

                                </span>

                            </label>


                            <label class="selection-card">

                                <input
                                    type="radio"
                                    name="travelCompanion"
                                    value="Family">

                                <span class="selection-content">

                                    <i class="fa-solid fa-people-roof"></i>

                                    <b>Family</b>

                                    <small>Family trips</small>

                                </span>

                            </label>


                            <label class="selection-card">

                                <input
                                    type="radio"
                                    name="travelCompanion"
                                    value="Partner">

                                <span class="selection-content">

                                    <i class="fa-solid fa-heart"></i>

                                    <b>Couple</b>

                                    <small>With partner</small>

                                </span>

                            </label>

                        </div>

                    </div>

                </div>

            </section>


            <!-- =================================================
                 STEP 2
            ================================================== -->

            <section
                class="form-step"
                data-step="2">


                <div class="glass-section">


                    <div class="section-title">

                        <div class="section-icon purple">

                            <i class="fa-solid fa-suitcase-rolling"></i>

                        </div>

                        <div>

                            <h2>Your Travel Style</h2>

                            <p>
                                Tell us how you usually travel.
                            </p>

                        </div>

                    </div>


                    <!-- BUDGET -->

                    <div class="question">

                        <div class="question-top">

                            <h3>
                                What's your typical trip budget?
                            </h3>

                            <span
                                class="budget-display"
                                id="budgetDisplay">
                                ₹20,000
                            </span>

                        </div>


                        <div class="budget-labels">

                            <span>₹5,000</span>

                            <span>₹50,000+</span>

                        </div>


                        <input
                            type="range"
                            id="budget"
                            name="budget"
                            min="5000"
                            max="50000"
                            step="5000"
                            value="20000"
                            class="budget-range">


                        <div class="budget-value">

                            ₹
                            <span id="budgetValue">
                                20,000
                            </span>

                        </div>

                    </div>


                    <!-- DURATION -->

                    <div class="question">

                        <h3>
                            How long do you usually travel?
                        </h3>


                        <input
                            type="hidden"
                            id="tripDuration"
                            name="tripDuration">


                        <div class="selection-grid four compact">


                            <label class="selection-card duration-card">

                                <input
                                    type="radio"
                                    name="durationChoice"
                                    value="1-2 Days">

                                <span class="selection-content">

                                    <i class="fa-regular fa-calendar"></i>

                                    <b>1-2 Days</b>

                                </span>

                            </label>


                            <label class="selection-card duration-card">

                                <input
                                    type="radio"
                                    name="durationChoice"
                                    value="3-5 Days">

                                <span class="selection-content">

                                    <i class="fa-solid fa-calendar-days"></i>

                                    <b>3-5 Days</b>

                                </span>

                            </label>


                            <label class="selection-card duration-card">

                                <input
                                    type="radio"
                                    name="durationChoice"
                                    value="6-10 Days">

                                <span class="selection-content">

                                    <i class="fa-solid fa-calendar-week"></i>

                                    <b>6-10 Days</b>

                                </span>

                            </label>


                            <label class="selection-card duration-card">

                                <input
                                    type="radio"
                                    name="durationChoice"
                                    value="10+ Days">

                                <span class="selection-content">

                                    <i class="fa-solid fa-calendar-plus"></i>

                                    <b>10+ Days</b>

                                </span>

                            </label>

                        </div>

                    </div>


                    <!-- TRANSPORTATION -->

                    <div class="question">

                        <h3>
                            Preferred Transportation
                        </h3>


                        <input
                            type="hidden"
                            id="transportation"
                            name="transportation">


                        <div class="selection-grid four compact">


                            <label class="selection-card transport-card">

                                <input
                                    type="radio"
                                    name="transportChoice"
                                    value="Train">

                                <span class="selection-content">

                                    <i class="fa-solid fa-train"></i>

                                    <b>Train</b>

                                </span>

                            </label>


                            <label class="selection-card transport-card">

                                <input
                                    type="radio"
                                    name="transportChoice"
                                    value="Bus">

                                <span class="selection-content">

                                    <i class="fa-solid fa-bus"></i>

                                    <b>Bus</b>

                                </span>

                            </label>


                            <label class="selection-card transport-card">

                                <input
                                    type="radio"
                                    name="transportChoice"
                                    value="Flight">

                                <span class="selection-content">

                                    <i class="fa-solid fa-plane"></i>

                                    <b>Flight</b>

                                </span>

                            </label>


                            <label class="selection-card transport-card">

                                <input
                                    type="radio"
                                    name="transportChoice"
                                    value="Private Vehicle">

                                <span class="selection-content">

                                    <i class="fa-solid fa-car"></i>

                                    <b>Car</b>

                                </span>

                            </label>

                        </div>

                    </div>


                    <!-- ACCOMMODATION -->

                    <div class="question">

                        <h3>
                            Accommodation Preference
                        </h3>


                        <input
                            type="hidden"
                            id="accommodation"
                            name="accommodation">


                        <div class="selection-grid four compact">


                            <label class="selection-card">

                                <input
                                    type="radio"
                                    name="accommodationChoice"
                                    value="3 Star Hotel">

                                <span class="selection-content">

                                    <i class="fa-solid fa-hotel"></i>

                                    <b>Hotel</b>

                                </span>

                            </label>


                            <label class="selection-card">

                                <input
                                    type="radio"
                                    name="accommodationChoice"
                                    value="Hostel">

                                <span class="selection-content">

                                    <i class="fa-solid fa-bed"></i>

                                    <b>Hostel</b>

                                </span>

                            </label>


                            <label class="selection-card">

                                <input
                                    type="radio"
                                    name="accommodationChoice"
                                    value="Homestay">

                                <span class="selection-content">

                                    <i class="fa-solid fa-house"></i>

                                    <b>Homestay</b>

                                </span>

                            </label>


                            <label class="selection-card">

                                <input
                                    type="radio"
                                    name="accommodationChoice"
                                    value="Resort">

                                <span class="selection-content">

                                    <i class="fa-solid fa-umbrella-beach"></i>

                                    <b>Resort</b>

                                </span>

                            </label>

                        </div>

                    </div>

                </div>

            </section>


            <!-- =================================================
                 STEP 3
            ================================================== -->

            <section
                class="form-step"
                data-step="3">


                <div class="glass-section">


                    <div class="section-title">

                        <div class="section-icon purple">

                            <i class="fa-solid fa-heart"></i>

                        </div>

                        <div>

                            <h2>What excites you the most?</h2>

                            <p>
                                Select all that you love.
                            </p>

                        </div>

                    </div>


                    <div class="question">

                        <div class="interest-grid">


                            <label class="interest-card">

                                <input
                                    type="checkbox"
                                    name="interest"
                                    value="Nature">

                                <span>

                                    <i class="fa-solid fa-leaf"></i>

                                    <b>Nature</b>

                                </span>

                            </label>


                            <label class="interest-card">

                                <input
                                    type="checkbox"
                                    name="interest"
                                    value="Trekking">

                                <span>

                                    <i class="fa-solid fa-mountain"></i>

                                    <b>Trekking</b>

                                </span>

                            </label>


                            <label class="interest-card">

                                <input
                                    type="checkbox"
                                    name="interest"
                                    value="Beaches">

                                <span>

                                    <i class="fa-solid fa-umbrella-beach"></i>

                                    <b>Beaches</b>

                                </span>

                            </label>


                            <label class="interest-card">

                                <input
                                    type="checkbox"
                                    name="interest"
                                    value="Adventure">

                                <span>

                                    <i class="fa-solid fa-parachute-box"></i>

                                    <b>Adventure</b>

                                </span>

                            </label>


                            <label class="interest-card">

                                <input
                                    type="checkbox"
                                    name="interest"
                                    value="Photography">

                                <span>

                                    <i class="fa-solid fa-camera"></i>

                                    <b>Photography</b>

                                </span>

                            </label>


                            <label class="interest-card">

                                <input
                                    type="checkbox"
                                    name="interest"
                                    value="Historical">

                                <span>

                                    <i class="fa-solid fa-landmark"></i>

                                    <b>History</b>

                                </span>

                            </label>


                            <label class="interest-card">

                                <input
                                    type="checkbox"
                                    name="interest"
                                    value="Spirituality">

                                <span>

                                    <i class="fa-solid fa-hands-praying"></i>

                                    <b>Spirituality</b>

                                </span>

                            </label>


                            <label class="interest-card">

                                <input
                                    type="checkbox"
                                    name="interest"
                                    value="Shopping">

                                <span>

                                    <i class="fa-solid fa-bag-shopping"></i>

                                    <b>Shopping</b>

                                </span>

                            </label>


                            <label class="interest-card">

                                <input
                                    type="checkbox"
                                    name="interest"
                                    value="Nightlife">

                                <span>

                                    <i class="fa-solid fa-music"></i>

                                    <b>Nightlife</b>

                                </span>

                            </label>


                            <label class="interest-card">

                                <input
                                    type="checkbox"
                                    name="interest"
                                    value="Food">

                                <span>

                                    <i class="fa-solid fa-utensils"></i>

                                    <b>Food</b>

                                </span>

                            </label>

                        </div>

                    </div>


                    <!-- DESTINATION CATEGORY -->

                    <div class="question destination-question">

                        <h3>
                            Which destinations attract you?
                        </h3>


                        <div class="interest-grid category-grid">


                            <label class="interest-card">

                                <input
                                    type="checkbox"
                                    name="destinationCategory"
                                    value="Hill Station">

                                <span>

                                    <i class="fa-solid fa-mountain-sun"></i>

                                    <b>Hill Station</b>

                                </span>

                            </label>


                            <label class="interest-card">

                                <input
                                    type="checkbox"
                                    name="destinationCategory"
                                    value="Beach">

                                <span>

                                    <i class="fa-solid fa-water"></i>

                                    <b>Beach</b>

                                </span>

                            </label>


                            <label class="interest-card">

                                <input
                                    type="checkbox"
                                    name="destinationCategory"
                                    value="City">

                                <span>

                                    <i class="fa-solid fa-city"></i>

                                    <b>City</b>

                                </span>

                            </label>


                            <label class="interest-card">

                                <input
                                    type="checkbox"
                                    name="destinationCategory"
                                    value="Heritage">

                                <span>

                                    <i class="fa-solid fa-building-columns"></i>

                                    <b>Heritage</b>

                                </span>

                            </label>


                            <label class="interest-card">

                                <input
                                    type="checkbox"
                                    name="destinationCategory"
                                    value="Religious">

                                <span>

                                    <i class="fa-solid fa-place-of-worship"></i>

                                    <b>Religious</b>

                                </span>

                            </label>


                            <label class="interest-card">

                                <input
                                    type="checkbox"
                                    name="destinationCategory"
                                    value="Wildlife">

                                <span>

                                    <i class="fa-solid fa-paw"></i>

                                    <b>Wildlife</b>

                                </span>

                            </label>

                        </div>

                    </div>

                </div>

            </section>


            <!-- =================================================
                 STEP 4
            ================================================== -->

            <section
                class="form-step"
                data-step="4">


                <div class="glass-section">


                    <div class="section-title">

                        <div class="section-icon purple">

                            <i class="fa-solid fa-sliders"></i>

                        </div>

                        <div>

                            <h2>Almost done!</h2>

                            <p>
                                Any last preferences?
                            </p>

                        </div>

                    </div>


                    <!-- FOOD -->

                    <div class="question">

                        <h3>Food Preference</h3>


                        <input
                            type="hidden"
                            id="foodPreference"
                            name="foodPreference">


                        <div class="preference-grid">


                            <label class="preference-card">

                                <input
                                    type="radio"
                                    name="foodChoice"
                                    value="Vegetarian">

                                <span>

                                    <i class="fa-solid fa-leaf"></i>

                                    <b>Veg</b>

                                </span>

                            </label>


                            <label class="preference-card">

                                <input
                                    type="radio"
                                    name="foodChoice"
                                    value="Non-Vegetarian">

                                <span>

                                    <i class="fa-solid fa-drumstick-bite"></i>

                                    <b>Non-Veg</b>

                                </span>

                            </label>


                            <label class="preference-card">

                                <input
                                    type="radio"
                                    name="foodChoice"
                                    value="Vegan">

                                <span>

                                    <i class="fa-solid fa-seedling"></i>

                                    <b>Vegan</b>

                                </span>

                            </label>


                            <label class="preference-card">

                                <input
                                    type="radio"
                                    name="foodChoice"
                                    value="Any">

                                <span>

                                    <i class="fa-regular fa-face-smile"></i>

                                    <b>Any</b>

                                </span>

                            </label>

                        </div>

                    </div>


                    <!-- SEASON -->

                    <div class="question">

                        <h3>Preferred Season</h3>


                        <input
                            type="hidden"
                            id="preferredSeason"
                            name="preferredSeason">


                        <div class="preference-grid">


                            <label class="preference-card">

                                <input
                                    type="radio"
                                    name="seasonChoice"
                                    value="Summer">

                                <span>

                                    <i class="fa-solid fa-sun"></i>

                                    <b>Summer</b>

                                </span>

                            </label>


                            <label class="preference-card">

                                <input
                                    type="radio"
                                    name="seasonChoice"
                                    value="Monsoon">

                                <span>

                                    <i class="fa-solid fa-cloud-rain"></i>

                                    <b>Monsoon</b>

                                </span>

                            </label>


                            <label class="preference-card">

                                <input
                                    type="radio"
                                    name="seasonChoice"
                                    value="Winter">

                                <span>

                                    <i class="fa-regular fa-snowflake"></i>

                                    <b>Winter</b>

                                </span>

                            </label>


                            <label class="preference-card">

                                <input
                                    type="radio"
                                    name="seasonChoice"
                                    value="Any">

                                <span>

                                    <i class="fa-solid fa-earth-americas"></i>

                                    <b>Any</b>

                                </span>

                            </label>

                        </div>

                    </div>


                    <!-- EXPERIENCE -->

                    <div class="question">

                        <h3>Trip Experience</h3>


                        <div class="preference-grid experience-grid">


                            <label class="preference-card">

                                <input
                                    type="radio"
                                    name="tripExperience"
                                    value="First Time">

                                <span>

                                    <i class="fa-solid fa-seedling"></i>

                                    <b>Relaxing</b>

                                </span>

                            </label>


                            <label class="preference-card">

                                <input
                                    type="radio"
                                    name="tripExperience"
                                    value="Adventurous">

                                <span>

                                    <i class="fa-solid fa-mountain"></i>

                                    <b>Adventurous</b>

                                </span>

                            </label>


                            <label class="preference-card">

                                <input
                                    type="radio"
                                    name="tripExperience"
                                    value="Cultural">

                                <span>

                                    <i class="fa-solid fa-landmark"></i>

                                    <b>Cultural</b>

                                </span>

                            </label>


                            <label class="preference-card">

                                <input
                                    type="radio"
                                    name="tripExperience"
                                    value="Party">

                                <span>

                                    <i class="fa-solid fa-champagne-glasses"></i>

                                    <b>Party</b>

                                </span>

                            </label>

                        </div>

                    </div>


                    <!-- COMPLETION MESSAGE -->

                    <div class="completion-banner">

                        <div class="completion-plane">

                            <i class="fa-solid fa-plane"></i>

                        </div>

                        <div>

                            <strong>
                                🎉 Great! We'll find the best trips just for you.
                            </strong>

                            <p>
                                Your preferences will help us personalize
                                your travel recommendations.
                            </p>

                        </div>

                    </div>

                </div>

            </section>


            <!-- =================================================
                 NAVIGATION
            ================================================== -->

            <div class="form-navigation">


                <button
                    type="button"
                    id="previousBtn"
                    class="navigation-button back-button"
                    disabled>

                    <i class="fa-solid fa-arrow-left"></i>

                    <span>Back</span>

                </button>


                <button
                    type="button"
                    id="nextBtn"
                    class="navigation-button next-button">

                    <span>Next</span>

                    <i class="fa-solid fa-arrow-right"></i>

                </button>


                <button
                    type="submit"
                    id="saveBtn"
                    class="navigation-button complete-button d-none">

                    <span>Complete Profile</span>

                    <i class="fa-solid fa-check"></i>

                </button>

            </div>


        </form>

    </main>

</div>


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js">
</script>


<script src="${pageContext.request.contextPath}/js/apiConfig.js"></script>
<script src="${pageContext.request.contextPath}/js/create_profile.js"></script>
</body>

</html>
