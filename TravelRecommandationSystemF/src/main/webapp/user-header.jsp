<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<script src="<%= request.getContextPath() %>/js/apiConfig.js"></script>

<style>

/* =========================================================
   USER HEADER
========================================================= */

.user-header {
    position: relative;
    z-index: 1000;
    width: 100%;
}

.header-left {
    display: flex;
    align-items: center;
    min-width: 0;
}

.header-right {
    display: flex !important;
    align-items: center !important;
    justify-content: flex-end;
    gap: 12px;
    visibility: visible !important;
    opacity: 1 !important;
}

/* =========================================================
   HEADER GREETING
========================================================= */

.header-greeting {
    display: flex;
    flex-direction: column;
    gap: 3px;
}

.header-greeting h2 {
    margin: 0;
    font-size: 22px;
    font-weight: 700;
    color: #29263d;
}

.header-greeting p {
    margin: 0;
    font-size: 12px;
    color: #8a879d;
}

/* =========================================================
   MOBILE MENU
========================================================= */

.mobile-menu-btn {
    border: none;
    background: transparent;
    cursor: pointer;
    width: 42px;
    height: 42px;
    display: none;
    align-items: center;
    justify-content: center;
    color: #5d5874;
    border-radius: 12px;
}

.mobile-menu-btn:hover {
    background: rgba(98, 85, 245, 0.09);
    color: #6255f5;
}

/* =========================================================
   HEADER SEARCH
========================================================= */

.header-search {
    display: flex;
    align-items: center;
    gap: 8px;
    width: 230px;
    height: 40px;
    padding: 0 13px;
    border-radius: 13px;
    background: rgba(255, 255, 255, 0.82);
    border: 1px solid rgba(80, 70, 130, 0.09);
    box-sizing: border-box;
}

.header-search i {
    color: #8a879d;
    font-size: 14px;
    flex-shrink: 0;
}

.header-search input {
    width: 100%;
    border: none;
    outline: none;
    background: transparent;
    font-family: inherit;
    font-size: 12px;
    color: #302c4a;
}

.header-search input::placeholder {
    color: #aaa6b8;
}

/* =========================================================
   PROFILE
========================================================= */

.header-profile {
    display: flex;
    align-items: center;
    gap: 10px;
    cursor: pointer;
    padding: 6px 10px;
    border-radius: 16px;
    transition: all 0.25s ease;
    user-select: none;
}

.header-profile:hover {
    background: rgba(99, 77, 245, 0.08);
}

.profile-avatar {
    width: 42px !important;
    height: 42px !important;
    min-width: 42px !important;
    min-height: 42px !important;
    max-width: 42px !important;
    max-height: 42px !important;
    border-radius: 50%;
    overflow: hidden;
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #6255f5, #8b5cf6);
    border: 3px solid rgba(255,255,255,0.95);
    box-shadow: 0 4px 14px rgba(91,74,235,0.25);
    flex-shrink: 0;
}

.profile-avatar img {
    width: 100% !important;
    height: 100% !important;
    min-width: 100%;
    min-height: 100%;
    max-width: none !important;
    max-height: none !important;
    display: block;
    object-fit: cover;
    object-position: center;
    border-radius: 50%;
}

#profileInitial {
    display: none !important;
}

#profileUserIcon {
    color: #ffffff;
    font-size: 18px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.profile-info {
    display: flex;
    flex-direction: column;
    gap: 2px;
    min-width: 75px;
}

.profile-info strong {
    font-size: 13px;
    font-weight: 700;
    color: #29263d;
    white-space: nowrap;
    max-width: 120px;
    overflow: hidden;
    text-overflow: ellipsis;
}

.profile-info span {
    font-size: 10px;
    color: #8a879d;
}

.profile-arrow {
    font-size: 11px;
    color: #8a879d;
    margin-left: 3px;
    transition: transform 0.25s ease;
}

.header-profile.active .profile-arrow {
    transform: rotate(180deg);
}

/* =========================================================
   PROFILE DROPDOWN
========================================================= */

