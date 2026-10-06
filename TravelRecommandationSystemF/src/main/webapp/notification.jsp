<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="${pageContext.request.contextPath}/js/apiConfig.js"></script>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Notifications | TripNexa</title>


<!-- Bootstrap 5 -->

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
    rel="stylesheet">


<!-- Font Awesome -->

<link
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    rel="stylesheet">


<style>

* {
    box-sizing: border-box;
}


body {

    margin: 0;

    background: #f8fafc;

    font-family:
        'Segoe UI',
        Tahoma,
        Geneva,
        Verdana,
        sans-serif;

    color: #1e293b;
}


.admin-layout {

    display: flex;

    min-height: 100vh;
}


/* =====================================================
   SIDEBAR
===================================================== */

.sidebar {

    width: 270px;

    background: #ffffff;

    border-right:
        1px solid #eef2f6;

    padding: 24px 16px;

    display: flex;

    flex-direction: column;

    min-height: 100vh;

    flex-shrink: 0;
}


.brand-container {

    display: flex;

    align-items: center;

    justify-content: center;

    padding: 0 12px 20px;
}


.brand-logo-img {

    max-width: 180px;

    height: auto;

    object-fit: contain;
}


.nav-links {

    list-style: none;

    padding: 0;

    margin: 0;

    display: flex;

    flex-direction: column;

    gap: 4px;
}


.nav-links li {

    border-radius: 12px;

    transition: .2s;
}


.nav-links li a {

    display: flex;

    align-items: center;

    gap: 12px;

    padding: 12px 16px;

    text-decoration: none;

    color: #64748b;

    font-size: 14px;

    font-weight: 500;

    border-radius: 12px;

    transition: .2s;
}


.nav-links li a .nav-icon {

    font-size: 18px;

    width: 22px;

    min-width: 22px;

    text-align: center;
}


.nav-links li:hover:not(.active) a {

    background: #f8fafc;

    color: #1e293b;
}


.nav-links li.active {

    background:
        linear-gradient(
            135deg,
            #6366f1 0%,
            #4f46e5 100%
        );

    box-shadow:
        0 4px 12px
        rgba(79,70,229,.25);
}


.nav-links li.active a {

    color: #ffffff !important;

    font-weight: 600;
}


.nav-links li.logout-item a {

    color: #ef4444;

    margin-top: 15px;
}


.nav-links li.logout-item:hover a {

    background: #fef2f2;

    color: #dc2626;
}


/* =====================================================
   NOTIFICATION BADGE
===================================================== */

.admin-notification-count {

    display: none;

    min-width: 20px;

    height: 20px;

    padding: 0 6px;

    border-radius: 20px;

    background: #ef4444;

    color: #ffffff;

    font-size: 10px;

    font-weight: 700;

    align-items: center;

    justify-content: center;

    margin-left: auto;
}


.admin-notification-count.show {

    display: flex;
}


/* =====================================================
   MAIN CONTENT
===================================================== */

.main-content {

    flex: 1;

    padding: 35px;

    min-width: 0;
}


/* =====================================================
   PAGE HEADER
===================================================== */

.page-header {

    display: flex;

    align-items: center;

    justify-content: space-between;

    margin-bottom: 25px;

    gap: 20px;
}


.page-title {

    font-size: 28px;

    font-weight: 700;

    margin: 0;
}


.page-subtitle {

    color: #64748b;

    font-size: 14px;

    margin-top: 5px;
}


/* =====================================================
   MARK ALL BUTTON
===================================================== */

.mark-all-btn {

    border: none;

    background:
        linear-gradient(
            135deg,
            #6366f1,
            #4f46e5
        );

    color: #ffffff;

    padding: 10px 18px;

    border-radius: 10px;

    font-size: 13px;

    font-weight: 600;

    cursor: pointer;

    transition: .2s;
}


.mark-all-btn:hover {

    opacity: .9;

    transform: translateY(-1px);
}


