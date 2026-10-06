<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>About Us | Travel Recommendation System</title>

    <style>

        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');

        :root {
            --navy: #092c4c;
            --dark-blue: #123c61;
            --teal: #0ca6a6;
            --teal-dark: #078f91;
            --text: #29445f;
            --white: #ffffff;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: 'Inter', Arial, sans-serif;
            color: var(--text);
            background: #ffffff;
            overflow-x: hidden;
        }

        img {
            max-width: 100%;
            display: block;
        }

        a {
            text-decoration: none;
        }

        h1,
        h2,
        h3,
        h4 {
            color: var(--navy);
        }

        h2 {
            font-size: 30px;
            line-height: 1.3;
            font-weight: 800;
        }

        .section-tag {
            display: inline-block;
            padding: 7px 18px;
            border: 1px solid #8bdfe0;
            border-radius: 30px;
            color: #078f91;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1.5px;
            background: rgba(255, 255, 255, 0.5);
        }


        /* HERO SECTION */

        .about-hero {
            min-height: 390px;
            padding: 45px 6%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 40px;

            background:
                linear-gradient(
                    90deg,
                    rgba(238, 250, 255, 0.98) 0%,
                    rgba(231, 248, 255, 0.86) 42%,
                    rgba(214, 244, 255, 0.25) 100%
                ),
                
            position: relative;
            overflow: hidden;
            margin-top:80px;
            background: linear-gradient(120deg, #f0fbfd, #e8f8fa);
        }

        .hero-content {
            width: 44%;
            max-width: 530px;
            z-index: 2;
        }

        .hero-content h1 {
            font-size: 38px;
            line-height: 1.18;
            margin: 16px 0;
            letter-spacing: -1px;
        }

        .hero-content h1 span {
            color: var(--teal);
        }

        .hero-content p {
            font-size: 14px;
            line-height: 1.7;
            color: #31516b;
            max-width: 410px;
            margin-bottom: 22px;
        }

        .hero-buttons {
            display: flex;
            gap: 13px;
            flex-wrap: wrap;
        }

        .btn-primary,
        .btn-outline {
            padding: 13px 20px;
            border-radius: 28px;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 12px;
            transition: 0.3s ease;
        }

        .btn-primary {
            background: var(--teal);
            color: white;
        }

        .btn-primary:hover {
            background: var(--teal-dark);
            transform: translateY(-2px);
        }

        .btn-outline {
            border: 1px solid var(--teal);
            color: #087d86;
            background: rgba(255, 255, 255, 0.5);
        }

        .btn-outline:hover {
            background: var(--teal);
            color: white;
        }

        .hero-image-wrapper {
            width: 52%;
            height: 290px;
            position: relative;
            display: flex;
            justify-content: flex-end;
            align-items: center;
        }

        .hero-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 100px 0 0 100px;
            object-position: center;
            box-shadow: 0 10px 30px rgba(0, 90, 130, 0.08);
        }

        .match-card {
            position: absolute;
            right: -5px;
            top: 18px;
            width: 215px;
            padding: 12px;
            background: white;
            border-radius: 14px;
            display: flex;
            gap: 10px;
            align-items: center;
            box-shadow: 0 8px 25px rgba(0, 50, 80, 0.15);
        }

        .match-card img {
            width: 65px;
            height: 65px;
            border-radius: 10px;
            object-fit: cover;
        }

        .match-info h4 {
            font-size: 11px;
            margin-bottom: 7px;
        }

        .match-info p {
            font-size: 10px;
            margin-bottom: 4px;
        }

        .location-pin {
            color: var(--teal);
            font-size: 10px;
        }

        .match-info strong {
            font-size: 12px;
            color: var(--teal);
        }

        .stars {
            color: #ffb000;
            font-size: 11px;
            margin-top: 4px;
        }


        /* WHY SECTION */

        .why-section {
            padding: 45px 8%;
            text-align: center;
            background: white;
        }

        .why-section h2 {
            margin: 12px 0 25px;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            max-width: 780px;
            margin: 0 auto;
        }

        .feature-card {
            min-height: 165px;
            padding: 22px 28px;
            border-radius: 13px;
            border: 1px solid;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
        }

        .personalized {
            background: linear-gradient(135deg, #f0fcfc, #e8f8f8);
            border-color: #c9eeee;
        }

        .explore {
            background: linear-gradient(135deg, #eff9ff, #eaf5ff);
            border-color: #cce7fa;
        }

        .confident {
            background: linear-gradient(135deg, #fffdf7, #fffbf2);
            border-color: #f5e8c9;
        }

        .feature-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 25px;
            color: var(--navy);
            margin-bottom: 12px;
            background: #b8f0ee;
        }

        .explore .feature-icon {
            background: #a9e4ff;
        }

        .confident .feature-icon {
            background: #ffe2a5;
        }

        .feature-card h3 {
            font-size: 16px;
            margin-bottom: 10px;
        }

        .feature-card h3::after {
            content: '';
            display: block;
            width: 35px;
            height: 2px;
            background: var(--teal);
            margin: 9px auto 0;
        }

        .confident h3::after {
            background: #f0b43c;
        }

        .feature-card p {
            font-size: 11px;
            line-height: 1.6;
            max-width: 190px;
        }


        /* MISSION SECTION */

        .mission-section {
            background: linear-gradient(120deg, #f0fbfd, #e8f8fa);
            padding: 50px 8%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 70px;
        }

        .mission-gallery {
            width: 43%;
            height: 290px;
            position: relative;
        }

        .gallery-main {
            width: 255px;
            height: 255px;
            border-radius: 50%;
            overflow: hidden;
            position: absolute;
            left: 0;
            top: 15px;
            border: 5px solid white;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
        }

        .gallery-main img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .gallery-small {
            position: absolute;
            width: 130px;
            height: 100px;
            border: 5px solid white;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            background: white;
        }

        .gallery-small img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .beach-image {
            left: 210px;
            top: 5px;
            transform: rotate(7deg);
        }

        .city-image {
            left: 220px;
            top: 115px;
            transform: rotate(-3deg);
        }

        .coast-image {
            left: 115px;
            top: 185px;
            transform: rotate(-7deg);
        }

        .mission-content {
            width: 48%;
            max-width: 520px;
        }

        .mission-content h2 {
            font-size: 27px;
            margin: 13px 0;
        }

        .mission-content h2 span {
            color: var(--teal);
        }

        .mission-content > p {
            font-size: 13px;
            line-height: 1.65;
            margin-bottom: 25px;
        }

        .stats-row {
            display: flex;
            gap: 24px;
            flex-wrap: wrap;
        }

        .stat {
            display: flex;
            align-items: center;
            gap: 9px;
        }

        .stat-icon {
            width: 37px;
            height: 37px;
            border: 2px solid #a6e9e9;
            background: #e1fafa;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            color: var(--teal);
            font-size: 20px;
        }

        .stat strong {
            display: block;
            color: var(--navy);
            font-size: 15px;
        }

        .stat span {
            display: block;
            font-size: 10px;
            margin-top: 3px;
        }


        /* PROCESS SECTION */

        .process-section {
            padding: 42px 7%;
            background: #eaf9fb;
            text-align: center;
        }

        .process-section h2 {
            margin: 12px 0 32px;
        }

        .process-line {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            max-width: 1000px;
            margin: auto;
            position: relative;
        }

        .process-line::before {
            content: '';
            position: absolute;
            top: 28px;
            left: 12%;
            right: 12%;
            border-top: 2px dashed #8adbdc;
            z-index: 0;
        }

        .process-step {
            position: relative;
            z-index: 1;
            padding: 0 15px;
        }

        .step-icon {
            width: 55px;
            height: 55px;
            border-radius: 50%;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            background: #0ba6a6;
            font-size: 24px;
            border: 4px solid #c8f4f4;
        }

        .process-step:nth-child(2) .step-icon {
            background: #3b83b7;
        }

        .process-step:nth-child(3) .step-icon {
            background: #146ca2;
        }

        .process-step:nth-child(4) .step-icon {
            background: #07588b;
        }

        .step-number {
            width: 22px;
            height: 22px;
            line-height: 22px;
            border-radius: 50%;
            background: white;
            color: var(--teal);
            font-size: 10px;
            font-weight: 700;
            margin: -4px auto 10px;
            position: relative;
        }

        .process-step h3 {
            font-size: 12px;
            line-height: 1.35;
            margin-bottom: 9px;
        }

        .process-step p {
            font-size: 11px;
            line-height: 1.5;
            max-width: 170px;
            margin: auto;
        }


        /* STORY SECTION */

        .story-section {
            padding: 50px 8%;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 65px;
            background: white;
        }

        .story-image {
            width: 40%;
            max-width: 390px;
        }

        .story-image img {
            width: 100%;
            height: 235px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 10px 25px rgba(0, 60, 100, 0.12);
        }

        .story-content {
            width: 48%;
            max-width: 500px;
        }

        .story-content h2 {
            font-size: 25px;
            margin: 12px 0;
        }

        .story-content > p {
            font-size: 12px;
            line-height: 1.7;
            margin-bottom: 25px;
        }

        .story-values {
            display: flex;
            gap: 25px;
        }

        .story-values > div {
            text-align: center;
            flex: 1;
        }

        .value-icon {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            background: #c6f1f1;
            color: var(--teal);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 9px;
            font-size: 20px;
        }

        .story-values h4 {
            font-size: 11px;
            margin-bottom: 5px;
        }

        .story-values p {
            font-size: 9px;
            line-height: 1.4;
        }


        /* CTA SECTION */

        .cta-section {
            min-height: 210px;
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;

            background:
                linear-gradient(
                    rgba(5, 45, 73, 0.55),
                    rgba(5, 45, 73, 0.55)
                ),
                url('${pageContext.request.contextPath}/images/about_us/sunset-traveler.jpg')
                center / cover no-repeat;

            color: white;
        }

        .cta-overlay {
            position: absolute;
            inset: 0;
            background: rgba(5, 45, 73, 0.1);
        }

        .cta-content {
            position: relative;
            z-index: 2;
        }

        .cta-content > span {
            font-size: 10px;
            letter-spacing: 1.5px;
        }

        .cta-content h2 {
            color: white;
            font-size: 23px;
            margin: 10px 0;
        }

        .cta-content p {
            font-size: 11px;
            margin-bottom: 17px;
        }

        .cta-button {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            padding: 11px 24px;
            border-radius: 25px;
            background: #0bb5b1;
            color: white;
            font-size: 11px;
            font-weight: 600;
            transition: 0.3s ease;
        }

        .cta-button:hover {
            background: #078f91;
            transform: translateY(-2px);
        }


        /* RESPONSIVE DESIGN */

        @media (max-width: 1000px) {

            .about-hero {
                padding: 40px 5%;
            }

            .hero-content h1 {
                font-size: 30px;
            }

            .mission-section,
            .story-section {
                gap: 35px;
                padding-left: 5%;
                padding-right: 5%;
            }

            .mission-gallery {
                transform: scale(0.85);
                transform-origin: center;
            }

            .stats-row {
                gap: 12px;
            }

        }


        @media (max-width: 768px) {

            .about-hero {
                flex-direction: column;
                padding: 45px 6%;
                text-align: center;
            }

            .hero-content,
            .hero-image-wrapper {
                width: 100%;
                max-width: 100%;
            }

            .hero-content p {
                margin: 0 auto 22px;
            }

            .hero-buttons {
                justify-content: center;
            }

            .hero-image-wrapper {
                height: 250px;
            }

            .match-card {
                right: 0;
            }

            .features-grid {
                grid-template-columns: 1fr;
                max-width: 350px;
            }

            .mission-section,
            .story-section {
                flex-direction: column;
                text-align: center;
            }

            .mission-gallery {
                width: 100%;
                max-width: 390px;
            }

            .mission-content,
            .story-content {
                width: 100%;
                max-width: 550px;
            }

            .stats-row {
                justify-content: center;
                flex-wrap: wrap;
            }

            .process-line {
                grid-template-columns: repeat(2, 1fr);
                gap: 35px 10px;
            }

            .process-line::before {
                display: none;
            }

            .story-image {
                width: 100%;
                max-width: 450px;
            }

            .story-values {
                gap: 10px;
            }

        }


        @media (max-width: 480px) {

            .hero-content h1 {
                font-size: 27px;
            }

            h2 {
                font-size: 24px;
            }

            .hero-image-wrapper {
                height: 210px;
            }

            .match-card {
                transform: scale(0.85);
                transform-origin: top right;
            }

            .mission-gallery {
                transform: scale(0.75);
                margin: -25px 0;
            }

            .process-line {
                grid-template-columns: 1fr;
            }

            .story-values {
                flex-direction: column;
                gap: 20px;
            }

        }

    </style>

</head>

<body>


    <%@ include file="header.jsp" %>


    <main>


        <!-- HERO SECTION -->

        <section class="about-hero">

            <div class="hero-content">

                <span class="section-tag">
                    ABOUT OUR JOURNEY
                </span>

                <h1>
                    Explore the World.<br>
                    Find Your <span>Perfect Journey.</span>
                </h1>

                <p>
                    We are a Travel Recommendation System, designed to
                    help you discover the best destinations based on your
                    preferences, interests and travel goals.
                </p>

                <div class="hero-buttons">

                    <a href="login.jsp" class="btn-primary">
                        Discover Our Mission
                        <span>→</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/login.jsp"
                       class="btn-outline">
                        Explore Destinations
                    </a>

                </div>

            </div>


            <div class="hero-image-wrapper">

                <img
                    src="${pageContext.request.contextPath}/images/about_us/hero-traveler.jpg"
                    alt="Traveler exploring a beautiful destination"
                    class="hero-image">


                <div class="match-card">

                    <img
                        src="${pageContext.request.contextPath}/images/about_us/mountain-lake.jpg"
                        alt="Mountain lake destination">

                    <div class="match-info">

                        <h4>
                            Perfect Match Found!
                        </h4>

                        <p>
                            <span class="location-pin">●</span>
                            Manali
                        </p>

                        <strong>
                            92% Match
                        </strong>

                        <div class="stars">
                            ★★★★★
                        </div>

                    </div>

                </div>

            </div>

        </section>


        <!-- WHY CHOOSE US -->

        <section class="why-section">

            <span class="section-tag">
                TRAVEL PLANNING, REIMAGINED
            </span>

            <h2>
                Why Choose Our Travel Recommendation System?
            </h2>

            <div class="features-grid">


                <div class="feature-card personalized">

                    <div class="feature-icon">
                      <i class="fa-solid fa-compass"></i>
                    </div>

                    <h3>
                        Personalized
                    </h3>

                    <p>
                        Recommendations based on your unique preferences,
                        interests and travel style.
                    </p>

                </div>


                <div class="feature-card explore">

                    <div class="feature-icon">
                       <i class="fa-solid fa-globe"></i>
                    </div>

                    <h3>
                        Explore Freely
                    </h3>

                    <p>
                        Discover destinations beyond the ordinary,
                        from hidden gems to popular hotspots.
                    </p>

                </div>


                <div class="feature-card confident">

                    <div class="feature-icon">
                      <i class="fa-solid fa-shield-halved"></i>
                    </div>

                    <h3>
                        Travel Confidently
                    </h3>

                    <p>
                        Make informed decisions with reliable information
                        and smart suggestions.
                    </p>

                </div>

            </div>

        </section>


        <!-- MISSION SECTION -->

        <section class="mission-section" id="mission">

            <div class="mission-gallery">


                <div class="gallery-main">

                    <img
                        src="${pageContext.request.contextPath}/images/about_us/mountain-lake.jpg"
                        alt="Mountain lake surrounded by mountains">

                </div>


                <div class="gallery-small beach-image">

                    <img
                        src="${pageContext.request.contextPath}/images/about_us/tropical-beach.jpg"
                        alt="Tropical beach">

                </div>


                <div class="gallery-small city-image">

                    <img
                        src="${pageContext.request.contextPath}/images/about_us/city-destination.jpg"
                        alt="Beautiful city destination">

                </div>


                <div class="gallery-small coast-image">

                    <img
                        src="${pageContext.request.contextPath}/images/about_us/coastal-destination.jpg"
                        alt="Coastal destination">

                </div>

            </div>


            <div class="mission-content">

                <span class="section-tag">
                    OUR MISSION
                </span>

                <h2>
                    We believe every traveler deserves a journey
                    that <span>feels personal.</span>
                </h2>

                <p>
                    Our Travel Recommendation System helps users discover
                    destinations that match their interests, preferences
                    and travel goals. We combine technology with the joy
                    of exploration to make travel planning easier,
                    smarter and more meaningful.
                </p>


                <div class="stats-row">


                    <div class="stat">

                        <div class="stat-icon">
                         <i class="fa-solid fa-location-dot"></i>
                        </div>

                        <div>
                            <strong>100+</strong>
                            <span>Destinations</span>
                        </div>

                    </div>


                    <div class="stat">

                        <div class="stat-icon">
                        <i class="fa-solid fa-users"></i>
                        </div>

                        <div>
                            <strong>Personalized</strong>
                            <span>Recommendations</span>
                        </div>

                    </div>


                    <div class="stat">

                        <div class="stat-icon">
                            ★
                        </div>

                        <div>
                            <strong>1</strong>
                            <span>Smarter Travel Experience</span>
                        </div>

                    </div>

                </div>

            </div>

        </section>


        <!-- HOW OUR SYSTEM WORKS -->

        <section class="process-section">

            <span class="section-tag">
                HOW OUR SYSTEM WORKS
            </span>

            <h2>
                From Your Preferences to Your Perfect Trip
            </h2>


            <div class="process-line">


                <div class="process-step">

                    <div class="step-icon">
                       <i class="fa-solid fa-user"></i>
                    </div>

                    <div class="step-number">
                        01
                    </div>

                    <h3>
                        Tell Us Your Style
                    </h3>

                    <p>
                        Choose your interests, budget, climate,
                        activities or preferred destination type.
                    </p>

                </div>


                <div class="process-step">

                    <div class="step-icon">
                       <i class="fa-solid fa-brain"></i>
                    </div>

                    <div class="step-number">
                        02
                    </div>

                    <h3>
                        We Understand<br>
                        Your Preferences
                    </h3>

                    <p>
                        The system processes your selected criteria.
                    </p>

                </div>


                <div class="process-step">

                    <div class="step-icon">
                       <i class="fa-solid fa-map-location-dot"></i>
                    </div>

                    <div class="step-number">
                        03
                    </div>

                    <h3>
                        Discover Your Matches
                    </h3>

                    <p>
                        Explore destinations recommended for you.
                    </p>

                </div>


                <div class="process-step">

                    <div class="step-icon">
                        <i class="fa-solid fa-plane"></i>
                    </div>

                    <div class="step-number">
                        04
                    </div>

                    <h3>
                        Start Your Journey
                    </h3>

                    <p>
                        Plan your next adventure with confidence.
                    </p>

                </div>

            </div>

        </section>


        <!-- PROJECT STORY -->

        <section class="story-section">


            <div class="story-image">

                <img
                    src="${pageContext.request.contextPath}/images/about_us/travel-workspace.jpg"
                    alt="Travel planning workspace">

            </div>


            <div class="story-content">

                <span class="section-tag">
                    OUR PROJECT STORY
                </span>

                <h2>
                    Built with curiosity.<br>
                    Designed for explorers.
                </h2>

                <p>
                    Our project was created to make travel discovery easier,
                    smarter and more personalized. By combining technology
                    with the joy of exploration, we aim to help travelers
                    spend less time searching and more time experiencing.
                </p>


                <div class="story-values">


                    <div>

                        <div class="value-icon">
                            ♧
                        </div>

                        <h4>
                            Our Team
                        </h4>

                        <p>
                            Passionate minds behind the project.
                        </p>

                    </div>


                    <div>

                        <div class="value-icon">
                            ♧
                        </div>

                        <h4>
                            Our Vision
                        </h4>

                        <p>
                            Smarter travel for everyone.
                        </p>

                    </div>


                    <div>

                        <div class="value-icon">
                            ▲
                        </div>

                        <h4>
                            Our Goal
                        </h4>

                        <p>
                            More journeys, more memories.
                        </p>

                    </div>

                </div>

            </div>

        </section>


        <!-- CTA SECTION -->

        <section class="cta-section">

            <div class="cta-overlay"></div>

            <div class="cta-content">

                <span>
                    LET'S EXPLORE TOGETHER
                </span>

                <h2>
                    Your next adventure is waiting.
                </h2>

                <p>
                    Discover personalized travel recommendations
                    and make your dream trip a reality.
                </p>

                <a
                    href="${pageContext.request.contextPath}/login.jsp"
                    class="cta-button">

                    Start Exploring
                    <span>→</span>

                </a>

            </div>

        </section>


    </main>

</body>
</html>