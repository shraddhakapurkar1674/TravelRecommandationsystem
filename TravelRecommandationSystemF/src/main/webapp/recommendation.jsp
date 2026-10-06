<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trip Netra - Recommendations</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/recommendations.css?v=11">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body>


<div class="dashboard-container">
    <!-- LEFT SIDE: Recommendation Main Content -->
    
    <main class="recommendation-main">
 <jsp:include page="user-header.jsp" />
        <!-- HERO -->
        
        <section class="recommendation-hero">
       
            <div class="hero-content">
                <span class="hero-badge">✨ TRIP NETRA</span>
                <h1>Recommendations For You</h1>
                <p>Discover destinations that match your profile, budget, mood and travel season.</p>
            </div>
            <div class="hero-icon">✈️</div>
        </section>

        <!-- TABS -->
        <section class="recommendation-tabs">
            <button type="button" class="recommendation-tab active" data-mode="forYou" onclick="switchRecommendationMode('forYou')">
                ✨ <span>For You</span>
            </button>
            <button type="button" class="recommendation-tab" data-mode="personalized" onclick="switchRecommendationMode('personalized')">
                🎯 <span>Personalized Filter</span>
            </button>
            <button type="button" class="recommendation-tab" data-mode="budget" onclick="switchRecommendationMode('budget')">
                💰 <span>Budget</span>
            </button>
            <button type="button" class="recommendation-tab" data-mode="mood" onclick="switchRecommendationMode('mood')">
                😊 <span>Mood</span>
            </button>
            <button type="button" class="recommendation-tab" data-mode="season" onclick="switchRecommendationMode('season')">
                🌤️ <span>Season</span>
            </button>
        </section>

        <!-- FOR YOU -->
        <section id="forYou-section" class="recommendation-section active">
            <div class="section-heading">
                <div>
                    <h2>✨ Recommended For You</h2>
                    <p>Recommendations generated from your saved travel profile.</p>
                </div>
            </div>
        </section>

        <!-- PERSONALIZED FILTER SECTION -->
        <section id="personalized-section" class="recommendation-section">
            <div class="filter-card">
                <div class="filter-title">
                    <span class="filter-icon">🎯</span>
                    <div>
                        <h2>Choose Your Factors</h2>
                        <p>Select your preferences below to get custom recommendations.</p>
                    </div>
                </div>

                <div class="personalized-form">
                    <div class="personalized-field">
                        <label>Min Budget (₹)</label>
                        <input type="number" id="personalMinBudget" placeholder="10000">
                    </div>
                    <div class="personalized-field">
                        <label>Max Budget (₹)</label>
                        <input type="number" id="personalMaxBudget" placeholder="50000">
                    </div>
                    <div class="personalized-field">
                        <label>Season</label>
                        <select id="personalSeason">
                            <option value="">Select Season</option>
                            <option value="Summer">Summer</option>
                            <option value="Rainy">Rainy</option>
                            <option value="Autumn">Autumn</option>
                            <option value="Winter">Winter</option>
                        </select>
                    </div>
                    <div class="personalized-field">
                        <label>Mood</label>
                        <select id="personalMood">
                            <option value="">Select Mood</option>
                            <option value="Adventure">Adventure</option>
                            <option value="Relaxation">Relaxation</option>
                            <option value="Nature">Nature</option>
                            <option value="Romantic">Romantic</option>
                            <option value="Culture">Culture</option>
                            <option value="Spiritual">Spiritual</option>
                            <option value="Party">Party</option>
                            <option value="Family">Family</option>
                        </select>
                    </div>
                    <div class="personalized-field">
                        <label>Category</label>
                        <select id="personalCategory">
                            <option value="">Select Category</option>
                            <option value="Hill Station">Hill Station</option>
                            <option value="Beach">Beach</option>
                            <option value="Historical">Historical</option>
                            <option value="Wildlife">Wildlife</option>
                        </select>
                    </div>
                    <div class="personalized-field">
                        <label>Travel Companion</label>
                        <select id="personalCompanion">
                            <option value="">Select Companion</option>
                            <option value="Family">Family</option>
                            <option value="Friends">Friends</option>
                            <option value="Couple">Couple</option>
                            <option value="Solo">Solo</option>
                        </select>
                    </div>
                    <div class="personalized-button-wrapper">
                        <button type="button" class="primary-button" onclick="findPersonalizedDestinations()">
                            🔍 Apply Factors & Recommend
                        </button>
                    </div>
                </div>
            </div>
        </section>

        <!-- BUDGET -->
        <section id="budget-section" class="recommendation-section">
            <div class="filter-card">
                <div class="filter-title">
                    <span class="filter-icon">💰</span>
                    <div>
                        <h2>Find destinations within your budget</h2>
                        <p>Enter your starting and ending budget.</p>
                    </div>
                </div>
                <div class="budget-inputs">
                    <div class="input-group">
                        <label>Starting Budget</label>
                        <div class="input-wrapper">
                            <span>₹</span>
                            <input type="number" id="minBudget" placeholder="10000" min="0">
                        </div>
                    </div>
                    <div class="input-group">
                        <label>Ending Budget</label>
                        <div class="input-wrapper">
                            <span>₹</span>
                            <input type="number" id="maxBudget" placeholder="50000" min="0">
                        </div>
                    </div>
                    <button type="button" class="primary-button" onclick="findBudgetDestinations()">
                        🔍 Find Destinations
                    </button>
                </div>
            </div>
        </section>

        <!-- MOOD -->
        <section id="mood-section" class="recommendation-section">
            <div class="filter-card">
                <div class="filter-title">
                    <span class="filter-icon">😊</span>
                    <div>
                        <h2>What are you in the mood for?</h2>
                        <p>Select a mood and get related destinations.</p>
                    </div>
                </div>
                <div class="choice-grid">
                    <button type="button" class="choice-button" onclick="findMoodDestinations('Adventure')">🏔️<span>Adventure</span></button>
                    <button type="button" class="choice-button" onclick="findMoodDestinations('Relaxation')">🌴<span>Relaxation</span></button>
                    <button type="button" class="choice-button" onclick="findMoodDestinations('Nature')">🌿<span>Nature</span></button>
                    <button type="button" class="choice-button" onclick="findMoodDestinations('Romantic')">💕<span>Romantic</span></button>
                    <button type="button" class="choice-button" onclick="findMoodDestinations('Culture')">🏛️<span>Culture</span></button>
                    <button type="button" class="choice-button" onclick="findMoodDestinations('Spiritual')">🕉️<span>Spiritual</span></button>
                    <button type="button" class="choice-button" onclick="findMoodDestinations('Party')">🎉<span>Party</span></button>
                    <button type="button" class="choice-button" onclick="findMoodDestinations('Family')">👨‍👩‍👧‍👦<span>Family</span></button>
                </div>
            </div>
        </section>

        <!-- SEASON -->
        <section id="season-section" class="recommendation-section">
            <div class="filter-card">
                <div class="filter-title">
                    <span class="filter-icon">🌤️</span>
                    <div>
                        <h2>Select Your Travel Season</h2>
                        <p>Choose the season in which you want to travel.</p>
                    </div>
                </div>
                <div class="choice-grid season-grid">
                    <button type="button" class="choice-button season-choice" onclick="findSeasonDestinations('Summer')">☀️<span>Summer</span><small>March - May</small></button>
                    <button type="button" class="choice-button season-choice" onclick="findSeasonDestinations('Rainy')">🌧️<span>Rainy</span><small>June - September</small></button>
                    <button type="button" class="choice-button season-choice" onclick="findSeasonDestinations('Autumn')">🍂<span>Autumn</span><small>October - November</small></button>
                    <button type="button" class="choice-button season-choice" onclick="findSeasonDestinations('Winter')">❄️<span>Winter</span><small>December - February</small></button>
                </div>
            </div>
        </section>

        <!-- RESULTS SECTION -->
        <section id="results-section" class="results-section">
            <div class="results-header">
                <div>
                    <h2 id="results-title">Recommended Destinations</h2>
                    <p id="results-subtitle">Explore destinations selected for you.</p>
                </div>
                <span id="result-count" class="result-count">0 destinations</span>
            </div>

            <div id="loading-state" class="state-box hidden">
                <div class="loader"></div>
                <h3>Finding destinations...</h3>
                <p>We are matching destinations with your preferences.</p>
            </div>

            <div id="error-state" class="state-box error-state hidden">
                <div class="state-icon">⚠️</div>
                <h3>Something went wrong</h3>
                <p id="error-message">Unable to load recommendations.</p>
            </div>

            <div id="empty-state" class="state-box hidden">
                <div class="state-icon">🔍</div>
                <h3>No destinations found</h3>
                <p>Try another budget, mood or season.</p>
            </div>

            <div id="destination-grid" class="destination-grid"></div>

            <div id="pagination" class="pagination"></div>
        </section>
    </main>

    <!-- RIGHT SIDE: Sidebar User Integration -->
    <aside class="recommendation-sidebar">
        <jsp:include page="sidebaruser.jsp" />
    </aside>
