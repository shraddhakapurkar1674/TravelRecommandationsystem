document.addEventListener("DOMContentLoaded", function () {
    loadDashboardStats();
    loadGreeting();
    loadRecentDestinations();
    loadAdminNotifications();

    if (document.getElementById("topNotificationBtn")) {
        document.getElementById("topNotificationBtn").addEventListener("click", function () {
            window.location.href = "notification.jsp";
        });
    }
});

/* =========================================================
   BACKEND BASE URL (same host used everywhere else in the app)
   ========================================================= */
const ADMIN_BACKEND = API_CONFIG.BASE_URL;

/**
 * Greets the logged-in admin using their real name/time-of-day.
 */
function loadGreeting() {
    const name = localStorage.getItem("userName") || sessionStorage.getItem("userName") || "Admin";
    setSafeText("adminNameLabel", name);

    const hour = new Date().getHours();
    let greeting = "Good Morning";
    if (hour >= 12 && hour < 17) greeting = "Good Afternoon";
    else if (hour >= 17) greeting = "Good Evening";

    const emoji = hour < 12 ? "☀️" : (hour < 17 ? "🌤️" : "🌙");
    const heroEl = document.getElementById("heroGreeting");
    if (heroEl) {
        heroEl.innerHTML = greeting + ", " + escapeHtmlDb(name) + " <span>" + emoji + "</span>";
    }
}

function escapeHtmlDb(value) {
    if (value === null || value === undefined) return "";
    return String(value)
        .replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;").replace(/'/g, "&#039;");
}

/**
 * Builds the "Top Destinations Overview" bar chart (Views only - no bookings).
 */
