<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%
    String activePage = request.getParameter("activePage");

    if (activePage == null) {
        activePage = "user_dashboard";
    }
%>

<style>
/* =========================================================
   TRIPNEXA SIDEBAR — UI ONLY
   Existing links, IDs, activePage logic and JavaScript
   are preserved.
   ========================================================= */

.user-sidebar {
    width: 263px;
    min-width: 263px;
    height: 100vh;
    box-sizing: border-box;

    position: fixed;
    top: 0;
    left: 0;
    z-index: 1000;

    display: flex;
    flex-direction: column;
    overflow: hidden;

    padding: 24px 12px 0;

    font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;

    /* Light blue-purple design from the reference */
    background:
        linear-gradient(
            180deg,
            #6675df 0%,
            #7180e3 45%,
            #7d8be8 72%,
            #7181df 100%
        );

    border-right: 1px solid rgba(255, 255, 255, 0.28);
}

/* Soft light overlay */
.user-sidebar::before {
    content: "";
    position: absolute;
    inset: 0;
    pointer-events: none;

    background:
        radial-gradient(
            circle at 8% 0%,
            rgba(255, 255, 255, 0.22),
            transparent 35%
        ),
        linear-gradient(
            180deg,
            transparent 0%,
            rgba(255, 255, 255, 0.035) 60%,
            rgba(49, 72, 164, 0.12) 100%
        );
}

/* =========================================================
   LOGO
   ========================================================= */

.user-sidebar .sidebar-logo {
    position: relative;
    z-index: 2;

    display: flex;
    align-items: center;
    justify-content: center;

    padding: 7px 0 22px;
}

.user-sidebar .sidebar-logo a {
    display: flex;
    align-items: center;
    justify-content: center;
    text-decoration: none;
}

.user-sidebar .sidebar-logo img {
    display: block;
    width: 174px;
    max-width: 100%;
    height: auto;
    object-fit: contain;

    filter: brightness(0) invert(1);
}

/* =========================================================
   MENU
   ========================================================= */

.user-sidebar .sidebar-menu {
    position: relative;
    z-index: 2;

    display: flex;
    flex-direction: column;
    gap: 5px;

    width: 100%;
}

/* Keep original section-title markup but hide it visually
   because the reference design does not display headings. */
.user-sidebar .menu-section-title {
    display: none;
}

/* =========================================================
   MENU ITEM
   ========================================================= */

.user-sidebar .sidebar-menu-item {
    position: relative;

    display: flex;
    align-items: center;
    gap: 16px;

    width: 100%;
    min-height: 50px;
    padding: 0 14px;

    box-sizing: border-box;
    border-radius: 11px;

    color: rgba(255, 255, 255, 0.94);
    text-decoration: none;

    font-size: 15px;
    font-weight: 500;

    transition:
        background 0.2s ease,
        color 0.2s ease,
        transform 0.2s ease;
}

.user-sidebar .sidebar-menu-item:hover {
    color: #ffffff;
    background: rgba(255, 255, 255, 0.13);
}

.user-sidebar .sidebar-menu-item.active {
    color: #ffffff;
    font-weight: 600;

    background: rgba(255, 255, 255, 0.22);

    box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.08),
        0 4px 12px rgba(54, 70, 160, 0.08);
}

.user-sidebar .sidebar-menu-item.active:hover {
    background: rgba(255, 255, 255, 0.22);
}

/* =========================================================
   ICONS
   ========================================================= */

.user-sidebar .menu-icon {
    width: 22px;
    min-width: 22px;
    height: 22px;

    display: flex;
    align-items: center;
    justify-content: center;

    color: rgba(255, 255, 255, 0.94);
    font-size: 17px;
    text-align: center;
}

.user-sidebar .sidebar-menu-item.active .menu-icon {
    color: #ffffff;
}

.user-sidebar .menu-text {
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}

/* =========================================================
   BOTTOM AREA
   ========================================================= */

.user-sidebar .sidebar-bottom {
    margin-top: auto;
    padding-top: 20px;
}

/* Preserve the original help-card area without displaying it */
.user-sidebar .sidebar-help-card {
    display: none;
}

/* =========================================================
   LOGOUT
   ========================================================= */

