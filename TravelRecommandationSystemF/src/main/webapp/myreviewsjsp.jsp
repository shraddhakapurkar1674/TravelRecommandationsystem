<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trip Netra - My Reviews</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/recommendations.css?v=11">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/myreviews.css?v=11">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- FontAwesome for modern icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        /* Modern Attractive Delete Button */
        .btn-delete-modern {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            color: #ffffff;
            border: none;
            padding: 8px 16px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            transition: all 0.25s ease;
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.25);
        }
        .btn-delete-modern:hover {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(239, 68, 68, 0.35);
        }
        .btn-delete-modern:active {
            transform: translateY(0);
        }
    </style>
</head>
<body>

<div class="dashboard-container">
    <!-- RIGHT SIDE / SIDEBAR: Dynamic Sidebar based on User Role -->
    <aside class="recommendation-sidebar">
        <div id="adminSidebar" class="hidden">
            <jsp:include page="sidebar.jsp" />
        </div>
        <div id="userSidebar" class="hidden">
            <jsp:include page="sidebaruser.jsp" />
        </div>
    </aside>

    <!-- LEFT SIDE: Main Content -->
    <main class="recommendation-main">

        <!-- ================= ADMIN VIEW ================= -->
        <div id="adminView" class="hidden">
            <section class="recommendation-hero">
                <div class="hero-content">
                    <span class="hero-badge">✨ TRIP NETRA ADMIN</span>
                    <h1>All Users Reviews</h1>
                    <p>Manage and moderate reviews posted across all destinations.</p>
                </div>
                <div class="hero-icon"><i class="fa-solid fa-shield-halved"></i></div>
            </section>

            <section class="results-section">
                <div class="results-header">
                    <div>
                        <h2>Admin Panel - All Reviews</h2>
                        <p>Review and moderate user submissions.</p>
                    </div>
                </div>
                <div id="adminReviewsContainer" class="destination-grid">
                    <p class="text-muted-custom">Loading all reviews...</p>
                </div>
            </section>
        </div>

        <!-- ================= USER VIEW ================= -->
        <div id="userView" class="hidden">
            <!-- HERO -->
            <section class="recommendation-hero">
                <div class="hero-content">
                    <span class="hero-badge">✨ TRIP NETRA</span>
                    <h1>My Destination Reviews</h1>
                    <p>Manage and share your personal travel experiences and ratings.</p>
                </div>
                <div class="hero-icon"><i class="fa-solid fa-star"></i></div>
            </section>

            <!-- ADD REVIEW FORM CARD -->
            <section class="filter-card">
                <div class="filter-title">
                    <span class="filter-icon">✍️</span>
                    <div>
                        <h2>Write a New Review</h2>
                        <p>Select a destination, rate your trip, and share your feedback.</p>
                    </div>
                </div>

                <form id="userReviewForm" class="personalized-form">
                    <div class="personalized-field input-group">
                        <label>Destination Name</label>
                        <select id="destinationSelect" required>
                            <option value="" selected disabled>-- Choose Destination --</option>
                        </select>
                    </div>

                    <div class="personalized-field input-group">
                        <label>Rating (1 to 5 Stars)</label>
                        <select id="rating" required>
                            <option value="5">⭐⭐⭐⭐⭐ (5 - Excellent)</option>
                            <option value="4">⭐⭐⭐⭐ (4 - Very Good)</option>
                            <option value="3">⭐⭐⭐ (3 - Good)</option>
                            <option value="2">⭐⭐ (2 - Fair)</option>
                            <option value="1">⭐ (1 - Poor)</option>
                        </select>
                    </div>

                    <div class="personalized-field input-group" style="grid-column: 1 / -1;">
                        <label>Your Feedback / Comment</label>
                        <textarea id="comment" rows="3" placeholder="Write your experience..." required style="width: 100%; padding: 12px; border: 1px solid rgba(148,163,184,.45); border-radius: 12px; background: rgba(255,255,255,.75); font-family: inherit; font-size: 13px; outline: none;"></textarea>
                    </div>

                    <div class="personalized-button-wrapper">
                        <button type="submit" class="primary-button">
                            <i class="fa-solid fa-rocket"></i> Submit Review
                        </button>
                    </div>
                </form>
            </section>

            <!-- REVIEWS RESULTS SECTION -->
            <section class="results-section">
                <div class="results-header">
                    <div>
                        <h2>Your Submitted Reviews</h2>
                        <p>All reviews you have posted across different destinations.</p>
                    </div>
                    <span id="review-count" class="result-count">0 reviews</span>
                </div>

                <div id="review-loading" class="state-box hidden">
                    <div class="loader"></div>
                    <h3>Loading reviews...</h3>
                    <p>Please wait while we fetch your feedback.</p>
                </div>

                <div id="review-empty" class="state-box hidden">
                    <div class="state-icon">📝</div>
                    <h3>No reviews found</h3>
                    <p>You haven't submitted any reviews yet. Use the form above to add one!</p>
                </div>

                <div id="myReviewsContainer" class="destination-grid">
                    <p class="text-muted-custom">Loading your reviews...</p>
                </div>
            </section>
        </div>

    </main>
