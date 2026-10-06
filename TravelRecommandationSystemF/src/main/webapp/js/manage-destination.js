const API_BASE_URL = API_CONFIG.api("/api/destinations");
let destinationsData = [];

// PAGINATION CONFIGURATION
let currentPage = 1;
const rowsPerPage = 5; 
document.addEventListener("DOMContentLoaded", () => {
    loadDestinations();
});

// ==========================================
// 1. FETCH ALL DESTINATIONS FROM BACKEND
// ==========================================
function loadDestinations() {
    fetch(API_BASE_URL)
        .then(response => response.json())
        .then(data => {
            destinationsData = data;
            currentPage = 1; 
            renderTable();
        })
        .catch(error => {
            console.error("Error fetching destinations:", error);
            document.getElementById("destinationsTableBody").innerHTML = `
                <tr>
                    <td colspan="7" style="text-align: center; color: #dc2626; padding: 20px;">
                        Failed to connect to Spring Boot Server! Check port 8091.
                    </td>
                </tr>`;
        });
}

// ==========================================
// 2. RENDER TABLE WITH PAGINATION
// ==========================================
function renderTable() {
    const tableBody = document.getElementById("destinationsTableBody");
    tableBody.innerHTML = "";

    if (!destinationsData || destinationsData.length === 0) {
        tableBody.innerHTML = `
            <tr>
                <td colspan="7" style="text-align: center; color: #64748b; padding: 20px;">
                    No destinations found in database.
                </td>
            </tr>`;
        updatePaginationControls(0);
        return;
    }

    
    const start = (currentPage - 1) * rowsPerPage;
    const end = start + rowsPerPage;
    const paginatedItems = destinationsData.slice(start, end);

    paginatedItems.forEach(dest => {
        const row = document.createElement("tr");
        row.innerHTML = `
            <td>${dest.id}</td>
            <td style="font-weight: 600; color: #1e293b;">${dest.destinationName || '-'}</td>
            <td>${dest.state || '-'}</td>
            <td>${dest.country || '-'}</td>
            <td>${dest.category || '-'}</td>
            <td>$${dest.budget ? dest.budget.toFixed(2) : '0.00'}</td>
            <td>
                <div class="action-btns">
                    <button class="btn-action btn-view" title="View" onclick="viewDestination(${dest.id})">
                        <i class="fa-solid fa-eye"></i>
                    </button>
                    <button class="btn-action btn-edit" title="Edit" onclick="editDestination(${dest.id})">
                        <i class="fa-solid fa-pen"></i>
                    </button>
                    <button class="btn-action btn-delete" title="Delete" onclick="deleteDestination(${dest.id})">
                        <i class="fa-solid fa-trash"></i>
                    </button>
                </div>
            </td>
        `;
        tableBody.appendChild(row);
    });

    updatePaginationControls(destinationsData.length);
}

// ==========================================
// 3. PAGINATION CONTROLS & UI UPDATES
// ==========================================
function updatePaginationControls(totalItems) {
    const totalPages = Math.ceil(totalItems / rowsPerPage) || 1;
    
    // Page Info text (उदा. Showing 1 to 5 of 12 entries)
    const pageInfo = document.getElementById("pageInfo");
    if (pageInfo) {
        const startItem = totalItems === 0 ? 0 : (currentPage - 1) * rowsPerPage + 1;
        const endItem = Math.min(currentPage * rowsPerPage, totalItems);
        pageInfo.innerText = `Showing ${startItem} to ${endItem} of ${totalItems} entries`;
    }

    // Previous & Next Buttons Enable / Disable
    const prevBtn = document.getElementById("prevBtn");
    const nextBtn = document.getElementById("nextBtn");
    
    if (prevBtn) prevBtn.disabled = currentPage === 1;
    if (nextBtn) nextBtn.disabled = currentPage === totalPages || totalItems === 0;

    // Page Number Buttons तयार करणे
    const pageNumbersContainer = document.getElementById("pageNumbers");
    if (pageNumbersContainer) {
        pageNumbersContainer.innerHTML = "";
        for (let i = 1; i <= totalPages; i++) {
            const btn = document.createElement("button");
            btn.innerText = i;
            btn.style.cssText = `
                padding: 6px 12px;
                border-radius: 6px;
                border: 1px solid #cbd5e1;
                cursor: pointer;
                background: ${i === currentPage ? '#2563eb' : '#fff'};
                color: ${i === currentPage ? '#fff' : '#1e293b'};
                font-weight: ${i === currentPage ? '600' : '400'};
            `;
            btn.onclick = () => goToPage(i);
            pageNumbersContainer.appendChild(btn);
        }
    }
}

function prevPage() {
    if (currentPage > 1) {
        currentPage--;
        renderTable();
    }
}

function nextPage() {
    const totalPages = Math.ceil(destinationsData.length / rowsPerPage);
    if (currentPage < totalPages) {
        currentPage++;
        renderTable();
    }
}

function goToPage(pageNumber) {
    currentPage = pageNumber;
    renderTable();
}

