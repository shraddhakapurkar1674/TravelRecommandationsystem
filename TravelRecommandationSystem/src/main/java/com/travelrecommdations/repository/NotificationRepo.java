package com.travelrecommdations.repository;

import com.travelrecommdations.model.Notification;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.sql.Timestamp;
import java.util.List;

@Repository
public class NotificationRepo {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Save ONE notification
    public int save(Notification notification) {

        String sql = """
            INSERT INTO notifications
            (recipient_type, recipient_id, title, message,
             notification_type, is_read)
            VALUES (?, ?, ?, ?, ?, ?)
            """;

        return jdbcTemplate.update(
                sql,
                notification.getRecipientType(),
                notification.getRecipientId(),
                notification.getTitle(),
                notification.getMessage(),
                notification.getNotificationType(),
                notification.isRead()
        );
    }


    // Get notifications for logged-in user
    // Includes ALL_USERS notifications
    public List<Notification> getUserNotifications(Long userId) {

        String sql = """
            SELECT n.notification_id,
                   n.recipient_type,
                   n.recipient_id,
                   n.title,
                   n.message,
                   n.notification_type,
                   n.is_read,
                   n.created_at,

                   CASE
                       WHEN nr.user_id IS NOT NULL THEN TRUE
                       ELSE FALSE
                   END AS user_read

            FROM notifications n

            LEFT JOIN notification_reads nr
                ON n.notification_id = nr.notification_id
                AND nr.user_id = ?

            WHERE n.recipient_type = 'ALL_USERS'

            ORDER BY n.created_at DESC
            """;

        return jdbcTemplate.query(
                sql,
                (rs, rowNum) -> {

                    Notification n = new Notification();

                    n.setNotificationId(
                            rs.getLong("notification_id")
                    );

                    n.setRecipientType(
                            rs.getString("recipient_type")
                    );

                    long recipientId =
                            rs.getLong("recipient_id");

                    if (!rs.wasNull()) {
                        n.setRecipientId(recipientId);
                    }

                    n.setTitle(
                            rs.getString("title")
                    );

                    n.setMessage(
                            rs.getString("message")
                    );

                    n.setNotificationType(
                            rs.getString("notification_type")
                    );

                    // IMPORTANT
                    // Read status belongs to THIS USER
                    n.setRead(
                            rs.getBoolean("user_read")
                    );

                    Timestamp timestamp =
                            rs.getTimestamp("created_at");

                    if (timestamp != null) {
                        n.setCreatedAt(
                                timestamp.toLocalDateTime()
                        );
                    }

                    return n;
                },
                userId
        );
    }


    // Get unread count for logged-in user
    public int getUserUnreadCount(Long userId) {

        String sql = """
            SELECT COUNT(*)
            FROM notifications n

            LEFT JOIN notification_reads nr
                ON n.notification_id = nr.notification_id
                AND nr.user_id = ?

            WHERE n.recipient_type = 'ALL_USERS'
            AND nr.notification_id IS NULL
            """;

        Integer count = jdbcTemplate.queryForObject(
                sql,
                Integer.class,
                userId
        );

        return count != null ? count : 0;
    }


    // Mark ONE notification as read for ONE user
    public int markAsRead(Long notificationId, Long userId) {

        String sql = """
            INSERT IGNORE INTO notification_reads
            (notification_id, user_id)
            VALUES (?, ?)
            """;

        return jdbcTemplate.update(
                sql,
                notificationId,
                userId
        );
    }


    // Mark ALL notifications as read for ONE user
    public int markAllUserAsRead(Long userId) {

        String sql = """
            INSERT IGNORE INTO notification_reads
            (notification_id, user_id)

            SELECT n.notification_id, ?

            FROM notifications n

            LEFT JOIN notification_reads nr
                ON n.notification_id = nr.notification_id
                AND nr.user_id = ?

            WHERE n.recipient_type = 'ALL_USERS'
            AND nr.notification_id IS NULL
            """;

        return jdbcTemplate.update(
                sql,
                userId,
                userId
        );
    }


    // ============================
    // ADMIN NOTIFICATIONS
    // ============================

    public List<Notification> getAdminNotifications() {

        String sql = """
            SELECT notification_id,
                   recipient_type,
                   recipient_id,
                   title,
                   message,
                   notification_type,
                   is_read,
                   created_at
            FROM notifications
            WHERE recipient_type = 'ADMIN'
            ORDER BY created_at DESC
            """;

        return jdbcTemplate.query(
                sql,
                (rs, rowNum) -> {

                    Notification n = new Notification();

                    n.setNotificationId(
                            rs.getLong("notification_id")
                    );

                    n.setRecipientType(
                            rs.getString("recipient_type")
                    );

                    long recipientId =
                            rs.getLong("recipient_id");

                    if (!rs.wasNull()) {
                        n.setRecipientId(recipientId);
                    }

                    n.setTitle(
                            rs.getString("title")
                    );

                    n.setMessage(
                            rs.getString("message")
                    );

                    n.setNotificationType(
                            rs.getString("notification_type")
                    );

                    n.setRead(
                            rs.getBoolean("is_read")
                    );

                    Timestamp timestamp =
                            rs.getTimestamp("created_at");

                    if (timestamp != null) {
                        n.setCreatedAt(
                                timestamp.toLocalDateTime()
                        );
                    }

                    return n;
                }
        );
    }


    public int getAdminUnreadCount() {

        String sql = """
            SELECT COUNT(*)
            FROM notifications
            WHERE recipient_type = 'ADMIN'
            AND is_read = FALSE
            """;

        Integer count = jdbcTemplate.queryForObject(
                sql,
                Integer.class
        );

        return count != null ? count : 0;
    }


    public int markAdminAsRead(Long notificationId) {

        String sql = """
            UPDATE notifications
            SET is_read = TRUE
            WHERE notification_id = ?
            AND recipient_type = 'ADMIN'
            """;

        return jdbcTemplate.update(
                sql,
                notificationId
        );
    }


    public int markAllAdminAsRead() {

        String sql = """
            UPDATE notifications
            SET is_read = TRUE
            WHERE recipient_type = 'ADMIN'
            AND is_read = FALSE
            """;

        return jdbcTemplate.update(sql);
    }
}