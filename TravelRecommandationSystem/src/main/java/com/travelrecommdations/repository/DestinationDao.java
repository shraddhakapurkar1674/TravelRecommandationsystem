package com.travelrecommdations.repository;

import com.travelrecommdations.model.Destination;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Repository
public class DestinationDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // =========================================================
    // ROW MAPPER
    // =========================================================

    private final RowMapper<Destination> rowMapper =
            (rs, rowNum) -> {

        Destination dest = new Destination();

        dest.setId(
                rs.getLong("id")
        );

        dest.setDestinationName(
                rs.getString("destination_name")
        );

        dest.setState(
                rs.getString("state")
        );

        dest.setCountry(
                rs.getString("country")
        );

        dest.setCategory(
                rs.getString("category")
        );

        Double budget =
                rs.getObject(
                        "budget",
                        Double.class
                );

        dest.setBudget(
                budget
        );

        dest.setBestSeason(
                rs.getString("best_season")
        );

        dest.setDescription(
                rs.getString("description")
        );

        dest.setImage(
                rs.getString("image")
        );

        dest.setStatus(
                rs.getString("status")
        );

        return dest;
    };

    // =========================================================
    // GET ALL / FILTER
    // =========================================================

    public List<Destination> getFilteredDestinations(
            String search,
            String country,
            String status) {

        StringBuilder sql =
                new StringBuilder(
                        "SELECT * FROM destination WHERE 1=1"
                );

        List<Object> params =
                new ArrayList<>();

        if (search != null &&
            !search.trim().isEmpty()) {

            sql.append(
                    " AND (" +
                    "LOWER(destination_name) LIKE ? " +
                    "OR LOWER(state) LIKE ? " +
                    "OR LOWER(country) LIKE ? " +
                    "OR LOWER(category) LIKE ? " +
                    "OR LOWER(description) LIKE ?" +
                    ")"
            );

            String term =
                    "%" +
                    search.trim().toLowerCase() +
                    "%";

            params.add(term);
            params.add(term);
            params.add(term);
            params.add(term);
            params.add(term);
        }

        if (country != null &&
            !country.trim().isEmpty()) {

            sql.append(
                    " AND LOWER(country) = LOWER(?)"
            );

            params.add(
                    country.trim()
            );
        }

        if (status != null &&
            !status.trim().isEmpty()) {

            sql.append(
                    " AND UPPER(status) = ?"
            );

            params.add(
                    status.trim().toUpperCase()
            );
        }

        sql.append(
                " ORDER BY id DESC"
        );

        return jdbcTemplate.query(
                sql.toString(),
                rowMapper,
                params.toArray()
        );
    }

    // =========================================================
    // GET BY ID
    // =========================================================

    public Optional<Destination> getDestinationById(
            Long id) {

        String sql =
                "SELECT * FROM destination WHERE id = ?";

        List<Destination> results =
                jdbcTemplate.query(
                        sql,
                        rowMapper,
                        id
                );

        return results
                .stream()
                .findFirst();
    }

    // =========================================================
    // INSERT
    // =========================================================

    public int addDestination(
            Destination d) {

        String sql =
                "INSERT INTO destination " +
                "(destination_name, state, country, " +
                "category, budget, best_season, " +
                "description, image, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        return jdbcTemplate.update(
                sql,
                d.getDestinationName(),
                d.getState(),
                d.getCountry(),
                d.getCategory(),
                d.getBudget(),
                d.getBestSeason(),
                d.getDescription(),
                d.getImage(),
                d.getStatus()
        );
    }

    // =========================================================
    // UPDATE
    // =========================================================

    public int updateDestination(
            Long id,
            Destination d) {

        String sql =
                "UPDATE destination SET " +
                "destination_name=?, " +
                "state=?, " +
                "country=?, " +
                "category=?, " +
                "budget=?, " +
                "best_season=?, " +
                "description=?, " +
                "image=?, " +
                "status=? " +
                "WHERE id=?";

        return jdbcTemplate.update(
                sql,
                d.getDestinationName(),
                d.getState(),
                d.getCountry(),
                d.getCategory(),
                d.getBudget(),
                d.getBestSeason(),
                d.getDescription(),
                d.getImage(),
                d.getStatus(),
                id
        );
    }

    // =========================================================
    // DELETE
    // =========================================================

    public int deleteDestination(
            Long id) {

        String sql =
                "DELETE FROM destination WHERE id = ?";

        return jdbcTemplate.update(
                sql,
                id
        );
    }

    // =========================================================
    // RECOMMENDATION - BUDGET
    // =========================================================

    public List<Destination> getDestinationsByBudget(
            Double minBudget,
            Double maxBudget) {

        String sql =
                "SELECT * FROM destination " +
                "WHERE budget BETWEEN ? AND ? " +
                "AND UPPER(status) = 'ACTIVE' " +
                "ORDER BY budget ASC";

        return jdbcTemplate.query(
                sql,
                rowMapper,
                minBudget,
                maxBudget
        );
    }

    // =========================================================
    // RECOMMENDATION - CATEGORY
    // =========================================================

    public List<Destination> getDestinationsByCategory(
            String category) {

        String sql =
                "SELECT * FROM destination " +
                "WHERE LOWER(category) = LOWER(?) " +
                "AND UPPER(status) = 'ACTIVE' " +
                "ORDER BY id DESC";

        return jdbcTemplate.query(
                sql,
                rowMapper,
                category
        );
    }

    // =========================================================
    // RECOMMENDATION - EXPLORE SEARCH
    // =========================================================

    public List<Destination> searchDestinations(
            String search) {

        String sql =
                "SELECT * FROM destination " +
                "WHERE UPPER(status) = 'ACTIVE' " +
                "AND (" +
                "LOWER(destination_name) LIKE ? " +
                "OR LOWER(state) LIKE ? " +
                "OR LOWER(country) LIKE ? " +
                "OR LOWER(category) LIKE ? " +
                "OR LOWER(description) LIKE ?" +
                ") " +
                "ORDER BY " +
                "CASE " +
                "WHEN LOWER(destination_name) = LOWER(?) THEN 1 " +
                "WHEN LOWER(destination_name) LIKE ? THEN 2 " +
                "WHEN LOWER(category) = LOWER(?) THEN 3 " +
                "ELSE 4 " +
                "END, id DESC";

        String term =
                "%" +
                search.trim().toLowerCase() +
                "%";

        String startsWith =
                search.trim().toLowerCase() +
                "%";

        String exact =
                search.trim().toLowerCase();

        return jdbcTemplate.query(
                sql,
                rowMapper,
                term,
                term,
                term,
                term,
                term,
                exact,
                startsWith,
                exact
        );
    }

    // =========================================================
    // RECOMMENDATION - AVAILABLE SEASONS
    // =========================================================

    public List<String> getAvailableSeasons() {

        List<String> seasons =
                new ArrayList<>();

        seasons.add("Summer");
        seasons.add("Monsoon");
        seasons.add("Winter");
        seasons.add("Autumn");

        return seasons;
    }

    // =========================================================
    // RECOMMENDATION - SEASON FILTER
    // =========================================================

    public List<Destination> getDestinationsBySeason(
            String season) {

        String normalizedSeason =
                season == null
                        ? ""
                        : season.trim().toLowerCase();

        StringBuilder sql =
                new StringBuilder(
                        "SELECT * FROM destination " +
                        "WHERE UPPER(status) = 'ACTIVE' "
                );

        List<Object> params =
                new ArrayList<>();

        if (normalizedSeason.equals("summer")) {

            sql.append(
                    "AND (" +
                    "LOWER(best_season) LIKE '%march to june%' " +
                    "OR LOWER(best_season) LIKE '%april to june%' " +
                    "OR LOWER(best_season) LIKE '%december to june%' " +
                    "OR LOWER(best_season) LIKE '%october to june%'" +
                    ") "
            );
        }

        else if (normalizedSeason.equals("monsoon")) {

            sql.append(
                    "AND (" +
                    "LOWER(best_season) LIKE '%june to october%' " +
                    "OR LOWER(best_season) LIKE '%june to september%' " +
                    "OR LOWER(best_season) LIKE '%july to september%' " +
                    "OR LOWER(best_season) LIKE '%september to november%' " +
                    "OR LOWER(best_season) LIKE '%april to october%' " +
                    ") "
            );
        }

        else if (normalizedSeason.equals("winter")) {

            sql.append(
                    "AND (" +
                    "LOWER(best_season) LIKE '%november to february%' " +
                    "OR LOWER(best_season) LIKE '%december to march%' " +
                    "OR LOWER(best_season) LIKE '%october to march%' " +
                    "OR LOWER(best_season) LIKE '%october to february%' " +
                    "OR LOWER(best_season) LIKE '%november to april%' " +
                    "OR LOWER(best_season) LIKE '%october to april%' " +
                    ") "
            );
        }

        else if (normalizedSeason.equals("autumn")) {

            sql.append(
                    "AND (" +
                    "LOWER(best_season) LIKE '%september to march%' " +
                    "OR LOWER(best_season) LIKE '%september to november%' " +
                    "OR LOWER(best_season) LIKE '%october to march%' " +
                    "OR LOWER(best_season) LIKE '%october to april%' " +
                    ") "
            );
        }

        else {
            return new ArrayList<>();
        }

        sql.append(
                "ORDER BY id DESC"
        );

        return jdbcTemplate.query(
                sql.toString(),
                rowMapper,
                params.toArray()
        );
    }

    // =========================================================
    // GET ALL ACTIVE DESTINATIONS
    // =========================================================

    public List<Destination> getAllActiveDestinations() {

        String sql =
                "SELECT * FROM destination " +
                "WHERE UPPER(status) = 'ACTIVE' " +
                "ORDER BY id DESC";

        return jdbcTemplate.query(
                sql,
                rowMapper
        );
    }
    
    
 // =========================================================
    // RECOMMENDATION - PERSONALIZED FILTER
    // =========================================================

 //
    
    
 // =========================================================
    // RECOMMENDATION - PERSONALIZED FILTER
    // =========================================================

    public List<Destination> getPersonalizedDestinations(
            Double minBudget,
            Double maxBudget,
            String season,
            String mood,
            String category,
            String companion) {

        // 1. Sarvat adhi strict combination (AND conditions) sathi query run karu
        StringBuilder sql = new StringBuilder(
                "SELECT * FROM destination WHERE UPPER(status) = 'ACTIVE'"
        );
        List<Object> params = new ArrayList<>();

        if (minBudget != null && maxBudget != null) {
            sql.append(" AND budget BETWEEN ? AND ?");
            params.add(minBudget);
            params.add(maxBudget);
        } else if (minBudget != null) {
            sql.append(" AND budget >= ?");
            params.add(minBudget);
        } else if (maxBudget != null) {
            sql.append(" AND budget <= ?");
            params.add(maxBudget);
        }

        // Season flexible condition
        if (season != null && !season.trim().isEmpty() && !season.equalsIgnoreCase("All") && !season.equalsIgnoreCase("undefined")) {
            sql.append(" AND (LOWER(best_season) LIKE ? OR LOWER(description) LIKE ?)");
            String sTerm = "%" + season.trim().toLowerCase() + "%";
            params.add(sTerm);
            params.add(sTerm);
        }

        // Category condition
        if (category != null && !category.trim().isEmpty() && !category.equalsIgnoreCase("All") && !category.equalsIgnoreCase("undefined")) {
            sql.append(" AND LOWER(category) LIKE ?");
            params.add("%" + category.trim().toLowerCase() + "%");
        }

        // Mood condition
        if (mood != null && !mood.trim().isEmpty() && !mood.equalsIgnoreCase("All") && !mood.equalsIgnoreCase("undefined")) {
            sql.append(" AND (LOWER(description) LIKE ? OR LOWER(category) LIKE ?)");
            String mTerm = "%" + mood.trim().toLowerCase() + "%";
            params.add(mTerm);
            params.add(mTerm);
        }

        // Companion condition
        if (companion != null && !companion.trim().isEmpty() && !companion.equalsIgnoreCase("All") && !companion.equalsIgnoreCase("undefined")) {
            sql.append(" AND (LOWER(description) LIKE ? OR LOWER(category) LIKE ?)");
            String cTerm = "%" + companion.trim().toLowerCase() + "%";
            params.add(cTerm);
            params.add(cTerm);
        }

        sql.append(" ORDER BY id DESC");

        List<Destination> results = jdbcTemplate.query(
                sql.toString(),
                rowMapper,
                params.toArray()
        );

        // 2. JAR strict combination mule ek pan destination bhetali nahi,
        // tar user ne select kelelya kontya pan 1 factor la match honare destinations fetch karu (OR Fallback)
        if (results == null || results.isEmpty()) {
            StringBuilder fallbackSql = new StringBuilder(
                    "SELECT * FROM destination WHERE UPPER(status) = 'ACTIVE' AND ("
            );
            List<Object> fallbackParams = new ArrayList<>();
            boolean hasCondition = false;

            if (minBudget != null && maxBudget != null) {
                fallbackSql.append("budget BETWEEN ? AND ?");
                fallbackParams.add(minBudget);
                fallbackParams.add(maxBudget);
                hasCondition = true;
            }

            if (season != null && !season.trim().isEmpty() && !season.equalsIgnoreCase("All") && !season.equalsIgnoreCase("undefined")) {
                if (hasCondition) fallbackSql.append(" OR ");
                fallbackSql.append("(LOWER(best_season) LIKE ? OR LOWER(description) LIKE ?)");
                String sTerm = "%" + season.trim().toLowerCase() + "%";
                fallbackParams.add(sTerm);
                fallbackParams.add(sTerm);
                hasCondition = true;
            }

            if (category != null && !category.trim().isEmpty() && !category.equalsIgnoreCase("All") && !category.equalsIgnoreCase("undefined")) {
                if (hasCondition) fallbackSql.append(" OR ");
                fallbackSql.append("LOWER(category) LIKE ?");
                fallbackParams.add("%" + category.trim().toLowerCase() + "%");
                hasCondition = true;
            }

            if (mood != null && !mood.trim().isEmpty() && !mood.equalsIgnoreCase("All") && !mood.equalsIgnoreCase("undefined")) {
                if (hasCondition) fallbackSql.append(" OR ");
                fallbackSql.append("(LOWER(description) LIKE ? OR LOWER(category) LIKE ?)");
                String mTerm = "%" + mood.trim().toLowerCase() + "%";
                fallbackParams.add(mTerm);
                fallbackParams.add(mTerm);
                hasCondition = true;
            }

            if (companion != null && !companion.trim().isEmpty() && !companion.equalsIgnoreCase("All") && !companion.equalsIgnoreCase("undefined")) {
                if (hasCondition) fallbackSql.append(" OR ");
                fallbackSql.append("(LOWER(description) LIKE ? OR LOWER(category) LIKE ?)");
                String cTerm = "%" + companion.trim().toLowerCase() + "%";
                fallbackParams.add(cTerm);
                fallbackParams.add(cTerm);
                hasCondition = true;
            }

            if (hasCondition) {
                fallbackSql.append(") ORDER BY id DESC");
                results = jdbcTemplate.query(
                        fallbackSql.toString(),
                        rowMapper,
                        fallbackParams.toArray()
                );
            } else {
                results = getAllActiveDestinations();
            }
        }

        return results;
    }
    public long count() {
        String sql = "SELECT COUNT(*) FROM destinations";
        Long total = jdbcTemplate.queryForObject(sql, Long.class);
        return total != null ? total : 0;
    }
}
