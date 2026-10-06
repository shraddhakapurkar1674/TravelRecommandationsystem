
document.addEventListener("DOMContentLoaded", function () {

    console.log("======================================");
    console.log("TRIPNEXA LOGIN");
    console.log("======================================");

    // --------------------------------------------------
    // CONTEXT PATH
    // --------------------------------------------------

    var FRONTEND_PATH = window.APP_CONTEXT_PATH || "";

    if (!FRONTEND_PATH && typeof API_CONFIG !== "undefined") {
        FRONTEND_PATH = API_CONFIG.FRONTEND_BASE_URL || "";
    }

    var BACKEND_PATH = "";

    if (typeof API_CONFIG !== "undefined") {
        BACKEND_PATH = API_CONFIG.BASE_URL || "";
    }

    var LOGIN_API = BACKEND_PATH + "/api/users/login";

    var USER_DASHBOARD =
        FRONTEND_PATH + "/user_dashboard.jsp";

    var ADMIN_DASHBOARD =
        FRONTEND_PATH + "/dashboard.jsp";

    var CREATE_PROFILE =
        FRONTEND_PATH + "/create_profile.jsp";

    var SIGNUP_PAGE =
        FRONTEND_PATH + "/signup.jsp";


    console.log("APP CONTEXT:", window.APP_CONTEXT_PATH);
    console.log("FRONTEND:", FRONTEND_PATH);
    console.log("BACKEND:", BACKEND_PATH);
    console.log("LOGIN API:", LOGIN_API);


    // --------------------------------------------------
    // ELEMENTS
    // --------------------------------------------------

    var loginForm = document.getElementById("loginForm");
    var emailInput = document.getElementById("emailInput");
    var passwordInput = document.getElementById("passwordInput");
    var togglePassword = document.getElementById("togglePassword");


    // --------------------------------------------------
    // PASSWORD SHOW / HIDE
    // --------------------------------------------------

    if (togglePassword && passwordInput) {

        togglePassword.addEventListener("click", function () {

            if (passwordInput.type === "password") {

                passwordInput.type = "text";

                togglePassword.classList.remove("fa-eye");
                togglePassword.classList.add("fa-eye-slash");

            } else {

                passwordInput.type = "password";

                togglePassword.classList.remove("fa-eye-slash");
                togglePassword.classList.add("fa-eye");
            }
        });
    }


    // --------------------------------------------------
    // LOGIN FORM
    // --------------------------------------------------

    if (!loginForm) {

        console.error("loginForm not found.");

        return;
    }


    loginForm.addEventListener("submit", async function (event) {

        event.preventDefault();

        console.log("Login button clicked.");


        // --------------------------------------------------
        // GET VALUES
        // --------------------------------------------------

        var email =
            emailInput ? emailInput.value.trim() : "";

        var password =
            passwordInput ? passwordInput.value : "";


        console.log("Email entered:", email);
        console.log(
            "Password entered:",
            password ? "YES" : "NO"
        );


        // --------------------------------------------------
        // VALIDATION
        // --------------------------------------------------

        if (!email) {

            showNotification(
                "Please enter your email address.",
                "error"
            );

            if (emailInput) {
                emailInput.focus();
            }

            return;
        }


        if (!password) {

            showNotification(
                "Please enter your password.",
                "error"
            );

            if (passwordInput) {
                passwordInput.focus();
            }

            return;
        }


        // --------------------------------------------------
        // DISABLE BUTTON
        // --------------------------------------------------

        var loginButton =
            loginForm.querySelector(
                'button[type="submit"]'
            );

        var originalButtonText = "";

        if (loginButton) {

            originalButtonText =
                loginButton.innerHTML;

            loginButton.disabled = true;
            loginButton.innerHTML = "Logging in...";
        }


        // --------------------------------------------------
        // LOGIN REQUEST
        // --------------------------------------------------

        console.log(
            "Sending login request to:",
            LOGIN_API
        );


        try {

            var response = await fetch(
                LOGIN_API,
                {
                    method: "POST",

                    headers: {
                        "Content-Type":
                            "application/json"
                    },

                    body: JSON.stringify({
                        email: email,
                        password: password
                    })
                }
            );


            console.log(
                "Login response status:",
                response.status
            );


            // --------------------------------------------------
            // READ RESPONSE
            // --------------------------------------------------

            var result = null;

            try {

                result = await response.json();

            } catch (jsonError) {

                console.error(
                    "Could not parse login response:",
                    jsonError
                );
            }


            console.log(
                "Login response:",
                result
            );


            // --------------------------------------------------
            // ERROR RESPONSE
            // --------------------------------------------------

            if (!response.ok) {

                var errorMessage =
                    "Invalid email or password.";

                if (result) {

                    if (result.message) {
                        errorMessage = result.message;
                    }

                    if (result.error) {
                        errorMessage = result.error;
                    }
                }


                if (response.status === 404) {

                    errorMessage =
                        "Login API not found. Please check the backend URL.";
                }


                if (response.status === 401) {

                    errorMessage =
                        "Invalid email or password.";
                }


                showNotification(
                    errorMessage,
                    "error"
                );

                return;
            }


            // --------------------------------------------------
            // EXTRACT USER DATA
            // --------------------------------------------------

            var user = null;

            var token = null;


            if (result) {

                // Format:
                // { data: { ... } }

                if (result.data) {
                    user = result.data;
                }

                // Format:
                // { user: { ... } }

                else if (result.user) {
                    user = result.user;
                }

                // Format:
                // direct user object

                else {
                    user = result;
                }


                if (result.token) {
                    token = result.token;
                }

                if (result.accessToken) {
                    token = result.accessToken;
                }
            }


            console.log(
                "Logged-in user:",
                user
            );


            // --------------------------------------------------
            // CHECK USER
            // --------------------------------------------------

            if (!user) {

                showNotification(
                    "Login successful, but user information was not returned.",
                    "error"
                );

                return;
            }


            // --------------------------------------------------
            // USER ID
            // --------------------------------------------------

            var userId =
                user.id ||
                user.userId ||
                user.userID;


            // --------------------------------------------------
            // USER NAME
            // --------------------------------------------------

            var userName =
                user.name ||
                user.userName ||
                user.username ||
                user.fullName ||
                "";


            // --------------------------------------------------
            // USER EMAIL
            // --------------------------------------------------

            var userEmail =
                user.email ||
                email;


            // --------------------------------------------------
            // USER ROLE
            // --------------------------------------------------

            var userRole =
                user.role ||
                user.userRole ||
                user.user_type ||
                user.userType ||
                "";


            // Convert role to uppercase
            userRole =
                String(userRole).toUpperCase();


            console.log(
                "USER ID:",
                userId
            );

            console.log(
                "USER NAME:",
                userName
            );

            console.log(
                "USER EMAIL:",
                userEmail
            );

            console.log(
                "USER ROLE:",
                userRole
            );


            // --------------------------------------------------
            // SAVE LOGIN INFORMATION
            // --------------------------------------------------

            if (userId !== undefined && userId !== null) {

                localStorage.setItem(
                    "userId",
                    String(userId)
                );

                sessionStorage.setItem(
                    "userId",
                    String(userId)
                );
            }


            localStorage.setItem(
                "userName",
                userName
            );

            localStorage.setItem(
                "userEmail",
                userEmail
            );

            localStorage.setItem(
                "userRole",
                userRole
            );


            sessionStorage.setItem(
                "userName",
                userName
            );

            sessionStorage.setItem(
                "userEmail",
                userEmail
            );

            sessionStorage.setItem(
                "userRole",
                userRole
            );


            if (token) {

                localStorage.setItem(
                    "token",
                    token
                );

                sessionStorage.setItem(
                    "token",
                    token
                );
            }


            // --------------------------------------------------
            // ADMIN LOGIN
            // --------------------------------------------------

            if (
                userRole === "ADMIN" ||
                userRole === "ROLE_ADMIN"
            ) {

                console.log(
                    "Admin login detected."
                );

                console.log(
                    "Redirecting to:",
                    ADMIN_DASHBOARD
                );


                showNotification(
                    "Admin login successful.",
                    "success"
                );


                setTimeout(function () {

                    window.location.href =
                        ADMIN_DASHBOARD;

                }, 500);


                return;
            }


            // --------------------------------------------------
            // NORMAL USER LOGIN
            // --------------------------------------------------

            console.log(
                "Normal user login detected."
            );


            // If user ID is not available,
            // directly open user dashboard.

            if (
                userId === undefined ||
                userId === null ||
                userId === ""
            ) {

                console.log(
                    "User ID not available."
                );

                console.log(
                    "Redirecting to:",
                    USER_DASHBOARD
                );


                showNotification(
                    "Login successful.",
                    "success"
                );


                setTimeout(function () {

                    window.location.href =
                        USER_DASHBOARD;

                }, 500);


                return;
            }


            // --------------------------------------------------
            // CHECK TRAVEL PROFILE
            // --------------------------------------------------

            var profileCheckUrl =
                BACKEND_PATH +
                "/api/travel-profile/check/" +
                encodeURIComponent(userId);


            console.log(
                "Checking travel profile:",
                profileCheckUrl
            );


            try {

                var profileResponse =
                    await fetch(
                        profileCheckUrl,
                        {
                            method: "GET",
                            headers: {
                                "Accept":
                                    "application/json"
                            }
                        }
                    );


                console.log(
                    "Profile check status:",
                    profileResponse.status
                );


                // --------------------------------------------------
                // PROFILE CHECK SUCCESS
                // --------------------------------------------------

                if (profileResponse.ok) {

                    var profileResult =
                        await profileResponse.json();


                    console.log(
                        "Profile check response:",
                        profileResult
                    );


                    var profileExists = false;


                    if (
                        profileResult === true
                    ) {

                        profileExists = true;

                    } else if (
                        profileResult &&
                        profileResult.exists === true
                    ) {

                        profileExists = true;

                    } else if (
                        profileResult &&
                        profileResult.data === true
                    ) {

                        profileExists = true;

                    } else if (
                        profileResult &&
                        profileResult.data &&
                        profileResult.data.exists === true
                    ) {

                        profileExists = true;
                    }


                    // --------------------------------------------------
                    // EXISTING PROFILE
                    // --------------------------------------------------

                    if (profileExists) {

                        console.log(
                            "Travel profile exists."
                        );

                        console.log(
                            "Redirecting to:",
                            USER_DASHBOARD
                        );


                        showNotification(
                            "Login successful.",
                            "success"
                        );


                        setTimeout(function () {

                            window.location.href =
                                USER_DASHBOARD;

                        }, 500);


                    }

                    // --------------------------------------------------
                    // PROFILE DOES NOT EXIST
                    // --------------------------------------------------

                    else {

                        console.log(
                            "Travel profile not found."
                        );

                        console.log(
                            "Redirecting to:",
                            CREATE_PROFILE
                        );


                        showNotification(
                            "Please complete your travel profile.",
                            "success"
                        );


                        setTimeout(function () {

                            window.location.href =
                                CREATE_PROFILE;

                        }, 500);
                    }


                    return;
                }


                // --------------------------------------------------
                // PROFILE API NOT AVAILABLE
                // --------------------------------------------------

                console.warn(
                    "Profile check API returned:",
                    profileResponse.status
                );


                // Do not block login if profile API
                // is unavailable.

                console.log(
                    "Redirecting to user dashboard:"
                );

                console.log(
                    USER_DASHBOARD
                );


                showNotification(
                    "Login successful.",
                    "success"
                );


                setTimeout(function () {

                    window.location.href =
                        USER_DASHBOARD;

                }, 500);


            } catch (profileError) {

                console.error(
                    "Profile check failed:",
                    profileError
                );


                // Login itself succeeded,
                // therefore still open dashboard.

                console.log(
                    "Redirecting to:",
                    USER_DASHBOARD
                );


                showNotification(
                    "Login successful.",
                    "success"
                );


                setTimeout(function () {

                    window.location.href =
                        USER_DASHBOARD;

                }, 500);
            }


        } catch (error) {

            console.error(
                "Login request failed:",
                error
            );


            showNotification(
                "Unable to connect to the server. Please try again.",
                "error"
            );


        } finally {

            // --------------------------------------------------
            // ENABLE BUTTON
            // --------------------------------------------------

            if (loginButton) {

                loginButton.disabled = false;

                loginButton.innerHTML =
                    originalButtonText ||
                    "Login";
            }
        }

    });


    // --------------------------------------------------
    // ENTER KEY SUPPORT
    // --------------------------------------------------

    if (emailInput) {

        emailInput.addEventListener(
            "keydown",
            function (event) {

                if (event.key === "Enter") {

                    event.preventDefault();

                    loginForm.requestSubmit();
                }
            }
        );
    }


    if (passwordInput) {

        passwordInput.addEventListener(
            "keydown",
            function (event) {

                if (event.key === "Enter") {

                    event.preventDefault();

                    loginForm.requestSubmit();
                }
            }
        );
    }


    // --------------------------------------------------
    // NOTIFICATION FUNCTION
    // --------------------------------------------------

    function showNotification(
        message,
        type
    ) {

        var notification =
            document.getElementById(
                "notification"
            );

        if (!notification) {

            notification =
                document.createElement("div");

            notification.id =
                "notification";

            notification.style.position =
                "fixed";

            notification.style.top =
                "20px";

            notification.style.right =
                "20px";

            notification.style.zIndex =
                "99999";

            notification.style.padding =
                "14px 20px";

            notification.style.borderRadius =
                "8px";

            notification.style.fontSize =
                "14px";

            notification.style.fontWeight =
                "600";

            notification.style.boxShadow =
                "0 4px 15px rgba(0,0,0,0.2)";

            document.body.appendChild(
                notification
            );
        }


        notification.textContent =
            message;


        if (type === "error") {

            notification.style.background =
                "#dc3545";

            notification.style.color =
                "#ffffff";

        } else {

            notification.style.background =
                "#198754";

            notification.style.color =
                "#ffffff";
        }


        notification.style.display =
            "block";


        setTimeout(function () {

            notification.style.display =
                "none";

        }, 3000);
    }

});

