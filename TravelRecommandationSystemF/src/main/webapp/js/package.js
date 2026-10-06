const API_BASE = API_CONFIG.api("/api/travel-packages");

/* Package images are saved in the backend upload folder, which is served by
   /api/destinations/images/{fileName} (same endpoint the destination pages use). */
function getPackageImageUrl(imageName) {
    if (!imageName || String(imageName).trim() === "") return "";
    return API_CONFIG.destinationImage(String(imageName).trim());
}

document.addEventListener("DOMContentLoaded", () => {
    fetchPackages();
    
    const searchInput = document.getElementById("searchInput");
    if (searchInput) searchInput.addEventListener("input", filterPackages);

    const statusFilter = document.getElementById("statusFilter");
    if (statusFilter) statusFilter.addEventListener("change", filterPackages);

    const packageModal = document.getElementById("packageModal");
    if (packageModal) {
        packageModal.addEventListener("show.bs.modal", () => {
            if (currentEditId === null) {
                const container = document.getElementById("destinationsContainer");
                if (container && container.children.length === 0) {
                    addDestinationRow();
                }
            }
        });
    }
});

let packageList = [];
let currentEditId = null;

async function fetchPackages() {
    try {
        const response = await fetch(API_BASE);
        packageList = await response.json();
        renderPackages(packageList);
        updateStatistics(packageList);
    } catch (error) {
        console.error("Error fetching packages:", error);
    }
}

function renderPackages(data) {
    const grid = document.getElementById("packageGrid");
    if (!grid) return;
    grid.innerHTML = "";
    
    if (data.length === 0) {
        grid.innerHTML = `<p class="text-muted text-center">No travel packages found.</p>`;
        return;
    }

    data.forEach(item => {
        let coverImage = "";
        
        if (item.destinations && item.destinations.length > 0 && item.destinations[0].imageName) {
            let imgName = item.destinations[0].imageName.trim();
            if (imgName !== "") {
                coverImage = getPackageImageUrl(imgName);
            }
        }

        let destinationsHtml = item.destinations ? item.destinations.map(d => `<span class="badge bg-light text-dark border me-1">${d.destinationName}</span>`).join('') : '';

        let imageTag = coverImage !== "" 
            ? `<img src="${coverImage}" class="card-img-top" style="height: 180px; object-fit: cover;" onerror="this.onerror=null; this.src='https://via.placeholder.com/400x180?text=No+Image';">`
            : `<div class="bg-secondary text-white d-flex align-items-center justify-content-center" style="height: 180px;">No Image Available</div>`;

        let badgeClass = (item.status === 'Active' || !item.status) ? 'bg-success' : 'bg-secondary';

        grid.innerHTML += `
            <div class="col-md-4 mb-3">
                <div class="card shadow-sm h-100">
                    ${imageTag}
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title"><i class="bi bi-geo-alt-fill text-danger"></i> ${item.packageName}</h5>
                        <p class="card-text mb-1"><strong>Duration:</strong> ${item.duration}</p>
                        <p class="card-text mb-1"><strong>Price:</strong> $${item.price}</p>
                        <p class="card-text mb-2"><strong>Destinations:</strong><br>${destinationsHtml}</p>
                        <div class="mb-2">
                            <span class="badge ${badgeClass}">${item.status || 'Active'}</span>
                        </div>
                        
                        <div class="mt-auto pt-2 border-top d-flex justify-content-between">
                            <button class="btn btn-sm btn-outline-info" onclick="viewPackage(${item.packageId})">
                                <i class="bi bi-eye"></i> View
                            </button>
                            <button class="btn btn-sm btn-outline-primary" onclick="editPackage(${item.packageId})">
                                <i class="bi bi-pencil"></i> Edit
                            </button>
                            <button class="btn btn-sm btn-outline-danger" onclick="deletePackage(${item.packageId})">
                                <i class="bi bi-trash"></i> Delete
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        `;
    });
}

function updateStatistics(data) {
    const totalCount = document.getElementById("totalCount");
    const activeCount = document.getElementById("activeCount");
    const inactiveCount = document.getElementById("inactiveCount");

    if (totalCount) totalCount.innerText = data.length;
    if (activeCount) activeCount.innerText = data.filter(i => (i.status || 'Active') === 'Active').length;
    if (inactiveCount) inactiveCount.innerText = data.filter(i => i.status === 'Inactive').length;
}