// ==========================================
// 4. SAVE / UPDATE DESTINATION WITH IMAGE
// ==========================================
function saveDestination(event) {
    event.preventDefault();

    const formData = new FormData();
    const id = document.getElementById("destinationId").value;
    
    if (id) {
        formData.append("id", id);
    }
    
    formData.append("destinationName", document.getElementById("destinationName").value);
    formData.append("state", document.getElementById("state").value);
    formData.append("country", document.getElementById("country").value);
    formData.append("category", document.getElementById("category").value);
    formData.append("budget", document.getElementById("budget").value || 0.0);
    formData.append("bestSeason", document.getElementById("bestSeason").value);
    formData.append("description", document.getElementById("description").value);
    formData.append("existingImage", document.getElementById("existingImage").value);

    const fileInput = document.getElementById("imageFile");
    if (fileInput.files.length > 0) {
        formData.append("imageFile", fileInput.files[0]);
    }

    fetch(`${API_BASE_URL}/upload`, {
        method: "POST",
        body: formData
    })
    .then(response => response.text())
    .then(message => {
        alert(message);
        closeModal("destinationModal");
        document.getElementById("addDestinationForm").reset();
        loadDestinations();
    })
    .catch(error => {
        console.error("Error saving destination:", error);
        alert("Failed to save destination.");
    });
}

// ==========================================
// 5. VIEW DESTINATION DETAILS (PORT 8091 IMAGE FIX)
// ==========================================
function viewDestination(id) {
    const dest = destinationsData.find(d => d.id === id);
    if (!dest) return;

    let imageSrc = dest.image ? dest.image : 'images/default.jpg';
    
    // जर इमेज Direct URL (http/https) नसेल, तर Spring Boot Port (8091) लावणे
    if (!imageSrc.startsWith('http://') && !imageSrc.startsWith('https://')) {
        const cleanPath = imageSrc.startsWith('/') ? imageSrc.substring(1) : imageSrc;
        imageSrc = API_CONFIG.BASE_URL + "/" + cleanPath;
    }

    const content = document.getElementById("viewDetailsContent");
    content.innerHTML = `
        <div style="text-align: center; margin-bottom: 15px;">
            <img src="${imageSrc}" 
                 alt="${dest.destinationName}" 
                 style="width: 100%; max-height: 220px; object-fit: cover; border-radius: 10px; border: 1px solid #cbd5e1;"
                 onerror="this.onerror=null; this.src='https://via.placeholder.com/400x200?text=No+Image+Available';">
        </div>
        <p><strong>Destination:</strong> ${dest.destinationName || '-'}</p>
        <p><strong>State & Country:</strong> ${dest.state || '-'}, ${dest.country || '-'}</p>
        <p><strong>Category:</strong> ${dest.category || '-'}</p>
        <p><strong>Budget:</strong> $${dest.budget ? dest.budget.toFixed(2) : '0.00'}</p>
        <p><strong>Best Season:</strong> ${dest.bestSeason || 'N/A'}</p>
        <p><strong>Description:</strong> ${dest.description || 'No description available.'}</p>
    `;
    
    document.getElementById("viewModal").style.display = "flex";
}

// ==========================================
// 6. EDIT DESTINATION
// ==========================================
function editDestination(id) {
    const dest = destinationsData.find(d => d.id === id);
    if (!dest) return;

    document.getElementById("modalTitle").innerText = "Edit Destination Details";
    document.getElementById("destinationId").value = dest.id;
    document.getElementById("existingImage").value = dest.image || '';
    
    document.getElementById("destinationName").value = dest.destinationName || '';
    document.getElementById("state").value = dest.state || '';
    document.getElementById("country").value = dest.country || '';
    document.getElementById("category").value = dest.category || 'City';
    document.getElementById("budget").value = dest.budget || '';
    document.getElementById("bestSeason").value = dest.bestSeason || '';
    document.getElementById("description").value = dest.description || '';
    
    document.getElementById("imageFile").required = false; // Edit करताना फोटो ऐच्छिक राहील
    const imageNote = document.getElementById("imageNote");
    if (imageNote) imageNote.innerText = "(Leave empty to keep current image)";

    document.getElementById("destinationModal").style.display = "flex";
}

// ==========================================
// 7. DELETE DESTINATION
// ==========================================
function deleteDestination(id) {
    if (confirm("Are you sure you want to delete this destination?")) {
        fetch(`${API_BASE_URL}/${id}`, {
            method: "DELETE"
        })
        .then(response => response.text())
        .then(message => {
            alert(message);
            loadDestinations();
        })
        .catch(error => {
            console.error("Error deleting destination:", error);
            alert("Failed to delete destination.");
        });
    }
}

// ==========================================
// 8. MODAL CONTROLS
// ==========================================
function openAddModal() {
    document.getElementById("modalTitle").innerText = "Add Destination Details";
    document.getElementById("destinationId").value = "";
    document.getElementById("existingImage").value = "";
    document.getElementById("imageFile").required = true;
    const imageNote = document.getElementById("imageNote");
    if (imageNote) imageNote.innerText = "";
    document.getElementById("addDestinationForm").reset();
    document.getElementById("destinationModal").style.display = "flex";
}

function closeModal(modalId) {
    document.getElementById(modalId).style.display = "none";
}