.mark-all-btn:disabled {

    opacity: .5;

    cursor: not-allowed;

    transform: none;
}


/* =====================================================
   NOTIFICATION CONTAINER
===================================================== */

.notification-container {

    background: #ffffff;

    border-radius: 18px;

    box-shadow:
        0 8px 30px
        rgba(15,23,42,.06);

    overflow: hidden;
}


/* =====================================================
   NOTIFICATION CARD
===================================================== */

.notification-card {

    display: flex;

    align-items: flex-start;

    gap: 15px;

    padding: 20px 22px;

    border-bottom:
        1px solid #eef2f7;

    transition: .2s;
}


.notification-card:last-child {

    border-bottom: none;
}


.notification-card:hover {

    background: #f8fafc;
}


.notification-card.unread {

    background: #eef2ff;
}


/* =====================================================
   NOTIFICATION ICON
===================================================== */

.notification-icon {

    width: 45px;

    height: 45px;

    min-width: 45px;

    border-radius: 50%;

    background: #eef2ff;

    color: #4f46e5;

    display: flex;

    align-items: center;

    justify-content: center;

    font-size: 18px;
}


/* =====================================================
   NOTIFICATION CONTENT
===================================================== */

.notification-content {

    flex: 1;

    min-width: 0;
}


.notification-title {

    font-size: 15px;

    font-weight: 700;

    margin-bottom: 5px;
}


.notification-message {

    font-size: 13px;

    color: #64748b;

    line-height: 1.5;
}


.notification-time {

    margin-top: 7px;

    color: #94a3b8;

    font-size: 11px;
}


/* =====================================================
   ACTIONS
===================================================== */

.notification-actions {

    display: flex;

    align-items: center;

    gap: 10px;
}


.read-btn {

    border:
        1px solid #e2e8f0;

    background: #ffffff;

    color: #475569;

    padding: 7px 11px;

    border-radius: 8px;

    font-size: 11px;

    cursor: pointer;

    transition: .2s;
}


.read-btn:hover {

    background: #f1f5f9;
}


.read-btn:disabled {

    opacity: .5;

    cursor: not-allowed;
}


.unread-badge {

    background: #4f46e5;

    color: #ffffff;

    padding: 4px 8px;

    border-radius: 20px;

    font-size: 10px;

    font-weight: 600;
}


.read-status {

    color: #22c55e;

    font-size: 11px;

    font-weight: 600;
}


/* =====================================================
   EMPTY STATE
===================================================== */

.empty-state {

    padding: 80px 20px;

    text-align: center;
}


.empty-icon {

    width: 75px;

    height: 75px;

    border-radius: 50%;

    background: #f1f5f9;

    color: #94a3b8;

    margin: 0 auto 15px;

    display: flex;

    align-items: center;

    justify-content: center;

    font-size: 30px;
}


.empty-state h4 {

    font-size: 17px;

    font-weight: 700;

    margin-bottom: 5px;
}


.empty-state p {

    color: #94a3b8;

    font-size: 13px;

    margin: 0;
}


/* =====================================================
   ERROR STATE
===================================================== */

.error-state .empty-icon {

    color: #ef4444;

    background: #fef2f2;
}


/* =====================================================
   RESPONSIVE
===================================================== */

@media (max-width: 900px) {

    .sidebar {

        width: 220px;
    }

    .main-content {

        padding: 20px;
    }

}


@media (max-width: 700px) {

    .sidebar {

        display: none;
    }

    .main-content {

        padding: 15px;
    }

    .page-header {

        align-items: flex-start;

        flex-direction: column;
    }

    .notification-card {

        flex-wrap: wrap;
    }

    .notification-actions {

        width: 100%;

        justify-content: flex-end;
    }

}

</style>

</head>


<body>


<div class="admin-layout">


<!-- =====================================================
     ADMIN SIDEBAR
===================================================== -->