function filterPackages() {
    const search = document.getElementById("searchInput").value.toLowerCase();
    const status = document.getElementById("statusFilter").value;

    const filtered = packageList.filter(item => {
        const matchesSearch = item.packageName.toLowerCase().includes(search) || (item.packageType && item.packageType.toLowerCase().includes(search));
        const matchesStatus = status === "" || (item.status || 'Active') === status;
        return matchesSearch && matchesStatus;
    });

    renderPackages(filtered);
}

function resetForm() {
    currentEditId = null;
    const form = document.getElementById("packageForm");
    if (form) form.reset();
    
    const modalTitle = document.getElementById("modalTitle");
    if (modalTitle) modalTitle.innerText = "Add Travel Package";

    const container = document.getElementById("destinationsContainer");
    if (container) {
        container.innerHTML = "";
        addDestinationRow(); 
    }
}

function addDestinationRow(destinationName = '', imageName = '') {
    const container = document.getElementById("destinationsContainer");
    if (!container) return;

    const rowId = 'row-' + Date.now() + Math.random().toString(36).substring(2, 7);
    
    const rowHtml = `
        <div class="destination-row row align-items-center mb-2" id="${rowId}">
            <div class="col-md-4">
                <input type="text" class="form-control dest-name" placeholder="Destination Name" value="${destinationName}" required>
            </div>
            <div class="col-md-5">
                <input type="file" class="form-control dest-file" accept="image/*">
                ${imageName ? `<small class="text-muted">Current: ${imageName}</small>` : ''}
            </div>
            <input type="hidden" class="dest-existing-image" value="${imageName}">
            <div class="col-md-3 text-end">
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeDestinationRow('${rowId}')">
                    <i class="bi bi-trash"></i> Remove
                </button>
            </div>
        </div>
    `;
    container.insertAdjacentHTML('beforeend', rowHtml);
}

function removeDestinationRow(rowId) {
    const container = document.getElementById("destinationsContainer");
    if (container && container.querySelectorAll('.destination-row').length <= 1) {
        alert("At least one destination is required.");
        return;
    }
    const row = document.getElementById(rowId);
    if (row) row.remove();
}

async function savePackage() {
    const formData = new FormData();
    formData.append("packageName", document.getElementById("packageName").value);
    formData.append("duration", document.getElementById("duration").value);
    formData.append("price", document.getElementById("price").value);
    formData.append("packageType", document.getElementById("packageType").value);
    formData.append("description", document.getElementById("description").value);
    formData.append("includedServices", document.getElementById("includedServices").value);
    formData.append("excludedServices", document.getElementById("excludedServices").value);
    formData.append("status", "Active");

    const destinationRows = document.querySelectorAll(".destination-row");
    const destinationsMeta = [];

    destinationRows.forEach(row => {
        const nameInput = row.querySelector(".dest-name");
        const fileInput = row.querySelector(".dest-file");
        const existingImageInput = row.querySelector(".dest-existing-image");
        
        let imageNameVal = existingImageInput ? existingImageInput.value : '';

        if (nameInput) {
            destinationsMeta.push({ 
                destinationName: nameInput.value,
                imageName: imageNameVal 
            });
        }
        
        if (fileInput && fileInput.files.length > 0) {
            formData.append("imageFiles", fileInput.files[0]);
        } else {
            formData.append("imageFiles", new Blob([]), "");
        }
    });

    formData.append("destinationsJson", JSON.stringify(destinationsMeta));

    let requestUrl = API_BASE;
    let requestMethod = "POST";
    let isEdit = currentEditId !== null;

    if (isEdit) {
        requestUrl = `${API_BASE}/${currentEditId}`;
        requestMethod = "PUT";
    }

    try {
        const response = await fetch(requestUrl, {
            method: requestMethod,
            body: formData
        });

        if (response.ok) {
            showToast(isEdit ? "Package updated successfully!" : "Package added successfully!", "success");
            setTimeout(() => location.reload(), 1200); // थोडा वेळ मेसेज दाखवून पेज रिलोड होईल
        } else {
            showToast("Failed to save travel package.", "error");
        }
    } catch (error) {
        console.error("Error saving package:", error);
        showToast("Error connecting to server.", "error");
    }
}

