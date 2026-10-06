<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trip Netra - User Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/recommendations.css?v=11">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        /* Table Styling matching your CSS theme */
        .table-container { background: rgba(255, 255, 255, 0.75); backdrop-filter: blur(10px); border: 1px solid rgba(148,163,184,0.3); border-radius: 16px; overflow: hidden; margin-top: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th, td { padding: 15px 20px; border-bottom: 1px solid rgba(148,163,184,0.2); font-size: 14px; color: #1e293b; }
        th { background-color: rgba(241, 245, 249, 0.8); color: #475569; font-weight: 600; }
        tr:hover { background-color: rgba(255, 255, 255, 0.9); }

        .profile-thumb { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; border: 2px solid #cbd5e1; }

        /* Action Buttons */
        .btn-view-modern {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: #ffffff; border: none; padding: 6px 14px; border-radius: 8px; font-size: 13px; font-weight: 600;
            display: inline-flex; align-items: center; gap: 6px; cursor: pointer; transition: all 0.25s ease;
            box-shadow: 0 4px 10px rgba(16, 185, 129, 0.2); margin-right: 5px;
        }
        .btn-view-modern:hover { background: linear-gradient(135deg, #059669 0%, #047857 100%); transform: translateY(-1px); }

        .btn-delete-modern {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            color: #ffffff; border: none; padding: 6px 14px; border-radius: 8px; font-size: 13px; font-weight: 600;
            display: inline-flex; align-items: center; gap: 6px; cursor: pointer; transition: all 0.25s ease;
            box-shadow: 0 4px 10px rgba(239, 68, 68, 0.2);
        }
        .btn-delete-modern:hover { background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%); transform: translateY(-1px); }

        /* Pagination Bar */
        .pagination { display: flex; justify-content: space-between; align-items: center; padding: 15px 20px; background: rgba(241, 245, 249, 0.5); border-top: 1px solid rgba(148,163,184,0.2); }
        .pagination-info { font-size: 13px; color: #64748b; }
        .pagination-buttons button { background: #ffffff; color: #334155; border: 1px solid #cbd5e1; padding: 6px 12px; cursor: pointer; border-radius: 6px; font-size: 13px; margin-left: 5px; font-weight: 500; }
        .pagination-buttons button:hover:not(:disabled) { background: #f1f5f9; border-color: #94a3b8; }
        .pagination-buttons button:disabled { opacity: 0.5; cursor: not-allowed; }
        .pagination-buttons button.active { background: #2563eb; border-color: #2563eb; color: #fff; }

        /* Modal Styling */
        .modal { display: none; position: fixed; z-index: 1050; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(15, 23, 42, 0.6); backdrop-filter: blur(5px); justify-content: center; align-items: center; }
        .modal-content { background: #ffffff; border: 1px solid rgba(148,163,184,0.3); border-radius: 16px; width: 650px; max-height: 85vh; overflow-y: auto; padding: 25px; box-shadow: 0 20px 40px rgba(0,0,0,0.2); }
        .modal-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #e2e8f0; padding-bottom: 15px; margin-bottom: 20px; }
        .modal-header h3 { color: #1e293b; font-size: 18px; font-weight: 700; }
        .close-btn { background: none; border: none; color: #64748b; font-size: 22px; cursor: pointer; }
        .close-btn:hover { color: #0f172a; }
        
        .profile-details-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; font-size: 13px; }
        .profile-details-grid div { background: #f8fafc; padding: 12px 14px; border-radius: 10px; border: 1px solid #e2e8f0; }
        .profile-details-grid span { color: #64748b; display: block; font-size: 11px; text-transform: uppercase; font-weight: 600; margin-bottom: 4px; }
        .profile-details-grid strong { color: #0f172a; font-size: 14px; }
        .full-width { grid-column: span 2; text-align: center; }
        .modal-img { width: 90px; height: 90px; border-radius: 50%; object-fit: cover; border: 3px solid #2563eb; margin-bottom: 10px; box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2); }
    </style>
</head>
<body>

<div class="dashboard-container">
    <!-- Sidebar Included -->
    <aside class="recommendation-sidebar">
        <jsp:include page="sidebar.jsp" />
    </aside>

    <!-- Main Content -->
    <main class="recommendation-main">
        <section class="recommendation-hero">
            <div class="hero-content">
                <span class="hero-badge">✨ TRIP NETRA ADMIN</span>
                <h1>User Management</h1>
                <p>Manage all registered users, view their travel profiles, and control system access.</p>
            </div>
            <div class="hero-icon"><i class="fa-solid fa-users-gear"></i></div>
        </section>

        <section class="results-section">
            <div class="results-header">
                <div>
                    <h2>Registered Users Directory</h2>
                    <p>Complete list of user accounts and travel preference data.</p>
                </div>
            </div>

            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Profile</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="userTableBody">
                        <tr><td colspan="6" style="text-align:center; color:#64748b;">Loading users...</td></tr>
                    </tbody>
                </table>
                
                <!-- Pagination Bar -->
                <div class="pagination">
                    <div class="pagination-info" id="paginationInfo">Showing 0 to 0 of 0 users</div>
                    <div class="pagination-buttons" id="paginationButtons"></div>
                </div>
            </div>
        </section>
    </main>
</div>

<!-- Details Modal -->
<div class="modal" id="userModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Travel Profile Details</h3>
            <button class="close-btn" onclick="closeModal()">&times;</button>
        </div>
        <div id="modalBody" class="profile-details-grid">
            <!-- Dynamic Profile Details -->
        </div>
    </div>
</div>

<!-- Toast Notifications Container -->
<div id="toastContainer" class="position-fixed bottom-0 end-0 p-3" style="z-index: 1080;"></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const API_URL = API_CONFIG.api('/api/admin/users');
    let allUsers = [];
    let currentPage = 1;
    const rowsPerPage = 5;

    document.addEventListener("DOMContentLoaded", function () {
        const token = localStorage.getItem("token");
        if (!token) {
            window.location.href = "login.jsp";
            return;
        }
        fetchUsers(token);
    });

    async function fetchUsers(token) {
        try {
            const response = await fetch(API_URL, {
                headers: { "Authorization": "Bearer " + token }
            });
            if (!response.ok) throw new Error('Failed to fetch data');
            const data = await response.json();
            allUsers = Array.isArray(data) ? data : (data.data || []);
            renderTable();
        } catch (error) {
            console.error('Error loading users:', error);
            document.getElementById('userTableBody').innerHTML = '<tr><td colspan="6" style="text-align:center; color:#ef4444;">Failed to load users from server.</td></tr>';
        }
    }

    function renderTable() {
        const tbody = document.getElementById('userTableBody');
        tbody.innerHTML = '';

        if (allUsers.length === 0) {
            tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; color:#64748b;">No users found.</td></tr>';
            document.getElementById('paginationInfo').innerText = 'Showing 0 to 0 of 0 users';
            document.getElementById('paginationButtons').innerHTML = '';
            return;
        }

        const startIndex = (currentPage - 1) * rowsPerPage;
        const endIndex = startIndex + rowsPerPage;
        const paginatedUsers = allUsers.slice(startIndex, endIndex);

        paginatedUsers.forEach(user => {
            const tr = document.createElement('tr');
            
            let photoSrc = 'https://via.placeholder.com/40';
            if (user.profile_photo) {
                photoSrc = user.profile_photo.startsWith('http') ? user.profile_photo : API_CONFIG.upload(user.profile_photo);
            }

            tr.innerHTML = `
                <td>\${user.id}</td>
                <td><img src="\${photoSrc}" alt="Photo" class="profile-thumb" onerror="this.src='https://via.placeholder.com/40'"></td>
                <td>\${user.full_name || user.name || 'N/A'}</td>
                <td>\${user.email || 'N/A'}</td>
                <td><span style="color: #2563eb; font-weight:600;">\${user.role || 'N/A'}</span></td>
                <td>
                    <button class="btn-view-modern" onclick='viewUserProfile(\${JSON.stringify(user)})'>
                        <i class="fa-solid fa-eye"></i> View
                    </button>
                    <button class="btn-delete-modern" onclick="deleteUser(\${user.id})">
                        <i class="fa-solid fa-trash-can"></i> Delete
                    </button>
                </td>
            `;
            tbody.appendChild(tr);
        });

        renderPaginationControls();
    }

    function renderPaginationControls() {
        const totalPages = Math.ceil(allUsers.length / rowsPerPage);
        const startIndex = (currentPage - 1) * rowsPerPage + 1;
        const endIndex = Math.min(currentPage * rowsPerPage, allUsers.length);
        
        document.getElementById('paginationInfo').innerText = `Showing \${startIndex} to \${endIndex} of \${allUsers.length} users`;

        const buttonsContainer = document.getElementById('paginationButtons');
        buttonsContainer.innerHTML = '';

        const prevBtn = document.createElement('button');
        prevBtn.innerText = 'Prev';
        prevBtn.disabled = currentPage === 1;
        prevBtn.onclick = () => { if (currentPage > 1) { currentPage--; renderTable(); } };
        buttonsContainer.appendChild(prevBtn);

        for (let i = 1; i <= totalPages; i++) {
            const pageBtn = document.createElement('button');
            pageBtn.innerText = i;
            if (i === currentPage) pageBtn.classList.add('active');
            pageBtn.onclick = () => { currentPage = i; renderTable(); };
            buttonsContainer.appendChild(pageBtn);
        }

        const nextBtn = document.createElement('button');
        nextBtn.innerText = 'Next';
        nextBtn.disabled = currentPage === totalPages;
        nextBtn.onclick = () => { if (currentPage < totalPages) { currentPage++; renderTable(); } };
        buttonsContainer.appendChild(nextBtn);
    }

    function viewUserProfile(user) {
        let photoSrc = 'https://via.placeholder.com/90';
        if (user.profile_photo) {
            photoSrc = user.profile_photo.startsWith('http') ? user.profile_photo : API_CONFIG.upload(user.profile_photo);
        }

        const modalBody = document.getElementById('modalBody');
        modalBody.innerHTML = `
            <div class="full-width">
                <img src="\${photoSrc}" alt="Profile Photo" class="modal-img" onerror="this.src='https://via.placeholder.com/90'">
                <h4 style="color:#0f172a; margin-bottom:15px; font-size:18px;">\${user.full_name || user.name || 'N/A'}</h4>
            </div>
            <div><span>User ID</span><strong>\${user.id}</strong></div>
            <div><span>Email</span><strong>\${user.email || 'N/A'}</strong></div>
            <div><span>Role</span><strong>\${user.role || 'N/A'}</strong></div>
            <div><span>Profile ID</span><strong>\${user.profile_id || 'N/A'}</strong></div>
            <div><span>Age</span><strong>\${user.age || 'N/A'}</strong></div>
            <div><span>Location</span><strong>\${user.location || 'N/A'}</strong></div>
            <div><span>Travel Companion</span><strong>\${user.travel_companion || 'N/A'}</strong></div>
            <div><span>Budget</span><strong>\${user.budget ? '$' + user.budget : 'N/A'}</strong></div>
            <div><span>Trip Duration</span><strong>\${user.trip_duration || 'N/A'}</strong></div>
            <div><span>Transportation</span><strong>\${user.transportation || 'N/A'}</strong></div>
            <div><span>Accommodation</span><strong>\${user.accommodation || 'N/A'}</strong></div>
            <div><span>Food Preference</span><strong>\${user.food_preference || 'N/A'}</strong></div>
            <div><span>Preferred Season</span><strong>\${user.preferred_season || 'N/A'}</strong></div>
            <div><span>Trip Experience</span><strong>\${user.trip_experience || 'N/A'}</strong></div>
            <div class="full-width"><span>Interests</span><strong>\${user.interests || 'N/A'}</strong></div>
            <div class="full-width"><span>Destination Categories</span><strong>\${user.destination_categories || 'N/A'}</strong></div>
        `;

        document.getElementById('userModal').style.display = 'flex';
    }

    function closeModal() {
        document.getElementById('userModal').style.display = 'none';
    }

    async function deleteUser(userId) {
        if (!confirm('Are you sure you want to delete this user?')) return;
        const token = localStorage.getItem("token");

        try {
            const response = await fetch(API_CONFIG.api('/api/admin/users') + '/' + userId, {
                method: 'DELETE',
                headers: { "Authorization": "Bearer " + token }
            });

            if (response.ok) {
                alert('User deleted successfully.');
                fetchUsers(token);
            } else {
                alert('Failed to delete user.');
            }
        } catch (error) {
            console.error('Error deleting user:', error);
        }
    }
</script>
</body>
</html>
