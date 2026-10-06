<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap 5 CSS & Font Awesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <!-- Transparent & Fixed Header CSS -->
    <style>
        :root {
            --purple-primary: #6346f6;
            --purple-gradient: linear-gradient(135deg, #5031e2 0%, #7b51f8 100%);
            --navy-dark: #0f172a;
            --text-muted: #64748b;
        }

        /* Transparent Header Overlay */
        .navbar-wrapper {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            background: transparent !important;
            box-shadow: none !important;
            z-index: 1000;
        }

        /* Fixed Small Brand Logo Image */
        .header-logo-img {
            max-width: 110px;
            height: auto;
            object-fit: contain;
        }

        /* Compact Nav Menu Items */
        .nav-link-custom {
            font-size: 0.85rem;
            font-weight: 600;
            color: #1e293b !important;
            padding: 0.25rem 0.85rem !important;
            position: relative;
            transition: all 0.2s ease;
        }

        .nav-link-custom:hover {
            color: var(--purple-primary) !important;
        }

        /* Active State Underline */
        .nav-link-custom.active {
            color: var(--purple-primary) !important;
            font-weight: 700;
        }

        .nav-link-custom.active::after {
            content: "";
            position: absolute;
            bottom: -5px;
            left: 0.85rem;
            right: 0.85rem;
            height: 2px;
            background-color: var(--purple-primary);
            border-radius: 10px;
        }

        /* Action Buttons with Glassmorphism for Transparency */
        .btn-login-nav {
            color: #1e293b;
            font-size: 0.82rem;
            font-weight: 600;
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(4px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: 0.35rem 0.65rem;
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .btn-login-nav:hover {
            color: var(--purple-primary);
            background: rgba(255, 255, 255, 0.85);
        }

        .btn-signup-nav {
            background: var(--purple-gradient);
            color: #ffffff !important;
            font-size: 0.82rem;
            font-weight: 600;
            padding: 0.4rem 1.1rem;
            border-radius: 9px;
            border: none;
            text-decoration: none;
            box-shadow: 0 3px 10px rgba(99, 70, 246, 0.25);
            transition: all 0.25s ease;
            cursor: pointer;
        }

        .btn-signup-nav:hover {
            transform: translateY(-1px);
            box-shadow: 0 5px 14px rgba(99, 70, 246, 0.35);
        }

        /* Guest / logged-in blocks are toggled by JS based on localStorage - hidden by default to avoid a flash of the wrong state */
        #navGuestButtons, #navUserDropdown {
            display: none;
        }

        /* Mobile Dropdown Menu Fix */
        @media (max-width: 1199.98px) {
            .navbar-collapse {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 12px;
                padding: 1rem;
                margin-top: 0.5rem;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            }
        }
    </style>
</head>
<body>

<header class="navbar-wrapper">
    <nav class="navbar navbar-expand-xl py-2">
        <div class="container-fluid px-lg-5">

            <!-- Brand Logo Image -->
            <a class="navbar-brand d-flex align-items-center py-0" href="${pageContext.request.contextPath}/home.jsp">
                <img src="${pageContext.request.contextPath}/images/TripNexa_logo.png" alt="TripNexa Logo" class="header-logo-img">
            </a>

            <!-- Mobile Toggler -->
            <button class="navbar-toggler border-0 shadow-none py-1 px-2" type="button" data-bs-toggle="collapse" data-bs-target="#tripWiseHeaderNav">
                <span class="navbar-toggler-icon" style="font-size: 0.85rem;"></span>
            </button>

            <!-- Navigation Links -->
            <div class="collapse navbar-collapse" id="tripWiseHeaderNav">

                <ul class="navbar-nav mx-auto my-1 my-xl-0 gap-xl-1 align-items-center">
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom ${pageContext.request.requestURI.endsWith('home.jsp') ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/home.jsp">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom js-scroll-nav-link"
                           data-scroll-target="popularDestinations"
                           href="${pageContext.request.contextPath}/home.jsp#popularDestinations">Destinations</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom js-scroll-nav-link"
                           data-scroll-target="search-bar"
                           href="${pageContext.request.contextPath}/home.jsp#search-bar">Trip Planner</a>
                    </li>
                      <li class="nav-item">
                        <a class="nav-link nav-link-custom js-scroll-nav-link"
                           
                           href="${pageContext.request.contextPath}/about_us.jsp">About_us</a>
                    </li>
                    
                                    </ul>

                <!-- Action Buttons -->
                <div class="d-flex align-items-center gap-2 justify-content-center my-1 my-xl-0">

                    <!-- Guest State (shown by JS when no logged-in user is found) -->
                    <div id="navGuestButtons" class="d-flex align-items-center gap-2">
                        <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-login-nav d-flex align-items-center gap-1">
                            <i class="far fa-user"></i>
                            <span>Login</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/signup.jsp" class="btn btn-signup-nav">
                            Sign Up
                        </a>
                    </div>

                    <!-- Logged-In User State (shown by JS when a token is found in localStorage) -->
                    <div id="navUserDropdown" class="dropdown">
                        
                        <ul class="dropdown-menu dropdown-menu-end border-0 shadow-lg rounded-3 mt-2">
                            <li><a class="dropdown-item py-1" href="${pageContext.request.contextPath}/profile.jsp"><i class="fas fa-user me-2 text-muted"></i> Profile</a></li>
                            <li><a class="dropdown-item py-1" href="${pageContext.request.contextPath}/user_dashboard.jsp"><i class="fas fa-ticket-alt me-2 text-muted"></i> My Trips</a></li>
                            <li><hr class="dropdown-divider opacity-10"></li>
                            <li><a class="dropdown-item py-1 text-danger" href="#" id="navLogoutBtn"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></li>
                        </ul>
                    </div>

                </div>

            </div>
        </div>
    </nav>
</header>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- Dynamic Auth State (Login / Sign Up vs Account) -->
<script>
(function () {
    function getLoggedInUser() {
        var token = localStorage.getItem('token') || sessionStorage.getItem('token');
        var userId = localStorage.getItem('userId') || sessionStorage.getItem('userId');
        if (!token || !userId) return null;
        return {
            name: localStorage.getItem('userName') || sessionStorage.getItem('userName') || 'Account',
            id: userId
        };
    }

    var user = getLoggedInUser();
    var guestBox = document.getElementById('navGuestButtons');
    var userBox = document.getElementById('navUserDropdown');
    var nameSpan = document.getElementById('navUserName');

    if (user) {
        if (userBox) userBox.style.display = 'block';
        if (guestBox) guestBox.style.display = 'none';
        if (nameSpan) nameSpan.textContent = (user.name.split(' ')[0]) || 'Account';
    } else {
        if (guestBox) guestBox.style.display = 'flex';
        if (userBox) userBox.style.display = 'none';
    }

    // Any nav link marked data-guest-href / data-user-href routes based on login state
    document.querySelectorAll('.js-guarded-nav-link').forEach(function (link) {
        var target = user ? link.getAttribute('data-user-href') : link.getAttribute('data-guest-href');
        if (target) link.setAttribute('href', target);
    });

    // "Destinations" / "Trip Planner" nav links: if we're already on the home page,
    // smooth-scroll to the matching section instead of reloading it. If we're on any
    // other page, let the href take the user to home.jsp#<section> as normal - home.js
    // scrolls to the hash once that page has loaded.
    var onHomePage = /\/home\.jsp$/.test(window.location.pathname);
    document.querySelectorAll('.js-scroll-nav-link').forEach(function (link) {
        link.addEventListener('click', function (e) {
            var targetId = link.getAttribute('data-scroll-target');
            var targetEl = document.getElementById(targetId);
            if (onHomePage && targetEl) {
                e.preventDefault();
                targetEl.scrollIntoView({ behavior: 'smooth', block: 'start' });
                history.replaceState(null, '', '#' + targetId);
            }
        });
    });

    var logoutBtn = document.getElementById('navLogoutBtn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', function (e) {
            e.preventDefault();
            ['userId', 'token', 'userName', 'userEmail', 'userRole'].forEach(function (key) {
                localStorage.removeItem(key);
                sessionStorage.removeItem(key);
            });
            window.location.href = '${pageContext.request.contextPath}/home.jsp';
        });
    }
})();
</script>

</body>
</html>