.profile-dropdown {
    position: fixed;
    top: 78px;
    right: 28px;
    width: 210px;
    background: rgba(255,255,255,0.97);
    backdrop-filter: blur(18px);
    -webkit-backdrop-filter: blur(18px);
    border: 1px solid rgba(255,255,255,0.8);
    border-radius: 18px;
    padding: 8px;
    box-shadow:
        0 20px 50px rgba(35,29,85,0.18),
        0 5px 15px rgba(35,29,85,0.08);
    z-index: 99999;
    opacity: 0;
    visibility: hidden;
    transform: translateY(-8px) scale(0.97);
    transform-origin: top right;
    transition:
        opacity 0.2s ease,
        transform 0.2s ease,
        visibility 0.2s ease;
}

.profile-dropdown.show {
    opacity: 1;
    visibility: visible;
    transform: translateY(0) scale(1);
}

.profile-dropdown a,
.profile-dropdown button {
    width: 100%;
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 13px;
    border: none;
    background: transparent;
    color: #302c4a;
    text-decoration: none;
    font-family: inherit;
    font-size: 13px;
    font-weight: 600;
    border-radius: 12px;
    cursor: pointer;
    transition: all 0.2s ease;
    box-sizing: border-box;
}

.profile-dropdown a:hover,
.profile-dropdown button:hover {
    background: linear-gradient(
        135deg,
        rgba(98,85,245,0.11),
        rgba(139,92,246,0.08)
    );
    color: #6255f5;
    transform: translateX(2px);
}

.profile-dropdown a i,
.profile-dropdown button i {
    width: 18px;
    text-align: center;
    font-size: 14px;
}

.dropdown-divider {
    height: 1px;
    background: rgba(80,70,130,0.10);
    margin: 6px 5px;
}

/* =========================================================
   NOTIFICATION BUTTON
========================================================= */

.header-icon-btn {
    position: relative !important;
    border: none !important;
    background: transparent !important;
    cursor: pointer !important;
    width: 42px !important;
    height: 42px !important;
    min-width: 42px !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    color: #5d5874 !important;
    transition: all 0.2s ease;
    z-index: 1001 !important;
    visibility: visible !important;
    opacity: 1 !important;
    flex-shrink: 0 !important;
}

.header-icon-btn:hover {
    background: rgba(98,85,245,0.09) !important;
    color: #6255f5 !important;
}

.header-icon-btn i {
    display: block !important;
    font-size: 18px;
    visibility: visible !important;
    opacity: 1 !important;
}

/* =========================================================
   NOTIFICATION BADGE
========================================================= */

.notification-dot {
    display: none;
    position: absolute;
    top: 3px;
    right: 1px;
    min-width: 18px;
    height: 18px;
    padding: 0 4px;
    background: #ef4444;
    color: #ffffff;
    border: 2px solid #ffffff;
    border-radius: 10px;
    font-size: 9px;
    font-weight: 700;
    line-height: 14px;
    text-align: center;
    align-items: center;
    justify-content: center;
    z-index: 10;
    box-sizing: border-box;
}

.notification-dot.show {
    display: flex !important;
}

/* =========================================================
   NOTIFICATION POPUP
========================================================= */

.notification-popup {
    position: fixed;
    top: 78px;
    right: 85px;
    width: 320px;
    max-width: calc(100vw - 30px);
    background: rgba(255,255,255,0.97);
    backdrop-filter: blur(18px);
    -webkit-backdrop-filter: blur(18px);
    border: 1px solid rgba(255,255,255,0.8);
    border-radius: 18px;
    box-shadow:
        0 20px 50px rgba(35,29,85,0.18),
        0 5px 15px rgba(35,29,85,0.08);
    z-index: 999999 !important;
    overflow: hidden;
    opacity: 0;
    visibility: hidden;
    transform: translateY(-8px) scale(0.97);
    transition:
        opacity 0.2s ease,
        transform 0.2s ease,
        visibility 0.2s ease;
}

.notification-popup.show {
    opacity: 1;
    visibility: visible;
    transform: translateY(0) scale(1);
}

/* =========================================================
   NOTIFICATION HEADER
========================================================= */

.notification-popup-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 15px 17px;
    border-bottom: 1px solid rgba(80,70,130,0.09);
}

.notification-popup-title-area {
    display: flex;
    flex-direction: column;
    gap: 3px;
}

.notification-popup-title-area strong {
    font-size: 15px;
    color: #302c4a;
}

.notification-popup-title-area span {
    font-size: 10px;
    color: #9995aa;
}

