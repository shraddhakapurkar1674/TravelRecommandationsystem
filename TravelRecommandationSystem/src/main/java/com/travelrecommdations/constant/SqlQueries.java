package com.travelrecommdations.constant;

public class SqlQueries {

    private SqlQueries() {}

    // Fixed table name from 'user' to 'users'
    public static final String FIND_USER_BY_EMAIL = 
        "SELECT * FROM users WHERE LOWER(email) = LOWER(?)";

    public static final String INSERT_USER = 
        "INSERT INTO users (email, password, full_name, role) VALUES (?, ?, ?, ?)";

    public static final String UPDATE_USER_PASSWORD = 
        "UPDATE users SET password = ? WHERE email = ?";

    public static final String COUNT_USERS = 
        "SELECT COUNT(*) FROM users";

    public static final String COUNT_DESTINATIONS = 
        "SELECT COUNT(*) FROM destination";

    public static final String COUNT_HOTELS = 
        "SELECT COUNT(*) FROM hotels";

    public static final String COUNT_TRANSPORTS = 
        "SELECT COUNT(*) FROM transports";

    public static final String COUNT_ACTIVITIES = 
        "SELECT COUNT(*) FROM activities";

    public static final String COUNT_REVIEWS = 
        "SELECT COUNT(*) FROM reviews";

    public static final String GET_TOP_5_DESTINATIONS = 
        "SELECT id, destination_name, state, country, category, budget, status FROM destination ORDER BY id DESC LIMIT 5";
}