package com.travelrecommdations.serviceImpl;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.travelrecommdations.dto.PackageDTO;
import com.travelrecommdations.model.Activity;
import com.travelrecommdations.model.Hotel;
import com.travelrecommdations.model.Package;
import com.travelrecommdations.repository.PackageRepo;

@Service
public class PackageServiceImpl {

    @Autowired
    private PackageRepo packageRepo;

    @Value("${file.upload-dir}")
    private String uploadDir;

    public Long createPackage(PackageDTO dto) throws IOException {
        Package pkg = new Package();
        pkg.setPackageName(dto.getPackageName());
        pkg.setDuration(dto.getDuration());
        pkg.setPrice(dto.getPrice());
        pkg.setPackageType(dto.getPackageType());
        pkg.setDescription(dto.getDescription());
        pkg.setIncludedServices(dto.getIncludedServices());
        pkg.setExcludedServices(dto.getExcludedServices());
        pkg.setStatus(dto.getStatus());

        Long packageId = packageRepo.savePackage(pkg);

        if (dto.getDestinations() != null && !dto.getDestinations().isEmpty()) {
            Path uploadPath = Paths.get(uploadDir).toAbsolutePath().normalize();
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            for (PackageDTO.DestinationItemDTO destItem : dto.getDestinations()) {
                String imageName = destItem.getImageName() != null ? destItem.getImageName() : "default.jpg";
                MultipartFile file = destItem.getImageFile();

                if (file != null && !file.isEmpty()) {
                    String originalFilename = file.getOriginalFilename();
                    imageName = System.currentTimeMillis() + "_" + originalFilename;
                    Path filePath = uploadPath.resolve(imageName);
                    Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                }

                packageRepo.saveDestination(packageId, destItem.getDestinationName(), imageName);
            }
        }

        return packageId;
    }

    public void updatePackage(Long id, PackageDTO dto) throws IOException {
        Package pkg = new Package();
        pkg.setPackageId(id);
        pkg.setPackageName(dto.getPackageName());
        pkg.setDuration(dto.getDuration());
        pkg.setPrice(dto.getPrice());
        pkg.setPackageType(dto.getPackageType());
        pkg.setDescription(dto.getDescription());
        pkg.setIncludedServices(dto.getIncludedServices());
        pkg.setExcludedServices(dto.getExcludedServices());
        pkg.setStatus(dto.getStatus());

        packageRepo.updatePackage(pkg);
        packageRepo.deleteDestinationsByPackageId(id);

        if (dto.getDestinations() != null && !dto.getDestinations().isEmpty()) {
            Path uploadPath = Paths.get(uploadDir).toAbsolutePath().normalize();
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            for (PackageDTO.DestinationItemDTO destItem : dto.getDestinations()) {
                String imageName = destItem.getImageName() != null ? destItem.getImageName() : "default.jpg";
                MultipartFile file = destItem.getImageFile();

                if (file != null && !file.isEmpty()) {
                    String originalFilename = file.getOriginalFilename();
                    imageName = System.currentTimeMillis() + "_" + originalFilename;
                    Path filePath = uploadPath.resolve(imageName);
                    Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                }

                packageRepo.saveDestination(id, destItem.getDestinationName(), imageName);
            }
        }
    }

    public void deletePackage(Long id) {
        packageRepo.deletePackage(id);
    }

    public List<Package> getAllPackages() {
        return packageRepo.findAllPackages();
    }
    
    public Package getPackageById(Long packageId) {
        return packageRepo.getPackageById(packageId);
    }

    public List<PackageDTO.DestinationItemDTO> getDestinationsByPackageId(Long packageId) {
        return packageRepo.getDestinationsByPackageId(packageId);
    }

    public List<Hotel> getHotelsForDestinations(List<String> destNames) {
        return packageRepo.getHotelsByDestinationNames(destNames);
    }

    public List<Activity> getActivitiesForDestinations(List<String> destNames) {
        return packageRepo.getActivitiesByDestinationNames(destNames);
    }
}