<aside class="sidebar">


    <div class="brand-container">

        <a href="dashboard.jsp">

            <img
                src="${pageContext.request.contextPath}/images/TripNexa_logo.png"
                alt="TripNexa Logo"
                class="brand-logo-img">

        </a>

    </div>


    <ul class="nav-links">


        <li>

            <a href="dashboard.jsp">

                <span class="nav-icon">
                    📊
                </span>

                Dashboard

            </a>

        </li>


        <li>

            <a href="destinations.jsp">

                <span class="nav-icon">
                    📍
                </span>

                Destination Management

            </a>

        </li>


        <li>

            <a href="hotels.jsp">

                <span class="nav-icon">
                    🏢
                </span>

                Hotel Management

            </a>

        </li>


        <li>

            <a href="transport.jsp">

                <span class="nav-icon">
                    🚌
                </span>

                Transport Management

            </a>

        </li>


        <li>

            <a href="activity.jsp">

                <span class="nav-icon">
                    🧗
                </span>

                Activity Management

            </a>

        </li>


        <li>

            <a href="package.jsp">

                <span class="nav-icon">
                    📦
                </span>

                Package Management

            </a>

        </li>


        <li>

            <a href="myreviewsjsp.jsp">

                <span class="nav-icon">
                    ⭐
                </span>

                Review Management

            </a>

        </li>


        <li>

            <a href="admin_user.jsp">

                <span class="nav-icon">
                    👥
                </span>

                User Management

            </a>

        </li>


        <li>

            <a href="reports.jsp">

                <span class="nav-icon">
                    📈
                </span>

                Reports & Analytics

            </a>

        </li>


        <!-- =================================================
             NOTIFICATIONS
        ================================================== -->

        <li class="active">

            <a href="notification.jsp">

                <span class="nav-icon">
                    🔔
                </span>

                <span style="flex:1;">
                    Notifications
                </span>

                <span
                    id="adminNotificationCount"
                    class="admin-notification-count">

                    0

                </span>

            </a>

        </li>


        <!-- =================================================
             LOGOUT
        ================================================== -->

        <li class="logout-item">

            <a href="home.jsp">

                <span class="nav-icon">
                    🚪
                </span>

                Logout

            </a>

        </li>


    </ul>

</aside>


<!-- =====================================================
     MAIN CONTENT
===================================================== -->

<main class="main-content">


    <div class="page-header">


        <div>

            <h1 class="page-title">
                Notifications
            </h1>

            <div class="page-subtitle">

                Stay updated with user registrations
                and system activities

            </div>

        </div>


        <button
            type="button"
            class="mark-all-btn"
            id="markAllBtn">

            <i class="fa-solid fa-check-double"></i>

            Mark all as read

        </button>


    </div>


    <!-- =================================================
         NOTIFICATION LIST
    ================================================== -->

    <div
        class="notification-container"
        id="notificationContainer">


        <div class="empty-state">


            <div class="empty-icon">

                <i class="fa-solid fa-spinner fa-spin"></i>

            </div>


            <h4>
                Loading notifications...
            </h4>


            <p>
                Please wait
            </p>


        </div>


    </div>


</main>


</div>


<!-- =====================================================
     JAVASCRIPT
===================================================== -->

<script>


/* =========================================================
   BACKEND
========================================================= */

const BACKEND_URL =
    API_CONFIG.BASE_URL;


/* =========================================================
   GET ADMIN TOKEN
========================================================= */

function getAdminToken() {

    return (

        localStorage.getItem("token") ||

        sessionStorage.getItem("token") ||

        localStorage.getItem("jwtToken") ||

        sessionStorage.getItem("jwtToken") ||

        localStorage.getItem("accessToken") ||

        sessionStorage.getItem("accessToken")

    );

}


/* =========================================================
   ESCAPE HTML
========================================================= */

function escapeHtml(value) {

    const div =
        document.createElement("div");


    div.textContent =
        value == null
            ? ""
            : String(value);


    return div.innerHTML;

}


/* =========================================================
   FORMAT DATE/TIME
========================================================= */

