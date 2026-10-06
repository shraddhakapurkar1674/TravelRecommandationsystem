document.addEventListener("DOMContentLoaded", function () {

    loadCurrentUserProfile();

    setupProfileButtons();

});


/* =========================================================
   CONFIG
========================================================= */

const BACKEND_URL =
    API_CONFIG.BASE_URL;

const PROFILE_API =
    BACKEND_URL +
    "/api/travel-profile";


const FRONTEND_URL =
    API_CONFIG.FRONTEND_BASE_URL;


/* =========================================================
   GET CURRENT USER ID
========================================================= */

function getCurrentUserId() {

    let userId =
        localStorage.getItem("userId");

    if (!userId) {

        userId =
            sessionStorage.getItem("userId");

    }

    return userId;

}


/* =========================================================
   GET USER NAME
========================================================= */

function getCurrentUserName() {

    return (

        localStorage.getItem("userName") ||

        sessionStorage.getItem("userName") ||

        "Travel Explorer"

    );

}


/* =========================================================
   GET USER EMAIL
========================================================= */

function getCurrentUserEmail() {

    return (

        localStorage.getItem("userEmail") ||

        sessionStorage.getItem("userEmail") ||

        ""

    );

}


/* =========================================================
   LOAD PROFILE
========================================================= */

async function loadCurrentUserProfile() {

    const userId =
        getCurrentUserId();


    console.log(
        "CURRENT USER ID:",
        userId
    );


    if (!userId) {

        showProfileError(
            "Logged-in user not found."
        );

        return;

    }


    try {

        const token =
            localStorage.getItem("token") ||
            sessionStorage.getItem("token");


        const headers = {
            "Content-Type":
                "application/json"
        };


        if (token) {

            headers["Authorization"] =
                "Bearer " + token;

        }


        console.log(
            "PROFILE API:",
            PROFILE_API + "/" + userId
        );


        const response =
            await fetch(

                PROFILE_API +
                "/" +
                encodeURIComponent(userId),

                {
                    method: "GET",
                    headers: headers
                }

            );


        console.log(
            "PROFILE STATUS:",
            response.status
        );


        const text =
            await response.text();


        console.log(
            "PROFILE RAW RESPONSE:",
            text
        );


        if (!response.ok) {

            throw new Error(
                "Profile API returned " +
                response.status
            );

        }


        let result;


        try {

            result =
                JSON.parse(text);

        } catch (e) {

            throw new Error(
                "Backend returned invalid JSON."
            );

        }


        console.log(
            "PROFILE JSON:",
            result
        );


        /*
         * Backend कधी:
         *
         * {
         *   success:true,
         *   data:{...}
         * }
         *
         * return करेल.
         *
         * किंवा direct:
         *
         * {...}
         *
         * return करू शकतो.
         */


        let profile;


        if (
            result &&
            result.data
        ) {

            profile =
                result.data;

        } else {

            profile =
                result;

        }


        if (
            !profile ||
            typeof profile !== "object"
        ) {

            throw new Error(
                "Profile data not found."
            );

        }


        console.log(
            "FINAL PROFILE:",
            profile
        );


        displayProfile(
            profile
        );


    } catch (error) {

        console.error(
            "PROFILE ERROR:",
            error
        );


        showProfileError(
            "Unable to load profile information."
        );

    }

}


/* =========================================================
   DISPLAY PROFILE
========================================================= */

function displayProfile(profile) {

    console.log(
        "DISPLAYING PROFILE:",
        profile
    );


    hideElement(
        "profileLoading"
    );


    hideElement(
        "profileError"
    );


    hideElement(
        "noProfile"
    );


    showElement(
        "profileContent"
    );


    /* =====================================================
       USER INFORMATION
    ===================================================== */

    const userName =
        getCurrentUserName();


    const userEmail =
        getCurrentUserEmail();


    setText(
        "profileName",
        userName
    );


    setText(
        "profileFullName",
        userName
    );


    setText(
        "profileEmail",
        userEmail
    );


    /* =====================================================
       LOCATION
    ===================================================== */

    setText(
        "profileLocation",
        profile.location
    );


    setText(
        "infoLocation",
        profile.location
    );


    /* =====================================================
       AGE
    ===================================================== */

    setText(
        "profileAge",
        profile.age
    );


    setText(
        "infoAge",
        profile.age
    );


    /* =====================================================
       TRAVEL COMPANION
    ===================================================== */

    setText(
        "profileCompanion",
        profile.travelCompanion
    );


    setText(
        "infoCompanion",
        profile.travelCompanion
    );


    /* =====================================================
       BUDGET
    ===================================================== */

    setText(
        "profileBudget",
        formatBudget(profile.budget)
    );


    setText(
        "infoBudget",
        formatBudget(profile.budget)
    );


    /* =====================================================
       TRIP DURATION
    ===================================================== */

    setText(
        "profileDuration",
        profile.tripDuration
    );


    setText(
        "infoDuration",
        profile.tripDuration
    );


    /* =====================================================
       TRANSPORTATION
    ===================================================== */

    setText(
        "infoTransportation",
        profile.transportation
    );


    /* =====================================================
       ACCOMMODATION
    ===================================================== */

    setText(
        "infoAccommodation",
        profile.accommodation
    );


    /* =====================================================
       FOOD
    ===================================================== */

    setText(
        "infoFood",
        profile.foodPreference
    );


    /* =====================================================
       SEASON
    ===================================================== */

    setText(
        "infoSeason",
        profile.preferredSeason
    );


    /* =====================================================
       EXPERIENCE
    ===================================================== */

    setText(
        "infoExperience",
        profile.tripExperience
    );


    /* =====================================================
       INTERESTS
    ===================================================== */

    renderTags(
        "interestsContainer",
        profile.interests
    );


    /* =====================================================
       DESTINATION CATEGORIES
    ===================================================== */

    renderTags(
        "categoriesContainer",
        profile.destinationCategories
    );


    /* =====================================================
       PROFILE PHOTO
    ===================================================== */

    displayUserPhoto(
        profile.profilePhoto
    );

}


