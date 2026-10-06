package com.travelrecommdations.serviceImpl;

import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String senderEmail;

    @Async
    public void sendWelcomeEmail(String toEmail, String name) {
        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            
            // true flag indicates multipart message support
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");

            // Sender Email ID + Custom Display Name ("TripNexa")
            helper.setFrom(senderEmail, "TripNexa"); 
            helper.setTo(toEmail);
            helper.setSubject("Welcome to TripNexa! 🚀");
            helper.setText("Hi " + name + ",\n\nWelcome to TripNexa! Your account has been created successfully.\n\nYou can now log in and start planning your travel.\n\nBest Regards,\nTripNexa Team");

            mailSender.send(mimeMessage);
            System.out.println("Email sent successfully to: " + toEmail);

        } catch (Exception e) {
            System.err.println("Email sending failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}