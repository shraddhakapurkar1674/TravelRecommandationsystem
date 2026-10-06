<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TripWise - Smart Travel, Better Experiences</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Swiper CSS (For Slider) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Custom Page Stylesheet -->
    <link href="${pageContext.request.contextPath}/css/styles.css" rel="stylesheet">
</head>
<body>

    <!-- Header Include -->
    <jsp:include page="header.jsp" />

    <!-- 1. HERO BANNER SECTION -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-8 col-xl-7">
                    <h1 class="fw-extrabold text-dark hero-title mb-3">
                        Discover Personalized<br/>
                        Travel <span class="text-purple-gradient">Recommendations</span>
                    </h1>
                    <p class="hero-subtitle mb-4">
                        Get destination, hotel, transport and activity recommendations tailored just for you.
                    </p>
                    <div class="d-flex flex-wrap gap-3 mb-2">
                        <a href="#search-bar" class="btn btn-primary-gradient rounded-3 px-4 py-2-5 fw-semibold shadow-sm d-flex align-items-center gap-2">
                            <i class="fas fa-sliders-h"></i> Get Recommendations
                        </a>
                        <a href="#" id="watchDemoBtn" data-bs-toggle="modal" data-bs-target="#demoVideoModal" class="btn btn-outline-secondary rounded-3 px-4 py-2-5 fw-semibold d-flex align-items-center gap-2 bg-white shadow-sm border-0">
                            <i class="fas fa-play-circle text-primary fs-5"></i> Watch Demo
                        </a>
                    </div>
                </div>
            </div>

            <!-- SEARCH / RECOMMENDATION BAR -->
            <div id="search-bar" class="search-floating-card card rounded-4 p-3 mt-5">
                <form id="recommendationForm" class="row g-2 align-items-center">
                    <div class="col-lg-3 col-md-6">
                        <div class="d-flex align-items-center search-input-group rounded-3 px-3 py-2">
                            <i class="fas fa-location-arrow text-primary fs-5 me-2"></i>
                            <div class="w-100">
                                <label class="d-block text-muted fw-bold mb-0" style="font-size: 0.7rem; text-transform: uppercase;">From</label>
                                <input type="text" id="sourceLocation" class="form-control border-0 bg-transparent p-0 fw-semibold text-dark shadow-none" value="Pune" placeholder="Enter Origin" required>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="d-flex align-items-center search-input-group rounded-3 px-3 py-2">
                            <i class="fas fa-map-marker-alt text-purple fs-5 me-2"></i>
                            <div class="w-100">
                                <label class="d-block text-muted fw-bold mb-0" style="font-size: 0.7rem; text-transform: uppercase;">Where to?</label>
                                <input type="text" id="targetDestination" class="form-control border-0 bg-transparent p-0 fw-semibold text-dark shadow-none" placeholder="Any Destination">
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-4">
                        <div class="d-flex align-items-center search-input-group rounded-3 px-3 py-2">
                            <i class="fas fa-wallet text-success fs-5 me-2"></i>
                            <div class="w-100">
                                <label class="d-block text-muted fw-bold mb-0" style="font-size: 0.7rem; text-transform: uppercase;">Budget</label>
                                <input type="number" id="maxBudget" class="form-control border-0 bg-transparent p-0 fw-semibold text-dark shadow-none" placeholder="Any Budget">
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-4">
                        <div class="d-flex align-items-center search-input-group rounded-3 px-3 py-2">
                            <i class="fas fa-tag text-warning fs-5 me-2"></i>
                            <div class="w-100">
                                <label class="d-block text-muted fw-bold mb-0" style="font-size: 0.7rem; text-transform: uppercase;">Trip Type</label>
                                <select id="tripType" class="form-select border-0 bg-transparent p-0 fw-semibold text-dark shadow-none">
                                    <option value="Any">Any Type</option>
                                    <option value="Adventure">Adventure</option>
                                    <option value="Beach">Beach</option>
                                    <option value="Nature">Nature</option>
                                    <option value="Historical">Historical</option>
                                    <option value="Family">Family</option>
                                    <option value="Romantic">Romantic</option>
                                    <option value="Party">Party</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-4">
                        <button type="submit" class="btn btn-primary-gradient w-100 rounded-3 py-2-5 text-white fw-bold shadow-sm d-flex align-items-center justify-content-center gap-2">
                            <i class="fas fa-map-marked-alt"></i> Plan My Trip
                        </button>
                    </div>
                </form>

                <!-- TRIP PLANNER RESULTS (filled in-place by js/home.js after "Plan My Trip" is
                     submitted). Anyone can see this preview list - clicking any individual
                     destination card always redirects straight to login.jsp (no direct access). -->
                <div id="tripPlannerResultsWrap" class="mt-4" style="display:none;">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold text-dark mb-0">
                            <i class="fas fa-route text-purple me-2"></i>
                            Matching Destinations <span id="tripPlannerResultsLabel" class="text-muted fw-normal"></span>
                        </h5>
                        <button type="button" id="closeTripPlannerResults" class="btn btn-sm btn-outline-secondary rounded-3">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <div class="row g-3" id="tripPlannerResultsRow"></div>
                </div>
            </div>
        </div>
    </section>

    <!-- 2. WHY CHOOSE TRIPWISE -->
    <section class="py-5 bg-white">
        <div class="container py-3">
            <div class="text-center mb-5">
                <h2 class="section-title">Why Choose <span class="text-purple">TripWise?</span></h2>
            </div>
            <div class="row g-3">
                <div class="col-lg-2 col-md-4 col-6">
                    <div class="card border-0 shadow-sm p-3 text-center h-100 rounded-4 feature-box">
                        <div class="icon-circle icon-bg-blue mx-auto mb-3"><i class="fas fa-bullseye"></i></div>
                        <h6 class="fw-bold text-dark mb-2" style="font-size: 0.88rem;">Personalized Recommendations</h6>
                        <p class="text-muted mb-0" style="font-size: 0.75rem;">AI-powered suggestions based on your preferences and past behavior.</p>
                    </div>
                </div>
                <div class="col-lg-2 col-md-4 col-6">
                    <div class="card border-0 shadow-sm p-3 text-center h-100 rounded-4 feature-box">
                        <div class="icon-circle icon-bg-orange mx-auto mb-3"><i class="fas fa-wallet"></i></div>
                        <h6 class="fw-bold text-dark mb-2" style="font-size: 0.88rem;">Budget Optimizer</h6>
                        <p class="text-muted mb-0" style="font-size: 0.75rem;">Smart suggestions that fit perfectly in your budget.</p>
                    </div>
                </div>
                <div class="col-lg-2 col-md-4 col-6">
                    <div class="card border-0 shadow-sm p-3 text-center h-100 rounded-4 feature-box">
                        <div class="icon-circle icon-bg-purple mx-auto mb-3"><i class="fas fa-map"></i></div>
                        <h6 class="fw-bold text-dark mb-2" style="font-size: 0.88rem;">Complete Trip Planner</h6>
                        <p class="text-muted mb-0" style="font-size: 0.75rem;">Plan hotels, activities, transport and more in one place.</p>
                    </div>
                </div>
                <div class="col-lg-2 col-md-4 col-6">
                    <div class="card border-0 shadow-sm p-3 text-center h-100 rounded-4 feature-box">
                        <div class="icon-circle icon-bg-teal mx-auto mb-3"><i class="fas fa-cloud-sun"></i></div>
                        <h6 class="fw-bold text-dark mb-2" style="font-size: 0.88rem;">Weather Check</h6>
                        <p class="text-muted mb-0" style="font-size: 0.75rem;">Real-time weather updates to help you plan better.</p>
                    </div>
                </div>
                <div class="col-lg-2 col-md-4 col-6">
                    <div class="card border-0 shadow-sm p-3 text-center h-100 rounded-4 feature-box">
                        <div class="icon-circle icon-bg-yellow mx-auto mb-3"><i class="fas fa-star"></i></div>
                        <h6 class="fw-bold text-dark mb-2" style="font-size: 0.88rem;">Top Experiences</h6>
                        <p class="text-muted mb-0" style="font-size: 0.75rem;">Handpicked activities and local experiences for you.</p>
                    </div>
                </div>
                <div class="col-lg-2 col-md-4 col-6">
                    <div class="card border-0 shadow-sm p-3 text-center h-100 rounded-4 feature-box">
                        <div class="icon-circle icon-bg-pink mx-auto mb-3"><i class="fas fa-heart"></i></div>
                        <h6 class="fw-bold text-dark mb-2" style="font-size: 0.88rem;">Save & Wishlist</h6>
                        <p class="text-muted mb-0" style="font-size: 0.75rem;">Save your favorite recommendations and plan anytime.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 3. POPULAR DESTINATIONS (DYNAMIC - loaded from the backend by js/home.js) -->
    <section class="py-5 bg-white" id="popularDestinations">
        <div class="container py-3">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="section-title mb-0">Popular <span class="text-purple">Destinations</span></h2>
                <a href="${pageContext.request.contextPath}/login.jsp" id="viewAllDestinationsLink" class="text-purple fw-bold text-decoration-none">
                    View All <i class="fas fa-arrow-right ms-1"></i>
                </a>
            </div>

            <!-- Populated dynamically. Clicking ANY card here always redirects to login.jsp -
                 there is no direct access to destination details from the home page. -->
            <div class="row g-3" id="popularDestinationsRow">
                <div class="col"><div class="skeleton-card"></div></div>
                <div class="col"><div class="skeleton-card"></div></div>
                <div class="col"><div class="skeleton-card"></div></div>
                <div class="col"><div class="skeleton-card"></div></div>
                <div class="col"><div class="skeleton-card"></div></div>
            </div>
        </div>
    </section>

    <!-- 4. WHAT KIND OF TRAVELLER ARE YOU? (DYNAMIC - DB categories + mood-based types from js/home.js) -->
    <section class="py-5 traveller-section">
        <div class="container py-3">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="section-title mb-1">What Kind of <span class="text-purple">Traveller</span> Are You?</h2>
                    <p class="text-muted mb-0 small">Swipe to find curated trips tailored to your vibe</p>
                </div>
                <!-- Navigation Arrows -->
                <div class="d-none d-md-flex gap-2">
                    <div class="swiper-button-prev-custom"><i class="fas fa-chevron-left"></i></div>
                    <div class="swiper-button-next-custom"><i class="fas fa-chevron-right"></i></div>
                </div>
            </div>

            <!-- Swiper Container -->
            <div class="swiper traveller-swiper">
                <div class="swiper-wrapper" id="travellerSwiperWrapper">
                    <div class="swiper-slide"><div class="skeleton-traveller-card"></div></div>
                    <div class="swiper-slide"><div class="skeleton-traveller-card"></div></div>
                    <div class="swiper-slide"><div class="skeleton-traveller-card"></div></div>
                    <div class="swiper-slide"><div class="skeleton-traveller-card"></div></div>
                </div>

                <!-- Swiper Dots -->
                <div class="swiper-pagination"></div>
            </div>
        </div>
    </section>

    <!-- 5. BUILD YOUR COMPLETE TRIP (plain flexbox layout - NOT Bootstrap's row/col grid -
         so the 5 step circles always sit in one horizontal line on desktop/tablet, joined by
         a single animated horizontal connector line, and wrap cleanly on small screens) -->
    <section class="py-5 bg-light">
        <div class="container py-3">
            <div class="text-center mb-5">
                <h2 class="section-title">Build Your <span class="text-purple">Complete</span> Trip</h2>
                <p class="text-muted mb-0">Plan your perfect trip in just a few simple steps</p>
            </div>

            <div class="trip-build-container">
                <div class="step-connector-line"></div>

                <div class="trip-build-steps">
                    <div class="trip-build-step">
                        <div class="step-circle" style="background-color:#6346f6;">
                            <i class="fas fa-map-marker-alt"></i>
                        </div>
                        <h6 class="fw-bold text-dark mb-1">1. Choose Destination</h6>
                        <p class="text-muted small mb-0">Select a destination you love</p>
                    </div>
                    <div class="trip-build-step">
                        <div class="step-circle" style="background-color:#7c3aed;">
                            <i class="fas fa-sliders-h"></i>
                        </div>
                        <h6 class="fw-bold text-dark mb-1">2. Customize Preferences</h6>
                        <p class="text-muted small mb-0">Tell us your budget, interests and style</p>
                    </div>
                    <div class="trip-build-step">
                        <div class="step-circle" style="background-color:#059669;">
                            <i class="fas fa-list-ul"></i>
                        </div>
                        <h6 class="fw-bold text-dark mb-1">3. Get Recommendations</h6>
                        <p class="text-muted small mb-0">We suggest the best options for you</p>
                    </div>
                    <div class="trip-build-step">
                        <div class="step-circle" style="background-color:#f97316;">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                        <h6 class="fw-bold text-dark mb-1">4. Plan Your Trip</h6>
                        <p class="text-muted small mb-0">Organize your itinerary, hotels, transport</p>
                    </div>
                    <div class="trip-build-step">
                        <div class="step-circle" style="background-color:#ec4899;">
                            <i class="fas fa-shopping-bag"></i>
                        </div>
                        <h6 class="fw-bold text-dark mb-1">5. Enjoy Your Journey</h6>
                        <p class="text-muted small mb-0">Pack your bags and have a great trip!</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 6. HIGH-CONTRAST FOOTER SECTION -->
    <jsp:include page="footer.jsp"></jsp:include>

    <!-- WATCH DEMO VIDEO MODAL -->
    <div class="modal fade" id="demoVideoModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 rounded-4 overflow-hidden">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">See TripWise in Action</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body pt-2">
                    <div class="demo-video-wrapper">
                        <!-- Replace this src with your own hosted product demo video -->
                        <iframe id="demoVideoFrame" data-src="https://www.youtube.com/embed/dQw4w9WgXcQ" src="" title="TripWise Demo Video" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JS Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>

   
<script>
    window.APP_CONTEXT_PATH = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/js/apiConfig.js"></script>
<script src="${pageContext.request.contextPath}/js/home.js"></script>

</body>
</html>