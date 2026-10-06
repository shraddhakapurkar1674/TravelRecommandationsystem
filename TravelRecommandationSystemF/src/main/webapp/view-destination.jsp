<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="${pageContext.request.contextPath}/js/apiConfig.js"></script>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Destination - TripWise</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: #eef2f7;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
            color: #2d3436;
        }

        .view-card-container {
            background: rgba(255, 255, 255, 0.92);
            backdrop-filter: blur(25px);
            border-radius: 28px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.12);
            width: 100%;
            max-width: 920px;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.8);
            position: relative;
        }

        .close-btn {
            position: absolute;
            top: 20px;
            right: 20px;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: #f1f5f9;
            border: none;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #636e72;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s;
            z-index: 10;
        }

        .close-btn:hover {
            background: #e2e8f0;
            color: #2d3436;
        }

        .view-header-icon {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: linear-gradient(135deg, #a29bfe 0%, #6c5ce7 100%);
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            box-shadow: 0 8px 20px rgba(108, 92, 231, 0.25);
        }

        .hero-img {
            width: 100%;
            height: 260px;
            object-fit: cover;
            border-radius: 20px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
            background: #e2e8f0;
        }

        .glass-stat-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 1rem;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .stat-icon-wrapper {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
        }

        .fs-8 { font-size: 0.78rem; }
    </style>
</head>
<body>

    <div class="view-card-container p-4 p-md-5">
        <!-- Close / Back Link to Main Table -->
        <a href="destinations.jsp" class="close-btn" title="Back to list">
            <i class="fas fa-times"></i>
        </a>

        <!-- Header -->
        <div class="d-flex align-items-center gap-3 mb-4">
            <div class="view-header-icon">
                <i class="far fa-eye"></i>
            </div>
            <div>
                <h4 class="fw-bold mb-0" style="color: #1e293b;">Destination Preview</h4>
                <small class="text-muted">Here is the destination information.</small>
            </div>
        </div>

        <!-- Content Area -->
        <div class="row g-4">
            <!-- Left Dynamic Hero Image -->
            <div class="col-md-6">
                <img id="destImage" src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80" class="hero-img" alt="Destination Image">
            </div>

            <!-- Right Info -->
            <div class="col-md-6 d-flex flex-column justify-content-center">
                <div class="d-flex align-items-center gap-2 mb-1">
                    <h3 id="destTitle" class="fw-bold mb-0" style="color: #0f172a;">Loading...</h3>
                    <span id="destStatus" class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-2 py-1 fs-8">
                        • Active
                    </span>
                </div>

                <div id="destLocation" class="text-muted small mb-2">
                    <i class="fas fa-location-dot text-primary me-1"></i> --
                </div>

                <div id="destRating" class="text-primary small fw-semibold mb-2">
                    <i class="far fa-star text-warning me-1"></i> 4.5 / 5 (512 Reviews)
                </div>

                <div id="destCategory" class="text-muted small mb-3">
                    <i class="fas fa-th-large me-1"></i> --
                </div>

                <div class="fw-bold fs-8 text-uppercase text-secondary mb-1">Description</div>
                <p id="destDescription" class="text-secondary small mb-0" style="line-height: 1.5;"></p>
            </div>
        </div>

        <!-- Bottom Feature Cards -->
        <div class="row g-3 mt-3">
            <div class="col-md-3 col-6">
                <div class="glass-stat-card">
                    <div class="stat-icon-wrapper bg-primary-subtle text-primary"><i class="fas fa-globe"></i></div>
                    <div>
                        <div class="text-muted fs-8">Country</div>
                        <div id="cardCountry" class="fw-bold small text-dark">--</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="glass-stat-card">
                    <div class="stat-icon-wrapper bg-success-subtle text-success"><i class="far fa-calendar-alt"></i></div>
                    <div>
                        <div class="text-muted fs-8">Best Time to Visit</div>
                        <div id="cardSeason" class="fw-bold small text-dark">--</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="glass-stat-card">
                    <div class="stat-icon-wrapper bg-warning-subtle text-warning"><i class="fas fa-star"></i></div>
                    <div>
                        <div class="text-muted fs-8">Popularity</div>
                        <div id="cardPopularity" class="fw-bold small text-dark">--</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="glass-stat-card">
                    <div class="stat-icon-wrapper bg-danger-subtle text-danger"><i class="fas fa-tag"></i></div>
                    <div>
                        <div class="text-muted fs-8">Category</div>
                        <div id="cardCategory" class="fw-bold small text-dark">--</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript logic to fetch dynamic data and database image -->
    <script>
        const API_BASE_URL = API_CONFIG.api("/api/destinations");

        document.addEventListener("DOMContentLoaded", function () {
            // 1. Get Destination ID from URL parameter (e.g. view-destination.jsp?id=5)
            const urlParams = new URLSearchParams(window.location.search);
            const destId = urlParams.get('id');

            if (destId) {
                fetchDestinationDetails(destId);
            } else {
                alert("No destination ID specified!");
            }
        });

        async function fetchDestinationDetails(id) {
            try {
                const response = await fetch(`${API_BASE_URL}/${id}`);
                const data = await response.json();

                if (response.ok && data) {
                    const dest = data.data || data; // Adjust based on your API response structure

                    // Bind Text Fields
                    document.getElementById("destTitle").innerText = dest.destinationName || dest.name || "Destination";
                    document.getElementById("destLocation").innerHTML = `<i class="fas fa-location-dot text-primary me-1"></i> ${dest.state || ''}, ${dest.country || 'India'}`;
                    document.getElementById("destRating").innerHTML = `<i class="far fa-star text-warning me-1"></i> ${dest.rating || '4.5'} / 5 (512 Reviews)`;
                    document.getElementById("destCategory").innerHTML = `<i class="fas fa-th-large me-1"></i> ${dest.category || 'N/A'}`;
                    document.getElementById("destDescription").innerText = dest.description || "No detailed description available.";

                    // Bind Bottom Cards
                    document.getElementById("cardCountry").innerText = dest.country || "India";
                    document.getElementById("cardSeason").innerText = dest.bestSeason || dest.bestTimeToVisit || "N/A";
                    document.getElementById("cardPopularity").innerText = `${dest.rating || '4.5'} / 5`;
                    document.getElementById("cardCategory").innerText = dest.category || "General";

                    // Dynamic Database Image Handling Logic
                    const imageElement = document.getElementById("destImage");
                    let dynamicImgUrl = "";

                    if (dest.imageUrl && dest.imageUrl.length > 5) {
                        dynamicImgUrl = dest.imageUrl;
                    } else if (dest.imagePath || dest.image) {
                        const path = dest.imagePath || dest.image;
                        dynamicImgUrl = path.startsWith("http") ? path : API_CONFIG.image(path);
                    } else {
                        // Fallback placeholder image if database record has no image
                        dynamicImgUrl = "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80";
                    }

                    imageElement.src = dynamicImgUrl;
                }
            } catch (error) {
                console.error("Error loading destination from DB:", error);
            }
        }
    </script>
</body>
</html>
