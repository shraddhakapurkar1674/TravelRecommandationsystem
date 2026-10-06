package com.travelrecommdations.dto;

public class LoginResponseDTO {

    private Long userId;
    private String token;
    private String role;
    private String fullName;
    private String email;

    public LoginResponseDTO() {
    }

    public LoginResponseDTO(
            Long userId,
            String token,
            String role,
            String fullName,
            String email) {

        this.userId = userId;
        this.token = token;
        this.role = role;
        this.fullName = fullName;
        this.email = email;
    }

    // =====================================================
    // USER ID
    // =====================================================

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    // =====================================================
    // TOKEN
    // =====================================================

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    // =====================================================
    // ROLE
    // =====================================================

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    // =====================================================
    // FULL NAME
    // =====================================================

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    // =====================================================
    // EMAIL
    // =====================================================

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}