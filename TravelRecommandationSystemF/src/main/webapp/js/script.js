const API_URL = API_CONFIG.api("/api/destinations");
let destinationsData = []; 

document.addEventListener("DOMContentLoaded", loadDestinations);

// Toggle Creation Form
function toggleForm() {
    const form = document.getElementById("destinationFormCard");
    if (form) {
        form.style.display = (form.style.display === "none" || form.style.display === "") ? "block" : "none";
    }
}

// Fetch and load list from Backend API
function loadDestinations() {
    fetch(API_URL)
        .then(res => res.json())
        .then(data => {
            console.log("Fetched API Data:", data); // Debugging log
            destinationsData = data || [];
            const tbody = document.getElementById("destinationsTableBody");
            if (!tbody) return;
            
            tbody.innerHTML = "";

            if (!destinationsData || destinationsData.length === 0) {
                tbody.innerHTML = '<tr><td colspan="7" style="text-align: center;">No destinations found.</td></tr>';
                return;
            }

            destinationsData.forEach(item => {
                const id = item.id;
                const name = item.destinationName || item.destination_name || 'N/A';
                const state = item.state || '';
                const country = item.country || '';
                const category = item.category || 'N/A';
                const budget = item.budget || '0';
                const status = item.status || 'Active';

                const row = `
                    <tr>
                        <td>${id}</td>
                        <td style="font-weight:600;">${name}</td>
                        <td>${state}${state && country ? ', ' : ''}${country}</td>
                        <td>${category}</td>
                        <td>$${budget}</td>
                        <td><span class="status-badge">${status}</span></td>
                        <td>
                            <div class="action-btns">
                                <button type="button" class="btn-action btn-view" onclick="viewDestination(${id})">
                                    <i class="fa-solid fa-eye"></i> View
                                </button>
                                <button type="button" class="btn-action btn-edit" onclick="editDestination(${id})">
                                    <i class="fa-solid fa-pen-to-square"></i> Edit
                                </button>
                                <button type="button" class="btn-action btn-delete" onclick="deleteDestination(${id})">
                                    <i class="fa-solid fa-trash"></i> Delete
                                </button>
                            </div>
                        </td>
                    </tr>
                `;
                tbody.innerHTML += row;
            });
        })
        .catch(err => console.error("Error fetching destinations:", err));
}

// Display Destination Details in Modal Pop-up
function viewDestination(id) {
    console.log("View clicked for ID:", id); // Debugging log

    // Use == instead of === to match string vs number IDs seamlessly
    const dest = destinationsData.find(d => d.id == id);
    
    if (!dest) {
        console.error("Destination not found in memory for ID:", id);
        alert("Unable to find destination details.");
        return;
    }

    const name = dest.destinationName || dest.destination_name || 'N/A';
    const state = dest.state || '';
    const country = dest.country || '';
    const category = dest.category || 'N/A';
    const budget = dest.budget || '0';
    const season = dest.bestSeason || dest.best_season || 'Any';
    const status = dest.status || 'Active';
    const description = dest.description || 'No description provided.';
    const imageUrl = dest.image || '';

    // Populate Modal Elements safely
    const modalTitle = document.getElementById("modalTitle");
    const modalLocation = document.getElementById("modalLocation");
    const modalCategory = document.getElementById("modalCategory");
    const modalBudget = document.getElementById("modalBudget");
    const modalSeason = document.getElementById("modalSeason");
    const modalStatus = document.getElementById("modalStatus");
    const modalDesc = document.getElementById("modalDesc");
    const modalImg = document.getElementById("modalImage");
    const modalOverlay = document.getElementById("viewModal");

    if (modalTitle) modalTitle.innerText = name;
    if (modalLocation) modalLocation.innerText = `${state}${state && country ? ', ' : ''}${country}`;
    if (modalCategory) modalCategory.innerText = category;
    if (modalBudget) modalBudget.innerText = `$${budget}`;
    if (modalSeason) modalSeason.innerText = season;
    if (modalStatus) modalStatus.innerText = status;
    if (modalDesc) modalDesc.innerText = description;

    if (modalImg) {
        modalImg.src = imageUrl && imageUrl.startsWith('http') 
            ? imageUrl 
            : 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=600&q=80';
    }

    // Force modal to show
    if (modalOverlay) {
        modalOverlay.style.display = "flex";
    } else {
        console.error("Element #viewModal not found in DOM!");
    }
}

function closeModal() {
    const modalOverlay = document.getElementById("viewModal");
    if (modalOverlay) {
        modalOverlay.style.display = "none";
    }
}

// Close Modal when clicking outside of dialog card
window.onclick = function(event) {
    const modal = document.getElementById("viewModal");
    if (event.target === modal) {
        closeModal();
    }
};

// Save New Destination
function saveDestination(event) {
    event.preventDefault();

    const payload = {
        destinationName: document.getElementById("destName").value,
        state: document.getElementById("destState").value,
        country: document.getElementById("destCountry").value,
        category: document.getElementById("destCategory").value,
        budget: parseFloat(document.getElementById("destBudget").value),
        bestSeason: document.getElementById("destSeason").value,
        description: document.getElementById("destDescription").value,
        image: document.getElementById("destImage").value,
        status: "Active"
    };

    fetch(API_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload)
    })
    .then(res => res.text())
    .then(msg => {
        alert(msg);
        document.getElementById("destinationForm").reset();
        toggleForm();
        loadDestinations();
    })
    .catch(err => alert("Error saving destination: " + err));
}

// Delete Destination
function deleteDestination(id) {
    if (confirm("Are you sure you want to delete this destination?")) {
        fetch(`${API_URL}/${id}`, { method: "DELETE" })
            .then(res => res.text())
            .then(msg => {
                alert(msg);
                loadDestinations();
            })
            .catch(err => alert("Error deleting destination: " + err));
    }
}

function editDestination(id) {
    alert("Edit destination ID: " + id);
}