function formatTime(value) {

    if (!value) {

        return "";

    }


    const date =
        new Date(value);


    if (
        isNaN(
            date.getTime()
        )
    ) {

        return escapeHtml(value);

    }


    return date.toLocaleString();

}


/* =========================================================
   SHOW EMPTY STATE
========================================================= */

function showEmpty(message) {

    const container =
        document.getElementById(
            "notificationContainer"
        );


    container.innerHTML = `

        <div class="empty-state">

            <div class="empty-icon">

                <i class="fa-regular fa-bell"></i>

            </div>

            <h4>
                No notifications
            </h4>

            <p>
                \${escapeHtml(
                    message ||
                    "You're all caught up!"
                )}
            </p>

        </div>

    `;

}


/* =========================================================
   SHOW ERROR
========================================================= */

function showError(message) {

    const container =
        document.getElementById(
            "notificationContainer"
        );


    container.innerHTML = `

        <div class="empty-state error-state">

            <div class="empty-icon">

                <i class="fa-solid fa-triangle-exclamation"></i>

            </div>

            <h4>
                Unable to load notifications
            </h4>

            <p>
                \${escapeHtml(message)}
            </p>

        </div>

    `;

}


/* =========================================================
   LOAD ADMIN NOTIFICATION COUNT
========================================================= */

