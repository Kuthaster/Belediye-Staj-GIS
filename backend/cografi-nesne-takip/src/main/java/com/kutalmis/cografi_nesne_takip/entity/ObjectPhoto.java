package com.kutalmis.cografi_nesne_takip.entity;

import java.time.LocalDateTime;

import jakarta.persistence.*;

@Entity
@Table(name = "object_photo")
public class ObjectPhoto {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "urban_object_id", nullable = false, unique = true)
    private UrbanObject urbanObject;

    @Column(name = "current_path", nullable = false)
    private String currentPath;

    @Column(name = "previous_path")
    private String previousPath;

    @Column(name = "uploaded_at", nullable = false)
    private LocalDateTime uploadedAt;

    @Column(name = "content_type", nullable = false)
    private String contentType;

    @Column(name = "previous_content_type")
    private String previousContentType;

    // getters/setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setUrbanObject(UrbanObject urbanObject) {
        this.urbanObject = urbanObject;
    }

    public UrbanObject getUrbanObject() {
        return urbanObject;
    }

    public String getPreviousPath() {
        return previousPath;
    }

    public void setPreviousPath(String previousPath) {
        this.previousPath = previousPath;

    }

    public String getCurrentPath() {
        return currentPath;
    }

    public void setCurrentPath(String currentPath) {
        this.currentPath = currentPath;
    }

    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(LocalDateTime uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public String getPreviousContentType() {
        return previousContentType;
    }

    public void setPreviousContentType(String previousContentType) {
        this.previousContentType = previousContentType;
    }

}