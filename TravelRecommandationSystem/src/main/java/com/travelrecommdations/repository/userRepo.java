package com.travelrecommdations.repository;

import com.travelrecommdations.model.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;

@Repository
public class userRepo {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<user> userRowMapper =
            new RowMapper<user>() {

        @Override
        public user mapRow(
                ResultSet rs,
                int rowNum) throws SQLException {

            user u = new user();

            u.setId(rs.getLong("id"));

            u.setFullName(
                    rs.getString("full_name")
            );

            u.setEmail(
                    rs.getString("email")
            );

            u.setPassword(
                    rs.getString("password")
            );

            u.setRole(
                    rs.getString("role")
            );

            return u;
        }
    };

    public Optional<user> findById(Long id) {

        String sql =
                "SELECT * FROM users WHERE id = ?";

        try {

            user u =
                    jdbcTemplate.queryForObject(
                            sql,
                            userRowMapper,
                            id
                    );

            return Optional.ofNullable(u);

        } catch (EmptyResultDataAccessException e) {

            return Optional.empty();
        }
    }

    public Optional<user> findByEmail(String email) {

        String sql =
                "SELECT * FROM users WHERE email = ?";

        try {

            user u =
                    jdbcTemplate.queryForObject(
                            sql,
                            userRowMapper,
                            email
                    );

            return Optional.ofNullable(u);

        } catch (EmptyResultDataAccessException e) {

            return Optional.empty();
        }
    }

    public void save(user u) {

        String sql =
                "INSERT INTO users " +
                "(full_name, email, password, role) " +
                "VALUES (?, ?, ?, ?)";

        jdbcTemplate.update(
                sql,
                u.getFullName(),
                u.getEmail(),
                u.getPassword(),
                u.getRole()
        );
    }
    public java.util.List<java.util.Map<String, Object>> findAllUsersWithProfilesAsMaps() {
        String sql = "SELECT u.id, u.full_name, u.email, u.role, u.created_at, " +
                     "p.profile_id, p.profile_photo, p.age, p.location, p.travel_companion, " +
                     "p.budget, p.trip_duration, p.transportation, p.accommodation, " +
                     "p.interests, p.destination_categories, p.food_preference, " +
                     "p.preferred_season, p.trip_experience, p.profile_completed " +
                     "FROM users u LEFT JOIN travel_profile p ON u.id = p.user_id";
        
        return jdbcTemplate.queryForList(sql);
    }

    public void deleteUserAndProfile(Long id) {
        // Delete child record first
        jdbcTemplate.update("DELETE FROM travel_profile WHERE user_id = ?", id);
        // Delete parent user record
        jdbcTemplate.update("DELETE FROM users WHERE id = ?", id);
    }
    
    public long count() {
        String sql = "SELECT COUNT(*) FROM users";
        Long total = jdbcTemplate.queryForObject(sql, Long.class);
        return total != null ? total : 0;
    }
}
