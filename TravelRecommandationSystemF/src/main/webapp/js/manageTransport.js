const API_BASE_URL = API_CONFIG.api("/api/admin/transports");

let currentTransports = [];
let currentPage = 0;
const pageSize = 5;
let totalPages = 0;

document.addEventListener("DOMContentLoaded", () => {
    fetchTransportsPaginated(currentPage);
});

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

function fetchTransportsPaginated(page) {
    fetch(`${API_BASE_URL}/page?page=${page}&size=${pageSize}`)
        .then(async response => {
            const data = await response.json().catch(() => null);
            if (!response.ok) {
                const errorMsg = data && (data.error || data.message) ? (data.error || data.message) : "Failed to load transport data.";
                throw new Error(errorMsg);
            }
            return data;
        })
        .then(data => {
            currentTransports = data.transports || [];
            currentPage = data.currentPage;
            totalPages = data.totalPages;
            renderTable(currentTransports);
            renderPagination();
        })
        .catch(err => showNotification(err.message, "error"));
}

function renderTable(data) {
    const tbody = document.getElementById("transportTableBody");
    tbody.innerHTML = "";

    if (!data || data.length === 0) {
        tbody.innerHTML = `<tr><td colspan="8" style="text-align:center; color:#8f9bba; padding:20px;">No transport records found</td></tr>`;
        return;
    }

    data.forEach(item => {
        const pricingDisplay = item.pricingType === "PER_KM" 
            ? `₹${item.pricingValue}/km` 
            : `₹${item.pricingValue}`;

        const tr = document.createElement("tr");
        tr.innerHTML = `
            <td>${item.transportId}</td>
            <td><b>${item.destination}</b></td>
            <td>${item.transportType}</td>
            <td>${item.transportProvider}</td>
            <td class="pricing-badge">${pricingDisplay}</td>
            <td>${item.facilities || '-'}</td>
            <td>₹${item.facilityCharge}</td>
            <td>
                <div class="action-btns">
                    <button class="btn-act btn-edit" onclick="openEditModal(${item.transportId})">
                        <i class="fa-solid fa-pen"></i>
                    </button>
                    <button class="btn-act btn-delete" onclick="deleteTransport(${item.transportId})">
                        <i class="fa-solid fa-trash"></i>
                    </button>
                </div>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

function renderPagination() {
    const paginationContainer = document.getElementById("paginationControls");
    paginationContainer.innerHTML = "";

    if (totalPages <= 1) return;

    let html = `<button class="page-btn" ${currentPage === 0 ? "disabled" : ""} onclick="changePage(${currentPage - 1})"><i class="fa-solid fa-chevron-left"></i></button>`;

    for (let i = 0; i < totalPages; i++) {
        html += `<button class="page-btn ${i === currentPage ? "active" : ""}" onclick="changePage(${i})">${i + 1}</button>`;
    }

    html += `<button class="page-btn" ${currentPage >= totalPages - 1 ? "disabled" : ""} onclick="changePage(${currentPage + 1})"><i class="fa-solid fa-chevron-right"></i></button>`;

    paginationContainer.innerHTML = html;
}

function changePage(page) {
    if (page >= 0 && page < totalPages) {
        fetchTransportsPaginated(page);
    }
}

function handleTypeChange() {
    const type = document.getElementById("transportType").value;
    const pricingTypeSelect = document.getElementById("pricingType");
    const pricingLabel = document.getElementById("pricingValueLabel");

    if (type === "Bus" || type === "Cab") {
        pricingTypeSelect.value = "PER_KM";
        pricingLabel.innerText = "Rate / KM (₹)";
    } else if (type === "Train" || type === "Air") {
        pricingTypeSelect.value = "PER_TICKET";
        pricingLabel.innerText = "Base Ticket Price (₹)";
    }
}

function openAddModal() {
    document.getElementById("modalTitle").innerText = "Add Transport";
    document.getElementById("transportForm").reset();
    document.getElementById("transportId").value = "";
    document.getElementById("transportModal").style.display = "flex";
}

function closeModal() {
    document.getElementById("transportModal").style.display = "none";
}

function openEditModal(id) {
    const item = currentTransports.find(t => t.transportId === id);
    if (!item) {
        // Fallback fetch single record directly if not found in current view page
        fetch(`${API_BASE_URL}/${id}`)
            .then(res => res.json())
            .then(data => populateAndShowModal(data))
            .catch(() => showNotification("Could not fetch record details", "error"));
        return;
    }
    populateAndShowModal(item);
}

function populateAndShowModal(item) {
    document.getElementById("modalTitle").innerText = "Edit Transport";
    document.getElementById("transportId").value = item.transportId;
    document.getElementById("destination").value = item.destination;
    document.getElementById("transportType").value = item.transportType;
    document.getElementById("transportProvider").value = item.transportProvider;
    document.getElementById("pricingType").value = item.pricingType;
    document.getElementById("pricingValue").value = item.pricingValue;
    document.getElementById("facilities").value = item.facilities || "";
    document.getElementById("facilityCharge").value = item.facilityCharge;

    handleTypeChange();
    document.getElementById("transportModal").style.display = "flex";
}

function saveTransport(event) {
    event.preventDefault();

    const id = document.getElementById("transportId").value;
    const payload = {
        destination: document.getElementById("destination").value.trim(),
        transportType: document.getElementById("transportType").value,
        transportProvider: document.getElementById("transportProvider").value.trim(),
        pricingType: document.getElementById("pricingType").value,
        pricingValue: parseFloat(document.getElementById("pricingValue").value),
        facilities: document.getElementById("facilities").value.trim(),
        facilityCharge: parseFloat(document.getElementById("facilityCharge").value)
    };

    const isEdit = id !== "";
    const url = isEdit ? `${API_BASE_URL}/${id}` : API_BASE_URL;
    const method = isEdit ? "PUT" : "POST";

    fetch(url, {
        method: method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload)
    })
    .then(async response => {
        const data = await response.json().catch(() => null);
        if (!response.ok) {
            const errorMsg = data && (data.error || data.message) ? (data.error || data.message) : "Error occurred while saving transport.";
            throw new Error(errorMsg);
        }
        return data;
    })
    .then(data => {
        showNotification(data.message || "Transport saved successfully!", "success");
        closeModal();
        fetchTransportsPaginated(currentPage);
    })
    .catch(err => showNotification(err.message, "error"));
}

function deleteTransport(id) {
    if (confirm("Are you sure you want to delete this transport record?")) {
        fetch(`${API_BASE_URL}/${id}`, { method: "DELETE" })
            .then(async response => {
                const data = await response.json().catch(() => null);
                if (!response.ok) {
                    const errorMsg = data && (data.error || data.message) ? (data.error || data.message) : "Failed to delete transport.";
                    throw new Error(errorMsg);
                }
                return data;
            })
            .then(data => {
                showNotification(data.message || "Transport deleted successfully!", "success");
                fetchTransportsPaginated(currentPage);
            })
            .catch(err => showNotification(err.message, "error"));
    }
}

function filterTable() {
    const query = document.getElementById("searchInput").value.toLowerCase();
    
    // If search is empty, reload standard paginated data
    if (!query) {
        fetchTransportsPaginated(currentPage);
        return;
    }

    // Fetch full array to filter locally when searching
    fetch(API_BASE_URL)
        .then(res => res.json())
        .then(data => {
            const filtered = data.filter(t => 
                t.destination.toLowerCase().includes(query) || 
                t.transportProvider.toLowerCase().includes(query)
            );
            renderTable(filtered);
            document.getElementById("paginationControls").innerHTML = ""; // Disable pagination during client-side search
        });
}