let topDestChartInstance = null;
function renderTopDestinationsChart(topDestinations) {
    const canvas = document.getElementById("topDestinationsChart");
    if (!canvas || typeof Chart === "undefined") return;

    const items = (topDestinations || []).slice(0, 6);
    const labels = items.map(i => i.name || "N/A");
    const views = items.map(i => Number(i.views) || 0);

    if (topDestChartInstance) {
        topDestChartInstance.destroy();
    }

    topDestChartInstance = new Chart(canvas.getContext("2d"), {
        type: "bar",
        data: {
            labels: labels,
            datasets: [
                {
                    label: "Views",
                    data: views,
                    backgroundColor: "rgba(99, 70, 246, 0.75)",
                    borderRadius: 8
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { position: "bottom", labels: { boxWidth: 10, font: { size: 11 } } } },
            scales: {
                x: { grid: { display: false } },
                y: { beginAtZero: true, grid: { color: "#f1f5f9" } }
            }
        }
    });
}

/**
 * Loads all destinations, renders the "Recently Added Destinations" table
 * AND builds the category breakdown donut chart from the same data.
 */
function loadRecentDestinations() {
    fetch(ADMIN_BACKEND + "/api/destinations")
        .then(res => res.json())
        .then(result => {
            const list = (result && result.data) ? result.data : (Array.isArray(result) ? result : []);
            renderRecentDestinationsTable(list);
            renderCategoryDonut(list);
        })
        .catch(err => {
            console.error("Error loading destinations:", err);
            const tbody = document.getElementById("recentDestinationsTable");
            if (tbody) tbody.innerHTML = `<tr><td colspan="6" class="text-center text-muted">Unable to load destinations</td></tr>`;
        });
}

function renderRecentDestinationsTable(list) {
    const tbody = document.getElementById("recentDestinationsTable");
    if (!tbody) return;

    const sorted = [...list].sort((a, b) => (b.id || 0) - (a.id || 0)).slice(0, 5);

    if (sorted.length === 0) {
        tbody.innerHTML = `<tr><td colspan="6" class="text-center text-muted">No destinations found</td></tr>`;
        return;
    }

    tbody.innerHTML = sorted.map(d => {
        const img = resolveDestinationImage(d.image);
        const status = (d.status || "Active");
        const badgeClass = status.toLowerCase() === "active" ? "dest-status-active" : "dest-status-inactive";
        return `
            <tr>
                <td><img src="${img}" class="dest-thumb" onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=80';"></td>
                <td class="fw-bold">${escapeHtmlDb(d.destinationName)}</td>
                <td>${escapeHtmlDb(d.state)}${d.state && d.country ? ", " : ""}${escapeHtmlDb(d.country)}</td>
                <td>${escapeHtmlDb(d.category)}</td>
                <td><span class="${badgeClass}">${escapeHtmlDb(status)}</span></td>
                <td>
                    <a class="dest-action-btn" href="destinations.jsp?edit=${d.id}" title="Edit"><i class="fas fa-pen"></i></a>
                    <a class="dest-action-btn" href="destination-details.jsp?id=${d.id}" title="View"><i class="fas fa-eye"></i></a>
                </td>
            </tr>`;
    }).join("");
}

/**
 * Resolves a destination image filename to the backend's real
 * upload-serving endpoint.
 */
function resolveDestinationImage(imageName) {
    if (!imageName || String(imageName).trim() === "" || String(imageName).toLowerCase() === "null") {
        return "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=80";
    }
    const value = String(imageName).trim();
    if (value.startsWith("http://") || value.startsWith("https://")) return value;
    return ADMIN_BACKEND + "/api/destinations/images/" + encodeURIComponent(value);
}

/**
 * Builds the category-breakdown donut chart + legend from the
 * real destinations list (grouped client-side by the "category" field).
 */
let categoryDonutInstance = null;
function renderCategoryDonut(list) {
    const canvas = document.getElementById("categoryDonutChart");
    if (!canvas || typeof Chart === "undefined") return;

    const counts = {};
    list.forEach(d => {
        const cat = (d.category && d.category.trim()) ? d.category.trim() : "Other";
        counts[cat] = (counts[cat] || 0) + 1;
    });

    const total = list.length;
    setSafeText("donutTotalCount", total);

    const palette = ["#4f46e5", "#22c55e", "#ec4899", "#f97316", "#06b6d4", "#a855f7", "#eab308"];
    const entries = Object.entries(counts).sort((a, b) => b[1] - a[1]).slice(0, 7);

    if (categoryDonutInstance) categoryDonutInstance.destroy();

    categoryDonutInstance = new Chart(canvas.getContext("2d"), {
        type: "doughnut",
        data: {
            labels: entries.map(e => e[0]),
            datasets: [{
                data: entries.map(e => e[1]),
                backgroundColor: entries.map((_, i) => palette[i % palette.length]),
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: "72%",
            plugins: { legend: { display: false }, tooltip: { enabled: true } }
        }
    });

    const legend = document.getElementById("donutLegend");
    if (legend) {
        legend.innerHTML = entries.map((e, i) => {
            const pct = total > 0 ? Math.round((e[1] / total) * 100) : 0;
            return `<div class="donut-legend-item">
                        <span><span class="dot" style="background:${palette[i % palette.length]}"></span>${escapeHtmlDb(e[0])}</span>
                        <strong>${pct}%</strong>
                    </div>`;
        }).join("");
    }

    if (entries.length > 0) {
        const top = entries[0];
        const tipBox = document.getElementById("growthTipBox");
        const tipText = document.getElementById("growthTipText");
        if (tipBox && tipText) {
            tipBox.style.display = "flex";
            tipText.innerHTML = `<strong>${escapeHtmlDb(top[0])}</strong> destinations lead your catalog with ${top[1]} of ${total} entries. Consider adding more ${escapeHtmlDb(top[0]).toLowerCase()} content.`;
        }
    }
}

/**
 * Loads the real admin notification feed and its unread count.
 */
function loadAdminNotifications() {
    fetch(ADMIN_BACKEND + "/api/notifications/admin")
        .then(res => res.json())
        .then(list => renderAdminNotifList(Array.isArray(list) ? list : []))
        .catch(err => {
            console.error("Error loading admin notifications:", err);
            const el = document.getElementById("adminNotifList");
            if (el) el.innerHTML = `<small class="text-muted">Unable to load notifications</small>`;
        });

    fetch(ADMIN_BACKEND + "/api/notifications/admin/unread-count")
        .then(res => res.json())
        .then(count => {
            const badge = document.getElementById("topNotifBadge");
            const n = Number(count) || 0;
            if (badge) {
                badge.style.display = n > 0 ? "inline-block" : "none";
                badge.textContent = n > 99 ? "99+" : n;
            }
        })
        .catch(err => console.error("Error loading unread count:", err));
}

function renderAdminNotifList(list) {
    const container = document.getElementById("adminNotifList");
    if (!container) return;

    if (list.length === 0) {
        container.innerHTML = `<small class="text-muted">No notifications yet</small>`;
        return;
    }

    const iconMap = {
        NEW_DESTINATION: "fa-map-marker-alt",
        NEW_HOTEL: "fa-hotel",
        NEW_TRANSPORT: "fa-bus",
        NEW_PACKAGE: "fa-suitcase",
        NEW_REVIEW: "fa-star",
        NEW_USER: "fa-user-plus"
    };

    container.innerHTML = list.slice(0, 6).map(n => {
        const icon = iconMap[n.notificationType] || "fa-bell";
        const time = n.createdAt ? formatRelativeTime(n.createdAt) : "";
        return `
            <div class="admin-notif-item ${n.read ? "" : "unread"}">
                <div class="admin-notif-icon"><i class="fas ${icon}"></i></div>
                <div class="flex-grow-1">
                    <p class="admin-notif-title">${escapeHtmlDb(n.title || "Notification")}</p>
                    <p class="admin-notif-msg">${escapeHtmlDb(n.message || "")}</p>
                    <span class="admin-notif-time">${escapeHtmlDb(time)}</span>
                </div>
            </div>`;
    }).join("");
}

function formatRelativeTime(dateStr) {
    try {
        const then = new Date(dateStr);
        const diffMs = Date.now() - then.getTime();
        const mins = Math.floor(diffMs / 60000);
        if (mins < 1) return "Just now";
        if (mins < 60) return mins + " min ago";
        const hrs = Math.floor(mins / 60);
        if (hrs < 24) return hrs + " hour" + (hrs > 1 ? "s" : "") + " ago";
        const days = Math.floor(hrs / 24);
        return days + " day" + (days > 1 ? "s" : "") + " ago";
    } catch (e) {
        return "";
    }
}

function loadDashboardStats() {
    const backendUrl = API_CONFIG.api("/api/admin/dashboard/stats");

    fetch(backendUrl)
        .then(response => {
            if (!response.ok) throw new Error("HTTP Status: " + response.status);
            return response.json();
        })
        .then(data => {
            console.log("Dashboard data fetched successfully:", data);

            // 1. Render Metrics Counter Cards
            setSafeText("totalUsers", data.totalUsers);
            setSafeText("totalDestinations", data.totalDestinations);
            setSafeText("totalHotels", data.totalHotels);
            setSafeText("totalTransport", data.totalTransport);
            setSafeText("totalActivities", data.totalActivities);
            setSafeText("totalReviews", data.totalReviews);

            // 2. Render Booking Summary Counters (harmless if the elements do not exist)
            setSafeText("totalBookings", data.totalBookings);
            setSafeText("confirmedBookings", data.confirmedBookings);
            setSafeText("pendingBookings", data.pendingBookings);

            // 3. Render Top Ranking Lists (with the images you uploaded, no booking numbers)
            renderRankingList("topDestinationsContainer", data.topDestinations, "views", "destination");
            renderRankingList("topHotelsContainer", data.topHotels, "", "hotel");
            renderRankingList("topTransportContainer", data.topTransport, "", "transport");
            renderRankingList("topActivitiesContainer", data.topActivities, "", "activity");

            // 3b. Chart built from the same topDestinations array
            renderTopDestinationsChart(data.topDestinations);

            // 4. Render Feeds and Tables
            renderReviews("recentReviewsContainer", data.recentReviews);
            renderUsers("recentUsersContainer", data.recentUsers);
            renderBookingsTable("latestBookingsTable", data.latestBookings);
        })
        .catch(err => {
            console.error("Error connecting to the dashboard API:", err);
        });
}

/**
 * Safely populates text inside an HTML element by ID
 */
function setSafeText(id, value) {
    const el = document.getElementById(id);
    if (el) {
        el.innerText = (value !== undefined && value !== null) ? value : "0";
    }
}

/**
 * Resolves images stored in 'src/main/webapp/images/' (used for review avatars)
 */
function resolveImageUrl(imageName) {
    if (!imageName || imageName.trim() === "" || imageName.toLowerCase() === "null") {
        return "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=80"; // Fallback placeholder image
    }

    // If image is already a full URL, return it directly
    if (imageName.startsWith("http://") || imageName.startsWith("https://")) {
        return imageName;
    }

    // Points to the local images directory under webapp
    return "images/" + imageName;
}

/**
 * Resolves the image you uploaded for a Top item to the backend endpoint that serves it.
 * Works on localhost:8080 and on tripnexa.co.in because it always builds from API_CONFIG.
 */
const TOP_IMG_VER = "?v=" + Date.now();   // shows a replaced image fresh on every load
function resolveTopItemImage(type, imageName) {
    const placeholder = "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=80";
    if (!imageName || String(imageName).trim() === "" || String(imageName).toLowerCase() === "null") {
        return placeholder;
    }
    let value = String(imageName).trim().replace(/\\/g, "/");
    if (/^(https?:|data:|blob:)/i.test(value)) return value;

    const fileName = value.substring(value.lastIndexOf("/") + 1);

    if (type === "hotel")     return API_CONFIG.hotelImage(fileName) + TOP_IMG_VER;
    if (type === "transport") return API_CONFIG.transportImage(fileName) + TOP_IMG_VER;
    if (type === "activity")  return API_CONFIG.BASE_URL + "/images/" + encodeURIComponent(fileName) + TOP_IMG_VER;
    return API_CONFIG.destinationImage(fileName) + TOP_IMG_VER;   // destination (default)
}

/**
 * Renders Top 5 cards for Destinations, Hotels, Transport, and Activities
 */
function renderRankingList(containerId, items, subMetricKey, imageType) {
    const container = document.getElementById(containerId);
    if (!container) return;
    container.innerHTML = "";

    if (!items || items.length === 0) {
        container.innerHTML = `<small class="text-muted">No data available</small>`;
        return;
    }

    items.slice(0, 5).forEach((item, idx) => {
        const subText = (subMetricKey && item[subMetricKey]) ? `${item[subMetricKey]} ${subMetricKey}` : '';
        const imgUrl = resolveTopItemImage(imageType, item.imageUrl);

        container.innerHTML += `
            <div class="d-flex align-items-center justify-content-between py-1">
                <div class="d-flex align-items-center gap-2">
                    <span class="ranking-badge">${idx + 1}</span>
                    <img src="${imgUrl}" 
                         class="item-thumb" 
                         alt="${item.name}" 
                         onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=80';">
                    <div>
                        <h6 class="item-title">${item.name}</h6>
                    </div>
                </div>
                <div class="text-end">
                    <small class="text-warning fw-bold" style="font-size:0.72rem;">★ ${item.rating || '4.5'}</small>
                    <div class="text-muted" style="font-size:0.68rem;">${subText}</div>
                </div>
            </div>`;
    });
}

/**
 * Renders Recent Reviews Feed
 */
function renderReviews(containerId, reviews) {
    const container = document.getElementById(containerId);
    if (!container) return;
    container.innerHTML = "";

    if (!reviews || reviews.length === 0) {
        container.innerHTML = `<small class="text-muted">No reviews available</small>`;
        return;
    }

    reviews.slice(0, 5).forEach(rev => {
        const avatarUrl = resolveImageUrl(rev.userAvatar);
        container.innerHTML += `
            <div class="d-flex gap-2 py-1">
                <img src="${avatarUrl}" 
                     class="rounded-circle item-thumb" 
                     onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=80';">
                <div class="flex-grow-1">
                    <div class="d-flex justify-content-between align-items-center">
                        <strong style="font-size:0.78rem;">${rev.user || 'Anonymous'}</strong>
                        <span class="text-muted" style="font-size:0.68rem;">${rev.date || ''}</span>
                    </div>
                    <small class="text-primary d-block" style="font-size:0.7rem;">${rev.location || ''}</small>
                    <p class="text-secondary mb-0" style="font-size:0.72rem; line-height:1.3;">"${rev.comment || ''}"</p>
                </div>
            </div>`;
    });
}

/**
 * Renders Recent Registered Users List
 */
function renderUsers(containerId, users) {
    const container = document.getElementById(containerId);
    if (!container) return;
    container.innerHTML = "";

    if (!users || users.length === 0) {
        container.innerHTML = `<small class="text-muted">No users found</small>`;
        return;
    }

    users.slice(0, 5).forEach(u => {
        const initial = u.name ? u.name.charAt(0).toUpperCase() : "U";
        container.innerHTML += `
            <div class="d-flex align-items-center justify-content-between py-1">
                <div class="d-flex align-items-center gap-2">
                    <div class="user-avatar-initial">${initial}</div>
                    <div>
                        <h6 class="item-title">${u.name}</h6>
                        <small class="text-muted" style="font-size:0.68rem;">${u.email}</small>
                    </div>
                </div>
                <small class="text-muted" style="font-size:0.68rem;">${u.date || ''}</small>
            </div>`;
    });
}

/**
 * Latest Bookings Table (kept so nothing breaks; the table does not exist on your dashboard)
 */
function renderBookingsTable(tableBodyId, bookings) {
    const tableBody = document.getElementById(tableBodyId);
    if (!tableBody) return;
    tableBody.innerHTML = "";

    if (!bookings || bookings.length === 0) {
        tableBody.innerHTML = `<tr><td colspan="6" class="text-center text-muted">No bookings found</td></tr>`;
        return;
    }

    bookings.slice(0, 5).forEach(b => {
        const isConfirmed = (b.status || "").toLowerCase() === "confirmed";
        const badgeClass = isConfirmed ? "badge-confirmed" : "badge-pending";

        tableBody.innerHTML += `
            <tr>
                <td><strong>${b.id}</strong></td>
                <td>${b.user}</td>
                <td>${b.destination}</td>
                <td>${b.date}</td>
                <td class="fw-bold">₹${b.amount}</td>
                <td><span class="status-badge-soft ${badgeClass}">${b.status}</span></td>
            </tr>`;
    });
}