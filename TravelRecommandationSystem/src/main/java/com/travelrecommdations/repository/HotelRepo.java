package com.travelrecommdations.repository;

import com.travelrecommdations.model.Hotel;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Repository
public class HotelRepo {

    @Autowired
    private JdbcTemplate jdbcTemplate;


    private final RowMapper<Hotel> rowMapper = (rs, rowNum) -> {

        Hotel hotel = new Hotel();

        hotel.setId(
                rs.getLong("id")
        );

        hotel.setDestinationId(
                rs.getObject(
                        "destination_id",
                        Long.class
                )
        );

        hotel.setHotelName(
                rs.getString("hotel_name")
        );

        hotel.setLocation(
                rs.getString("location")
        );

        hotel.setRating(
                rs.getObject(
                        "rating",
                        Double.class
                )
        );

        hotel.setPricePerNight(
                rs.getObject(
                        "price_per_night",
                        Double.class
                )
        );

        hotel.setContactNumber(
                rs.getString("contact_number")
        );

        hotel.setDescription(
                rs.getString("description")
        );

        hotel.setImage(
                rs.getString("image")
        );

        hotel.setStatus(
                rs.getString("status")
        );

        return hotel;
    };


    /* =====================================================
       EXISTING GET / FILTER
    ===================================================== */

    public List<Hotel> getFilteredHotels(
            String search,
            Long destinationId,
            String status) {

        StringBuilder sql =
                new StringBuilder(
                        "SELECT * FROM Hotel WHERE 1=1"
                );

        List<Object> params =
                new ArrayList<>();


        if (
                search != null &&
                !search.trim().isEmpty()
        ) {

            sql.append(
                    " AND (" +
                    "LOWER(hotel_name) LIKE ? " +
                    "OR LOWER(location) LIKE ?" +
                    ")"
            );

            String value =
                    "%" +
                    search.trim().toLowerCase() +
                    "%";

            params.add(value);
            params.add(value);
        }


        if (destinationId != null) {

            sql.append(
                    " AND destination_id = ?"
            );

            params.add(destinationId);
        }


        if (
                status != null &&
                !status.trim().isEmpty()
        ) {

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


    /* =====================================================
       NEW:
       FIND HOTELS BY DESTINATION NAME

       NO destination_id USED
    ===================================================== */

    public List<Hotel> findByDestinationName(
            String destinationName) {

        if (
                destinationName == null ||
                destinationName.trim().isEmpty()
        ) {
            return new ArrayList<>();
        }


        String search =
                destinationName
                        .trim()
                        .toLowerCase();


        /*
         * First get ACTIVE hotels.
         *
         * Matching is done in Java so existing
         * database structure is not disturbed.
         */

        String sql =
                "SELECT * FROM Hotel " +
                "WHERE UPPER(status) = 'ACTIVE' " +
                "ORDER BY id DESC";


        List<Hotel> allHotels =
                jdbcTemplate.query(
                        sql,
                        rowMapper
                );


        List<Hotel> matched =
                new ArrayList<>();


        String normalizedDestination =
                normalize(search);


        /*
         * Destination words.
         */

        String[] words =
                normalizedDestination
                        .split("\\s+");


        for (Hotel hotel : allHotels) {

            String hotelName =
                    normalize(
                            hotel.getHotelName()
                    );

            String location =
                    normalize(
                            hotel.getLocation()
                    );


            /*
             * Full destination name match.
             *
             * Example:
             *
             * destination:
             * Baga Beach
             *
             * hotel:
             * The Baga Beach Resort
             */

            if (
                    hotelName.contains(
                            normalizedDestination
                    ) ||
                    location.contains(
                            normalizedDestination
                    )
            ) {

                matched.add(hotel);

                continue;
            }


            /*
             * Match meaningful destination words.
             *
             * Last word is also checked.
             *
             * Example:
             * Kedarnath Temple
             *
             * Kedarnath Hotel
             */

            boolean wordMatched = false;


            for (int i = 0;
                 i < words.length;
                 i++) {

                String word =
                        words[i].trim();


                if (
                        word.length() < 3
                ) {
                    continue;
                }


                if (
                        hotelName.contains(word) ||
                        location.contains(word)
                ) {

                    wordMatched = true;

                    break;
                }

            }


            if (wordMatched) {

                matched.add(hotel);

            }

        }


        return matched;
    }


    private String normalize(String value) {

        if (value == null)
            return "";

        return value
                .toLowerCase()
                .replaceAll(
                        "[^a-z0-9 ]",
                        " "
                )
                .replaceAll(
                        "\\s+",
                        " "
                )
                .trim();
    }


    /* =====================================================
       GET BY ID
    ===================================================== */

    public Optional<Hotel> getHotelById(Long id) {

        String sql =
                "SELECT * FROM Hotel WHERE id = ?";

        List<Hotel> results =
                jdbcTemplate.query(
                        sql,
                        rowMapper,
                        id
                );

        return results.stream().findFirst();
    }


    /* =====================================================
       ADD
    ===================================================== */

    public int addHotel(Hotel h) {

        String sql =
                "INSERT INTO Hotel " +
                "(destination_id, hotel_name, location, " +
                "rating, price_per_night, contact_number, " +
                "description, image, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        return jdbcTemplate.update(
                sql,
                h.getDestinationId(),
                h.getHotelName(),
                h.getLocation(),
                h.getRating(),
                h.getPricePerNight(),
                h.getContactNumber(),
                h.getDescription(),
                h.getImage(),
                h.getStatus()
        );
    }


    /* =====================================================
       UPDATE
    ===================================================== */

    public int updateHotel(
            Long id,
            Hotel h) {

        String sql =
                "UPDATE Hotel SET " +
                "destination_id=?, " +
                "hotel_name=?, " +
                "location=?, " +
                "rating=?, " +
                "price_per_night=?, " +
                "contact_number=?, " +
                "description=?, " +
                "image=?, " +
                "status=? " +
                "WHERE id=?";

        return jdbcTemplate.update(
                sql,
                h.getDestinationId(),
                h.getHotelName(),
                h.getLocation(),
                h.getRating(),
                h.getPricePerNight(),
                h.getContactNumber(),
                h.getDescription(),
                h.getImage(),
                h.getStatus(),
                id
        );
    }


    /* =====================================================
       DELETE
    ===================================================== */

    public int deleteHotel(Long id) {

        return jdbcTemplate.update(
                "DELETE FROM Hotel WHERE id = ?",
                id
        );

    }
    public long count() {
        String sql = "SELECT COUNT(*) FROM hotels";
        Long total = jdbcTemplate.queryForObject(sql, Long.class);
        return total != null ? total : 0;
    }

}