.user-sidebar .sidebar-logout {
    position: relative;
    z-index: 3;

    width: 100%;
    min-height: 50px;

    display: flex;
    align-items: center;
    gap: 16px;

    padding: 0 14px;

    border: none;
    border-radius: 11px;
    background: transparent;

    color: rgba(255, 255, 255, 0.94);
    font-family: inherit;
    font-size: 15px;
    font-weight: 500;
    text-align: left;

    cursor: pointer;

    transition:
        background 0.2s ease,
        color 0.2s ease;
}

.user-sidebar .sidebar-logout:hover {
    background: rgba(255, 255, 255, 0.13);
    color: #ffffff;
}

.user-sidebar .sidebar-logout .menu-icon {
    color: inherit;
}

/* =========================================================
   DECORATIVE FOOTER ART
   ========================================================= */

.user-sidebar .sidebar-footer-art {
    position: absolute;
    right: 0;
    bottom: 0;
    left: 0;
    z-index: 1;

    height: 245px;
    overflow: hidden;

    padding: 0;
    margin: 0;
    border: 0;

    text-align: center;
    pointer-events: none;
}

.user-sidebar .sidebar-footer-art::after {
    content: "";
    position: absolute;
    inset: 0;

    background: linear-gradient(
        180deg,
        transparent 0%,
        rgba(66, 86, 180, 0.04) 35%,
        rgba(42, 63, 151, 0.20) 100%
    );
}

.user-sidebar .sidebar-footer-art .art-plane {
    position: absolute;
    top: 8px;
    right: 65px;
    z-index: 2;

    font-size: 25px;
    opacity: 0.95;
    transform: rotate(-18deg);
}

.user-sidebar .sidebar-footer-art .art-tagline {
    position: absolute;
    right: 0;
    bottom: 38px;
    left: 0;
    z-index: 2;

    margin: 0;
    padding: 0 24px;

    color: #ffffff;
    font-family: Georgia, "Times New Roman", serif;
    font-size: 24px;
    font-style: italic;
    line-height: 1.35;

    text-shadow: 0 2px 8px rgba(39, 57, 137, 0.12);
}

/* =========================================================
   SCROLLBAR
   ========================================================= */

.user-sidebar::-webkit-scrollbar {
    width: 4px;
}

.user-sidebar::-webkit-scrollbar-track {
    background: transparent;
}

.user-sidebar::-webkit-scrollbar-thumb {
    background: rgba(255, 255, 255, 0.45);
    border-radius: 10px;
}

/* =========================================================
   MOBILE
   ========================================================= */

/* Mobile visibility is controlled by user.css so the sidebar remains
   a normal flex child on desktop and does not create a blank column. */