</div>

<!-- Modern Toast Notification Container -->
<div id="toastContainer" class="position-fixed bottom-0 end-0 p-3" style="z-index: 1080;"></div>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>!-- JavaScript Logic -->
<!-- JavaScript Logic -->
<script>
    let destinationMap = {};

    /* ---------- Login info (reads localStorage first, then sessionStorage) ---------- */
    function getStored(key) {
        return localStorage.getItem(key) || sessionStorage.getItem(key);
    }

    function isAdminRole(role) {
        const r = String(role || "").toUpperCase();
        return r === "ADMIN" || r === "ROLE_ADMIN";
    }

    // Only adds the Authorization header when a token really exists
    function buildHeaders(token, withJson) {
        const headers = {};
        if (withJson) headers["Content-Type"] = "application/json";
        if (token) headers["Authorization"] = "Bearer " + token;
        return headers;
    }

    function escapeHtml(value) {
        if (value === null || value === undefined) return "";
        return String(value)
            .replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;").replace(/'/g, "&#039;");
    }

    function formatReviewDate(value) {
        if (!value) return "";
        const d = new Date(value);
        if (isNaN(d.getTime())) return "";
        return d.toLocaleDateString("en-IN", { day: "2-digit", month: "short", year: "numeric" });
    }

    document.addEventListener("DOMContentLoaded", function () {
        const role = getStored("userRole");
        const userId = getStored("userId");
        const token = getStored("token") || getStored("jwtToken") || getStored("accessToken");

        // Only the user id is required to open this page
        if (!userId) {
            showToast("Please login first!", "danger");
            setTimeout(() => { window.location.href = "login.jsp"; }, 1500);
            return;
        }

        loadDestinationsData().then(() => {
            if (isAdminRole(role)) {
                document.getElementById("adminView").classList.remove("hidden");
                document.getElementById("adminSidebar").classList.remove("hidden");
                loadAdminReviews(token);
            } else {
                document.getElementById("userView").classList.remove("hidden");
                document.getElementById("userSidebar").classList.remove("hidden");
                loadUserReviews(userId, token);
                setupReviewForm(userId, token);
            }
        });
    });

    // Modern Toast Notification Function with FontAwesome Icons
    function showToast(message, type = 'success') {
        const container = document.getElementById("toastContainer");
        const toastId = 'toast_' + Date.now();
        const bgClass = type === 'success' ? 'bg-success text-white shadow-lg' : 'bg-danger text-white shadow-lg';
        const iconClass = type === 'success' ? 'fa-circle-check' : 'fa-circle-exclamation';

        const toastHTML = `
            <div id="\${toastId}" class="toast align-items-center \${bgClass} border-0 mb-3 rounded-3" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex p-2 align-items-center">
                    <div class="toast-body fw-semibold fs-6">
                        <i class="fa-solid \${iconClass} me-2"></i> \${message}
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            </div>
        `;
        container.insertAdjacentHTML('beforeend', toastHTML);
        const toastElement = document.getElementById(toastId);
        const bsToast = new bootstrap.Toast(toastElement, { delay: 3500 });
        bsToast.show();

        toastElement.addEventListener('hidden.bs.toast', () => {
            toastElement.remove();
        });
    }

    // Fetch destinations and build map + populate dropdown
    function loadDestinationsData() {
        return fetch(API_CONFIG.api("/api/destinations"))
            .then(res => res.json())
            .then(data => {
                const select = document.getElementById("destinationSelect");
                if (select) select.innerHTML = `<option value="" selected disabled>-- Choose Destination --</option>`;

                let destinations = [];
                if (Array.isArray(data)) {
                    destinations = data;
                } else if (data.data && Array.isArray(data.data)) {
                    destinations = data.data;
                } else if (data.destinations && Array.isArray(data.destinations)) {
                    destinations = data.destinations;
                }

                if (destinations.length > 0) {
                    destinations.forEach(dest => {
                        let destId = dest.id || dest.destinationId;
                        let destName = dest.destinationName || dest.name || dest.title;

                        if (destId && destName) {
                            destinationMap[destId] = destName;
                            destinationMap[String(destId)] = destName;
                        }

                        if (select) {
                            let opt = document.createElement("option");
                            opt.value = destId;
                            opt.textContent = destName;
                            select.appendChild(opt);
                        }
                    });
                }
            })
            .catch(err => {
                console.error("Error loading destinations:", err);
            });
    }

    function getDestinationName(rev) {
        let destId = rev.destinationId || rev.destination_id || (rev.destination ? (rev.destination.id || rev.destination.destinationId) : null);
        let nestedName = rev.destination ? (rev.destination.destinationName || rev.destination.name || rev.destination.title) : null;

        return nestedName ||
               rev.destinationName ||
               rev.destination_name ||
               destinationMap[destId] ||
               destinationMap[String(destId)] ||
               ("Destination ID: " + (destId || "Unknown"));
    }

    function makeStars(rating) {
        const r = Math.max(0, Math.min(5, parseInt(rating) || 0));
        return "★".repeat(r) + "☆".repeat(5 - r);
    }

    // ADMIN: load ALL reviews of ALL users
    function loadAdminReviews(token) {
        fetch(API_CONFIG.api("/api/reviews/admin/all"), {
            method: "GET",
            headers: buildHeaders(token, false)
        })
        .then(res => res.json())
        .then(response => {
            const container = document.getElementById("adminReviewsContainer");
            container.innerHTML = "";
            let reviews = response.data || response;

            if (Array.isArray(reviews) && reviews.length > 0) {
                reviews.forEach(rev => {
                    let reviewId = rev.reviewId || rev.id;
                    let stars = makeStars(rev.rating);
                    let destName = getDestinationName(rev);
                    let userName = rev.userName || rev.user_name || ("User ID: " + (rev.userId || rev.user_id));
                    let dateText = formatReviewDate(rev.createdAt);

                    container.innerHTML += `
                        <div class="destination-card p-4 h-100 d-flex flex-column justify-content-between" style="padding: 22px;">
                            <div>
                                <div class="d-flex justify-content-between align-items-center mb-2" style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
                                    <span class="match-pill" style="position:static; padding:4px 10px; font-size:11px;">\${escapeHtml(userName)}</span>
                                    <span class="review-stars" style="color:#d97706; font-size:14px; font-weight:700;">\${stars}</span>
                                </div>
                                <h3 class="recommendation-destination-name" style="font-size:18px; margin-bottom:10px;">\${escapeHtml(destName)}</h3>
                                <p style="color:#334155; font-size:13px; line-height:1.6; margin-bottom:10px;">"\${escapeHtml(rev.comment)}"</p>
                                <small style="color:#94a3b8; font-size:11px;">\${dateText}</small>
                            </div>
                            <div style="margin-top:15px;">
                                <button class="btn-delete-modern" onclick="deleteReview(\${reviewId})">
                                    <i class="fa-solid fa-trash-can"></i> Delete Review
                                </button>
                            </div>
                        </div>
                    `;
                });
            } else {
                container.innerHTML = `<p class="text-muted-custom">No reviews found in database.</p>`;
            }
        })
        .catch(err => {
            console.error("Error loading admin reviews:", err);
            document.getElementById("adminReviewsContainer").innerHTML =
                `<p class="text-muted-custom">Unable to load reviews. Please check that the backend (api) is running.</p>`;
        });
    }

    // USER: load only this user's own reviews
    function loadUserReviews(userId, token) {
        fetch(API_CONFIG.api("/api/reviews/user/" + userId), {
            method: "GET",
            headers: buildHeaders(token, false)
        })
        .then(res => res.json())
        .then(response => {
            const container = document.getElementById("myReviewsContainer");
            container.innerHTML = "";
            let reviews = response.data || response;
            const countBadge = document.getElementById("review-count");

            if (Array.isArray(reviews) && reviews.length > 0) {
                if (countBadge) countBadge.textContent = reviews.length + " reviews";
                reviews.forEach(rev => {
                    let stars = makeStars(rev.rating);
                    let destName = getDestinationName(rev);
                    let dateText = formatReviewDate(rev.createdAt);

                    container.innerHTML += `
                        <div class="destination-card p-4 h-100 d-flex flex-column justify-content-between" style="padding: 22px;">
                            <div>
                                <div class="d-flex justify-content-between align-items-center mb-2" style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
                                    <h3 class="recommendation-destination-name" style="font-size:18px; margin-bottom:0;">\${escapeHtml(destName)}</h3>
                                    <span class="review-stars" style="color:#d97706; font-size:14px; font-weight:700;">\${stars}</span>
                                </div>
                                <p style="color:#334155; font-size:13px; line-height:1.6; margin-top:10px; margin-bottom:10px;">"\${escapeHtml(rev.comment)}"</p>
                                <small style="color:#94a3b8; font-size:11px;">\${dateText}</small>
                            </div>
                        </div>
                    `;
                });
            } else {
                if (countBadge) countBadge.textContent = "0 reviews";
                container.innerHTML = `<p class="text-muted-custom">You haven't posted any reviews yet.</p>`;
            }
        })
        .catch(err => {
            console.error("Error loading user reviews:", err);
            document.getElementById("myReviewsContainer").innerHTML =
                `<p class="text-muted-custom">Unable to load your reviews. Please check that the backend (api) is running.</p>`;
        });
    }

    // USER: submit a new review
    function setupReviewForm(userId, token) {
        document.getElementById("userReviewForm").addEventListener("submit", function (e) {
            e.preventDefault();

            const destValue = document.getElementById("destinationSelect").value;
            if (!destValue) {
                showToast("Please choose a destination.", "danger");
                return;
            }

            const reviewData = {
                userId: parseInt(userId),
                destinationId: parseInt(destValue),
                rating: parseInt(document.getElementById("rating").value),
                comment: document.getElementById("comment").value.trim()
            };

            fetch(API_CONFIG.api("/api/reviews"), {
                method: "POST",
                headers: buildHeaders(token, true),
                body: JSON.stringify(reviewData)
            })
            .then(res => res.json())
            .then(data => {
                if (data.success || data.id) {
                    showToast("Review submitted successfully!", "success");
                    setTimeout(() => { location.reload(); }, 1200);
                } else {
                    showToast("Failed to submit review: " + (data.message || "Unknown error"), "danger");
                }
            })
            .catch(err => {
                console.error("Error submitting review:", err);
                showToast("Error connecting to server.", "danger");
            });
        });
    }

    // ADMIN: delete a review
    async function deleteReview(id) {
        if (!confirm("Are you sure you want to delete this review?")) return;
        const token = getStored("token") || getStored("jwtToken") || getStored("accessToken");

        try {
            const res = await fetch(API_CONFIG.api("/api/reviews/admin/" + id), {
                method: "DELETE",
                headers: buildHeaders(token, true)
            });

            const data = await res.json();

            if (res.ok && data.success) {
                showToast("Review deleted successfully!", "success");
                setTimeout(() => { location.reload(); }, 1200);
            } else {
                showToast("Failed to delete review: " + (data.message || "Server error"), "danger");
            }
        } catch (err) {
            console.error("Network or parsing error during delete:", err);
            showToast("Error connecting to server while deleting review.", "danger");
        }
    }
</script>

</body>
</html>
