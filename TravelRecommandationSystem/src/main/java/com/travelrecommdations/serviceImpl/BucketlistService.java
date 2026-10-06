package com.travelrecommdations.serviceImpl;

import com.travelrecommdations.model.Destination;
import com.travelrecommdations.repository.BucketlistRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BucketlistService {

    @Autowired
    private BucketlistRepo bucketlistDao;

    public boolean addDestination(Long userId, Long destinationId) {
        if (bucketlistDao.isAlreadyInBucketlist(userId, destinationId)) {
            return true; // Already added
        }
        return bucketlistDao.addToBucketlist(userId, destinationId) > 0;
    }

    public boolean removeDestination(Long userId, Long destinationId) {
        return bucketlistDao.removeFromBucketlist(userId, destinationId) > 0;
    }

    public List<Destination> getUserBucketlist(Long userId) {
        return bucketlistDao.getBucketlistByUser(userId);
    }
}