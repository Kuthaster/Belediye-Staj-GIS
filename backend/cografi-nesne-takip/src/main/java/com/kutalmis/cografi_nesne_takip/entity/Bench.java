package com.kutalmis.cografi_nesne_takip.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "bench")
@DiscriminatorValue("BENCH")
public class Bench extends UrbanObject {
    @Column(name = "seat_count", nullable = false)
    private Integer seatCount;

    @Column(name = "material", nullable = true)
    private String material;

    @Column(name = "has_backrest", nullable = false)
    private Boolean hasBackrest;

    public Integer getSeatCount() {
        return seatCount;
    }

    public void setSeatCount(Integer seatCount) {
        this.seatCount = seatCount;
    }

    public String getMaterial() {
        return material;
    }

    public void setMaterial(String material) {
        this.material = material;
    }

    public Boolean getHasBackrest() {
        return hasBackrest;
    }

    public void setHasBackrest(Boolean hasBackrest) {
        this.hasBackrest = hasBackrest;
    }

}
