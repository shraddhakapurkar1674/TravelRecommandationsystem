<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Analysis & Report</title>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style type="text/css">
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: "Segoe UI", Arial, sans-serif; background: linear-gradient(135deg, #f5f7fb, #eef3f8); color: #172033; min-height: 100vh; }

/* Main Admin Layout Structure */
.admin-layout {
    display: flex;
    min-height: 100vh;
    width: 100%;
}

/* Left Sidebar Wrapper */
.admin-sidebar-wrapper {
    width: 260px;
    flex-shrink: 0;
    background: #ffffff;
    border-right: 1px solid #edf0f5;
    position: fixed;
    height: 100vh;
    overflow-y: auto;
    z-index: 100;
}

/* Right Content Wrapper */
.admin-content-wrapper {
    flex-grow: 1;
    margin-left: 260px; /* Matches the sidebar width */
    width: calc(100% - 260px);
    background: transparent;
    min-height: 100vh;
}

.page-container { width: 100%; max-width: 1500px; margin: auto; padding: 30px; }
.report-header { display: flex; justify-content: space-between; align-items: center; background: #ffffff; padding: 30px; border-radius: 22px; margin-bottom: 25px; box-shadow: 0 10px 35px rgba(30, 45, 70, 0.08); }
.page-label { font-size: 12px; font-weight: 700; letter-spacing: 2px; color: #6c63ff; }
.report-header h1 { font-size: 36px; margin: 8px 0; font-weight: 800; }
.report-header p { color: #7a8497; font-size: 15px; }
.refresh-btn { border: none; padding: 13px 22px; border-radius: 12px; background: linear-gradient(135deg, #6c63ff, #4f46e5); color: white; font-size: 14px; font-weight: 700; cursor: pointer; transition: 0.25s; }
.refresh-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(79, 70, 229, 0.25); }
.error-message { display: none; background: #fff0f0; color: #c0392b; border: 1px solid #ffd0d0; padding: 15px 20px; border-radius: 12px; margin-bottom: 20px; }
.stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 18px; margin-bottom: 25px; }
.stat-card { display: flex; align-items: center; gap: 16px; background: #ffffff; padding: 22px; border-radius: 18px; box-shadow: 0 8px 25px rgba(30, 45, 70, 0.06); transition: 0.25s; }
.stat-card:hover { transform: translateY(-4px); box-shadow: 0 15px 35px rgba(30, 45, 70, 0.10); }
.stat-icon { width: 55px; height: 55px; display: flex; align-items: center; justify-content: center; border-radius: 15px; font-size: 25px; }
.users-icon { background: #eeeaff; }
.destination-icon { background: #e8f8ee; }
.hotel-icon { background: #fff0e5; }
.transport-icon { background: #e8f3ff; }
.activity-icon { background: #fff4d9; }
.package-icon { background: #f4eaff; }
.review-icon { background: #fff0b8; }
.rating-icon { background: #ffe7ed; }
.stat-title { display: block; font-size: 13px; color: #8791a5; margin-bottom: 5px; }
.stat-card strong { display: block; font-size: 27px; font-weight: 800; color: #172033; }
.stat-card small { display: block; color: #a0a8b7; margin-top: 4px; font-size: 11px; }
.charts-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; }
.chart-card { background: #ffffff; border-radius: 20px; padding: 25px; min-height: 390px; box-shadow: 0 8px 30px rgba(30, 45, 70, 0.06); }
.large-chart { grid-column: span 2; }
.chart-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
.chart-header h2 { font-size: 19px; margin-bottom: 5px; }
.chart-header p { color: #8a94a6; font-size: 13px; }
.chart-badge { background: #f0efff; color: #6259ef; padding: 7px 12px; border-radius: 20px; font-size: 10px; font-weight: 800; letter-spacing: 1px; }
.chart-wrapper { position: relative; height: 300px; width: 100%; }
.destination-list { display: flex; flex-direction: column; gap: 12px; }
.destination-item { display: flex; align-items: center; justify-content: space-between; padding: 15px; border-radius: 12px; background: #f7f8fc; border: 1px solid #edf0f5; }
.destination-info { display: flex; flex-direction: column; gap: 4px; }
.destination-name { font-weight: 700; font-size: 14px; }
.destination-meta { font-size: 11px; color: #8b94a5; }
.destination-category { font-size: 11px; font-weight: 700; color: #6259ef; background: #efedff; padding: 6px 9px; border-radius: 20px; }
.empty-data { text-align: center; color: #9aa2b1; padding: 60px 20px; }
.report-footer { margin-top: 25px; padding: 20px; display: flex; justify-content: space-between; color: #8b94a5; font-size: 12px; }

@media (max-width: 1100px) { .stats-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 800px) { 
    .admin-sidebar-wrapper { width: 70px; }
    .admin-content-wrapper { margin-left: 70px; width: calc(100% - 70px); }
    .page-container { padding: 15px; } 
    .report-header { flex-direction: column; align-items: flex-start; gap: 20px; } 
    .charts-grid { grid-template-columns: 1fr; } 
    .large-chart { grid-column: span 1; } 
}
</style>
</head>
<body>

<div class="admin-layout">
    <!-- Left Hand Side: Sidebar JSP -->
    <aside class="admin-sidebar-wrapper">
        <jsp:include page="sidebar.jsp" />
    </aside>

    <!-- Right Hand Side: Report Analytics Content -->
    <main class="admin-content-wrapper">
        <div class="page-container">
            <header class="report-header">
                <div>
                    <span class="page-label">ADMIN DASHBOARD</span>
                    <h1>Analysis & Report</h1>
                    <p>Monitor your travel recommendation platform with real-time insights.</p>
                </div>
                <div class="header-actions">
                    <button class="refresh-btn" onclick="loadReports()">↻ Refresh</button>
                </div>
            </header>
            
            <div id="reportError" class="error-message"></div>
            
            <section class="stats-grid">
                <div class="stat-card"><div class="stat-icon users-icon">👥</div><div><span class="stat-title">Total Users</span><strong id="totalUsers">0</strong><small>Registered users</small></div></div>
                <div class="stat-card"><div class="stat-icon destination-icon">📍</div><div><span class="stat-title">Destinations</span><strong id="totalDestinations">0</strong><small>Available destinations</small></div></div>
                <div class="stat-card"><div class="stat-icon hotel-icon">🏨</div><div><span class="stat-title">Hotels</span><strong id="totalHotels">0</strong><small>Accommodation options</small></div></div>
                <div class="stat-card"><div class="stat-icon transport-icon">🚗</div><div><span class="stat-title">Transport</span><strong id="totalTransports">0</strong><small>Transport options</small></div></div>
                <div class="stat-card"><div class="stat-icon activity-icon">🎯</div><div><span class="stat-title">Activities</span><strong id="totalActivities">0</strong><small>Travel activities</small></div></div>
                <div class="stat-card"><div class="stat-icon package-icon">🧳</div><div><span class="stat-title">Packages</span><strong id="totalPackages">0</strong><small>Travel packages</small></div></div>
                <div class="stat-card"><div class="stat-icon review-icon">⭐</div><div><span class="stat-title">Reviews</span><strong id="totalReviews">0</strong><small>User reviews</small></div></div>
                <div class="stat-card"><div class="stat-icon rating-icon">★</div><div><span class="stat-title">Average Rating</span><strong id="averageRating">0.0</strong><small>Out of 5.0</small></div></div>
            </section>

            <section class="charts-grid">
                <div class="chart-card large-chart"><div class="chart-header"><div><h2>User Growth</h2><p>Registered users over the recent months</p></div><span class="chart-badge">USERS</span></div><div class="chart-wrapper"><canvas id="userGrowthChart"></canvas></div></div>
                <div class="chart-card"><div class="chart-header"><div><h2>Destination Categories</h2><p>Distribution of destinations</p></div></div><div class="chart-wrapper"><canvas id="destinationChart"></canvas></div></div>
                <div class="chart-card"><div class="chart-header"><div><h2>Travel Preferences</h2><p>What users prefer</p></div></div><div class="chart-wrapper"><canvas id="preferenceChart"></canvas></div></div>
                <div class="chart-card"><div class="chart-header"><div><h2>Rating Distribution</h2><p>User review ratings</p></div></div><div class="chart-wrapper"><canvas id="ratingChart"></canvas></div></div>
                <div class="chart-card"><div class="chart-header"><div><h2>Top Destinations</h2><p>Latest destinations</p></div></div><div id="topDestinations" class="destination-list"></div></div>
            </section>

            <footer class="report-footer"><span>Travel Recommendation System</span><span>Dynamic Admin Analytics</span></footer>
        </div>
    </main>
</div>

<script>const contextPath = "${pageContext.request.contextPath}";</script>
<script src="${pageContext.request.contextPath}/js/apiConfig.js"></script>
<script src="${pageContext.request.contextPath}/js/Reports.js"></script>
</body>
</html>