</div>

<script>
    window.APP_CONTEXT_PATH = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/js/apiConfig.js"></script>
<script src="${pageContext.request.contextPath}/js/recommendation.js"></script>

<!-- =========================================================
     AUTO-APPLY FILTERS FROM QUICK-FILTER LINKS
     (dashboard "Quick Filters" / filter tiles link here with
     ?mode=... query params; this reads them and triggers the
     matching tab + search using the EXISTING functions above,
     no backend changes needed)
     ========================================================= -->
<script>
document.addEventListener("DOMContentLoaded", function () {
    var params = new URLSearchParams(window.location.search);
    var mode = params.get("mode");
    if (!mode) return;

    setTimeout(function () {
        if (typeof switchRecommendationMode === "function") {
            switchRecommendationMode(mode);
        }

        if (mode === "personalized") {
            var minB = params.get("minBudget");
            var maxB = params.get("maxBudget");
            var season = params.get("season");
            var mood = params.get("mood");
            var category = params.get("category");
            var companion = params.get("companion");

            var minEl = document.getElementById("personalMinBudget");
            var maxEl = document.getElementById("personalMaxBudget");
            var seasonEl = document.getElementById("personalSeason");
            var moodEl = document.getElementById("personalMood");
            var categoryEl = document.getElementById("personalCategory");
            var companionEl = document.getElementById("personalCompanion");

            if (minB && minEl) minEl.value = minB;
            if (maxB && maxEl) maxEl.value = maxB;
            if (season && seasonEl) seasonEl.value = season;
            if (mood && moodEl) moodEl.value = mood;
            if (category && categoryEl) categoryEl.value = category;
            if (companion && companionEl) companionEl.value = companion;

            if ((minB || maxB || season || mood || category || companion) &&
                typeof findPersonalizedDestinations === "function") {
                findPersonalizedDestinations();
            }
        } else if (mode === "budget") {
            var minBudget = params.get("minBudget");
            var maxBudget = params.get("maxBudget");
            var minBudgetEl = document.getElementById("minBudget");
            var maxBudgetEl = document.getElementById("maxBudget");

            if (minBudget && minBudgetEl) minBudgetEl.value = minBudget;
            if (maxBudget && maxBudgetEl) maxBudgetEl.value = maxBudget;

            if ((minBudget || maxBudget) && typeof findBudgetDestinations === "function") {
                findBudgetDestinations();
            }
        } else if (mode === "mood") {
            var mood2 = params.get("mood");
            if (mood2 && typeof findMoodDestinations === "function") {
                findMoodDestinations(mood2);
            }
        } else if (mode === "season") {
            var season2 = params.get("season");
            if (season2 && typeof findSeasonDestinations === "function") {
                findSeasonDestinations(season2);
            }
        }
    }, 60);
});
</script>

</body>
</html>