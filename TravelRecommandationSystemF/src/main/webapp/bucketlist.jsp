<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TripNexa - My Bucketlist</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/recommendations.css?v=11">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/explore.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
    
/* Container grid matching the explore page layout */
#bucketlistContainer {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 24px;
    margin-top: 20px;
}

/* Card styling identical to explore page cards */
#bucketlistContainer .destination-card {
    background: #ffffff;
    border-radius: 16px;
    overflow: hidden;
    border: 1px solid #e2e8f0;
    box-shadow: 0 4px 15px rgba(15, 23, 42, 0.06);
    display: flex;
    flex-direction: column;
    height: 100%;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}

#bucketlistContainer .destination-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 10px 25px rgba(15, 23, 42, 0.10);
}

/* Image wrapper and image height control */
#bucketlistContainer .card-image {
    height: 190px;
    position: relative;
    overflow: hidden;
}

#bucketlistContainer .card-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.3s ease;
}

#bucketlistContainer .destination-card:hover .card-image img {
    transform: scale(1.05);
}

/* Favorite button positioning */
#bucketlistContainer .favorite-btn {
    position: absolute;
    top: 12px;
    right: 12px;
    width: 38px;
    height: 38px;
    border: none;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.95);
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    color: #475569;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    z-index: 2;
}

#bucketlistContainer .favorite-btn:hover {
    color: #ef4444;
}

/* Card body layout */
#bucketlistContainer .card-body {
    padding: 16px;
    display: flex;
    flex-direction: column;
    flex-grow: 1;
    justify-content: space-between;
}

/* Title and text formatting */
#bucketlistContainer .card-body h3 {
    margin: 8px 0 9px;
    font-size: 17px;
    font-weight: 700;
    color: #0f172a;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

#bucketlistContainer .location-row {
    display: flex;
    align-items: center;
    gap: 6px;
    color: #64748b;
    font-size: 12px;
    margin-bottom: 10px;
}

#bucketlistContainer .location-row i {
    color: #0284c7;
}

#bucketlistContainer .category-badge {
    display: inline-block;
    padding: 4px 8px;
    border-radius: 20px;
    background: #e0f2fe;
    color: #0369a1;
    font-size: 10px;
    font-weight: 600;
    width: fit-content;
}

#bucketlistContainer .price {
    margin-top: 10px;
    color: #0f172a;
    font-size: 18px;
    font-weight: 700;
}

#bucketlistContainer .price-text {
    font-size: 11px;
    color: #94a3b8;
    font-weight: 400;
}

#bucketlistContainer .card-footer {
    margin-top: 14px;
    padding-top: 12px;
    border-top: 1px solid #f1f5f9;
}

#bucketlistContainer .view-details {
    border: none;
    background: transparent;
    color: #0284c7;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    padding: 0;
    display: inline-flex;
    align-items: center;
    gap: 5px;
}

#bucketlistContainer .view-details:hover {
    color: #0369a1;
}    
   
    </style>
</head>
<body>

<div class="dashboard-container">
    <!-- SIDEBAR -->
    <aside class="recommendation-sidebar">
        <jsp:include page="sidebaruser.jsp">
            <jsp:param name="activePage" value="bucketlist"/>
        </jsp:include>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="recommendation-main">
    <jsp:include page="user-header.jsp" />
        <!-- HERO SECTION -->
        <section class="recommendation-hero">
            <div class="hero-content">
                <span class="hero-badge">✨ TRIPNEXA</span>
                <h1>My Bucketlist</h1>
                <p>Your saved dream destinations for future adventures.</p>
            </div>
            <div class="hero-icon"><i class="fa-solid fa-heart"></i></div>
        </section>

        <!-- BUCKETLIST RESULTS SECTION -->
        <section class="results-section">
            <div class="results-header">
                <div>
                    <h2>Saved Destinations</h2>
                    <p>All destinations you have saved to your bucketlist.</p>
                </div>
                <span id="bucketlistCount" class="result-count">0 saved</span>
            </div>

            <div id="loadingMessage" class="state-box hidden">
                <div class="loader"></div>
                <h3>Loading your bucketlist...</h3>
                <p>Please wait while we fetch your saved destinations.</p>
            </div>

            <div id="noBucketlistMessage" class="state-box hidden">
                <div class="state-icon">🤍</div>
                <h3>Your bucketlist is empty</h3>
                <p>Explore destinations and add your favorites here.</p>
                <a href="explore.jsp" class="primary-button mt-3" style="display: inline-flex; width: auto; text-decoration: none;">Explore Destinations</a>
            </div>

            <div id="bucketlistContainer" class="destination-grid">
                <p class="text-muted-custom">Loading your bucketlist...</p>
            </div>
        </section>
    </main>
</div>

<!-- Toast Notification Container -->
<div id="toastContainer" class="position-fixed bottom-0 end-0 p-3" style="z-index: 1080;"></div>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script src="${pageContext.request.contextPath}/js/apiConfig.js"></script>
<script src="${pageContext.request.contextPath}/js/bucketlist.js"></script>
</body>
</html>