.notification-header-actions {
    display: flex;
    align-items: center;
    gap: 5px;
}

.notification-header-actions button {
    border: none;
    background: transparent;
    cursor: pointer;
    width: 30px;
    height: 30px;
    border-radius: 9px;
    color: #8a879d;
    display: flex;
    align-items: center;
    justify-content: center;
}

.notification-header-actions button:hover {
    background: rgba(98,85,245,0.09);
    color: black;
}

/* =========================================================
   NOTIFICATION LIST
========================================================= */

.notification-list {
    max-height: 380px;
    overflow-y: auto;
}

.notification-list::-webkit-scrollbar {
    width: 5px;
}

.notification-list::-webkit-scrollbar-thumb {
    background: rgba(98,85,245,0.25);
    border-radius: 10px;
}

.notification-item {
    position: relative;
    display: flex;
    align-items: flex-start;
    gap: 10px;
    padding: 13px 15px;
    border-bottom: 1px solid rgba(80,70,130,0.08);
    cursor: pointer;
    transition: background 0.2s ease;
}

.notification-item:hover {
    background: rgba(98,85,245,0.05);
}

.notification-item.unread {
    background: rgba(98,85,245,0.07);
}

.notification-item-icon {
    width: 35px;
    height: 35px;
    min-width: 35px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #6255f5;
    background: rgba(98,85,245,0.11);
}

.notification-item-content {
    flex: 1;
    min-width: 0;
}

.notification-item-title {
    font-size: 12px;
    font-weight: 700;
    color: #302c4a;
    margin-bottom: 3px;
}

.notification-item-message {
    font-size: 11px;
    color: #77738b;
    line-height: 1.4;
}

.notification-item-time {
    font-size: 9px;
    color: #aaa6b8;
    margin-top: 4px;
}

.notification-unread-dot {
    width: 7px;
    height: 7px;
    min-width: 7px;
    margin-top: 5px;
    border-radius: 50%;
    background: #6255f5;
}

/* =========================================================
   EMPTY / LOADING
========================================================= */

.notification-empty {
    padding: 30px 20px 34px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
    gap: 7px;
}

.notification-empty-icon {
    width: 55px;
    height: 55px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 5px;
    color: #6255f5;
    background: linear-gradient(
        135deg,
        rgba(98,85,245,0.12),
        rgba(139,92,246,0.10)
    );
}

.notification-empty-icon i {
    font-size: 22px;
}

.notification-empty strong {
    font-size: 13px;
    color: #302c4a;
}

.notification-empty span {
    font-size: 11px;
    color: #9995aa;
}

.notification-loading {
    padding: 30px 20px;
    text-align: center;
    color: #8a879d;
    font-size: 12px;
}

/* =========================================================
   RESPONSIVE
========================================================= */

@media (max-width: 1000px) {

    .header-search {
        width: 180px;
    }

}

@media (max-width: 768px) {

    .mobile-menu-btn {
        display: flex;
    }

    .header-search {
        display: none;
    }

    .profile-info {
        display: none;
    }

    .profile-dropdown {
        top: 70px;
        right: 15px;
        width: 200px;
    }

    .notification-popup {
        top: 70px;
        right: 15px;
        width: calc(100vw - 30px);
        max-width: 310px;
    }
.header-icon-btn {
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    visibility: visible !important;
    opacity: 1 !important;
}

#notificationBtn i {
    display: block !important;
    visibility: visible !important;
    opacity: 1 !important;
    color: #5d5874 !important;
    font-size: 20px !important;
    line-height: 1 !important;
}
}

</style>

<!-- =========================================================
     USER HEADER
========================================================= -->

<header class="user-header">


<div class="header-left">

    <button
        type="button"
        class="mobile-menu-btn"
        id="mobileMenuBtn">

        <i class="fa-solid fa-bars"></i>

    </button>


    <div class="header-greeting">

        <h2>
            Hello,
            <span id="headerUserName">User</span>
            👋
        </h2>

        <p>
            Ready for your next adventure?
        </p>

    </div>

</div>


