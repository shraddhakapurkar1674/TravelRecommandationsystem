const API_BASE_URL = API_CONFIG.BASE_URL;

document.addEventListener("DOMContentLoaded", function () {
    loadUserBucketlist();
});

function getLoggedInUserId() {
    let userId = localStorage.getItem("userId");
    if (userId) return userId;

    userId = sessionStorage.getItem("userId");
    if (userId) return userId;

    const keys = ["loggedInUser", "user", "currentUser"];
    for (const key of keys) {
        try {
            const user = JSON.parse(localStorage.getItem(key));
            if (!user) continue;
            if (user.id != null) return user.id;
            if (user.userId != null) return user.userId;
        } catch (error) {}
    }

    for (const key of keys) {
        try {
            const user = JSON.parse(sessionStorage.getItem(key));
            if (!user) continue;
            if (user.id != null) return user.id;
            if (user.userId != null) return user.userId;
        } catch (error) {}
    }
    return null;
}

async function loadUserBucketlist() {
    const userId = getLoggedInUserId();
    const loading = document.getElementById("loadingMessage");
    const container = document.getElementById("bucketlistContainer");
    const noMsg = document.getElementById("noBucketlistMessage");
    const countEl = document.getElementById("bucketlistCount");

    if (!userId) {
        alert("Please login first!");
        window.location.href = "login.jsp";
        return;
    }

    if (loading) loading.style.display = "block";
    if (container) container.innerHTML = "";
    if (noMsg) noMsg.style.display = "none";

    try {
        const response = await fetch(`${API_BASE_URL}/api/bucketlist/user/${userId}`, {
            method: "GET",
            credentials: "include",
            headers: { "Accept": "application/json" }
        });

        if (!response.ok) throw new Error("Failed to fetch bucketlist");

        const result = await response.json();
        const destinations = result.data || result;

        if (loading) loading.style.display = "none";

        if (!Array.isArray(destinations) || destinations.length === 0) {
            if (noMsg) noMsg.style.display = "block";
            if (countEl) countEl.textContent = "0";
            return;
        }

        if (countEl) countEl.textContent = destinations.length;
        renderBucketlistCards(destinations);

    } catch (error) {
        console.error("Error loading bucketlist:", error);
        if (loading) loading.style.display = "none";
        if (noMsg) noMsg.style.display = "block";
    }
}

function renderBucketlistCards(destinations) {
    const container = document.getElementById("bucketlistContainer");
    if (!container) return;
    container.innerHTML = "";

    destinations.forEach(dest => {
        const id = dest.id || dest.destinationId;
        const name = dest.destinationName || dest.name || "Destination";
        const state = dest.state || "";
        const country = dest.country || "";
        const category = dest.category || "";
        const budget = dest.budget != null ? "₹" + Number(dest.budget).toLocaleString("en-IN") : "Not specified";
        const image = dest.imageUrl || dest.image || "";

        let imageUrl = API_BASE_URL + "/images/background.webp";
        if (image) {
            if (image.startsWith("http")) imageUrl = image;
            else if (image.startsWith("/uploads/")) imageUrl = API_BASE_URL + image;
            else imageUrl = API_BASE_URL + "/uploads/" + encodeURIComponent(image);
        }

        const card = document.createElement("div");
        card.className = "destination-card";
        card.innerHTML = `
            <div class="card-image">
                <img src="${imageUrl}" alt="${escapeHtml(name)}" onerror="this.src='${API_BASE_URL}/images/background.webp'">
                <button type="button" class="favorite-btn" onclick="removeFromBucketlist(${id})" title="Remove from Bucketlist">
                    <i class="fa-solid fa-heart" style="color: #ef4444;"></i>
                </button>
            </div>
            <div class="card-body">
                ${category ? `<span class="category-badge">${escapeHtml(category.split(',')[0])}</span>` : ""}
                <h3 class="mt-2">${escapeHtml(name)}</h3>
                <div class="location-row">
                    <i class="fa-solid fa-location-dot"></i>
                    <span>${escapeHtml([state, country].filter(Boolean).join(", "))}</span>
                </div>
                <div class="price">
                    ${budget} <span class="price-text">/ person</span>
                </div>
                <div class="card-footer">
                    <button type="button" class="view-details" onclick="window.location.href='destination-details.jsp?id=${id}'">
                        View Details <i class="fa-solid fa-arrow-right"></i>
                    </button>
                </div>
            </div>
        `;
        container.appendChild(card);
    });
}

async function removeFromBucketlist(destinationId) {
    const userId = getLoggedInUserId();
    if (!userId) return;

    try {
        const response = await fetch(`${API_BASE_URL}/api/bucketlist/remove?userId=${userId}&destinationId=${destinationId}`, {
            method: "DELETE",
            credentials: "include"
        });

        const result = await response.json();
        if (result.success) {
            alert("Removed from bucketlist successfully!");
            loadUserBucketlist();
        } else {
            alert("Failed to remove: " + (result.message || "Unknown error"));
        }
    } catch (error) {
        console.error("Error removing item:", error);
        alert("Server error while removing item.");
    }
}

function escapeHtml(value) {
    return String(value == null ? "" : value)
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
}