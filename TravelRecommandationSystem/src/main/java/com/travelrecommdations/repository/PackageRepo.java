package com.travelrecommdations.repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.Collections;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import com.travelrecommdations.model.PackageDestination;
import com.travelrecommdations.dto.PackageDTO;
import com.travelrecommdations.model.Activity;
import com.travelrecommdations.model.Hotel;
import com.travelrecommdations.model.Package;

@Repository
public class PackageRepo {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public Long savePackage(Package pkg) {
        String sql = "INSERT INTO travel_package (package_name, duration, price, package_type, description, included_services, excluded_services, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, pkg.getPackageName());
            ps.setString(2, pkg.getDuration());
            ps.setDouble(3, pkg.getPrice());
            ps.setString(4, pkg.getPackageType());
            ps.setString(5, pkg.getDescription());
            ps.setString(6, pkg.getIncludedServices());
            ps.setString(7, pkg.getExcludedServices());
            ps.setString(8, pkg.getStatus() != null ? pkg.getStatus() : "Active");
            return ps;
        }, keyHolder);

        return keyHolder.getKey().longValue();
    }

    public void saveDestination(Long packageId, String destinationName, String imageName) {
        String sql = "INSERT INTO package_destination (package_id, destination_name, image_name) VALUES (?, ?, ?)";
        jdbcTemplate.update(sql, packageId, destinationName, imageName);
    }

    public List<Package> findAllPackages() {
        String pkgSql = "SELECT * FROM travel_package ORDER BY package_id DESC";
        return jdbcTemplate.query(pkgSql, (rs, rowNum) -> {
            Package pkg = new Package();
            pkg.setPackageId(rs.getLong("package_id"));
            pkg.setPackageName(rs.getString("package_name"));
            pkg.setDuration(rs.getString("duration"));
            pkg.setPrice(rs.getDouble("price"));
            pkg.setPackageType(rs.getString("package_type"));
            pkg.setDescription(rs.getString("description"));
            pkg.setIncludedServices(rs.getString("included_services"));
            pkg.setExcludedServices(rs.getString("excluded_services"));
            pkg.setStatus(rs.getString("status"));
            pkg.setCreatedAt(rs.getString("created_at"));

            String destSql = "SELECT * FROM package_destination WHERE package_id = ?";
            List<PackageDestination> destinations = jdbcTemplate.query(destSql, new Object[]{pkg.getPackageId()}, (dRs, dNum) -> {
                PackageDestination dest = new PackageDestination();
                dest.setId(dRs.getLong("id"));
                dest.setPackageId(dRs.getLong("package_id"));
                dest.setDestinationName(dRs.getString("destination_name"));
                dest.setImageName(dRs.getString("image_name"));
                return dest;
            });
            pkg.setDestinations(destinations);

            return pkg;
        });
    }

    public void deleteDestinationsByPackageId(Long packageId) {
        String sql = "DELETE FROM package_destination WHERE package_id = ?";
        jdbcTemplate.update(sql, packageId);
    }

    public void deletePackage(Long packageId) {
        deleteDestinationsByPackageId(packageId);
        String sql = "DELETE FROM travel_package WHERE package_id = ?";
        jdbcTemplate.update(sql, packageId);
    }

    public void updatePackage(Package pkg) {
        String sql = "UPDATE travel_package SET package_name = ?, duration = ?, price = ?, package_type = ?, description = ?, included_services = ?, excluded_services = ?, status = ? WHERE package_id = ?";
        jdbcTemplate.update(sql, pkg.getPackageName(), pkg.getDuration(), pkg.getPrice(), pkg.getPackageType(), pkg.getDescription(), pkg.getIncludedServices(), pkg.getExcludedServices(), pkg.getStatus(), pkg.getPackageId());
    }

    public Package getPackageById(Long packageId) {
        String sql = "SELECT * FROM travel_package WHERE package_id = ?";
        return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(Package.class), packageId);
    }

    public List<PackageDTO.DestinationItemDTO> getDestinationsByPackageId(Long packageId) {
        String sql = "SELECT destination_name AS destinationName, image_name AS imageName FROM package_destination WHERE package_id = ?";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(PackageDTO.DestinationItemDTO.class), packageId);
    }

    public List<Hotel> getHotelsByDestinationNames(List<String> destNames) {
        if (destNames == null || destNames.isEmpty()) return Collections.emptyList();
        
        StringBuilder sql = new StringBuilder("SELECT DISTINCT h.id, h.destination_id, h.hotel_name AS hotelName, h.location, h.rating, h.price_per_night AS pricePerNight, h.contact_number AS contactNumber, h.description, h.image, h.status FROM hotel h WHERE ");
        
        for (int i = 0; i < destNames.size(); i++) {
            sql.append("(h.location LIKE ? OR h.hotel_name LIKE ?)");
            if (i < destNames.size() - 1) {
                sql.append(" OR ");
            }
        }
        
        Object[] params = new Object[destNames.size() * 2];
        int index = 0;
        for (String name : destNames) {
            params[index++] = "%" + name + "%";
            params[index++] = "%" + name + "%";
        }
        
        return jdbcTemplate.query(sql.toString(), new BeanPropertyRowMapper<>(Hotel.class), params);
    }

    public List<Activity> getActivitiesByDestinationNames(List<String> destNames) {
        if (destNames == null || destNames.isEmpty()) return Collections.emptyList();
        String placeholders = String.join(",", Collections.nCopies(destNames.size(), "?"));
        String sql = "SELECT a.* FROM activity a JOIN destination d ON a.destination_id = d.id WHERE d.destination_name IN (" + placeholders + ")";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Activity.class), destNames.toArray());
    }
}