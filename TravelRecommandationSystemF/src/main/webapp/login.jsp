
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0">

    <title>Login - TripNexa</title>


    <!-- Bootstrap -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- Font Awesome -->
    <link
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
        rel="stylesheet">


    <!-- Google Font -->
    <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
        rel="stylesheet">


    <!-- Login CSS -->
    <link
        href="${pageContext.request.contextPath}/css/login-styles.css"
        rel="stylesheet">

</head>


<body>


<div class="login-page-wrapper">


    <main class="main-content my-auto w-100">

        <div class="container">

            <div class="row align-items-center justify-content-center">


                <div class="col-lg-5 col-xl-4 mx-auto">


                    <div class="glass-login-card position-relative">


                        <!-- =====================================================
                             LOGO
                        ====================================================== -->

                        <div class="brand-logo-container text-center mb-3">

                            <a
                                href="${pageContext.request.contextPath}/home.jsp"
                                class="text-decoration-none d-inline-block">

                                <img
                                    src="${pageContext.request.contextPath}/images/TripNexa_logo.png"
                                    alt="TripNexa Logo"
                                    class="card-logo-img">

                            </a>

                        </div>


                        <!-- =====================================================
                             TITLE
                        ====================================================== -->

                        <h5
                            class="fw-extrabold text-center mb-1"
                            style="
                                font-weight: 800;
                                font-size: 1.25rem;
                                color: #0f172a;
                            ">

                            Welcome Back

                        </h5>


                        <p
                            class="text-center text-muted small mb-3"
                            style="font-size: 0.8rem;">

                            Discover. Plan. Travel Smarter.

                        </p>


                        <!-- =====================================================
                             NOTIFICATION
                        ====================================================== -->

                        <div
                            id="inlineToast"
                            class="modern-inline-toast d-none"
                            role="alert">

                            <div
                                class="toast-icon-wrapper"
                                id="toastIconContainer">

                                <i
                                    class="fas fa-exclamation-circle"
                                    id="toastIcon">
                                </i>

                            </div>


                            <div class="toast-content">

                                <span
                                    class="toast-title"
                                    id="toastTitle">

                                    Login Failed

                                </span>


                                <span
                                    class="toast-message"
                                    id="toastMessage">

                                    Invalid email or password.

                                </span>

                            </div>


                            <button
                                type="button"
                                class="toast-close-btn"
                                onclick="dismissToast()">

                                <i class="fas fa-times"></i>

                            </button>

                        </div>


                        <!-- =====================================================
                             LOGIN FORM
                        ====================================================== -->

                        <form
                            id="loginForm"
                            method="post"
                            autocomplete="on">


                            <!-- EMAIL -->

                            <div class="mb-3 custom-input-group">

                                <i
                                    class="far fa-envelope input-icon-left">
                                </i>


                                <input
                                    type="email"
                                    id="emailInput"
                                    name="email"
                                    class="form-control"
                                    placeholder="Email Address"
                                    autocomplete="username"
                                    required>

                            </div>


                            <!-- PASSWORD -->

                            <div class="mb-2 custom-input-group">

                                <i
                                    class="fas fa-lock input-icon-left">
                                </i>


                                <input
                                    type="password"
                                    id="passwordInput"
                                    name="password"
                                    class="form-control"
                                    placeholder="Password"
                                    autocomplete="current-password"
                                    required>


                                <i
                                    class="far fa-eye input-icon-right"
                                    id="togglePassword"
                                    style="cursor:pointer;">
                                </i>

                            </div>


                            <!-- REMEMBER ME -->

                            <div
                                class="d-flex align-items-center justify-content-between mb-3"
                                style="font-size: 0.78rem;">

                                <div class="form-check mb-0">

                                    <input
                                        class="form-check-input"
                                        type="checkbox"
                                        id="rememberMe"
                                        name="rememberMe">

                                    <label
                                        class="form-check-label text-secondary fw-medium"
                                        for="rememberMe">

                                        Remember me

                                    </label>

                                </div>


                                <a
                                    href="#"
                                    class="text-decoration-none fw-semibold"
                                    style="color:#0284c7;">

                                    Forgot Password?

                                </a>

                            </div>


                            <!-- =================================================
                                 LOGIN BUTTON
                            ================================================== -->

                            <button
                                type="submit"
                                id="submitBtn"
                                class="btn btn-login-submit w-100 d-flex align-items-center justify-content-center gap-2 text-white">

                                <i
                                    class="fas fa-paper-plane"
                                    id="btnIcon">
                                </i>


                                <span id="btnText">
                                    Login
                                </span>


                                <i
                                    class="fas fa-arrow-right fs-6"
                                    id="btnArrow">
                                </i>

                            </button>


                        </form>


                        <!-- =====================================================
                             DIVIDER
                        ====================================================== -->

                        <div
                            class="divider-text text-center text-muted small my-3">

                            <span>
                                OR
                            </span>

                        </div>


                        <!-- =====================================================
                             SOCIAL LOGIN
                        ====================================================== -->

                        <div
                            class="d-flex justify-content-center gap-2 mb-3">


                            <a
                                href="#"
                                class="social-login-btn border d-flex align-items-center justify-content-center">

                                <svg
                                    width="16"
                                    height="16"
                                    viewBox="0 0 24 24">

                                    <path
                                        fill="#EA4335"
                                        d="M12 5c1.6 0 3 .6 4.1 1.6l3.1-3.1C17.3 1.7 14.8 1 12 1 7.5 1 3.7 3.6 1.9 7.3l3.7 2.9C6.5 7.3 9 5 12 5z"/>

                                    <path
                                        fill="#4285F4"
                                        d="M23.5 12.3c0-.8-.1-1.6-.2-2.3H12v4.5h6.5c-.3 1.5-1.1 2.8-2.4 3.7l3.7 2.9c2.2-2 3.7-5 3.7-8.8z"/>

                                    <path
                                        fill="#FBBC05"
                                        d="M5.6 14.8c-.2-.7-.4-1.5-.4-2.3s.2-1.6.4-2.3L1.9 7.3C.7 9.7 0 10.8 0 12s.7 2.3 1.9 4.7l3.7-2.9z"/>

                                    <path
                                        fill="#34A853"
                                        d="M12 23c3.2 0 6-1.1 8-3l-3.7-2.9c-1.1.7-2.5 1.2-4.3 1.2-3 0-5.5-2.3-6.4-5.2L1.9 16C3.7 19.7 7.5 23 12 23z"/>

                                </svg>

                            </a>


                            <a
                                href="#"
                                class="social-login-btn border d-flex align-items-center justify-content-center">

                                <i
                                    class="fab fa-facebook-f"
                                    style="color:#1877f2;">
                                </i>

                            </a>


                            <a
                                href="#"
                                class="social-login-btn border d-flex align-items-center justify-content-center text-dark">

                                <i class="fab fa-apple"></i>

                            </a>

                        </div>


                        <!-- =====================================================
                             SIGNUP
                        ====================================================== -->

                        <p
                            class="text-center mb-0 text-secondary"
                            style="font-size:0.78rem;">

                            Don't have an account?

                            <a
                                href="${pageContext.request.contextPath}/signup.jsp"
                                class="fw-bold text-decoration-none"
                                style="color:#0284c7;">

                                Sign Up Now

                                <i
                                    class="fas fa-arrow-right ms-1">
                                </i>

                            </a>

                        </p>


                    </div>

                </div>

            </div>

        </div>

    </main>