/* Premium light sidebar override — UI only */
.user-sidebar {
    background: linear-gradient(180deg, #b8c9ff 0%, #cbd5ff 48%, #d9ddff 100%) !important;
    color: #25345f !important;
    box-shadow: 8px 0 30px rgba(91, 108, 180, 0.10);
    border-right: 1px solid rgba(255,255,255,.75);
}

.user-sidebar::before {
    background:
        radial-gradient(circle at 15% 0%, rgba(255,255,255,.72), transparent 42%),
        linear-gradient(180deg, transparent, rgba(255,255,255,.18)) !important;
}

.user-sidebar .sidebar-logo img {
    filter: none !important;
    width: 174px !important;
}

.user-sidebar .sidebar-menu-item,
.user-sidebar .sidebar-logout {
    color: #34446f !important;
    border: 1px solid transparent;
    font-weight: 600;
}

.user-sidebar .sidebar-menu-item:hover,
.user-sidebar .sidebar-logout:hover {
    color: #263665 !important;
    background: rgba(255,255,255,.48) !important;
    border-color: rgba(255,255,255,.65);
}

.user-sidebar .sidebar-menu-item.active {
    color: #263665 !important;
    background: rgba(255,255,255,.78) !important;
    border: 1px solid rgba(255,255,255,.92);
    box-shadow: 0 8px 22px rgba(93,110,181,.12);
}

.user-sidebar .menu-icon,
.user-sidebar .sidebar-menu-item.active .menu-icon {
    color: #5268bd !important;
}

.user-sidebar .sidebar-footer-art::before {
    opacity: .35 !important;
}

.user-sidebar .sidebar-footer-art::after {
    background: linear-gradient(180deg, transparent, rgba(104,122,204,.12)) !important;
}

.user-sidebar .sidebar-footer-art .art-tagline {
    color: #52639f !important;
    text-shadow: none !important;
}

</style>

<!-- =========================================================
     ORIGINAL USER SIDEBAR MARKUP
     ========================================================= -->

<aside class="user-sidebar">

    <div class="sidebar-logo">
        <a href="user_dashboard.jsp"
           style="display:flex; align-items:center; gap:10px; text-decoration:none;">
            <img
                src="${pageContext.request.contextPath}/images/TripNexa_logo.png"
                alt="TripNexa Logo"
                style="max-width:150px; height:auto; object-fit:contain; filter:brightness(0) invert(1);">
        </a>
    </div>

    <div class="sidebar-menu">

        <div class="menu-section-title">
            MAIN MENU
        </div>

        <a
            href="user_dashboard.jsp"
            class="sidebar-menu-item <%= "dashboard".equals(activePage) ? "active" : "" %>">
            <span class="menu-icon">
                <i class="fa-solid fa-house"></i>
            </span>
            <span class="menu-text">
                Dashboard
            </span>
        </a>

        <a
            href="explore.jsp"
            class="sidebar-menu-item <%= "explore".equals(activePage) ? "active" : "" %>">
            <span class="menu-icon">
                <i class="fa-solid fa-compass"></i>
            </span>
            <span class="menu-text">
                Explore
            </span>
        </a>

        <a
            href="recommendation.jsp"
            class="sidebar-menu-item <%= "recommendations".equals(activePage) ? "active" : "" %>">
            <span class="menu-icon">
                <i class="fa-solid fa-wand-magic-sparkles"></i>
            </span>
            <span class="menu-text">
                Recommendations
            </span>
        </a>

        <a
            href="packagesuserjsp.jsp"
            class="sidebar-menu-item <%= "trips".equals(activePage) ? "active" : "" %>">
            <span class="menu-icon">
                <i class="fa-solid fa-suitcase-rolling"></i>
            </span>
            <span class="menu-text">
                Package
            </span>
        </a>

        <a
            href="bucketlist.jsp"
            class="sidebar-menu-item <%= "bucketlist".equals(activePage) ? "active" : "" %>">
            <span class="menu-icon">
                <i class="fa-regular fa-heart"></i>
            </span>
            <span class="menu-text">
                Bucket List
            </span>
        </a>

        <a
            href="myreviewsjsp.jsp"
            class="sidebar-menu-item <%= "reviews".equals(activePage) ? "active" : "" %>">
            <span class="menu-icon">
                <i class="fa-regular fa-star"></i>
            </span>
            <span class="menu-text">
                My Reviews
            </span>
        </a>

        <div class="menu-section-title second-section">
            ACCOUNT
        </div>

        <a
            href="profile.jsp"
            class="sidebar-menu-item <%= "profile".equals(activePage) ? "active" : "" %>">
            <span class="menu-icon">
                <i class="fa-regular fa-user"></i>
            </span>
            <span class="menu-text">
                Profile
            </span>
        </a>

    </div>

    <div class="sidebar-bottom">
    </div>

    <button
        type="button"
        class="sidebar-logout"
        id="logoutBtn">
        <span class="menu-icon">
            <i class="fa-solid fa-right-from-bracket"></i>
        </span>
        <span class="menu-text">
            Logout
        </span>
    </button>

    <div class="sidebar-footer-art"></div>

</aside>

<!-- =========================================================
     ORIGINAL LOGOUT SCRIPT — PRESERVED
     ========================================================= -->

<script>
document.addEventListener("DOMContentLoaded", function () {

    const logoutBtn =
        document.getElementById("logoutBtn");

    if (logoutBtn) {
        logoutBtn.addEventListener("click", function () {

            localStorage.removeItem("token");
            localStorage.removeItem("userName");
            localStorage.removeItem("userEmail");
            localStorage.removeItem("userRole");

            sessionStorage.clear();

            window.location.href = "login.jsp";
        });
    }

    const mobileMenuBtn =
        document.getElementById("mobileMenuBtn");

    const sidebar =
        document.querySelector(".user-sidebar");

    if (mobileMenuBtn && sidebar) {
        mobileMenuBtn.addEventListener("click", function () {
            sidebar.classList.toggle("mobile-open");
        });
    }

    const sidebarLinks =
        document.querySelectorAll(
            ".user-sidebar .sidebar-menu-item"
        );

    sidebarLinks.forEach(function (link) {
        link.addEventListener("click", function () {

            if (window.innerWidth <= 900) {
                sidebar.classList.remove("mobile-open");
            }

        });
    });

});
</script>