async function loadAdminNotificationCount() {

    const token =
        getAdminToken();


    const element =
        document.getElementById(
            "adminNotificationCount"
        );


    if (!element) {

        return;

    }


    if (!token) {

        element.textContent = "0";

        element.classList.remove(
            "show"
        );

        return;

    }


    try {

        const response =
            await fetch(

                BACKEND_URL +
                "/api/notifications/admin/unread-count",

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


        const count =
            Number(
                await response.json()
            ) || 0;


        if (count > 0) {

            element.textContent =
                count > 99
                    ? "99+"
                    : count;


            element.classList.add(
                "show"
            );


        } else {

            element.textContent =
                "0";


            element.classList.remove(
                "show"
            );

        }


    } catch (error) {

        console.error(
            "Notification count error:",
            error
        );

    }

}


/* =========================================================
   LOAD ADMIN NOTIFICATIONS
========================================================= */

async function loadAdminNotifications() {

    const token =
        getAdminToken();


    if (!token) {

        showEmpty(
            "Please login as admin."
        );

        return;

    }


    try {

        const response =
            await fetch(

                BACKEND_URL +
                "/api/notifications/admin",

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


            if (
                response.status === 401 ||
                response.status === 403
            ) {

                showError(
                    "Your admin session is invalid or expired."
                );


            } else {

                showError(
                    "Server returned HTTP " +
                    response.status
                );

            }


            return;

        }


        const notifications =
            await response.json();


        renderNotifications(
            notifications
        );


    } catch (error) {

        console.error(
            "Load notifications error:",
            error
        );


        showError(
            "Cannot connect to the backend."
        );

    }

}


/* =========================================================
   RENDER NOTIFICATIONS
========================================================= */

function renderNotifications(list) {

    const container =
        document.getElementById(
            "notificationContainer"
        );


    if (
        !Array.isArray(list) ||
        list.length === 0
    ) {

        showEmpty(
            "You're all caught up!"
        );

        return;

    }


    container.innerHTML = "";


    list.forEach(
        function (notification) {


            const notificationId =
                Number(
                    notification.notificationId
                );


            const isUnread =
                !notification.read;


            const card =
                document.createElement(
                    "div"
                );


            card.className =
                "notification-card" +
                (
                    isUnread
                        ? " unread"
                        : ""
                );


            const title =
                escapeHtml(
                    notification.title ||
                    "Notification"
                );


            const message =
                escapeHtml(
                    notification.message ||
                    ""
                );


            const createdAt =
                formatTime(
                    notification.createdAt
                );


            let actionHtml = "";


            /* -----------------------------------------
               UNREAD
            ------------------------------------------ */

            if (isUnread) {

                actionHtml = `

                    <span class="unread-badge">

                        UNREAD

                    </span>


                    <button
                        type="button"
                        class="read-btn"
                        onclick="markAdminNotificationAsRead(\${notificationId})">

                        <i class="fa-solid fa-check"></i>

                        Read

                    </button>

                `;


            }


            /* -----------------------------------------
               READ
            ------------------------------------------ */

            else {

                actionHtml = `

                    <span class="read-status">

                        <i class="fa-solid fa-check"></i>

                        Read

                    </span>

                `;

            }


            /* -----------------------------------------
               CARD

               IMPORTANT:

               \${...} is escaped with a backslash
               so JSP does NOT interpret it.

            ------------------------------------------ */

            card.innerHTML = `

                <div class="notification-icon">

                    <i class="fa-regular fa-bell"></i>

                </div>


                <div class="notification-content">

                    <div class="notification-title">

                        \${title}

                    </div>


                    <div class="notification-message">

                        \${message}

                    </div>


                    <div class="notification-time">

                        \${createdAt}

                    </div>

                </div>


                <div class="notification-actions">

                    \${actionHtml}

                </div>

            `;


            container.appendChild(
                card
            );


        }
    );

}


/* =========================================================
   MARK ONE NOTIFICATION AS READ
========================================================= */

async function markAdminNotificationAsRead(
    notificationId
) {


    const token =
        getAdminToken();


    if (!token) {

        alert(
            "Admin login session not found."
        );

        return;

    }


    try {


        const response =
            await fetch(

                BACKEND_URL +
                "/api/notifications/admin/" +
                notificationId +
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

            alert(
                "Unable to mark notification as read."
            );

            return;

        }


        /* Refresh notification list */

        await loadAdminNotifications();


        /* Refresh sidebar badge */

        await loadAdminNotificationCount();


        /*
         * If sidebar.jsp exposes the function,
         * refresh that badge too.
         */

        if (
            typeof window.loadAdminNotificationCount ===
            "function"
        ) {

            await window.loadAdminNotificationCount();

        }


    } catch (error) {

        console.error(
            "Mark notification read error:",
            error
        );


        alert(
            "Cannot connect to the backend."
        );

    }

}


/* =========================================================
   MARK ALL AS READ
========================================================= */

async function markAllAdminNotificationsAsRead() {


    const token =
        getAdminToken();


    if (!token) {

        alert(
            "Admin login session not found."
        );

        return;

    }


    const button =
        document.getElementById(
            "markAllBtn"
        );


    button.disabled = true;


    try {


        const response =
            await fetch(

                BACKEND_URL +
                "/api/notifications/admin/read-all",

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

            alert(
                "Unable to mark all notifications as read."
            );

            return;

        }


        /* Refresh notification list */

        await loadAdminNotifications();


        /* Refresh this page badge */

        await loadAdminNotificationCount();


        /* Refresh sidebar badge */

        if (
            typeof window.loadAdminNotificationCount ===
            "function"
        ) {

            await window.loadAdminNotificationCount();

        }


    } catch (error) {

        console.error(
            "Mark all notifications error:",
            error
        );


        alert(
            "Cannot connect to the backend."
        );


    } finally {

        button.disabled = false;

    }

}


/* =========================================================
   MARK ALL BUTTON
========================================================= */

document
    .getElementById(
        "markAllBtn"
    )
    .addEventListener(
        "click",
        markAllAdminNotificationsAsRead
    );


/* =========================================================
   INITIAL LOAD
========================================================= */

loadAdminNotifications();

loadAdminNotificationCount();


/* =========================================================
   REFRESH BADGE EVERY 10 SECONDS
========================================================= */

setInterval(
    loadAdminNotificationCount,
    10000
);


/* =========================================================
   REFRESH NOTIFICATION LIST EVERY 10 SECONDS
========================================================= */

setInterval(
    loadAdminNotifications,
    10000
);


</script>


</body>

</html>
