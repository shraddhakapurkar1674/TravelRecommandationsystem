# Travel Recommendation System

## About the Project
Travel Recommendation System is a web-based application that helps users discover suitable travel destinations based on their preferences, budget, interests, and travel requirements.

## Features
- User Registration and Login
- User Profile Management
- Personalized Destination Recommendations
- Destination Search and Filtering
- Destination and Hotel Management
- Activity and Review Management
- Admin Dashboard
- Notifications for newly added destinations

## Technologies Used
- **Backend:** Java 17, Spring Boot, Spring MVC, JDBC
- **Frontend:** JSP, HTML, CSS, Bootstrap, JavaScript
- **Database:** MySQL
- **Tools:** Spring Tool Suite, Eclipse, Git, GitHub

## Project Setup

### Prerequisites
- JDK 17
- MySQL Server
- Spring Tool Suite (STS)
- Eclipse IDE
- Apache Tomcat

### 1. Clone the Repository


git clone https://github.com/shraddhakapurkar1674/TravelRecommandationsystem.git


### 2. Create the Database


CREATE DATABASE travel_db;


Import the project's SQL scripts, if available.

### 3. Configure Database Connection

Update the MySQL credentials in `application.properties`:

properties
spring.datasource.url=jdbc:mysql://localhost:3306/travel_db
spring.datasource.username=YOUR_USERNAME
spring.datasource.password=YOUR_PASSWORD


Replace the placeholders with your local MySQL credentials.

### 4. Run the Application
- Open the backend project in Spring Tool Suite.
- Configure the database connection and run the Spring Boot application.
- Open the frontend project in Eclipse and configure Tomcat.
- Start both applications and open the frontend URL configured for your environment.


## Contributors

Shraddha Kapurkar
Vaishnavi Mahalle

## GitHub

https://github.com/shraddhakapurkar1674/TravelRecommandationsystem
