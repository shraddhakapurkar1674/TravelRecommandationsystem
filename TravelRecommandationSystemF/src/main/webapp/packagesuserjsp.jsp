<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TripNexa - Travel Packages</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/recommendations.css?v=11">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .dashboard-layout { display: flex; min-height: 100vh; }
        .sidebar-area { width: 260px; flex-shrink: 0; }
        .content-area { flex-grow: 1; padding: 30px; background-color: #f8fafc; }

        .package-card-custom {
            background: #ffffff;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
            transition: transform 0.25s ease, box-shadow 0.25s ease;
            display: flex;
            flex-direction: column;
            height: 100%;
            border: 1px solid rgba(226, 232, 240, 0.8);
        }
        .package-card-custom:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }
        .package-img-wrapper {
            position: relative;
            height: 200px;
            overflow: hidden;
            background: #e2e8f0;
        }
        .package-img-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
        }
        .package-card-custom:hover .package-img-wrapper img {
            transform: scale(1.05);
        }
        .package-price-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: rgba(15, 23, 42, 0.85);
            color: #ffffff;
            padding: 6px 14px;
            border-radius: 30px;
            font-weight: 700;
            font-size: 14px;
            backdrop-filter: blur(4px);
        }
        .btn-view-details {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: #ffffff;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.2s ease;
            width: 100%;
            text-decoration: none;
        }
        .btn-view-details:hover {
            background: linear-gradient(135deg, #1d4ed8 0%, #1e40af 100%);
            color: #ffffff;
        }
        .modal-content { background-color: #f8fafc; }
        .modal-body { background-color: #ffffff; }
    </style>
</head>
<body>

<div class="dashboard-layout">
    <!-- SIDEBAR AREA -->
    <aside class="sidebar-area">
        <jsp:include page="sidebaruser.jsp" />
    </aside>

    <!-- CONTENT AREA -->
    <main class="content-area">
    <jsp:include page="user-header.jsp" />
        <!-- HERO SECTION -->
        <section class="recommendation-hero">
            <div class="hero-content">
                <span class="hero-badge">✨ TRIPNEXA</span>
                <h1>Curated Travel Packages</h1>
                <p>Explore expertly designed vacation packages tailored for your dream getaway.</p>
            </div>
            <div class="hero-icon"><i class="fa-solid fa-suitcase-rolling"></i></div>
        </section>

        <!-- RESULTS SECTION -->
        <section class="results-section">
            <div class="results-header">
                <div>
                    <h2>Available Packages</h2>
                    <p>Choose from our selection of handcrafted holiday packages.</p>
                </div>
                <span id="package-count" class="result-count">0 Packages</span>
            </div>

            <div id="packagesContainer" class="destination-grid">
                <div class="text-center py-5" style="grid-column: 1 / -1;">
                    <div class="spinner-border text-primary" role="status"></div>
                    <p class="text-muted mt-2">Loading packages...</p>
                </div>
            </div>
        </section>
    </main>
</div>

<!-- Modal for Package Details -->
<div class="modal fade" id="packageDetailModal" tabindex="-1">
  <div class="modal-dialog modal-xl modal-dialog-scrollable">
    <div class="modal-content border-0 shadow-lg rounded-4">
      <div class="modal-header bg-dark text-white px-4 py-3">
        <h5 class="modal-title fw-bold" id="modalPkgName">Package Details</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body p-4" id="modalBodyContent"></div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    /* ---------- IMAGE HELPERS (same endpoints the admin page and other pages use) ---------- */
    // Cache-buster: a replaced image (same file name) shows fresh on every page load
    const IMG_VER = "?v=" + Date.now();

    function pkgCleanName(name) {
        return String(name || "").trim().replace(/\\/g, "/");
    }

    // Destination images -> /api/destinations/images/{fileName}  (same as admin package page)
    function pkgDestinationImg(name) {
        name = pkgCleanName(name);
        if (!name) return "";
        return API_CONFIG.destinationImage(name) + IMG_VER;
    }

    // Hotel images -> /api/hotels/images/{fileName}
    function pkgHotelImg(name) {
        name = pkgCleanName(name);
        if (!name) return "";
        if (/^(https?:|data:|blob:)/i.test(name)) return name;
        return API_CONFIG.hotelImage(name.substring(name.lastIndexOf("/") + 1)) + IMG_VER;
    }

    // Activity images -> backend static /images/{fileName}  (served from the upload folder)
    function pkgActivityImg(name) {
        name = pkgCleanName(name);
        if (!name) return "";
        if (/^(https?:|data:|blob:)/i.test(name)) return name;
        return API_CONFIG.BASE_URL + "/images/" + encodeURIComponent(name.substring(name.lastIndexOf("/") + 1)) + IMG_VER;
    }

    document.addEventListener("DOMContentLoaded", function () {
        loadAllPackages();
    });

    function loadAllPackages() {
        fetch(API_CONFIG.api("/api/travel-packages"))
            .then(res => res.json())
            .then(async data => {
                const container = document.getElementById("packagesContainer");
                container.innerHTML = "";
                let packages = Array.isArray(data) ? data : (data.data || []);

                const countBadge = document.getElementById("package-count");
                if (countBadge) countBadge.textContent = packages.length + " Packages";

                if (packages.length === 0) {
                    container.innerHTML = `<div class="text-center py-5" style="grid-column: 1 / -1;"><p class="text-muted">No packages available right now.</p></div>`;
                    return;
                }

                for (let pkg of packages) {
                    let pkgId = pkg.packageId || pkg.id;
                    let firstImage = "";

                    try {
                        let detailRes = await fetch(API_CONFIG.api("/api/travel-packages/" + pkgId + "/details"));
                        let detailData = await detailRes.json();
                        if (detailData.destinations && detailData.destinations.length > 0) {
                            firstImage = detailData.destinations[0].imageName || "";
                        }
                    } catch (e) {
                        console.error("Error fetching preview image", e);
                    }

                    let imageUrl = pkgDestinationImg(firstImage);

                    container.innerHTML += `
                        <div class="destination-card">
                            <div class="package-card-custom">
                                <div class="package-img-wrapper">
                                    <img src="\${imageUrl}" alt="\${pkg.packageName}" onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1488646953014-85cb44e25828?auto=format&fit=crop&w=600&q=80'">
                                    <div class="package-price-badge">₹\${pkg.price}</div>
                                </div>
                                <div class="card-body d-flex flex-column justify-content-between p-4" style="flex-grow: 1;">
                                    <div>
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <span class="match-pill" style="position:static; padding:4px 10px; font-size:11px;">\${pkg.packageType || 'Holiday'}</span>
                                            <span class="text-muted small"><i class="fa-solid fa-clock me-1"></i>\${pkg.duration}</span>
                                        </div>
                                        <h4 class="recommendation-destination-name fw-bold mb-2 text-dark" style="font-size: 1.15rem;">\${pkg.packageName}</h4>
                                        <p class="text-muted small mb-4" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">\${pkg.description || 'Experience an unforgettable journey.'}</p>
                                    </div>
                                    <button class="btn-view-details" onclick="viewPackageDetails(\${pkgId})">
                                        <i class="fa-solid fa-eye"></i> View Details
                                    </button>
                                </div>
                            </div>
                        </div>
                    `;
                }
            })
            .catch(err => {
                console.error("Error loading packages:", err);
            });
    }

    function viewPackageDetails(packageId) {
        fetch(API_CONFIG.api("/api/travel-packages/" + packageId + "/details"))
            .then(res => res.json())
            .then(data => {
                const pkg = data.packageInfo;
                const destinations = data.destinations || [];
                const hotels = data.hotels || [];
                const activities = data.activities || [];

                document.getElementById("modalPkgName").textContent = pkg.packageName;

                let html = `
                    <div class="mb-4 model">
                        <h6 class="text-uppercase text-muted fw-bold small mb-2">Overview</h6>
                        <p class="text-secondary mb-3">\${pkg.description || 'No description provided.'}</p>
                        <div class="row g-3">
                            <div class="col-md-4">
                                <div class="p-3 bg-light rounded-3 border">
                                    <span class="text-muted d-block small">Duration</span>
                                    <strong class="text-dark">\${pkg.duration}</strong>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="p-3 bg-light rounded-3 border">
                                    <span class="text-muted d-block small">Package Price</span>
                                    <strong class="text-success fs-5">₹\${pkg.price}</strong>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="p-3 bg-light rounded-3 border">
                                    <span class="text-muted d-block small">Type</span>
                                    <strong class="text-dark">\${pkg.packageType || 'Standard'}</strong>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="p-3 bg-success bg-opacity-10 rounded-3 border border-success border-opacity-25 h-100">
                                <h6 class="text-success fw-bold mb-2"><i class="fa-solid fa-circle-check me-2"></i>Included Services</h6>
                                <p class="mb-0 small text-dark">\${pkg.includedServices || 'None specified'}</p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="p-3 bg-danger bg-opacity-10 rounded-3 border border-danger border-opacity-25 h-100">
                                <h6 class="text-danger fw-bold mb-2"><i class="fa-solid fa-circle-xmark me-2"></i>Excluded Services</h6>
                                <p class="mb-0 small text-dark">\${pkg.excludedServices || 'None specified'}</p>
                            </div>
                        </div>
                    </div>

                    <hr class="my-4">
                    <h5 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-map-location-dot text-primary me-2"></i>Destinations Covered</h5>
                    <div class="row g-3 mb-4">
                `;

                if (destinations.length > 0) {
                    destinations.forEach(dest => {
                        let imgPath = pkgDestinationImg(dest.imageName);
                        html += `
                            <div class="col-md-4">
                                <div class="card border shadow-sm h-100">
                                    <img src="\${imgPath}" class="card-img-top" style="height: 140px; object-fit: cover;" onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400&q=80'">
                                    <div class="card-body p-3 text-center">
                                        <h6 class="fw-bold mb-0">\${dest.destinationName}</h6>
                                    </div>
                                </div>
                            </div>
                        `;
                    });
                } else {
                    html += `<div class="col-12"><p class="text-muted small">No destinations listed.</p></div>`;
                }

                html += `</div><hr class="my-4"><h5 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-hotel text-success me-2"></i>Available Hotels</h5><div class="row g-3 mb-4">`;

                if (hotels.length > 0) {
                    hotels.forEach(h => {
                        let hotelImgName = h.image || h.hotelImage || '';
                        let hotelImgUrl = pkgHotelImg(hotelImgName);

                        html += `
                            <div class="col-md-4">
                                <div class="card border shadow-sm h-100">
                                    <img src="\${hotelImgUrl}" class="card-img-top" style="height: 120px; object-fit: cover;" onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=400&q=80'">
                                    <div class="card-body p-3">
                                        <h6 class="fw-bold text-dark mb-1">\${h.hotel_name || h.hotelName}</h6>
                                        <p class="small text-muted mb-1"><i class="fa-solid fa-location-dot me-1"></i>\${h.location || 'Location available'}</p>
                                        <p class="small text-success fw-bold mb-0">₹\${h.price_per_night || h.pricePerNight} / night</p>
                                    </div>
                                </div>
                            </div>
                        `;
                    });
                } else {
                    html += `<div class="col-12"><p class="text-muted small">No hotels available for these destinations.</p></div>`;
                }

                html += `</div><hr class="my-4"><h5 class="fw-bold mb-3 text-dark"><i class="fa-solid fa-person-hiking text-warning me-2"></i>Available Activities</h5><div class="row g-3">`;

                if (activities.length > 0) {
                    activities.forEach(act => {
                        let actImgName = act.image || act.activityImage || '';
                        let actImgUrl = pkgActivityImg(actImgName);

                        html += `
                            <div class="col-md-4">
                                <div class="card border shadow-sm h-100">
                                    <img src="\${actImgUrl}" class="card-img-top" style="height: 120px; object-fit: cover;" onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1533105079780-92b9be482077?auto=format&fit=crop&w=400&q=80'">
                                    <div class="card-body p-3">
                                        <h6 class="fw-bold text-dark mb-1">\${act.activity_name || act.activityName}</h6>
                                        <p class="small text-muted mb-1">Type: \${act.activity_type || act.activityType || 'General'}</p>
                                        <p class="small text-danger fw-bold mb-0">₹\${act.price}</p>
                                    </div>
                                </div>
                            </div>
                        `;
                    });
                } else {
                    html += `<div class="col-12"><p class="text-muted small">No activities available for these destinations.</p></div>`;
                }

                html += `</div>`;

                document.getElementById("modalBodyContent").innerHTML = html;
                new bootstrap.Modal(document.getElementById('packageDetailModal')).show();
            })
            .catch(err => {
                console.error("Error fetching package details:", err);
            });
    }
</script>
</body>
</html>