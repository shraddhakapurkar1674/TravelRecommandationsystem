let userGrowthChart = null;
let destinationChart = null;
let preferenceChart = null;
let ratingChart = null;

document.addEventListener("DOMContentLoaded", function () {
    loadReports();
});

async function loadReports() {
    showLoading();

    try {
        const response = await fetch(
            API_CONFIG.api("/api/admin/reports/analytics?period=6m&category=all")
        );

        if (!response.ok) {
            throw new Error(
                "Server returned " +
                response.status
            );
        }

        const data = await response.json();
        console.log("Report data:", data);

        displayStatistics(data.statistics);
        createUserGrowthChart(data.monthlyUsers || []);
        createDestinationChart(data.destinationCategories || []);
        createPreferenceChart(data.travelPreferences || []);
        createRatingChart(data.ratingDistribution || []);
        displayTopDestinations(data.topDestinations || []);

        hideError();

    } catch (error) {
        console.error("Report error:", error);
        showError(
            "Unable to load report data. Check your server and database connection."
        );
    }
}

function displayStatistics(statistics) {
    if (!statistics) return;

    setValue("totalUsers", statistics.totalUsers);
    setValue("totalDestinations", statistics.totalDestinations);
    setValue("totalHotels", statistics.totalHotels);
    setValue("totalTransports", statistics.totalTransports);
    setValue("totalActivities", statistics.totalActivities);
    setValue("totalPackages", statistics.totalPackages);
    setValue("totalReviews", statistics.totalReviews);

    const rating = Number(statistics.averageRating || 0);
    setValue("averageRating", rating.toFixed(1));
}

function setValue(id, value) {
    const element = document.getElementById(id);
    if (element) {
        element.textContent = value == null ? 0 : value;
    }
}

function createUserGrowthChart(monthlyUsers) {
    const canvas = document.getElementById("userGrowthChart");
    if (!canvas) return;

    if (userGrowthChart) userGrowthChart.destroy();

    userGrowthChart = new Chart(canvas, {
        type: "line",
        data: {
            labels: getLastSixMonths(),
            datasets: [{
                label: "Users",
                data: monthlyUsers,
                borderColor: "#6c63ff",
                backgroundColor: "rgba(108,99,255,0.12)",
                borderWidth: 3,
                fill: true,
                tension: 0.4,
                pointRadius: 4,
                pointBackgroundColor: "#6c63ff"
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, ticks: { precision: 0 } },
                x: { grid: { display: false } }
            }
        }
    });
}

function createDestinationChart(categories) {
    const canvas = document.getElementById("destinationChart");
    if (!canvas) return;

    if (destinationChart) destinationChart.destroy();

    if (!categories || !categories.length) {
        showEmptyChart(canvas, "No destination category data");
        return;
    }

    destinationChart = new Chart(canvas, {
        type: "doughnut",
        data: {
            labels: categories.map(item => item.name),
            datasets: [{
                data: categories.map(item => item.value),
                backgroundColor: ["#6c63ff", "#22c55e", "#f59e0b", "#3b82f6", "#ec4899", "#14b8a6"],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: "65%",
            plugins: { legend: { position: "bottom" } }
        }
    });
}

function createPreferenceChart(preferences) {
    const canvas = document.getElementById("preferenceChart");
    if (!canvas) return;

    if (preferenceChart) preferenceChart.destroy();

    if (!preferences || !preferences.length) {
        showEmptyChart(canvas, "No travel preference data");
        return;
    }

    preferenceChart = new Chart(canvas, {
        type: "bar",
        data: {
            labels: preferences.map(item => item.name),
            datasets: [{
                label: "Preference %",
                data: preferences.map(item => item.value),
                backgroundColor: "#6c63ff",
                borderRadius: 8,
                borderSkipped: false
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, max: 100, ticks: { callback: value => value + "%" } },
                x: { grid: { display: false } }
            }
        }
    });
}

function createRatingChart(ratings) {
    const canvas = document.getElementById("ratingChart");
    if (!canvas) return;

    if (ratingChart) ratingChart.destroy();

    if (!ratings || !ratings.length) {
        showEmptyChart(canvas, "No review data");
        return;
    }

    ratingChart = new Chart(canvas, {
        type: "bar",
        data: {
            labels: ratings.map(item => item.star + " Stars"),
            datasets: [{
                label: "Reviews %",
                data: ratings.map(item => item.value),
                backgroundColor: "#f59e0b",
                borderRadius: 8
            }]
        },
        options: {
            indexAxis: "y",
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                x: { beginAtZero: true, max: 100, ticks: { callback: value => value + "%" } },
                y: { grid: { display: false } }
            }
        }
    });
}

function displayTopDestinations(destinations) {
    const container = document.getElementById("topDestinations");
    if (!container) return;

    container.innerHTML = "";

    if (!destinations || !destinations.length) {
        container.innerHTML = '<div class="empty-data">No destination data available</div>';
        return;
    }

    destinations.forEach(destination => {
        const item = document.createElement("div");
        item.className = "destination-item";

        const info = document.createElement("div");
        info.className = "destination-info";

        const name = document.createElement("span");
        name.className = "destination-name";
        name.textContent = destination.name || "Destination";

        const meta = document.createElement("span");
        meta.className = "destination-meta";
        meta.textContent = [destination.state, destination.country].filter(Boolean).join(", ");

        info.appendChild(name);
        info.appendChild(meta);

        const category = document.createElement("span");
        category.className = "destination-category";
        category.textContent = destination.category || "Travel";

        item.appendChild(info);
        item.appendChild(category);
        container.appendChild(item);
    });
}

function getLastSixMonths() {
    const months = [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];

    const result = [];
    const today = new Date();

    for (let i = 5; i >= 0; i--) {
        const date = new Date(
            today.getFullYear(),
            today.getMonth() - i,
            1
        );

        result.push(
            months[date.getMonth()]
        );
    }

    return result;
}

function showEmptyChart(canvas, message) {
    const parent = canvas.parentElement;
    parent.innerHTML = '<div class="empty-data">' + message + '</div>';
}

function showError(message) {
    const element = document.getElementById("reportError");
    if (!element) return;
    element.textContent = message;
    element.style.display = "block";
}

function hideError() {
    const element = document.getElementById("reportError");
    if (element) element.style.display = "none";
}

function showLoading() {
    setValue("totalUsers", "...");
    setValue("totalDestinations", "...");
    setValue("totalHotels", "...");
    setValue("totalTransports", "...");
}