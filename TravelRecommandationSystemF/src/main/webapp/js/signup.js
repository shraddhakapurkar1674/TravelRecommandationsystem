document.addEventListener("DOMContentLoaded", function () {

    // ============================================================
    // CONFIGURATION
    // ============================================================

    const BACKEND_PATH =
        API_CONFIG.BASE_URL;

    const FRONTEND_PATH =
        API_CONFIG.FRONTEND_BASE_URL;

    const REGISTER_API =
        BACKEND_PATH + "/api/users/register";

    const CREATE_PROFILE_PAGE =
        FRONTEND_PATH + "/create_profile.jsp";

    const LOGIN_PAGE =
        FRONTEND_PATH + "/login.jsp";


    // ============================================================
    // FORM ELEMENTS
    // ============================================================

    const signupForm =
        document.getElementById("signupForm");

    const fullNameInput =
        document.getElementById("fullNameInput");

    const emailInput =
        document.getElementById("emailInput");

    const passwordInput =
        document.getElementById("passwordInput");

    const confirmPasswordInput =
        document.getElementById("confirmPasswordInput");

    const togglePassword =
        document.getElementById("togglePassword");

    const toggleConfirmPassword =
        document.getElementById("toggleConfirmPassword");


    // ============================================================
    // PASSWORD TOGGLE
    // ============================================================

    if (togglePassword && passwordInput) {

        togglePassword.addEventListener(
            "click",
            function () {

                const type =
                    passwordInput.getAttribute("type");


                if (type === "password") {

                    passwordInput.setAttribute(
                        "type",
                        "text"
                    );

                    togglePassword.classList.remove(
                        "fa-eye"
                    );

                    togglePassword.classList.add(
                        "fa-eye-slash"
                    );

                } else {

                    passwordInput.setAttribute(
                        "type",
                        "password"
                    );

                    togglePassword.classList.remove(
                        "fa-eye-slash"
                    );

                    togglePassword.classList.add(
                        "fa-eye"
                    );
                }
            }
        );
    }


    // ============================================================
    // CONFIRM PASSWORD TOGGLE
    // ============================================================

    if (
        toggleConfirmPassword &&
        confirmPasswordInput
    ) {

        toggleConfirmPassword.addEventListener(
            "click",
            function () {

                const type =
                    confirmPasswordInput
                        .getAttribute("type");


                if (type === "password") {

                    confirmPasswordInput.setAttribute(
                        "type",
                        "text"
                    );

                    toggleConfirmPassword.classList.remove(
                        "fa-eye"
                    );

                    toggleConfirmPassword.classList.add(
                        "fa-eye-slash"
                    );

                } else {

                    confirmPasswordInput.setAttribute(
                        "type",
                        "password"
                    );

                    toggleConfirmPassword.classList.remove(
                        "fa-eye-slash"
                    );

                    toggleConfirmPassword.classList.add(
                        "fa-eye"
                    );
                }
            }
        );
    }


    // ============================================================
    // REGISTER
    // ============================================================

    if (signupForm) {

        signupForm.addEventListener(
            "submit",
            async function (event) {

                event.preventDefault();


                const fullName =
                    fullNameInput
                        ? fullNameInput.value.trim()
                        : "";


                const email =
                    emailInput
                        ? emailInput.value.trim()
                        : "";


                const password =
                    passwordInput
                        ? passwordInput.value
                        : "";


                const confirmPassword =
                    confirmPasswordInput
                        ? confirmPasswordInput.value
                        : "";


                // =================================================
                // VALIDATION
                // =================================================

                if (
                    !fullName ||
                    !email ||
                    !password ||
                    !confirmPassword
                ) {

                    showNotification(
                        "Validation Error",
                        "Please fill in all required fields.",
                        "error"
                    );

                    return;
                }


                if (password.length < 6) {

                    showNotification(
                        "Invalid Password",
                        "Password must be at least 6 characters long.",
                        "error"
                    );

                    return;
                }


                if (password !== confirmPassword) {

                    showNotification(
                        "Password Mismatch",
                        "Passwords do not match.",
                        "error"
                    );

                    return;
                }


                // =================================================
                // DISABLE FORM
                // =================================================

                const submitButton =
                    signupForm.querySelector(
                        'button[type="submit"]'
                    );


                if (submitButton) {

                    submitButton.disabled = true;

                    submitButton.dataset.originalText =
                        submitButton.innerHTML;

                    submitButton.innerHTML =
                        '<i class="fas fa-spinner fa-spin"></i> Creating Account...';
                }


                try {

                    const response =
                        await fetch(
                            REGISTER_API,
                            {
                                method: "POST",

                                headers: {
                                    "Content-Type":
                                        "application/json"
                                },

                                body: JSON.stringify({
                                    fullName: fullName,
                                    email: email,
                                    password: password,
                                    role: "ROLE_USER"
                                })
                            }
                        );


                    let result = null;


                    try {

                        result =
                            await response.json();

                    } catch (e) {

                        result = null;
                    }


                    console.log(
                        "REGISTER RESPONSE:",
                        result
                    );


                    // =================================================
                    // ALREADY REGISTERED
                    // =================================================

                    if (response.status === 409) {

                        showNotification(
                            "Account Already Exists",
                            "This email is already registered. Please login.",
                            "warning"
                        );


                        setTimeout(
                            function () {

                                window.location.href =
                                    LOGIN_PAGE;

                            },
                            1200
                        );


                        return;
                    }


                    // =================================================
                    // REGISTRATION FAILED
                    // =================================================

                    if (
                        !response.ok ||
                        !result ||
                        result.success !== true
                    ) {

                        showNotification(
                            "Registration Failed",
                            result && result.message
                                ? result.message
                                : "Could not create your account.",
                            "error"
                        );

                        return;
                    }


                    // =================================================
                    // USER DATA
                    // =================================================

                    const userData =
                        result.data;


                    /*
                     * Backend now returns login data
                     * immediately after registration.
                     */

                    if (
                        userData &&
                        userData.userId &&
                        userData.token
                    ) {

                        const userId =
                            userData.userId;

                        const token =
                            userData.token;

                        const role =
                            userData.role ||
                            "ROLE_USER";

                        const name =
                            userData.fullName ||
                            fullName;

                        const userEmail =
                            userData.email ||
                            email;


                        // =================================================
                        // CLEAR OLD SESSION
                        // =================================================

                        localStorage.removeItem("userId");
                        localStorage.removeItem("token");
                        localStorage.removeItem("userName");
                        localStorage.removeItem("userEmail");
                        localStorage.removeItem("userRole");

                        sessionStorage.removeItem("userId");
                        sessionStorage.removeItem("token");
                        sessionStorage.removeItem("userName");
                        sessionStorage.removeItem("userEmail");
                        sessionStorage.removeItem("userRole");


                        // =================================================
                        // SAVE NEW USER SESSION
                        // =================================================

                        localStorage.setItem(
                            "userId",
                            String(userId)
                        );

                        localStorage.setItem(
                            "token",
                            token
                        );

                        localStorage.setItem(
                            "userName",
                            name
                        );

                        localStorage.setItem(
                            "userEmail",
                            userEmail
                        );

                        localStorage.setItem(
                            "userRole",
                            role
                        );


                        sessionStorage.setItem(
                            "userId",
                            String(userId)
                        );

                        sessionStorage.setItem(
                            "token",
                            token
                        );

                        sessionStorage.setItem(
                            "userName",
                            name
                        );

                        sessionStorage.setItem(
                            "userEmail",
                            userEmail
                        );

                        sessionStorage.setItem(
                            "userRole",
                            role
                        );


                        // =================================================
                        // REDIRECT TO CREATE PROFILE
                        // =================================================

                        showNotification(
                            "Account Created!",
                            "Your account was created successfully. Now complete your travel profile.",
                            "success"
                        );


                        setTimeout(
                            function () {

                                window.location.href =
                                    CREATE_PROFILE_PAGE;

                            },
                            1000
                        );

                    } else {

                        /*
                         * Fallback:
                         * If backend does not return login data,
                         * go to login page.
                         */

                        showNotification(
                            "Account Created",
                            "Registration successful. Please login to continue.",
                            "success"
                        );


                        setTimeout(
                            function () {

                                window.location.href =
                                    LOGIN_PAGE;

                            },
                            1500
                        );
                    }


                } catch (error) {

                    console.error(
                        "SIGNUP ERROR:",
                        error
                    );


                    showNotification(
                        "Server Error",
                        "Unable to connect to the server. Please try again.",
                        "error"
                    );

                } finally {

                    if (submitButton) {

                        submitButton.disabled = false;

                        if (
                            submitButton.dataset.originalText
                        ) {

                            submitButton.innerHTML =
                                submitButton.dataset.originalText;
                        }
                    }
                }
            }
        );
    }
});