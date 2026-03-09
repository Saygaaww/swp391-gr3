package model;

import java.time.LocalDateTime;

/**
 * LinkedAccount - Tài khoản OAuth liên kết với Reader
 */
public class LinkedAccount {

    private Integer linkId;
    private Integer readerId;
    private String provider; // "google", "facebook"
    private String providerUserId;
    private String providerEmail;
    private LocalDateTime linkedAt;

    public LinkedAccount() {
    }

    public LinkedAccount(Integer readerId, String provider, String providerUserId, String providerEmail) {
        this.readerId = readerId;
        this.provider = provider;
        this.providerUserId = providerUserId;
        this.providerEmail = providerEmail;
    }

    public Integer getLinkId() {
        return linkId;
    }

    public void setLinkId(Integer linkId) {
        this.linkId = linkId;
    }

    public Integer getReaderId() {
        return readerId;
    }

    public void setReaderId(Integer readerId) {
        this.readerId = readerId;
    }

    public String getProvider() {
        return provider;
    }

    public void setProvider(String provider) {
        this.provider = provider;
    }

    public String getProviderUserId() {
        return providerUserId;
    }

    public void setProviderUserId(String providerUserId) {
        this.providerUserId = providerUserId;
    }

    public String getProviderEmail() {
        return providerEmail;
    }

    public void setProviderEmail(String providerEmail) {
        this.providerEmail = providerEmail;
    }

    public LocalDateTime getLinkedAt() {
        return linkedAt;
    }

    public void setLinkedAt(LocalDateTime linkedAt) {
        this.linkedAt = linkedAt;
    }

    /** Trả về icon class CSS cho provider */
    public String getProviderIcon() {
        if ("google".equalsIgnoreCase(provider))
            return "fa-google";
        if ("facebook".equalsIgnoreCase(provider))
            return "fa-facebook-f";
        return "fa-link";
    }

    /** Tên hiển thị của provider */
    public String getProviderDisplayName() {
        if (provider == null)
            return "Unknown";
        return provider.substring(0, 1).toUpperCase() + provider.substring(1).toLowerCase();
    }
}