<div class="header-right">

    <!-- Search -->

    <div class="header-search">

        <i class="fa-solid fa-magnifying-glass"></i>

        <input
            type="text"
            id="dashboardSearch"
            placeholder="Search destinations...">

    </div>


    <!-- Notification Button -->

    <button
        type="button"
        class="header-icon-btn"
        id="notificationBtn"
        aria-label="Notifications">

       <i class="fa-solid fa-bell"></i>

        <span
            class="notification-dot"
            id="notificationDot">
            0
        </span>

    </button>


    <!-- Profile -->

    <div
        class="header-profile"
        id="headerProfile">

        <div class="profile-avatar">

            <img
                id="headerProfilePhoto"
                src=""
                alt="Profile Photo"
                style="display:none;">

            <span
                id="profileInitial"
                style="display:none;">
            </span>

            <i
                id="profileUserIcon"
                class="fa-regular fa-user"
                style="display:flex;">
            </i>

        </div>


        <div class="profile-info">

            <strong id="headerProfileName">
                User
            </strong>

            <span>
                Traveler
            </span>

        </div>


        <i class="fa-solid fa-chevron-down profile-arrow"></i>

    </div>

</div>


</header>

<!-- =========================================================
     NOTIFICATION POPUP
========================================================= -->

<div
    class="notification-popup"
    id="notificationPopup">

