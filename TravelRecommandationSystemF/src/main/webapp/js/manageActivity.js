const API_BASE_URL = API_CONFIG.api("/api/admin/activities");
const DESTINATION_API_URL = API_CONFIG.api("/api/destinations");

let currentActivities = [];
let currentPage = 0;
const pageSize = 5;
let totalPages = 0;
let destinationList = [];

// Helper function to send JWT Token in HTTP Headers
function getAuthHeaders() {
    const token = localStorage.getItem("jwt_token");
    return {
        "Content-Type": "application/json",
        "Authorization": token ? `Bearer ${token}` : ""
    };
}

document.addEventListener("DOMContentLoaded", () => {
    fetchDestinations();
    fetchActivitiesPaginated(currentPage);
});

// Toast Notification System
function showNotification(message, type = "success") {
    let container = document.getElementById("toast-container");
    if (!container) {
        container = document.createElement("div");
        container.id = "toast-container";
        document.body.appendChild(container);
    }

    const toast = document.createElement("div");
    toast.className = `custom-toast ${type}`;

    const icon = type === "success" 
        ? `<i class="fa-solid fa-circle-check" style="font-size:18px;"></i>` 
        : `<i class="fa-solid fa-triangle-exclamation" style="font-size:18px;"></i>`;

    toast.innerHTML = `${icon} <span>${message}</span>`;
    container.appendChild(toast);

    setTimeout(() => {
        toast.style.animation = "fadeOut 0.4s ease-in-out forwards";
        setTimeout(() => toast.remove(), 400);
    }, 3500);
}

// 1. Load Destinations
function fetchDestinations() {
    fetch(DESTINATION_API_URL, {
        method: "GET",
        headers: getAuthHeaders()
    })
    .then(res => {
        if (!res.ok) throw new Error("Failed to load destinations");
        return res.json();
    })
    .then(data => {
        destinationList = data || [];
        populateDestinationDropdown();
    })
    .catch(err => console.warn("Destination load error:", err.message));
}

function populateDestinationDropdown() {
    const select = document.getElementById("destinationId");
    if (!select) return;

    const currentValue = select.value;
    select.innerHTML = `<option value="">-- Select Destination --</option>`;

    if (!destinationList || destinationList.length === 0) return;

    destinationList.forEach(dest => {
        const id = dest.destinationId || dest.destination_id || dest.id;
        const name = dest.destinationName || dest.destination_name || dest.name;

        if (id && name) {
            const option = document.createElement("option");
            option.value = id;
            option.textContent = name;
            select.appendChild(option);
        }
    });

    if (currentValue) select.value = currentValue;
}

function getDestinationNameById(destId) {
    if (!destinationList || destinationList.length === 0) return destId || "N/A";
    const dest = destinationList.find(d => (d.destinationId || d.id || d.destination_id) == destId);
    return dest ? (dest.destinationName || dest.name || dest.destination_name) : destId;
}

function handleFileSelect(event) {
    const file = event.target.files[0];
    const imageInput = document.getElementById("image");
    const nameLabel = document.getElementById("existingImageName");

    if (file) {
        if (imageInput) imageInput.value = file.name;
        if (nameLabel) nameLabel.innerText = `Selected: ${file.name}`;
    }
}

// 2. Fetch Paginated Activities
function fetchActivitiesPaginated(page) {
    fetch(`${API_BASE_URL}/page?page=${page}&size=${pageSize}`, {
        method: "GET",
        headers: getAuthHeaders()
    })
    .then(async response => {
        if (response.status === 401 || response.status === 403) {
            showNotification("Session expired or unauthorized. Please log in again.", "error");
            setTimeout(() => {
                window.location.href = "login.html";
            }, 2000);
            return;
        }
        const data = await response.json().catch(() => null);
        if (!response.ok) {
            const errorMsg = data && (data.error || data.message) ? (data.error || data.message) : "Failed to load activities.";
            throw new Error(errorMsg);
        }
        return data;
    })
    .then(data => {
        if (!data) return;
        currentActivities = data.activities || [];
        currentPage = data.currentPage;
        totalPages = data.totalPages;
        renderTable(currentActivities);
        renderPagination();
    })
    .catch(err => showNotification(err.message, "error"));
}

