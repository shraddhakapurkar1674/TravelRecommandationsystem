<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<header class="top-navbar">


    <!-- =================================================
         MENU BUTTON
         ================================================= -->

    <div class="header-left">


        <button id="menuToggle"
                class="menu-toggle"
                type="button">

            <i class="fa-solid fa-bars"></i>

        </button>


    </div>



    <!-- =================================================
         SEARCH
         ================================================= -->

    <div class="search-container">


        <i class="fa-solid fa-magnifying-glass search-icon"></i>


        <input type="text"
               id="searchInput"
               placeholder="Search here...">


        <i class="fa-solid fa-search search-right"></i>


    </div>



    <!-- =================================================
         HEADER RIGHT
         ================================================= -->

    <div class="header-right">


        <!-- NOTIFICATION -->

        <div class="notification">


            <i class="fa-regular fa-bell"></i>


            <span class="notification-count">
                5
            </span>


        </div>



        <!-- ADMIN -->

        <div class="admin-profile">


            <div class="admin-avatar">

                <i class="fa-solid fa-user"></i>

            </div>


            <div class="admin-info">

                <strong>
                    Admin
                </strong>

                <span>
                    Super Admin
                </span>

            </div>


            <i class="fa-solid fa-chevron-down admin-arrow"></i>


        </div>


    </div>


</header>