</div>


<!-- =========================================================
     NOTIFICATION FUNCTIONS
========================================================= -->

<script>

function showNotification(title, message, type) {

    const toast =
        document.getElementById("inlineToast");

    const toastTitle =
        document.getElementById("toastTitle");

    const toastMessage =
        document.getElementById("toastMessage");

    const icon =
        document.getElementById("toastIcon");


    if (!toast) {
        return;
    }


    toastTitle.innerText =
        title || "";


    toastMessage.innerText =
        message || "";


    toast.className =
        "modern-inline-toast show " +
        (type || "error");


    if (type === "success") {

        icon.className =
            "fas fa-check-circle";

    } else if (type === "warning") {

        icon.className =
            "fas fa-user-plus";

    } else {

        icon.className =
            "fas fa-exclamation-circle";

    }


    setTimeout(
        function () {
            dismissToast();
        },
        4500
    );
}


function dismissToast() {

    const toast =
        document.getElementById("inlineToast");


    if (!toast) {
        return;
    }


    toast.classList.remove("show");


    setTimeout(
        function () {

            toast.classList.add("d-none");

        },
        300
    );
}

</script>


<!-- =========================================================
     TOMCAT APPLICATION CONTEXT
========================================================= -->

<script>

window.APP_CONTEXT_PATH =
    "${pageContext.request.contextPath}";

console.log(
    "Application Context:",
    window.APP_CONTEXT_PATH
);

</script>


<!-- =========================================================
     API CONFIG
========================================================= -->

<script
    src="${pageContext.request.contextPath}/js/apiConfig.js">
</script>


<!-- =========================================================
     LOGIN JS
========================================================= -->

<script
    src="${pageContext.request.contextPath}/js/login.js">
</script>


</body>

</html>