// 3. Render Activities Table
function renderTable(data) {
    const tbody = document.getElementById("activityTableBody");
    if (!tbody) return;
    tbody.innerHTML = "";

    if (!data || data.length === 0) {
        tbody.innerHTML = `<tr><td colspan="8" style="text-align:center; color:#8f9bba; padding:20px;">No activity records found</td></tr>`;
        return;
    }

    data.forEach(activity => {
        const destName = activity.destinationName || getDestinationNameById(activity.destinationId);
        const statusBadge = activity.status === "Active" 
            ? `<span class="badge-active">Active</span>` 
            : `<span class="badge-inactive">Inactive</span>`;

        const tr = document.createElement("tr");
        tr.innerHTML = `
            <td>#${activity.activityId}</td>
            <td><strong>${activity.activityName || 'N/A'}</strong></td>
            <td>${destName}</td>
            <td><span class="category-badge">${activity.category || 'N/A'}</span></td>
            <td><span class="pricing-badge">₹${activity.price ? activity.price.toFixed(2) : '0.00'}</span></td>
            <td>${activity.duration || 'N/A'}</td>
            <td>${statusBadge}</td>
            <td>
                <div class="action-btns">
                    <button class="btn-act btn-view" title="View Details" onclick="viewActivityDetails(${activity.activityId})">
                        <i class="fa-solid fa-eye"></i>
                    </button>
                    <button class="btn-act btn-edit" title="Edit Activity" onclick="openEditModal(${activity.activityId})">
                        <i class="fa-solid fa-pen-to-square"></i>
                    </button>
                    <button class="btn-act btn-delete" title="Delete Activity" onclick="deleteActivity(${activity.activityId})">
                        <i class="fa-solid fa-trash-can"></i>
                    </button>
                </div>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

// 4. Pagination
function renderPagination() {
    const container = document.getElementById("paginationControls");
    if (!container) return;
    container.innerHTML = "";

    if (totalPages <= 1) return;

    const prevBtn = document.createElement("button");
    prevBtn.className = "page-btn";
    prevBtn.innerHTML = `<i class="fa-solid fa-chevron-left"></i> Previous`;
    prevBtn.disabled = currentPage === 0;
    prevBtn.onclick = () => fetchActivitiesPaginated(currentPage - 1);
    container.appendChild(prevBtn);

    for (let i = 0; i < totalPages; i++) {
        const pageBtn = document.createElement("button");
        pageBtn.className = `page-btn ${i === currentPage ? 'active' : ''}`;
        pageBtn.innerText = i + 1;
        pageBtn.onclick = () => fetchActivitiesPaginated(i);
        container.appendChild(pageBtn);
    }

    const nextBtn = document.createElement("button");
    nextBtn.className = "page-btn";
    nextBtn.innerHTML = `Next <i class="fa-solid fa-chevron-right"></i>`;
    nextBtn.disabled = currentPage >= totalPages - 1;
    nextBtn.onclick = () => fetchActivitiesPaginated(currentPage + 1);
    container.appendChild(nextBtn);
}

// Search Filter
function filterTable() {
    const query = document.getElementById("searchInput").value.toLowerCase();
    const filtered = currentActivities.filter(a => {
        const destName = (a.destinationName || getDestinationNameById(a.destinationId)).toLowerCase();
        return (
            (a.activityName && a.activityName.toLowerCase().includes(query)) ||
            (a.category && a.category.toLowerCase().includes(query)) ||
            destName.includes(query)
        );
    });
    renderTable(filtered);
}

// 5. Open Add Modal
function openAddModal() {
    document.getElementById("modalTitle").innerText = "Add Activity";
    document.getElementById("activityForm").reset();
    document.getElementById("activityId").value = "";
    document.getElementById("image").value = "";
    document.getElementById("existingImageName").innerText = "";
    document.getElementById("activityModal").style.display = "flex";
}

// 6. Open Edit Modal
function openEditModal(id) {
    const activity = currentActivities.find(a => a.activityId === id);
    if (!activity) return;

    document.getElementById("modalTitle").innerText = "Edit Activity";
    document.getElementById("activityId").value = activity.activityId;
    document.getElementById("destinationId").value = activity.destinationId;
    document.getElementById("activityName").value = activity.activityName;
    document.getElementById("category").value = activity.category;
    document.getElementById("price").value = activity.price;
    document.getElementById("duration").value = activity.duration;
    document.getElementById("description").value = activity.description || "";
    document.getElementById("status").value = activity.status;
    document.getElementById("image").value = activity.image || "";
    
    document.getElementById("existingImageName").innerText = activity.image ? `Current: ${activity.image}` : "";
    document.getElementById("activityModal").style.display = "flex";
}

function closeModal() {
    document.getElementById("activityModal").style.display = "none";
}

// 7. Save / Update Activity
function saveActivity(event) {
    event.preventDefault();

    const activityId = document.getElementById("activityId").value;
    const isEdit = activityId !== "";

    const payload = {
        destinationId: parseInt(document.getElementById("destinationId").value),
        activityName: document.getElementById("activityName").value.trim(),
        category: document.getElementById("category").value,
        price: parseFloat(document.getElementById("price").value),
        duration: document.getElementById("duration").value.trim(),
        description: document.getElementById("description").value.trim(),
        image: document.getElementById("image").value,
        status: document.getElementById("status").value
    };

    const url = isEdit ? `${API_BASE_URL}/${activityId}` : API_BASE_URL;
    const method = isEdit ? "PUT" : "POST";

    fetch(url, {
        method: method,
        headers: getAuthHeaders(),
        body: JSON.stringify(payload)
    })
    .then(async res => {
        const data = await res.json().catch(() => null);
        if (!res.ok) {
            const error = data && data.error ? data.error : "Failed to save activity record.";
            throw new Error(error);
        }
        return data;
    })
    .then(data => {
        showNotification(data.message || (isEdit ? "Activity updated!" : "Activity saved!"), "success");
        closeModal();
        fetchActivitiesPaginated(currentPage);
    })
    .catch(err => showNotification(err.message, "error"));
}

// 8. View Activity
function viewActivityDetails(id) {
    fetch(`${API_BASE_URL}/${id}`, {
        method: "GET",
        headers: getAuthHeaders()
    })
    .then(res => {
        if (!res.ok) throw new Error("Could not retrieve activity details");
        return res.json();
    })
    .then(activity => {
        const destName = activity.destinationName || getDestinationNameById(activity.destinationId);
        const imageUrl = activity.image ? activity.image : 'https://via.placeholder.com/600x220?text=No+Image+Available';

        const detailsBody = document.getElementById("viewActivityDetails");
        detailsBody.innerHTML = `
            <div class="view-card-image-container">
                <img src="${imageUrl}" alt="${activity.activityName}" class="view-card-img" onerror="this.src='https://via.placeholder.com/600x220?text=Image+Not+Found'">
            </div>
            <div class="view-card-info-grid">
                <div class="view-info-item">
                    <span class="info-label">Activity Name</span>
                    <span class="info-value"><strong>${activity.activityName}</strong></span>
                </div>
                <div class="view-info-item">
                    <span class="info-label">Destination</span>
                    <span class="info-value">${destName}</span>
                </div>
                <div class="view-info-item">
                    <span class="info-label">Category</span>
                    <span class="info-value">${activity.category}</span>
                </div>
                <div class="view-info-item">
                    <span class="info-label">Price</span>
                    <span class="info-value">₹${activity.price ? activity.price.toFixed(2) : '0.00'}</span>
                </div>
                <div class="view-info-item">
                    <span class="info-label">Duration</span>
                    <span class="info-value">${activity.duration}</span>
                </div>
                <div class="view-info-item">
                    <span class="info-label">Status</span>
                    <span class="info-value">${activity.status}</span>
                </div>
                <div class="view-info-item full-width">
                    <span class="info-label">Description</span>
                    <p class="info-description">${activity.description || 'No description provided.'}</p>
                </div>
            </div>
        `;
        document.getElementById("viewActivityModal").style.display = "flex";
    })
    .catch(err => showNotification(err.message, "error"));
}

function closeViewModal() {
    document.getElementById("viewActivityModal").style.display = "none";
}

// 9. Delete Activity
function deleteActivity(id) {
    if (!confirm("Are you sure you want to delete this activity?")) return;

    fetch(`${API_BASE_URL}/${id}`, { 
        method: "DELETE",
        headers: getAuthHeaders()
    })
    .then(async res => {
        const data = await res.json().catch(() => null);
        if (!res.ok) {
            const error = data && data.error ? data.error : "Failed to delete activity.";
            throw new Error(error);
        }
        return data;
    })
    .then(data => {
        showNotification(data.message || "Activity deleted successfully!", "success");
        fetchActivitiesPaginated(currentPage);
    })
    .catch(err => showNotification(err.message, "error"));
}