```
<div class="notification-popup-header">

    <div class="notification-popup-title-area">

        <strong>
            Notifications
        </strong>

        <span id="notificationHeaderCount">
            0 unread
        </span>

    </div>


    <div class="notification-header-actions">

        <button
            type="button"
            id="markAllNotifications"
            title="Mark all as read">

            <i class="fa-solid fa-check-double"></i>

        </button>


        <button
            type="button"
            id="closeNotification"
            title="Close">

            <i class="fa-solid fa-xmark"></i>

        </button>

    </div>

</div>


<div
    class="notification-list"
    id="notificationList">

    <div class="notification-empty">

        <div class="notification-empty-icon">

            <i class="fa-solid fa-bell"></i>

        </div>

        <strong>
            No new notifications
        </strong>

        <span>
            You're all caught up!
        </span>

    </div>

</div>


</div>

<!-- =========================================================
     PROFILE DROPDOWN
========================================================= -->

<div
    class="profile-dropdown"
    id="profileDropdown">

<a
    href="profile.jsp"
    id="myProfileLink">

    <i class="fa-regular fa-user"></i>

    <span>
        My Profile
    </span>

</a>


<div class="dropdown-divider"></div>


<button
    type="button"
    id="dropdownLogout">

    <i class="fa-solid fa-right-from-bracket"></i>

    <span>
        Logout
    </span>

</button>


</div>

<script>

document.addEventListener("DOMContentLoaded", function () {

    /* =========================================================
       CONFIGURATION
    ========================================================= */

    const BACKEND_URL =
        API_CONFIG.BASE_URL;

    const FRONTEND_URL =
        window.location.origin + "<%= request.getContextPath() %>";

    const EXPLORE_PAGE =
        FRONTEND_URL + "/explore.jsp";

    const PROFILE_API =
        BACKEND_URL + "/api/travel-profile";


    /* =========================================================
       DOM ELEMENTS
    ========================================================= */

    const notificationBtn =
        document.getElementById("notificationBtn");

    const notificationPopup =
        document.getElementById("notificationPopup");

    const notificationList =
        document.getElementById("notificationList");

    const notificationDot =
        document.getElementById("notificationDot");

    const notificationHeaderCount =
        document.getElementById("notificationHeaderCount");

    const closeNotification =
        document.getElementById("closeNotification");

    const markAllNotifications =
        document.getElementById("markAllNotifications");

    const headerProfile =
        document.getElementById("headerProfile");

    const profileDropdown =
        document.getElementById("profileDropdown");

    const dropdownLogout =
        document.getElementById("dropdownLogout");

    const dashboardSearch =
        document.getElementById("dashboardSearch");


    let currentUnreadCount = 0;


    /* =========================================================
       GET TOKEN
    ========================================================= */

    function getToken() {

        return (
            localStorage.getItem("token") ||
            sessionStorage.getItem("token") ||
            ""
        );

    }


    /* =========================================================
       GET USER ID
    ========================================================= */

    function getUserId() {

        return (
            localStorage.getItem("userId") ||
            sessionStorage.getItem("userId") ||
            ""
        );

    }


    /* =========================================================
       GET USER NAME
    ========================================================= */

    function getUserName() {

        return (
            localStorage.getItem("userName") ||
            sessionStorage.getItem("userName") ||
            localStorage.getItem("fullName") ||
            sessionStorage.getItem("fullName") ||
            "User"
        );

    }


    /* =========================================================
       LOAD HEADER USER
    ========================================================= */

    async function loadHeaderUser() {

        const userName =
            getUserName();

        const headerUserName =
            document.getElementById("headerUserName");

        const headerProfileName =
            document.getElementById("headerProfileName");


        if (headerUserName) {

            headerUserName.textContent =
                userName;

        }


        if (headerProfileName) {

            headerProfileName.textContent =
                userName;

        }


        const userId =
            getUserId();


        if (!userId) {

            showDefaultHeaderUserIcon();

            return;

        }


        try {

            const token =
                getToken();


            const headers = {
                "Accept": "application/json"
            };


            if (token) {

                headers["Authorization"] =
                    "Bearer " + token;

            }


            const response =
                await fetch(
                    PROFILE_API +
                    "/" +
                    encodeURIComponent(userId),
                    {
                        method: "GET",
                        headers: headers,
                        cache: "no-store"
                    }
                );


            if (!response.ok) {

                console.warn(
                    "Profile API returned:",
                    response.status
                );

                showDefaultHeaderUserIcon();

                return;

            }


            const result =
                await response.json();


            const profile =
                result &&
                result.data
                    ? result.data
                    : result;


            if (
                profile &&
                profile.profilePhoto &&
                String(profile.profilePhoto).trim() !== ""
            ) {

                showHeaderProfilePhoto(
                    profile.profilePhoto
                );

            } else {

                showDefaultHeaderUserIcon();

            }

        } catch (error) {

            console.error(
                "Header profile error:",
                error
            );

            showDefaultHeaderUserIcon();

        }

    }


    /* =========================================================
       SHOW PROFILE PHOTO
    ========================================================= */

    function showHeaderProfilePhoto(
        profilePhoto
    ) {

        const image =
            document.getElementById(
                "headerProfilePhoto"
            );

        const userIcon =
            document.getElementById(
                "profileUserIcon"
            );

        const initial =
            document.getElementById(
                "profileInitial"
            );


        if (!image) {

            return;

        }


        if (
            !profilePhoto ||
            String(profilePhoto).trim() === ""
        ) {

            showDefaultHeaderUserIcon();

            return;

        }


        const cleanFileName =
            String(profilePhoto)
                .trim()
                .replace(/\\/g, "/")
                .split("/")
                .pop();


        if (!cleanFileName) {

            showDefaultHeaderUserIcon();

            return;

        }


        const imageURL =
            BACKEND_URL +
            "/uploads/profile/" +
            encodeURIComponent(
                cleanFileName
            );


        console.log(
            "Header profile image:",
            imageURL
        );


        image.src =
            imageURL;

        image.style.display =
            "block";


        if (userIcon) {

            userIcon.style.display =
                "none";

        }


        if (initial) {

            initial.style.display =
                "none";

        }


        image.onerror =
            function () {

                console.warn(
                    "Profile image could not be loaded:",
                    imageURL
                );

                this.onerror =
                    null;

                showDefaultHeaderUserIcon();

            };

    }


    /* =========================================================
       DEFAULT USER ICON
    ========================================================= */

    function showDefaultHeaderUserIcon() {

        const image =
            document.getElementById(
                "headerProfilePhoto"
            );

        const userIcon =
            document.getElementById(
                "profileUserIcon"
            );

        const initial =
            document.getElementById(
                "profileInitial"
            );


        if (image) {

            image.src = "";

            image.style.display =
                "none";

        }


        if (initial) {

            initial.style.display =
                "none";

        }


        if (userIcon) {

            userIcon.style.display =
                "flex";

        }

    }


    /* =========================================================
       ESCAPE HTML
    ========================================================= */

    function escapeHtml(value) {

        if (
            value === null ||
            value === undefined
        ) {

            return "";

        }


        return String(value)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");

    }


    /* =========================================================
       UPDATE NOTIFICATION BADGE
    ========================================================= */

    function updateBadge(count) {

        currentUnreadCount =
            Math.max(
                0,
                Number(count) || 0
            );


        if (notificationDot) {

            if (currentUnreadCount > 0) {

                notificationDot.textContent =
                    currentUnreadCount > 99
                        ? "99+"
                        : currentUnreadCount;

                notificationDot.classList.add(
                    "show"
                );

            } else {

                notificationDot.textContent =
                    "0";

                notificationDot.classList.remove(
                    "show"
                );

            }

        }


        if (notificationHeaderCount) {

            notificationHeaderCount.textContent =
                currentUnreadCount +
                " unread";

        }

    }


    /* =========================================================
       DECREASE UNREAD COUNT
    ========================================================= */

    function decreaseUnreadCount() {

        if (currentUnreadCount > 0) {

            currentUnreadCount--;

        }

        updateBadge(
            currentUnreadCount
        );

    }


    /* =========================================================
       LOAD NOTIFICATION COUNT
    ========================================================= */

    async function loadNotificationCount() {

        const token =
            getToken();


        if (!token) {

            updateBadge(0);

            return;

        }


        try {

            const response =
                await fetch(
                    BACKEND_URL +
                    "/api/notifications/user/unread-count",
                    {
                        method: "GET",
                        headers: {
                            "Authorization":
                                "Bearer " + token,
                            "Accept":
                                "application/json"
                        },
                        cache: "no-store"
                    }
                );


            if (!response.ok) {

                console.error(
                    "Unread count failed:",
                    response.status
                );

                return;

            }


            const data =
                await response.json();


            updateBadge(data);

        } catch (error) {

            console.error(
                "Notification count error:",
                error
            );

        }

    }


    /* =========================================================
       LOAD NOTIFICATIONS
    ========================================================= */

    async function loadNotifications() {

        const token =
            getToken();


        if (!notificationList) {

            return;

        }


        if (!token) {

            notificationList.innerHTML = `
                <div class="notification-empty">

                    <div class="notification-empty-icon">
                        <i class="fa-regular fa-bell"></i>
                    </div>

                    <strong>
                        Please login
                    </strong>

                    <span>
                        Login to view your notifications.
                    </span>

                </div>
            `;

            updateBadge(0);

            return;

        }


        notificationList.innerHTML = `
            <div class="notification-loading">
                Loading notifications...
            </div>
        `;


        try {

            const response =
                await fetch(
                    BACKEND_URL +
                    "/api/notifications/user",
                    {
                        method: "GET",
                        headers: {
                            "Authorization":
                                "Bearer " + token,
                            "Accept":
                                "application/json"
                        },
                        cache: "no-store"
                    }
                );


            if (!response.ok) {

                throw new Error(
                    "HTTP " +
                    response.status
                );

            }


            const notifications =
                await response.json();


            if (
                !Array.isArray(notifications) ||
                notifications.length === 0
            ) {

                notificationList.innerHTML = `
                    <div class="notification-empty">

                        <div class="notification-empty-icon">
                            <i class="fa-regular fa-bell"></i>
                        </div>

                        <strong>
                            No notifications
                        </strong>

                        <span>
                            You're all caught up!
                        </span>

                    </div>
                `;

                updateBadge(0);

                return;

            }


            let html = "";


            notifications.forEach(
                function (notification) {

                    const notificationId =
                        notification.notificationId;

                    const title =
                        notification.title ||
                        "Notification";

                    const message =
                        notification.message ||
                        "";

                    const notificationType =
                        notification.notificationType ||
                        "";

                    const createdAt =
                        notification.createdAt ||
                        "";

                    const isRead =
                        notification.read === true;


                    let icon =
                        "fa-solid fa-bell";


                    if (
                        notificationType ===
                        "NEW_DESTINATION"
                    ) {

                        icon =
                            "fa-solid fa-location-dot";

                    } else if (
                        notificationType ===
                        "NEW_PACKAGE"
                    ) {

                        icon =
                            "fa-solid fa-suitcase";

                    } else if (
                        notificationType ===
                        "NEW_HOTEL"
                    ) {

                        icon =
                            "fa-solid fa-hotel";

                    } else if (
                        notificationType ===
                        "NEW_TRANSPORT"
                    ) {

                        icon =
                            "fa-solid fa-bus";

                    }


                    html += `
                        <div
                            class="notification-item ${isRead ? "" : "unread"}"
                            data-notification-id="${escapeHtml(notificationId)}"
                            data-notification-type="${escapeHtml(notificationType)}">

                            <div class="notification-item-icon">

                                <i class="${icon}"></i>

                            </div>


                            <div class="notification-item-content">

                                <div class="notification-item-title">
                                    ${escapeHtml(title)}
                                </div>

                                <div class="notification-item-message">
                                    ${escapeHtml(message)}
                                </div>

                                ${
                                    createdAt
                                    ? `
                                        <div class="notification-item-time">
                                            ${escapeHtml(createdAt)}
                                        </div>
                                      `
                                    : ""
                                }

                            </div>


                            ${
                                !isRead
                                ? `
                                    <div class="notification-unread-dot"></div>
                                  `
                                : ""
                            }

                        </div>
                    `;

                }
            );


            notificationList.innerHTML =
                html;


            const items =
                notificationList.querySelectorAll(
                    ".notification-item"
                );


            items.forEach(
                function (item) {

                    item.addEventListener(
                        "click",
                        function () {

                            const notificationId =
                                this.getAttribute(
                                    "data-notification-id"
                                );

                            const notificationType =
                                this.getAttribute(
                                    "data-notification-type"
                                );


                            handleNotificationClick(
                                notificationId,
                                notificationType,
                                this
                            );

                        }
                    );

                }
            );

        } catch (error) {

            console.error(
                "Notification loading error:",
                error
            );


            notificationList.innerHTML = `
                <div class="notification-empty">

                    <div class="notification-empty-icon">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                    </div>

                    <strong>
                        Unable to load notifications
                    </strong>

                    <span>
                        Please try again.
                    </span>

                </div>
            `;

        }

    }


    /* =========================================================
       HANDLE NOTIFICATION CLICK
    ========================================================= */

    async function handleNotificationClick(
        notificationId,
        notificationType,
        element
    ) {

        const token =
            getToken();


        if (!notificationId) {

            window.location.href =
                EXPLORE_PAGE;

            return;

        }


        const wasUnread =
            element.classList.contains(
                "unread"
            );


        if (wasUnread) {

            decreaseUnreadCount();

            element.classList.remove(
                "unread"
            );


            const unreadDot =
                element.querySelector(
                    ".notification-unread-dot"
                );


            if (unreadDot) {

                unreadDot.remove();

            }

        }


        if (token) {

            try {

                const response =
                    await fetch(
                        BACKEND_URL +
                        "/api/notifications/user/" +
                        encodeURIComponent(
                            notificationId
                        ) +
                        "/read",
                        {
                            method: "PUT",
                            headers: {
                                "Authorization":
                                    "Bearer " + token,
                                "Accept":
                                    "application/json"
                            }
                        }
                    );


                if (!response.ok) {

                    console.warn(
                        "Mark notification as read failed:",
                        response.status
                    );

                }

            } catch (error) {

                console.warn(
                    "Mark notification error:",
                    error
                );

            }

        }


        /* All notification clicks go to Explore */

        window.location.href =
            EXPLORE_PAGE;

    }


    /* =========================================================
       NOTIFICATION BUTTON
    ========================================================= */

    if (notificationBtn) {

        notificationBtn.addEventListener(
            "click",
            async function (event) {

                event.preventDefault();

                event.stopPropagation();


                if (profileDropdown) {

                    profileDropdown.classList.remove(
                        "show"
                    );

                }


                if (headerProfile) {

                    headerProfile.classList.remove(
                        "active"
                    );

                }


                if (!notificationPopup) {

                    console.error(
                        "notificationPopup not found."
                    );

                    return;

                }


                const alreadyOpen =
                    notificationPopup.classList.contains(
                        "show"
                    );


                if (alreadyOpen) {

                    notificationPopup.classList.remove(
                        "show"
                    );

                    return;

                }


                notificationPopup.classList.add(
                    "show"
                );


                await loadNotifications();

            }
        );

    }


    /* =========================================================
       CLOSE NOTIFICATION
    ========================================================= */

    if (closeNotification) {

        closeNotification.addEventListener(
            "click",
            function (event) {

                event.preventDefault();

                event.stopPropagation();


                if (notificationPopup) {

                    notificationPopup.classList.remove(
                        "show"
                    );

                }

            }
        );

    }


    /* =========================================================
       MARK ALL NOTIFICATIONS AS READ
    ========================================================= */

    if (markAllNotifications) {

        markAllNotifications.addEventListener(
            "click",
            async function (event) {

                event.preventDefault();

                event.stopPropagation();


                const token =
                    getToken();


                if (!token) {

                    return;

                }


                try {

                    const response =
                        await fetch(
                            BACKEND_URL +
                            "/api/notifications/user/read-all",
                            {
                                method: "PUT",
                                headers: {
                                    "Authorization":
                                        "Bearer " + token,
                                    "Accept":
                                        "application/json"
                                }
                            }
                        );


                    if (!response.ok) {

                        console.error(
                            "Mark all read failed:",
                            response.status
                        );

                        return;

                    }


                    updateBadge(0);

                    await loadNotifications();

                } catch (error) {

                    console.error(
                        "Mark all read error:",
                        error
                    );

                }

            }
        );

    }


    /* =========================================================
       PROFILE DROPDOWN
    ========================================================= */

    if (headerProfile) {

        headerProfile.addEventListener(
            "click",
            function (event) {

                event.preventDefault();

                event.stopPropagation();


                if (notificationPopup) {

                    notificationPopup.classList.remove(
                        "show"
                    );

                }


                if (!profileDropdown) {

                    return;

                }


                const isOpen =
                    profileDropdown.classList.contains(
                        "show"
                    );


                if (isOpen) {

                    profileDropdown.classList.remove(
                        "show"
                    );

                    headerProfile.classList.remove(
                        "active"
                    );

                } else {

                    profileDropdown.classList.add(
                        "show"
                    );

                    headerProfile.classList.add(
                        "active"
                    );

                }

            }
        );

    }


    /* =========================================================
       CLOSE DROPDOWNS WHEN CLICKING OUTSIDE
    ========================================================= */

    document.addEventListener(
        "click",
        function (event) {

            if (
                notificationPopup &&
                notificationPopup.classList.contains(
                    "show"
                ) &&
                !notificationPopup.contains(
                    event.target
                ) &&
                notificationBtn &&
                !notificationBtn.contains(
                    event.target
                )
            ) {

                notificationPopup.classList.remove(
                    "show"
                );

            }


            if (
                profileDropdown &&
                profileDropdown.classList.contains(
                    "show"
                ) &&
                !profileDropdown.contains(
                    event.target
                ) &&
                headerProfile &&
                !headerProfile.contains(
                    event.target
                )
            ) {

                profileDropdown.classList.remove(
                    "show"
                );

                if (headerProfile) {

                    headerProfile.classList.remove(
                        "active"
                    );

                }

            }

        }
    );


    /* =========================================================
       LOGOUT
    ========================================================= */

    if (dropdownLogout) {

        dropdownLogout.addEventListener(
            "click",
            function (event) {

                event.preventDefault();

                event.stopPropagation();


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


                window.location.href =
                    FRONTEND_URL +
                    "/login.jsp";

            }
        );

    }


    /* =========================================================
       SEARCH
    ========================================================= */

    if (dashboardSearch) {

        dashboardSearch.addEventListener(
            "keydown",
            function (event) {

                if (
                    event.key ===
                    "Enter"
                ) {

                    const query =
                        this.value.trim();


                    if (query.length > 0) {

                        window.location.href =
                            EXPLORE_PAGE +
                            "?search=" +
                            encodeURIComponent(
                                query
                            );

                    }

                }

            }
        );

    }


    /* =========================================================
       MOBILE MENU
    ========================================================= */

    const mobileMenuBtn =
        document.getElementById(
            "mobileMenuBtn"
        );


    if (mobileMenuBtn) {

        mobileMenuBtn.addEventListener(
            "click",
            function (event) {

                event.preventDefault();

                event.stopPropagation();


                const sidebar =
                    document.querySelector(
                        ".sidebar"
                    );


                if (sidebar) {

                    sidebar.classList.toggle(
                        "show"
                    );

                }

            }
        );

    }


    /* =========================================================
       INITIAL LOAD
    ========================================================= */

    loadHeaderUser();

    loadNotificationCount();


    /* =========================================================
       NOTIFICATION POLLING
    ========================================================= */

    setInterval(
        loadNotificationCount,
        30000
    );

});

</script>
