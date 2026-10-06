document.addEventListener("DOMContentLoaded", function () {

    // =========================================================
    // CONFIGURATION
    // =========================================================

    const BACKEND_PATH = API_CONFIG.BASE_URL;
    const FRONTEND_PATH = API_CONFIG.FRONTEND_BASE_URL;

    const PROFILE_API =
        BACKEND_PATH + "/api/travel-profile";

    const UPLOAD_PHOTO_API =
        BACKEND_PATH + "/api/travel-profile/upload-photo/";

    const USER_DASHBOARD =
        FRONTEND_PATH + "/user_dashboard.jsp";

    const LOGIN_PAGE =
        FRONTEND_PATH + "/login.jsp";

    const DEFAULT_PROFILE_IMAGE =
        FRONTEND_PATH + "/images/TripNexa_logo.png";


    // =========================================================
    // CURRENT USER
    // =========================================================

    const userId =
        localStorage.getItem("userId") ||
        sessionStorage.getItem("userId");

    const token =
        localStorage.getItem("token") ||
        sessionStorage.getItem("token");

    const userName =
        localStorage.getItem("userName") ||
        sessionStorage.getItem("userName") ||
        "";


    if (!userId || !token) {

        alert("Please login before creating your profile.");

        window.location.href = LOGIN_PAGE;

        return;
    }


    // =========================================================
    // ELEMENTS
    // =========================================================

    const form =
        document.getElementById("travelProfileForm");

    const nextBtn =
        document.getElementById("nextBtn");

    const previousBtn =
        document.getElementById("previousBtn");

    const saveBtn =
        document.getElementById("saveBtn");

    const progressFill =
        document.getElementById("progressFill");

    const profilePhoto =
        document.getElementById("profilePhoto");

    const profilePhotoPreview =
        document.getElementById("profilePhotoPreview");

    const steps =
        Array.from(
            document.querySelectorAll(".form-step")
        );

    const stepItems =
        Array.from(
            document.querySelectorAll(".step-item")
        );


    let currentStep = 1;
    let existingProfile = null;
    let profileExists = false;


    // =========================================================
    // SHOW CURRENT USER NAME
    // =========================================================

    const fullNameInput =
        document.getElementById("fullName");

    if (fullNameInput) {
        fullNameInput.value =
            userName || "";
    }


    const fullNameDisplay =
        document.getElementById("profileUserName");

    if (fullNameDisplay) {
        fullNameDisplay.textContent =
            userName || "Travel Explorer";
    }


    // =========================================================
    // PHOTO PREVIEW
    // =========================================================

    if (profilePhoto) {

        profilePhoto.addEventListener(
            "change",
            function () {

                const file =
                    this.files && this.files.length
                        ? this.files[0]
                        : null;

                if (!file) {
                    return;
                }


                // IMAGE TYPE

                if (!file.type.startsWith("image/")) {

                    showProfileMessage(
                        "Invalid Image",
                        "Please select a valid image file.",
                        "error"
                    );

                    this.value = "";

                    if (profilePhotoPreview) {
                        profilePhotoPreview.src =
                            DEFAULT_PROFILE_IMAGE;
                    }

                    return;
                }


                // IMAGE SIZE

                if (file.size > 10 * 1024 * 1024) {

                    showProfileMessage(
                        "Image Too Large",
                        "Image size must be less than 10 MB.",
                        "error"
                    );

                    this.value = "";

                    if (profilePhotoPreview) {
                        profilePhotoPreview.src =
                            DEFAULT_PROFILE_IMAGE;
                    }

                    return;
                }


                // IMAGE PREVIEW

                const reader =
                    new FileReader();

                reader.onload =
                    function (event) {

                        if (profilePhotoPreview) {

                            profilePhotoPreview.src =
                                event.target.result;
                        }
                    };

                reader.readAsDataURL(file);
            }
        );
    }


    // =========================================================
    // DIRECT RADIO VALUE
    // IMPORTANT FIX
    // =========================================================

    function getSelectedValue(name) {

        const selected =
            document.querySelector(
                'input[name="' + name + '"]:checked'
            );

        return selected
            ? selected.value
            : "";
    }


    // =========================================================
    // GET CHECKED CHECKBOX VALUES
    // =========================================================

    function getCheckedValues(name) {

        return Array.from(
            document.querySelectorAll(
                'input[name="' + name + '"]:checked'
            )
        )
        .map(function (item) {
            return item.value;
        })
        .join(", ");
    }


    // =========================================================
    // CONNECT RADIO TO HIDDEN INPUT
    // KEPT FOR FRONTEND COMPATIBILITY
    // =========================================================

    function connectRadio(
        radioName,
        hiddenId
    ) {

        const radios =
            document.querySelectorAll(
                'input[name="' + radioName + '"]'
            );

        const hidden =
            document.getElementById(hiddenId);


        radios.forEach(function (radio) {

            radio.addEventListener(
                "change",
                function () {

                    if (hidden) {

                        hidden.value =
                            this.value;
                    }

                    console.log(
                        radioName +
                        " selected:",
                        this.value
                    );
                }
            );
        });
    }


    connectRadio(
        "durationChoice",
        "tripDuration"
    );

    connectRadio(
        "transportChoice",
        "transportation"
    );

    connectRadio(
        "accommodationChoice",
        "accommodation"
    );

    connectRadio(
        "foodChoice",
        "foodPreference"
    );

    connectRadio(
        "seasonChoice",
        "preferredSeason"
    );


    // =========================================================
    // BUDGET
    // =========================================================

    const budget =
        document.getElementById("budget");

    const budgetDisplay =
        document.getElementById("budgetDisplay");

    const budgetValue =
        document.getElementById("budgetValue");


    function formatMoney(value) {

        return Number(value)
            .toLocaleString("en-IN");
    }


    function updateBudget() {

        if (!budget) {
            return;
        }


        const value =
            Number(budget.value);


        if (budgetDisplay) {

            budgetDisplay.innerText =
                "₹" + formatMoney(value);
        }


        if (budgetValue) {

            budgetValue.innerText =
                formatMoney(value);
        }


        const min =
            Number(budget.min);

        const max =
            Number(budget.max);


        if (max === min) {
            return;
        }


        const percentage =
            ((value - min) /
            (max - min)) * 100;


        budget.style.background =
            `linear-gradient(
                90deg,
                #6242d9 0%,
                #6242d9 ${percentage}%,
                #e4e1ed ${percentage}%,
                #e4e1ed 100%
            )`;
    }


    if (budget) {

        budget.addEventListener(
            "input",
            updateBudget
        );

        updateBudget();
    }


    // =========================================================
    // SHOW STEP
    // =========================================================

    function showStep(stepNumber) {

        currentStep =
            stepNumber;


        steps.forEach(function (step) {

            const stepValue =
                Number(step.dataset.step);

            step.classList.toggle(
                "active",
                stepValue === currentStep
            );
        });


        stepItems.forEach(function (item) {

            const itemStep =
                Number(item.dataset.step);


            item.classList.toggle(
                "active",
                itemStep === currentStep
            );


            item.classList.toggle(
                "completed",
                itemStep < currentStep
            );
        });


        if (progressFill) {

            const percentage =
                ((currentStep - 1) / 3) * 100;

            progressFill.style.width =
                percentage + "%";
        }


        if (previousBtn) {

            previousBtn.disabled =
                currentStep === 1;
        }


        if (nextBtn) {

            nextBtn.classList.toggle(
                "d-none",
                currentStep === steps.length
            );
        }


        if (saveBtn) {

            saveBtn.classList.toggle(
                "d-none",
                currentStep !== steps.length
            );
        }


        window.scrollTo({
            top: 0,
            behavior: "smooth"
        });
    }


    // =========================================================
    // SET RADIO VALUE
    // =========================================================

    function setRadioValue(
        name,
        value
    ) {

        if (
            value === null ||
            value === undefined ||
            String(value).trim() === ""
        ) {
            return;
        }


        const targetValue =
            String(value).trim();


        const radios =
            document.querySelectorAll(
                'input[name="' + name + '"]'
            );


        radios.forEach(function (radio) {

            radio.checked =
                radio.value.trim() === targetValue;
        });


        // Update hidden field too

        const hiddenMap = {
            durationChoice: "tripDuration",
            transportChoice: "transportation",
            accommodationChoice: "accommodation",
            foodChoice: "foodPreference",
            seasonChoice: "preferredSeason"
        };


        const hiddenId =
            hiddenMap[name];


        if (hiddenId) {

            const hidden =
                document.getElementById(hiddenId);

            if (hidden) {
                hidden.value = targetValue;
            }
        }
    }


    // =========================================================
    // SET CHECKBOX VALUES
    // =========================================================

    function setCheckboxValues(
        name,
        value
    ) {

        const checkboxes =
            document.querySelectorAll(
                'input[name="' + name + '"]'
            );


        checkboxes.forEach(function (checkbox) {

            checkbox.checked = false;
        });


        if (
            value === null ||
            value === undefined
        ) {
            return;
        }


        let values = [];


        if (Array.isArray(value)) {

            values = value.map(function (item) {
                return String(item).trim();
            });

        } else {

            values =
                String(value)
                    .split(",")
                    .map(function (item) {
                        return item.trim();
                    })
                    .filter(function (item) {
                        return item !== "";
                    });
        }


        checkboxes.forEach(function (checkbox) {

            checkbox.checked =
                values.includes(
                    checkbox.value.trim()
                );
        });
    }


    // =========================================================
    // LOAD EXISTING PROFILE
    // =========================================================

    async function loadExistingProfile() {

        try {

            const response =
                await fetch(
                    PROFILE_API +
                    "/" +
                    encodeURIComponent(userId),
                    {
                        method: "GET",

                        headers: {
                            "Authorization":
                                "Bearer " + token,

                            "Content-Type":
                                "application/json"
                        }
                    }
                );


            if (response.status === 404) {

                profileExists = false;

                existingProfile = null;

                setCreateMode();

                return;
            }


            if (!response.ok) {

                throw new Error(
                    "Unable to load existing profile."
                );
            }


            const result =
                await response.json();


            console.log(
                "EXISTING PROFILE:",
                result
            );


            if (
                result &&
                result.success === true &&
                result.data
            ) {

                profileExists = true;

                existingProfile =
                    result.data;


                fillExistingProfile(
                    existingProfile
                );


                setEditMode();

            } else {

                profileExists = false;

                existingProfile = null;

                setCreateMode();
            }


        } catch (error) {

            console.error(
                "PROFILE LOAD ERROR:",
                error
            );


            profileExists = false;

            existingProfile = null;

            setCreateMode();
        }
    }


    // =========================================================
    // FILL EXISTING PROFILE
    // =========================================================

    function fillExistingProfile(profile) {

        console.log(
            "FILLING EXISTING PROFILE:",
            profile
        );


        // FULL NAME

        const nameField =
            document.getElementById("fullName");

        if (nameField) {

            nameField.value =
                userName;
        }


        // AGE

        const age =
            document.getElementById("age");

        if (age) {

            age.value =
                profile.age ?? "";
        }


        // LOCATION

        const location =
            document.getElementById("location");

        if (location) {

            location.value =
                profile.location || "";
        }


        // TRAVEL COMPANION

        setRadioValue(
            "travelCompanion",
            profile.travelCompanion
        );


        // BUDGET

        if (budget) {

            if (
                profile.budget !== null &&
                profile.budget !== undefined
            ) {

                budget.value =
                    profile.budget;
            }

            updateBudget();
        }


        // DURATION

        setRadioValue(
            "durationChoice",
            profile.tripDuration
        );


        // TRANSPORTATION

        setRadioValue(
            "transportChoice",
            profile.transportation
        );


        // ACCOMMODATION

        setRadioValue(
            "accommodationChoice",
            profile.accommodation
        );


        // INTERESTS

        setCheckboxValues(
            "interest",
            profile.interests
        );


        // DESTINATION CATEGORIES

        setCheckboxValues(
            "destinationCategory",
            profile.destinationCategories
        );


        // FOOD

        setRadioValue(
            "foodChoice",
            profile.foodPreference
        );


        // SEASON

        setRadioValue(
            "seasonChoice",
            profile.preferredSeason
        );


        // EXPERIENCE

        setRadioValue(
            "tripExperience",
            profile.tripExperience
        );


        // EXISTING PHOTO

        if (
            profile.profilePhoto &&
            String(profile.profilePhoto).trim() !== ""
        ) {

            const fileName =
                String(profile.profilePhoto)
                    .trim()
                    .replace(/\\/g, "/")
                    .split("/")
                    .pop();


            const imageUrl =
                BACKEND_PATH +
                "/uploads/profile/" +
                encodeURIComponent(fileName);


            console.log(
                "EXISTING PHOTO URL:",
                imageUrl
            );


            if (profilePhotoPreview) {

                profilePhotoPreview.src =
                    imageUrl;


                profilePhotoPreview.onerror =
                    function () {

                        this.onerror = null;

                        this.src =
                            DEFAULT_PROFILE_IMAGE;
                    };
            }
        }
    }


    // =========================================================
    // CREATE MODE
    // =========================================================

    function setCreateMode() {

        const heading =
            document.querySelector(
                ".onboarding-heading h1"
            );


        if (heading) {

            heading.innerHTML =
                'Create Your<br>' +
                '<span>Travel Profile</span>';
        }


        const description =
            document.querySelector(
                ".onboarding-heading p"
            );


        if (description) {

            description.textContent =
                "Let's personalize your travel experience";
        }


        if (saveBtn) {

            saveBtn.innerHTML =
                '<span>Complete Profile</span>' +
                '<i class="fa-solid fa-check"></i>';
        }
    }


    // =========================================================
    // EDIT MODE
    // =========================================================

    function setEditMode() {

        const heading =
            document.querySelector(
                ".onboarding-heading h1"
            );


        if (heading) {

            heading.innerHTML =
                'Update Your<br>' +
                '<span>Travel Profile</span>';
        }


        const description =
            document.querySelector(
                ".onboarding-heading p"
            );


        if (description) {

            description.textContent =
                "Update your travel information and preferences.";
        }


        if (saveBtn) {

            saveBtn.innerHTML =
                '<span>Update Profile</span>' +
                '<i class="fa-solid fa-save"></i>';
        }
    }


    // =========================================================
    // VALIDATION
    // =========================================================

    function validateCurrentStep() {


        // =====================================================
        // STEP 1
        // =====================================================

        if (currentStep === 1) {

            const age =
                document.getElementById("age");

            const location =
                document.getElementById("location");

            const companion =
                getSelectedValue(
                    "travelCompanion"
                );


            if (
                !age ||
                !age.value ||
                Number(age.value) < 1
            ) {

                showProfileMessage(
                    "Age Required",
                    "Please enter your age.",
                    "error"
                );

                if (age) {
                    age.focus();
                }

                return false;
            }


            if (
                !location ||
                !location.value.trim()
            ) {

                showProfileMessage(
                    "Location Required",
                    "Please enter your location.",
                    "error"
                );

                if (location) {
                    location.focus();
                }

                return false;
            }


            if (!companion) {

                showProfileMessage(
                    "Travel Companion",
                    "Please select who you usually travel with.",
                    "error"
                );

                return false;
            }
        }


        // =====================================================
        // STEP 2
        // =====================================================

        if (currentStep === 2) {

            const duration =
                getSelectedValue(
                    "durationChoice"
                );

            const transportation =
                getSelectedValue(
                    "transportChoice"
                );

            const accommodation =
                getSelectedValue(
                    "accommodationChoice"
                );


            if (!duration) {

                showProfileMessage(
                    "Trip Duration",
                    "Please select your usual trip duration.",
                    "error"
                );

                return false;
            }


            if (!transportation) {

                showProfileMessage(
                    "Transportation",
                    "Please select your preferred transportation.",
                    "error"
                );

                return false;
            }


            if (!accommodation) {

                showProfileMessage(
                    "Accommodation",
                    "Please select your preferred accommodation.",
                    "error"
                );

                return false;
            }
        }


        // =====================================================
        // STEP 3
        // =====================================================

        if (currentStep === 3) {

            const interests =
                document.querySelectorAll(
                    'input[name="interest"]:checked'
                );

            const categories =
                document.querySelectorAll(
                    'input[name="destinationCategory"]:checked'
                );


            if (interests.length === 0) {

                showProfileMessage(
                    "Choose Your Interests",
                    "Select at least one travel interest.",
                    "error"
                );

                return false;
            }


            if (categories.length === 0) {

                showProfileMessage(
                    "Choose Destinations",
                    "Select at least one destination category.",
                    "error"
                );

                return false;
            }
        }


        // =====================================================
        // STEP 4
        // =====================================================

        if (currentStep === 4) {

            const food =
                getSelectedValue(
                    "foodChoice"
                );

            const season =
                getSelectedValue(
                    "seasonChoice"
                );

            const experience =
                getSelectedValue(
                    "tripExperience"
                );


            if (!food) {

                showProfileMessage(
                    "Food Preference",
                    "Please select your food preference.",
                    "error"
                );

                return false;
            }


            if (!season) {

                showProfileMessage(
                    "Preferred Season",
                    "Please select your preferred season.",
                    "error"
                );

                return false;
            }


            if (!experience) {

                showProfileMessage(
                    "Trip Experience",
                    "Please select your travel experience.",
                    "error"
                );

                return false;
            }
        }


        return true;
    }


    // =========================================================
    // NEXT
    // =========================================================

    if (nextBtn) {

        nextBtn.addEventListener(
            "click",
            function () {

                if (!validateCurrentStep()) {
                    return;
                }


                if (
                    currentStep <
                    steps.length
                ) {

                    showStep(
                        currentStep + 1
                    );
                }
            }
        );
    }


    // =========================================================
    // BACK
    // =========================================================

    if (previousBtn) {

        previousBtn.addEventListener(
            "click",
            function () {

                if (currentStep > 1) {

                    showStep(
                        currentStep - 1
                    );
                }
            }
        );
    }


    // =========================================================
    // SAVE / UPDATE
    // =========================================================

    if (form) {

        form.addEventListener(
            "submit",
            async function (event) {

                event.preventDefault();


                if (!validateCurrentStep()) {
                    return;
                }


                if (saveBtn) {

                    saveBtn.disabled = true;

                    saveBtn.innerHTML =
                        '<i class="fa-solid fa-spinner fa-spin"></i> Saving...';
                }


                try {

                    // -------------------------------------------------
                    // READ VALUES DIRECTLY FROM FORM
                    // -------------------------------------------------

                    const ageElement =
                        document.getElementById("age");

                    const locationElement =
                        document.getElementById("location");

                    const budgetElement =
                        document.getElementById("budget");


                    const profileData = {

                        userId:
                            Number(userId),

                        profilePhoto:
                            existingProfile &&
                            existingProfile.profilePhoto
                                ? existingProfile.profilePhoto
                                : null,

                        age:
                            Number(
                                ageElement.value
                            ),

                        location:
                            locationElement.value.trim(),

                        travelCompanion:
                            getSelectedValue(
                                "travelCompanion"
                            ),

                        budget:
                            Number(
                                budgetElement.value
                            ),

                        tripDuration:
                            getSelectedValue(
                                "durationChoice"
                            ),

                        transportation:
                            getSelectedValue(
                                "transportChoice"
                            ),

                        accommodation:
                            getSelectedValue(
                                "accommodationChoice"
                            ),

                        interests:
                            getCheckedValues(
                                "interest"
                            ),

                        destinationCategories:
                            getCheckedValues(
                                "destinationCategory"
                            ),

                        foodPreference:
                            getSelectedValue(
                                "foodChoice"
                            ),

                        preferredSeason:
                            getSelectedValue(
                                "seasonChoice"
                            ),

                        tripExperience:
                            getSelectedValue(
                                "tripExperience"
                            ),

                        profileCompleted:
                            true
                    };


                    // -------------------------------------------------
                    // DEBUG
                    // -------------------------------------------------

                    console.log(
                        "================================="
                    );

                    console.log(
                        "FINAL PROFILE DATA"
                    );

                    console.table(
                        profileData
                    );

                    console.log(
                        "================================="
                    );


                    // -------------------------------------------------
                    // POST / PUT
                    // -------------------------------------------------

                    const requestMethod =
                        profileExists
                            ? "PUT"
                            : "POST";


                    const response =
                        await fetch(
                            PROFILE_API,
                            {
                                method:
                                    requestMethod,

                                headers: {

                                    "Content-Type":
                                        "application/json",

                                    "Authorization":
                                        "Bearer " + token
                                },

                                body:
                                    JSON.stringify(
                                        profileData
                                    )
                            }
                        );


                    const result =
                        await response.json();


                    console.log(
                        "SAVE PROFILE RESPONSE:",
                        result
                    );


                    if (
                        !response.ok ||
                        !result.success
                    ) {

                        throw new Error(
                            result.message ||
                            "Profile could not be saved."
                        );
                    }


                    // -------------------------------------------------
                    // PHOTO UPLOAD
                    // -------------------------------------------------

                    if (
                        profilePhoto &&
                        profilePhoto.files &&
                        profilePhoto.files.length > 0
                    ) {

                        const file =
                            profilePhoto.files[0];


                        const formData =
                            new FormData();


                        formData.append(
                            "profilePhoto",
                            file
                        );


                        const photoResponse =
                            await fetch(
                                UPLOAD_PHOTO_API +
                                encodeURIComponent(userId),
                                {
                                    method: "POST",

                                    headers: {
                                        "Authorization":
                                            "Bearer " + token
                                    },

                                    body:
                                        formData
                                }
                            );


                        const photoResult =
                            await photoResponse.json();


                        console.log(
                            "PHOTO UPLOAD RESPONSE:",
                            photoResult
                        );


                        if (
                            !photoResponse.ok ||
                            !photoResult.success
                        ) {

                            throw new Error(
                                photoResult.message ||
                                "Profile saved but photo upload failed."
                            );
                        }


                        console.log(
                            "SAVED PHOTO FILE:",
                            photoResult.data
                        );
                    }


                    // -------------------------------------------------
                    // PROFILE COMPLETED
                    // -------------------------------------------------

                    localStorage.setItem(
                        "profileCompleted",
                        "true"
                    );

                    sessionStorage.setItem(
                        "profileCompleted",
                        "true"
                    );


                    showProfileMessage(
                        profileExists
                            ? "Profile Updated!"
                            : "Profile Completed!",

                        profileExists
                            ? "Your travel profile has been updated successfully."
                            : "Your personalized travel profile has been saved.",

                        "success"
                    );


                    setTimeout(
                        function () {

                            window.location.href =
                                USER_DASHBOARD;

                        },
                        1200
                    );


                } catch (error) {

                    console.error(
                        "PROFILE SAVE ERROR:",
                        error
                    );


                    showProfileMessage(
                        "Unable to Save",
                        error.message ||
                        "Something went wrong.",
                        "error"
                    );


                } finally {

                    if (saveBtn) {

                        saveBtn.disabled = false;


                        saveBtn.innerHTML =
                            profileExists

                                ? '<span>Update Profile</span>' +
                                  '<i class="fa-solid fa-save"></i>'

                                : '<span>Complete Profile</span>' +
                                  '<i class="fa-solid fa-check"></i>';
                    }
                }
            }
        );
    }


    // =========================================================
    // SKIP
    // =========================================================

    const skipBtn =
        document.getElementById(
            "skipProfileBtn"
        );


    if (skipBtn) {

        skipBtn.addEventListener(
            "click",
            function () {

                if (
                    confirm(
                        "Are you sure you want to skip your travel profile?"
                    )
                ) {

                    window.location.href =
                        USER_DASHBOARD;
                }
            }
        );
    }


    // =========================================================
    // TOAST CLOSE
    // =========================================================

    window.closeProfileToast =
        function () {

            const toast =
                document.getElementById(
                    "profileToast"
                );


            if (toast) {

                toast.classList.add(
                    "d-none"
                );
            }
        };


    // =========================================================
    // TOAST MESSAGE
    // =========================================================

    function showProfileMessage(
        title,
        message,
        type
    ) {

        const toast =
            document.getElementById(
                "profileToast"
            );


        if (!toast) {

            alert(
                title +
                "\n\n" +
                message
            );

            return;
        }


        const titleElement =
            document.getElementById(
                "profileToastTitle"
            );

        const messageElement =
            document.getElementById(
                "profileToastMessage"
            );

        const icon =
            document.getElementById(
                "profileToastIcon"
            );


        if (titleElement) {

            titleElement.innerText =
                title;
        }


        if (messageElement) {

            messageElement.innerText =
                message;
        }


        if (icon) {

            if (type === "success") {

                icon.className =
                    "fa-solid fa-circle-check";

            } else if (type === "warning") {

                icon.className =
                    "fa-solid fa-triangle-exclamation";

            } else {

                icon.className =
                    "fa-solid fa-circle-exclamation";
            }
        }


        toast.classList.remove(
            "d-none"
        );


        setTimeout(
            function () {

                toast.classList.add(
                    "d-none"
                );

            },
            4000
        );
    }


    // =========================================================
    // INITIALIZE
    // =========================================================

    showStep(1);

    loadExistingProfile();

});