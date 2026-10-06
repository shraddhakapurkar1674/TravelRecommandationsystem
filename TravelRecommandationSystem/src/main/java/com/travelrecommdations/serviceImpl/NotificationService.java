package com.travelrecommdations.serviceImpl;

import com.travelrecommdations.model.Notification;
import com.travelrecommdations.repository.NotificationRepo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NotificationService {

    @Autowired
    private NotificationRepo notificationDao;


    // =========================================================
    // DESTINATION NOTIFICATION
    // =========================================================
    // Only ONE row is inserted into notifications table.
    // That notification is visible to ALL registered users.
    public void notifyUsersAboutNewDestination(String destinationName) {

        Notification notification = new Notification();

        notification.setRecipientType("ALL_USERS");
        notification.setRecipientId(null);

        notification.setTitle("New Destination Added");

        notification.setMessage(
                destinationName
                        + " has been added to Travel Recommendation System."
        );

        notification.setNotificationType("NEW_DESTINATION");

        // Global notification itself is not read.
        // Individual user read status is stored in notification_reads.
        notification.setRead(false);

        notificationDao.save(notification);
    }


    // =========================================================
    // NEW USER REGISTRATION NOTIFICATION FOR ADMIN
    // =========================================================
    // One notification is created for admin when a new user registers.
    public void notifyAdminAboutNewUser(String userName) {

        Notification notification = new Notification();

        notification.setRecipientType("ADMIN");
        notification.setRecipientId(null);

        notification.setTitle("New User Registered");

        notification.setMessage(
                userName
                        + " has registered on Travel Recommendation System."
        );

        notification.setNotificationType("NEW_USER");

        notification.setRead(false);

        notificationDao.save(notification);
    }


    // =========================================================
    // USER NOTIFICATIONS
    // =========================================================

    // Get notifications for a particular logged-in user.
    public List<Notification> getUserNotifications(Long userId) {

        return notificationDao.getUserNotifications(userId);
    }


    // Get unread notification count for a particular user.
    public int getUserUnreadCount(Long userId) {

        return notificationDao.getUserUnreadCount(userId);
    }


    // Mark one notification as read for a particular user.
    public boolean markAsRead(
            Long notificationId,
            Long userId) {

        return notificationDao.markAsRead(
                notificationId,
                userId
        ) > 0;
    }


    // Mark all notifications as read for a particular user.
    public void markAllUserAsRead(Long userId) {

        notificationDao.markAllUserAsRead(userId);
    }


    // =========================================================
    // ADMIN NOTIFICATIONS
    // =========================================================

    // Get all admin notifications.
    public List<Notification> getAdminNotifications() {

        return notificationDao.getAdminNotifications();
    }


    // Get unread admin notification count.
    public int getAdminUnreadCount() {

        return notificationDao.getAdminUnreadCount();
    }


    // Mark one admin notification as read.
    public boolean markAdminAsRead(Long notificationId) {

        return notificationDao.markAdminAsRead(
                notificationId
        ) > 0;
    }


    // Mark all admin notifications as read.
    public void markAllAdminAsRead() {

        notificationDao.markAllAdminAsRead();
    }
}