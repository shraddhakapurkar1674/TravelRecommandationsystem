<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TripNexa Admin Dashboard</title>

    <!-- Bootstrap 5 & FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/dashboard.css">

    <!-- Chart.js (used only for real backend data - no fake data is plotted) -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
</head>
<body class="dashboard-body">

<div class="dashboard-wrapper">

    <jsp:include page="sidebar.jsp">
        <jsp:param name="activePage" value="dashboard" />
    </jsp:include>

    <main class="main-content">

        <!-- Top Navigation Bar -->
        <header class="glass-topbar d-flex justify-content-between align-items-center mb-4">
            <div class="search-box position-relative flex-grow-1 me-4" style="max-width: 400px;">
                <i class="fas fa-search search-icon"></i>
                <input type="text" class="form-control search-input" id="adminSearchInput" placeholder="Search destinations, users, reports...">
            </div>
            <div class="d-flex align-items-center gap-3">
                <button type="button" class="btn btn-light position-relative" id="topNotificationBtn" title="Notifications" style="border-radius:12px;">
                    <i class="fas fa-bell"></i>
                    <span id="topNotifBadge" class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="display:none; font-size:0.6rem;">0</span>
                </button>
                <div class="user-profile-badge d-flex align-items-center gap-2">
                    <div class="avatar-circle"><i class="fas fa-user"></i></div>
                    <div>
                        <div class="fw-bold lh-1" style="font-size: 0.85rem;" id="adminNameLabel">Admin</div>
                        <small class="text-muted" style="font-size: 0.72rem;">Administrator</small>
                    </div>
                </div>
            </div>
        </header>

        <!-- Greeting Hero -->
        <section class="dashboard-hero">
            <div>
                <h2 id="heroGreeting">Good Morning, Admin <span>&#9728;&#65039;</span></h2>
                <p>Here's what's happening with your travel platform today.</p>
            </div>
        </section>

        <!-- Metric Cards -->
        <section class="row g-3 mb-4">
            <div class="col-6 col-md-4 col-xl-2">
                <div class="glass-card metric-card">
                    <div class="d-flex align-items-center gap-3">
                        <div class="icon-shape bg-purple-soft text-purple"><i class="fas fa-users"></i></div>
                        <div>
                            <span class="metric-label">Users</span>
                            <h3 class="metric-value" id="totalUsers">0</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-xl-2">
                <div class="glass-card metric-card">
                    <div class="d-flex align-items-center gap-3">
                        <div class="icon-shape bg-indigo-soft text-indigo"><i class="fas fa-map-marker-alt"></i></div>
                        <div>
                            <span class="metric-label">Destinations</span>
                            <h3 class="metric-value" id="totalDestinations">0</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-xl-2">
                <div class="glass-card metric-card">
                    <div class="d-flex align-items-center gap-3">
                        <div class="icon-shape bg-orange-soft text-orange"><i class="fas fa-hotel"></i></div>
                        <div>
                            <span class="metric-label">Hotels</span>
                            <h3 class="metric-value" id="totalHotels">0</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-xl-2">
                <div class="glass-card metric-card">
                    <div class="d-flex align-items-center gap-3">
                        <div class="icon-shape bg-blue-soft text-blue"><i class="fas fa-bus"></i></div>
                        <div>
                            <span class="metric-label">Transport</span>
                            <h3 class="metric-value" id="totalTransport">0</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-xl-2">
                <div class="glass-card metric-card">
                    <div class="d-flex align-items-center gap-3">
                        <div class="icon-shape bg-green-soft text-green"><i class="fas fa-walking"></i></div>
                        <div>
                            <span class="metric-label">Activities</span>
                            <h3 class="metric-value" id="totalActivities">0</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-xl-2">
                <div class="glass-card metric-card">
                    <div class="d-flex align-items-center gap-3">
                        <div class="icon-shape bg-pink-soft text-pink"><i class="fas fa-star"></i></div>
                        <div>
                            <span class="metric-label">Reviews</span>
                            <h3 class="metric-value" id="totalReviews">0</h3>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Chart + Quick Actions/Notifications Row -->
        <section class="row g-3 mb-4">
            <div class="col-xl-8">
                <div class="glass-card p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0"><i class="fas fa-chart-line text-primary me-2"></i>Top Destinations Overview</h5>
                        <span class="text-muted" style="font-size:0.72rem;">Live from database</span>
                    </div>
                    <div class="chart-canvas-wrap">
                        <canvas id="topDestinationsChart"></canvas>
                    </div>
                </div>
            </div>

            <div class="col-xl-4">
                <div class="glass-card p-3 mb-3">
                    <h6 class="fw-bold mb-3">Quick Actions</h6>
                    <div class="row g-2">
                        <div class="col-6">
                            <a class="quick-action-btn qa-blue w-100" href="destinations.jsp"><i class="fas fa-map-marker-alt"></i>Add Destination</a>
                        </div>
                        <div class="col-6">
                            <a class="quick-action-btn qa-purple w-100" href="hotels.jsp"><i class="fas fa-hotel"></i>Add Hotel</a>
                        </div>
                        <div class="col-6">
                            <a class="quick-action-btn qa-green w-100" href="activity.jsp"><i class="fas fa-walking"></i>Add Activity</a>
                        </div>
                        <div class="col-6">
                            <a class="quick-action-btn qa-orange w-100" href="reports.jsp"><i class="fas fa-chart-pie"></i>View Reports</a>
                        </div>
                    </div>
                </div>

                <div class="glass-card p-3">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <h6 class="fw-bold mb-0">Notifications</h6>
                        <a href="notification.jsp" class="text-decoration-none" style="font-size:0.7rem;">View All &rarr;</a>
                    </div>
                    <div id="adminNotifList" style="max-height:260px; overflow-y:auto;"></div>
                </div>
            </div>
        </section>

        <!-- Top Items Section -->
        <section class="row g-3 mb-4">
            <div class="col-xl-3 col-md-6">
                <div class="glass-card p-3 h-100">
                    <h6 class="fw-bold mb-3">Top Destinations</h6>
                    <div id="topDestinationsContainer" class="d-flex flex-column gap-2"></div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="glass-card p-3 h-100">
                    <h6 class="fw-bold mb-3">Top Hotels</h6>
                    <div id="topHotelsContainer" class="d-flex flex-column gap-2"></div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="glass-card p-3 h-100">
                    <h6 class="fw-bold mb-3">Top Transport</h6>
                    <div id="topTransportContainer" class="d-flex flex-column gap-2"></div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="glass-card p-3 h-100">
                    <h6 class="fw-bold mb-3">Top Activities</h6>
                    <div id="topActivitiesContainer" class="d-flex flex-column gap-2"></div>
                </div>
            </div>
        </section>

        <!-- Recently Added Destinations + Travel Insights -->
        <section class="row g-3 mb-4">
            <div class="col-xl-8">
                <div class="glass-card p-3 h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 class="fw-bold mb-0">Recently Added Destinations</h6>
                        <a href="destinations.jsp" class="text-decoration-none" style="font-size:0.72rem;">View All &rarr;</a>
                    </div>
                    <div class="table-responsive">
                        <table class="table custom-glass-table align-middle">
                            <thead>
                                <tr><th>Image</th><th>Name</th><th>Location</th><th>Category</th><th>Status</th><th>Actions</th></tr>
                            </thead>
                            <tbody id="recentDestinationsTable"></tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="col-xl-4">
                <div class="glass-card p-3 h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 class="fw-bold mb-0">Travel Insights &amp; Analytics</h6>
                    </div>
                    <div class="donut-wrap">
                        <div class="donut-canvas-wrap">
                            <canvas id="categoryDonutChart"></canvas>
                            <div class="donut-center-label">
                                <div class="donut-total">
                                    <h3 id="donutTotalCount">0</h3>
                                    <span>Total</span>
                                </div>
                            </div>
                        </div>
                        <div class="donut-legend" id="donutLegend"></div>
                    </div>
                    <div class="growth-tip" id="growthTipBox" style="display:none;">
                        <i class="fas fa-lightbulb mt-1"></i>
                        <span id="growthTipText"></span>
                    </div>
                </div>
            </div>
        </section>

    </main>
</div>

<script src="${pageContext.request.contextPath}/js/apiConfig.js"></script>
<script src="${pageContext.request.contextPath}/js/dashboard.js"></script>
</body>
</html>