function viewPackage(id) {
    const pkg = packageList.find(p => p.packageId === id);
    if (!pkg) {
        alert("Package not found!");
        return;
    }

    document.getElementById("viewPkgName").innerText = pkg.packageName || '';
    document.getElementById("viewDuration").innerText = pkg.duration || '';
    document.getElementById("viewPrice").innerText = pkg.price ? `$${pkg.price}` : '';
    document.getElementById("viewType").innerText = pkg.packageType || 'N/A';
    document.getElementById("viewDescription").innerText = pkg.description || 'N/A';
    document.getElementById("viewIncluded").innerText = pkg.includedServices || 'N/A';
    document.getElementById("viewExcluded").innerText = pkg.excludedServices || 'N/A';

    const carouselIndicators = document.getElementById("carouselIndicators");
    const carouselInner = document.getElementById("carouselInnerImages");
    
    carouselIndicators.innerHTML = "";
    carouselInner.innerHTML = ""; 

    if (pkg.destinations && pkg.destinations.length > 0) {
        pkg.destinations.forEach((dest, index) => {
            let imgSource = getPackageImageUrl(dest.imageName);
            let activeClass = index === 0 ? "active" : "";
            
            carouselIndicators.innerHTML += `
                <button type="button" data-bs-target="#packageCarousel" data-bs-slide-to="${index}" class="${activeClass}" ${index === 0 ? 'aria-current="true"' : ''} aria-label="Slide ${index + 1}"></button>
            `;

            let slideImg = imgSource !== ""
                ? `<img src="${imgSource}" class="d-block w-100" style="height: 300px; object-fit: cover;" onerror="this.onerror=null; this.src='https://via.placeholder.com/600x300?text=No+Image';">`
                : `<div class="bg-secondary text-white d-flex align-items-center justify-content-center" style="height: 300px;">No Image Available</div>`;

            carouselInner.innerHTML += `
                <div class="carousel-item ${activeClass}">
                    ${slideImg}
                    <div class="carousel-caption d-none d-md-block bg-dark bg-opacity-50 rounded p-2">
                        <h5 class="mb-0 text-white">${dest.destinationName}</h5>
                    </div>
                </div>
            `;
        });
    } else {
        carouselIndicators.innerHTML = `
            <button type="button" data-bs-target="#packageCarousel" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
        `;
        carouselInner.innerHTML = `
            <div class="carousel-item active">
                <div class="bg-secondary text-white d-flex align-items-center justify-content-center" style="height: 300px;">No Destinations Found</div>
            </div>
        `;
    }

    const viewModalElement = document.getElementById('viewPackageModal');
    if (viewModalElement) {
        const viewModal = new bootstrap.Modal(viewModalElement);
        viewModal.show();
    }
}

function editPackage(id) {
    const pkg = packageList.find(p => p.packageId === id);
    if (!pkg) return;
    
    currentEditId = pkg.packageId;

    document.getElementById("packageName").value = pkg.packageName;
    document.getElementById("duration").value = pkg.duration;
    document.getElementById("price").value = pkg.price;
    document.getElementById("packageType").value = pkg.packageType || '';
    document.getElementById("description").value = pkg.description || '';
    document.getElementById("includedServices").value = pkg.includedServices || '';
    document.getElementById("excludedServices").value = pkg.excludedServices || '';

    const modalTitle = document.getElementById("modalTitle");
    if (modalTitle) modalTitle.innerText = "Edit Travel Package";

    const container = document.getElementById("destinationsContainer");
    container.innerHTML = "";

    if (pkg.destinations && pkg.destinations.length > 0) {
        pkg.destinations.forEach(dest => {
            addDestinationRow(dest.destinationName, dest.imageName);
        });
    } else {
        addDestinationRow();
    }
    
    const modal = new bootstrap.Modal(document.getElementById('packageModal'));
    modal.show();
}

async function deletePackage(id) {
    if (!confirm("Are you sure you want to delete this travel package?")) return;

    try {
        const response = await fetch(`${API_BASE}/${id}`, {
            method: "DELETE"
        });

        if (response.ok) {
            showToast("Package deleted successfully!", "success");
            setTimeout(() => fetchPackages(), 1000); 
        } else {
            showToast("Failed to delete package.", "error");
        }
    } catch (error) {
        console.error("Error deleting package:", error);
        showToast("Error connecting to server.", "error");
    }
}

/* Toast Notification Helper Function */
function showToast(message, type = "success") {
    const container = document.getElementById("toastContainer");
    if (!container) return;

    const toast = document.createElement("div");
    toast.className = `package-toast ${type}`;

    const icon = type === "success" ? "bi-check-circle-fill" : "bi-exclamation-circle-fill";

    toast.innerHTML = `
        <div class="toast-content">
            <div class="toast-icon">
                <i class="bi ${icon}"></i>
            </div>
            <span>${message}</span>
        </div>
    `;

    container.appendChild(toast);

    setTimeout(() => {
        toast.classList.add("hide");
        setTimeout(() => toast.remove(), 300);
    }, 2500);
}