/* =========================================================
   DISPLAY USER PHOTO
========================================================= */

function displayUserPhoto(
    profilePhoto
) {

    const image =
        document.getElementById(
            "profilePhoto"
        );


    if (!image) {

        console.error(
            "profilePhoto image element not found."
        );

        return;

    }


    /*
     * DB मध्ये:
     *
     * shraddha.jpg
     *
     * असेल.
     *
     * कधी जुन्या data मध्ये:
     *
     * uploads/profile/shraddha.jpg
     *
     * असेल तरी खालील code फक्त filename घेईल.
     */


    if (
        !profilePhoto ||
        String(profilePhoto).trim() === ""
    ) {

        image.src =
            FRONTEND_URL +
            "/images/TripNexa_logo.png";

        return;

    }


    const cleanFileName =
        String(profilePhoto)
            .trim()
            .replace(/\\/g, "/")
            .split("/")
            .pop();


    const imageURL =
        BACKEND_URL +
        "/uploads/profile/" +
        encodeURIComponent(
            cleanFileName
        );


    console.log(
        "USER PROFILE PHOTO:",
        imageURL
    );


    image.src =
        imageURL;


    image.onerror =
        function () {

            console.error(
                "USER PHOTO NOT FOUND:",
                imageURL
            );


            this.onerror =
                null;


            this.src =
                FRONTEND_URL +
                "/images/TripNexa_logo.png";

        };

}


/* =========================================================
   RENDER TAGS
========================================================= */

function renderTags(
    elementId,
    values
) {

    const container =
        document.getElementById(
            elementId
        );


    if (!container) {

        return;

    }


    container.innerHTML =
        "";


    if (
        !values ||
        String(values).trim() === ""
    ) {

        container.innerHTML =
            '<span class="profile-tag muted-tag">' +
            'Not specified' +
            '</span>';

        return;

    }


    const items =
        String(values)
            .split(",")
            .map(
                function (item) {

                    return item.trim();

                }
            )
            .filter(
                function (item) {

                    return item !== "";

                }
            );


    items.forEach(
        function (item) {

            const tag =
                document.createElement(
                    "span"
                );


            tag.className =
                "profile-tag";


            tag.textContent =
                item;


            container.appendChild(
                tag
            );

        }
    );

}


/* =========================================================
   FORMAT BUDGET
========================================================= */

function formatBudget(
    value
) {

    if (
        value === null ||
        value === undefined ||
        value === ""
    ) {

        return "-";

    }


    const number =
        Number(value);


    if (
        Number.isNaN(number)
    ) {

        return value;

    }


    return "₹" +
        number.toLocaleString(
            "en-IN"
        );

}


/* =========================================================
   SET TEXT
========================================================= */

function setText(
    elementId,
    value
) {

    const element =
        document.getElementById(
            elementId
        );


    if (!element) {

        return;

    }


    if (
        value === null ||
        value === undefined ||
        String(value).trim() === ""
    ) {

        element.textContent =
            "-";

        return;

    }


    element.textContent =
        value;

}


/* =========================================================
   SHOW ELEMENT
========================================================= */

function showElement(
    elementId
) {

    const element =
        document.getElementById(
            elementId
        );


    if (!element) {

        return;

    }


    element.classList.remove(
        "d-none"
    );


    element.style.display =
        "";

}


/* =========================================================
   HIDE ELEMENT
========================================================= */

function hideElement(
    elementId
) {

    const element =
        document.getElementById(
            elementId
        );


    if (!element) {

        return;

    }


    element.classList.add(
        "d-none"
    );


    element.style.display =
        "none";

}


/* =========================================================
   ERROR
========================================================= */

function showProfileError(
    message
) {

    hideElement(
        "profileLoading"
    );


    hideElement(
        "profileContent"
    );


    hideElement(
        "noProfile"
    );


    const error =
        document.getElementById(
            "profileError"
        );


    const errorText =
        document.getElementById(
            "profileErrorText"
        );


    if (errorText) {

        errorText.textContent =
            message;

    }


    if (error) {

        error.classList.remove(
            "d-none"
        );


        error.style.display =
            "block";

    }

}


/* =========================================================
   BUTTONS
========================================================= */

function setupProfileButtons() {

    const editButton =
        document.getElementById(
            "editProfileButton"
        );


    if (editButton) {

        editButton.onclick =
            function () {

                window.location.href =
                    FRONTEND_URL +
                    "/create_profile.jsp";

            };

    }


    const createButton =
        document.getElementById(
            "createProfileButton"
        );


    if (createButton) {

        createButton.onclick =
            function () {

                window.location.href =
                    FRONTEND_URL +
                    "/create_profile.jsp";

            };

    }

}