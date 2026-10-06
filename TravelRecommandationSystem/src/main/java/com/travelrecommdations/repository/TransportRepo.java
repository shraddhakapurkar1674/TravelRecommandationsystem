package com.travelrecommdations.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.travelrecommdations.model.Transport;

@Repository
public class TransportRepo {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // =========================
    // ADD TRANSPORT
    // =========================
    public int save(Transport transport) {

        String sql = "INSERT INTO transport "
                + "(from_location, to_location, transport_type, transport_provider, "
                + "pricing_type, pricing_value, facilities, facility_charge, image, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        return jdbcTemplate.update(
                sql,
                transport.getFromLocation(),
                transport.getToLocation(),
                transport.getTransportType(),
                transport.getTransportProvider(),
                transport.getPricingType(),
                transport.getPricingValue(),
                transport.getFacilities(),
                transport.getFacilityCharge(),
                transport.getImage(),
                transport.getStatus()
        );
    }

    // =========================
    // GET ALL TRANSPORTS
    // =========================
    public List<Transport> findAll() {

        String sql = "SELECT * FROM transport ORDER BY transport_id DESC";

        return jdbcTemplate.query(sql, (rs, rowNum) -> {

            Transport transport = new Transport();

            transport.setTransportId(rs.getInt("transport_id"));
            transport.setFromLocation(rs.getString("from_location"));
            transport.setToLocation(rs.getString("to_location"));
            transport.setTransportType(rs.getString("transport_type"));
            transport.setTransportProvider(rs.getString("transport_provider"));
            transport.setPricingType(rs.getString("pricing_type"));
            transport.setPricingValue(rs.getDouble("pricing_value"));
            transport.setFacilities(rs.getString("facilities"));
            transport.setFacilityCharge(rs.getDouble("facility_charge"));
            transport.setImage(rs.getString("image"));
            transport.setStatus(rs.getString("status"));

            return transport;
        });
    }

    // =========================
    // GET TRANSPORT BY ID
    // =========================
    public Transport findById(Integer id) {

        String sql = "SELECT * FROM transport WHERE transport_id = ?";

        List<Transport> list = jdbcTemplate.query(
                sql,
                new Object[]{id},
                (rs, rowNum) -> {

                    Transport transport = new Transport();

                    transport.setTransportId(rs.getInt("transport_id"));
                    transport.setFromLocation(rs.getString("from_location"));
                    transport.setToLocation(rs.getString("to_location"));
                    transport.setTransportType(rs.getString("transport_type"));
                    transport.setTransportProvider(rs.getString("transport_provider"));
                    transport.setPricingType(rs.getString("pricing_type"));
                    transport.setPricingValue(rs.getDouble("pricing_value"));
                    transport.setFacilities(rs.getString("facilities"));
                    transport.setFacilityCharge(rs.getDouble("facility_charge"));
                    transport.setImage(rs.getString("image"));
                    transport.setStatus(rs.getString("status"));

                    return transport;
                }
        );

        if (list.isEmpty()) {
            return null;
        }

        return list.get(0);
    }

    // =========================
    // UPDATE TRANSPORT
    // =========================
    public int update(Transport transport) {

        String sql = "UPDATE transport SET "
                + "from_location = ?, "
                + "to_location = ?, "
                + "transport_type = ?, "
                + "transport_provider = ?, "
                + "pricing_type = ?, "
                + "pricing_value = ?, "
                + "facilities = ?, "
                + "facility_charge = ?, "
                + "image = ?, "
                + "status = ? "
                + "WHERE transport_id = ?";

        return jdbcTemplate.update(
                sql,
                transport.getFromLocation(),
                transport.getToLocation(),
                transport.getTransportType(),
                transport.getTransportProvider(),
                transport.getPricingType(),
                transport.getPricingValue(),
                transport.getFacilities(),
                transport.getFacilityCharge(),
                transport.getImage(),
                transport.getStatus(),
                transport.getTransportId()
        );
    }

    // =========================
    // DELETE TRANSPORT
    // =========================
    public int delete(Integer id) {

        String sql = "DELETE FROM transport WHERE transport_id = ?";

        return jdbcTemplate.update(sql, id);
    }

    // =========================
    // SEARCH TRANSPORT
    // =========================
    public List<Transport> search(String keyword) {

        String sql = "SELECT * FROM transport "
                + "WHERE LOWER(from_location) LIKE ? "
                + "OR LOWER(to_location) LIKE ? "
                + "OR LOWER(transport_type) LIKE ? "
                + "OR LOWER(transport_provider) LIKE ? "
                + "ORDER BY transport_id DESC";

        String searchValue = "%" + keyword.toLowerCase() + "%";

        return jdbcTemplate.query(
                sql,
                new Object[]{
                        searchValue,
                        searchValue,
                        searchValue,
                        searchValue
                },
                (rs, rowNum) -> {

                    Transport transport = new Transport();

                    transport.setTransportId(rs.getInt("transport_id"));
                    transport.setFromLocation(rs.getString("from_location"));
                    transport.setToLocation(rs.getString("to_location"));
                    transport.setTransportType(rs.getString("transport_type"));
                    transport.setTransportProvider(rs.getString("transport_provider"));
                    transport.setPricingType(rs.getString("pricing_type"));
                    transport.setPricingValue(rs.getDouble("pricing_value"));
                    transport.setFacilities(rs.getString("facilities"));
                    transport.setFacilityCharge(rs.getDouble("facility_charge"));
                    transport.setImage(rs.getString("image"));
                    transport.setStatus(rs.getString("status"));

                    return transport;
                }
        );
    }

    // =========================
    // GET TRANSPORT FOR DESTINATION
    // =========================
    public List<Transport> findByDestination(String destination) {

        String sql =
                "SELECT * FROM transport " +
                "WHERE UPPER(status) = 'ACTIVE' " +
                "AND (LOWER(from_location) LIKE ? " +
                "OR LOWER(to_location) LIKE ?) " +
                "ORDER BY transport_id DESC";

        String value =
                "%" + destination.trim().toLowerCase() + "%";

        return jdbcTemplate.query(
                sql,
                new Object[]{value, value},
                (rs, rowNum) -> {

                    Transport transport = new Transport();

                    transport.setTransportId(
                            rs.getInt("transport_id")
                    );

                    transport.setFromLocation(
                            rs.getString("from_location")
                    );

                    transport.setToLocation(
                            rs.getString("to_location")
                    );

                    transport.setTransportType(
                            rs.getString("transport_type")
                    );

                    transport.setTransportProvider(
                            rs.getString("transport_provider")
                    );

                    transport.setPricingType(
                            rs.getString("pricing_type")
                    );

                    transport.setPricingValue(
                            rs.getObject(
                                    "pricing_value",
                                    Double.class
                            )
                    );

                    transport.setFacilities(
                            rs.getString("facilities")
                    );

                    transport.setFacilityCharge(
                            rs.getObject(
                                    "facility_charge",
                                    Double.class
                            )
                    );

                    transport.setImage(
                            rs.getString("image")
                    );

                    transport.setStatus(
                            rs.getString("status")
                    );

                    return transport;
                }
        );
    }
    public long count() {
        String sql = "SELECT COUNT(*) FROM transport_routes";
        Long total = jdbcTemplate.queryForObject(sql, Long.class);
        return total != null ? total : 0;
    }

}
