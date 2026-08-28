package com.kutalmis.cografi_nesne_takip.entity;

import java.time.LocalDateTime;
import java.time.ZoneOffset;

import org.locationtech.jts.geom.Point;
import jakarta.persistence.*;

@Entity
@Table(name = "urban_object")
@Inheritance(strategy = InheritanceType.JOINED)
@DiscriminatorColumn(name = "type")
public class UrbanObject {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "location", nullable = false, columnDefinition = "geometry(Point,4326)")
    private Point location;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private ObjectStatus status;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    private void onPrePersist() {
        this.createdAt = LocalDateTime.now(ZoneOffset.UTC);
        if (this.status == null) {
            this.status = ObjectStatus.ACTIVE;
        }
    }

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PreUpdate
    private void onPreUpdate() {
        this.updatedAt = LocalDateTime.now(ZoneOffset.UTC);
    }

    public UrbanObject() {

    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Point getLocation() {
        return location;
    }

    public void setLocation(Point location) {
        this.location = location;
    }

    public ObjectStatus getStatus() {
        return status;
    }

    public void setStatus(ObjectStatus status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
}
