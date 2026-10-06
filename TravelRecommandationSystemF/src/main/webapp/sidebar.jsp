<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="${pageContext.request.contextPath}/js/apiConfig.js"></script>

<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<style>
.sidebar {
    width: 270px;
    background: linear-gradient(180deg, #1e2a5e 0%, #2d3a7a 45%, #3d2f78 100%);
    border-right: 1px solid rgba(255,255,255,0.06);
    padding: 24px 16px;
    display: flex; flex-direction: column; min-height: 100vh; box-sizing: border-box;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    flex-shrink: 0; position: relative; overflow: hidden;
}
.brand-container { display: flex; align-items: center; justify-content: center; padding: 0 12px 20px 12px; }
.brand-logo-img { max-width: 180px; height: auto; object-fit: contain; filter: brightness(0) invert(1); }

.nav-links { list-style: none; padding: 0; margin: 0; display: flex; flex-direction: column; gap: 4px; }
.nav-links li { border-radius: 12px; transition: all 0.2s ease; }
.nav-links li a {
    display: flex; align-items: center; gap: 12px; padding: 12px 16px; text-decoration: none;
    color: rgba(255,255,255,0.72); font-size: 14px; font-weight: 500; border-radius: 12px; transition: all 0.2s ease;
}
.nav-links li a .nav-icon { font-size: 18px; width: 22px; min-width: 22px; text-align: center; }
.nav-links li:hover:not(.active) a { background-color: rgba(255,255,255,0.08); color: #ffffff; }

.nav-links li.active { background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%); box-shadow: 0 4px 12px rgba(79,70,229,0.25); }
.nav-links li.active a { color: #ffffff !important; font-weight: 600; }

.nav-links li.logout-item a { color: #ff8a8a; margin-top: 15px; }
.nav-links li.logout-item:hover a { background-color: rgba(239,68,68,0.18); color: #ffb3b3; }

.admin-notification-count {
    display: none; min-width: 20px; height: 20px; padding: 0 6px; border-radius: 20px;
    background: #ef4444; color: #fff; font-size: 10px; font-weight: 700; align-items: center;
    justify-content: center; margin-left: auto; box-shadow: 0 2px 8px rgba(239,68,68,0.35);
    line-height: 20px; text-align: center;
}
.admin-notification-count.show { display: flex; animation: notificationPulse 1.5s infinite; }
@keyframes notificationPulse { 0%{transform:scale(1);} 50%{transform:scale(1.08);} 100%{transform:scale(1);} }

.sidebar-footer-art { margin-top: auto; padding-top: 24px; text-align: center; }
.sidebar-footer-art .art-plane { font-size: 20px; color: rgba(255,255,255,0.55); }
.sidebar-footer-art .art-tagline { font-style: italic; font-size: 15px; line-height: 1.3; color: rgba(255,255,255,0.85); padding: 10px 10px 6px; }
/* =========================================================
   TRIPNEXA ADMIN SIDEBAR
   User Dashboard Light Blue / Lavender Design
   Existing HTML, JSP and JavaScript compatible
   ========================================================= */

.sidebar {
    width: 263px;
    min-width: 263px;
    min-height: 100vh;

    display: flex;
    flex-direction: column;

    position: relative;
    flex-shrink: 0;
    overflow: hidden;

    padding: 24px 12px 0;
    box-sizing: border-box;

    font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;

    /*
     * Light blue and lavender gradient matching
     * the user dashboard sidebar
     */
    background:
        linear-gradient(
            180deg,
            #b9caff 0%,
            #cbd5ff 45%,
            #daddff 100%
        );

    color: #34446f;

    border-right: 1px solid rgba(255, 255, 255, 0.75);
    box-shadow: 8px 0 30px rgba(91, 108, 180, 0.10);
}

/* Soft decorative lighting */

.sidebar::before {
    content: "";
    position: absolute;
    inset: 0;
    z-index: 0;
    pointer-events: none;

    background:
        radial-gradient(
            circle at 10% 0%,
            rgba(255, 255, 255, 0.72),
            transparent 40%
        ),
        linear-gradient(
            180deg,
            rgba(255, 255, 255, 0.08),
            rgba(255, 255, 255, 0.18)
        );
}

/* Keep all sidebar content above the decorative layer */

.sidebar > * {
    position: relative;
    z-index: 2;
}

/* =========================================================
   BRAND / LOGO
   ========================================================= */

.brand-container {
    display: flex;
    align-items: center;
    justify-content: center;

    padding: 7px 0 22px;
}

.brand-container a {
    display: flex;
    align-items: center;
    justify-content: center;
    text-decoration: none;
}

.brand-logo-img {
    display: block;

    width: 174px;
    max-width: 100%;
    height: auto;

    object-fit: contain;

    /*
     * The user sidebar uses the original logo colors.
     * Remove the previous white-logo filter.
     */
    filter: none !important;
}

/* =========================================================
   NAVIGATION LIST
   ========================================================= */

.nav-links {
    display: flex;
    flex-direction: column;
    gap: 5px;

    width: 100%;

    list-style: none;
    padding: 0;
    margin: 0;
}

/* Each navigation list item */

.nav-links li {
    width: 100%;
    border-radius: 11px;
    transition:
        background 0.2s ease,
        box-shadow 0.2s ease,
        transform 0.2s ease;
}

/* =========================================================
   NAVIGATION LINKS
   ========================================================= */

.nav-links li a {
    display: flex;
    align-items: center;
    gap: 16px;

    width: 100%;
    min-height: 50px;

    padding: 0 14px;
    box-sizing: border-box;

    border: 1px solid transparent;
    border-radius: 11px;

    color: #34446f;
    text-decoration: none;

    font-size: 15px;
    font-weight: 600;
    line-height: 1.3;

    transition:
        background 0.2s ease,
        color 0.2s ease,
        border-color 0.2s ease,
        box-shadow 0.2s ease,
        transform 0.2s ease;
}

/* =========================================================
   NAVIGATION ICONS
   ========================================================= */

.nav-links li a .nav-icon {
    display: flex;
    align-items: center;
    justify-content: center;

    width: 22px;
    min-width: 22px;
    height: 22px;

    color: #5268bd;

    font-size: 17px;
    line-height: 1;
    text-align: center;

    transition:
        color 0.2s ease,
        transform 0.2s ease;
}

/* =========================================================
   HOVER STATE
   ========================================================= */

.nav-links li:hover:not(.active) a {
    color: #263665;

    background: rgba(255, 255, 255, 0.48);
    border-color: rgba(255, 255, 255, 0.65);

    transform: translateX(2px);
}

.nav-links li:hover:not(.active) a .nav-icon {
    color: #4056a8;
    transform: scale(1.04);
}

/* =========================================================
   ACTIVE MENU ITEM
   ========================================================= */

.nav-links li.active {
    background: transparent;
    box-shadow: none;
}

.nav-links li.active a {
    color: #263665 !important;
    font-weight: 600;

    background: rgba(255, 255, 255, 0.80);
    border: 1px solid rgba(255, 255, 255, 0.92);

    box-shadow:
        0 8px 22px rgba(93, 110, 181, 0.12);

    transform: none;
}

.nav-links li.active a .nav-icon {
    color: #5268bd;
}

.nav-links li.active:hover a {
    color: #263665 !important;
    background: rgba(255, 255, 255, 0.84);
    transform: none;
}

/* =========================================================
   NOTIFICATION BADGE
   Existing JavaScript remains unchanged
   ========================================================= */

.admin-notification-count {
    display: none;
    align-items: center;
    justify-content: center;

    min-width: 20px;
    height: 20px;
    padding: 0 6px;
    margin-left: auto;

    color: #ffffff;
    background: #ed6b83;

    border: 2px solid rgba(255, 255, 255, 0.8);
    border-radius: 50px;

    font-size: 10px;
    font-weight: 700;
    line-height: 1;
    text-align: center;

    box-shadow: 0 3px 10px rgba(237, 107, 131, 0.22);
}

.admin-notification-count.show {
    display: flex;
    animation: notificationPulse 1.5s infinite;
}

@keyframes notificationPulse {
    0% {
        transform: scale(1);
    }

    50% {
        transform: scale(1.08);
    }

    100% {
        transform: scale(1);
    }
}

/* =========================================================
   LOGOUT ITEM
   ========================================================= */

.nav-links li.logout-item {
    margin-top: 15px;
}

.nav-links li.logout-item a {
    color: #34446f;
    background: transparent;
    border-color: transparent;
}

.nav-links li.logout-item a .nav-icon {
    color: #5268bd;
}

.nav-links li.logout-item:hover a {
    color: #263665;
    background: rgba(255, 255, 255, 0.48);
    border-color: rgba(255, 255, 255, 0.65);
}

.nav-links li.logout-item:hover a .nav-icon {
    color: #4056a8;
}

/* =========================================================
   SIDEBAR FOOTER ART
   ========================================================= */

.sidebar-footer-art {
    position: relative;
    z-index: 2;

    margin-top: auto;
    padding-top: 24px;

    text-align: center;
    pointer-events: none;
}

.sidebar-footer-art .art-plane {
    color: #52639f;
    font-size: 22px;
    opacity: 0.85;
}

.sidebar-footer-art .art-tagline {
    padding: 10px 10px 18px;

    color: #52639f;

    font-family: Georgia, "Times New Roman", serif;
    font-size: 18px;
    font-style: italic;
    font-weight: 500;
    line-height: 1.35;

    text-shadow: none;
}

/* =========================================================
   RESPONSIVE DESIGN
   ========================================================= */

@media (max-width: 1100px) {
    .sidebar {
        width: 245px;
        min-width: 245px;
    }

    .nav-links li a {
        gap: 13px;
        padding: 0 12px;
        font-size: 14px;
    }

    .brand-logo-img {
        width: 165px;
    }
}

@media (max-width: 900px) {
    .sidebar {
        width: 230px;
        min-width: 230px;
    }

    .nav-links li a {
        min-height: 48px;
        font-size: 13px;
    }

    .sidebar-footer-art .art-tagline {
        font-size: 16px;
    }
}

@media (max-width: 700px) {
    .sidebar {
        display: none;
    }
}

@media (max-width: 900px) { .sidebar { width: 230px; } .nav-links li a { font-size: 13px; padding: 11px 12px; } }
@media (max-width: 700px) { .sidebar { display: none; } }
</style>
</head>

<aside class="sidebar">

    <div class="brand-container">
        <a href="dashboard.jsp">
            <img src="${pageContext.request.contextPath}/images/TripNexa_logo.png" alt="TripNexa Logo" class="brand-logo-img">
        </a>
    </div>

    <ul class="nav-links">

        <li class="${param.activePage == 'dashboard' ? 'active' : ''}">
            <a href="dashboard.jsp"><span class="nav-icon">📊</span><span>Dashboard</span></a>
        </li>

        <li class="${param.activePage == 'destination' ? 'active' : ''}">
            <a href="destinations.jsp"><span class="nav-icon">📍</span><span>Destination Management</span></a>
        </li>

        <li class="${param.activePage == 'hotel' ? 'active' : ''}">
            <a href="hotels.jsp"><span class="nav-icon">🏢</span><span>Hotel Management</span></a>
        </li>

        <li class="${param.activePage == 'transport' ? 'active' : ''}">
            <a href="transport.jsp"><span class="nav-icon">🚌</span><span>Transport Management</span></a>
        </li>

        <li class="${param.activePage == 'activity' ? 'active' : ''}">
            <a href="activity.jsp"><span class="nav-icon">🧗</span><span>Activity Management</span></a>
        </li>

        <li class="${param.activePage == 'package' ? 'active' : ''}">
            <a href="package.jsp"><span class="nav-icon">📦</span><span>Package Management</span></a>
        </li>

        <li class="${param.activePage == 'review' ? 'active' : ''}">
            <a href="myreviewsjsp.jsp"><span class="nav-icon">⭐</span><span>Review Management</span></a>
        </li>

        <li class="${param.activePage == 'user' ? 'active' : ''}">
            <a href="admin_user.jsp"><span class="nav-icon">👥</span><span>User Management</span></a>
        </li>

        <li class="${param.activePage == 'report' ? 'active' : ''}">
            <a href="reports.jsp"><span class="nav-icon">📈</span><span>Reports &amp; Analytics</span></a>
        </li>

        <li class="${param.activePage == 'notification' ? 'active' : ''}">
            <a href="notification.jsp">
                <span class="nav-icon">🔔</span>
                <span style="flex: 1;">Notifications</span>
                <span id="adminNotificationCount" class="admin-notification-count" aria-label="Unread notifications">0</span>
            </a>
        </li>

        <li class="logout-item">
            <a href="home.jsp"><span class="nav-icon">🚪</span><span>Logout</span></a>
        </li>

    </ul>

    <div class="sidebar-footer-art">
        <div class="art-plane">&#9992;&#65039;</div>
        <div class="art-tagline">Better Places<br>Happier People</div>
    </div>

</aside>

<script>
(function () {
    "use strict";

    const NOTIFICATION_API = API_CONFIG.api("/api/notifications");

    function getAdminToken() {
        return (
            localStorage.getItem("token") || sessionStorage.getItem("token") ||
            localStorage.getItem("jwtToken") || sessionStorage.getItem("jwtToken") ||
            localStorage.getItem("accessToken") || sessionStorage.getItem("accessToken")
        );
    }

    function updateNotificationBadge(count) {
        const badge = document.getElementById("adminNotificationCount");
        if (!badge) return;
        count = Number(count) || 0;

        if (count > 0) {
            badge.textContent = count > 99 ? "99+" : String(count);
            badge.classList.add("show");
            badge.setAttribute("aria-label", count + " unread notification" + (count === 1 ? "" : "s"));
        } else {
            badge.textContent = "0";
            badge.classList.remove("show");
            badge.setAttribute("aria-label", "No unread notifications");
        }
    }

    async function loadAdminNotificationCount() {
        const badge = document.getElementById("adminNotificationCount");
        if (!badge) return;

        const token = getAdminToken();
        if (!token) { updateNotificationBadge(0); return; }

        try {
            const response = await fetch(NOTIFICATION_API + "/admin/unread-count", {
                method: "GET",
                headers: { "Authorization": "Bearer " + token, "Accept": "application/json" },
                cache: "no-store"
            });

            if (response.ok) {
                const data = await response.json();
                updateNotificationBadge(Number(data) || 0);
                return;
            }

            if (response.status === 401 || response.status === 403) {
                updateNotificationBadge(0);
                return;
            }

            console.error("Admin notification count API error:", response.status);
        } catch (error) {
            console.error("Unable to load admin notification count:", error);
        }
    }

    function setActiveMenu() {
        const currentPath = window.location.pathname.split("/").pop();
        if (!currentPath) return;

        const links = document.querySelectorAll(".nav-links li a");
        links.forEach(function (link) {
            const href = link.getAttribute("href");
            if (!href) return;
            const li = link.parentElement;

            if (currentPath === href) {
                document.querySelectorAll(".nav-links li").forEach(item => item.classList.remove("active"));
                li.classList.add("active");
            }
        });
    }

    function initializeSidebar() {
        setActiveMenu();
        loadAdminNotificationCount();
        setInterval(loadAdminNotificationCount, 10000);
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", initializeSidebar);
    } else {
        initializeSidebar();
    }

    window.loadAdminNotificationCount = loadAdminNotificationCount;

})();
</script>
