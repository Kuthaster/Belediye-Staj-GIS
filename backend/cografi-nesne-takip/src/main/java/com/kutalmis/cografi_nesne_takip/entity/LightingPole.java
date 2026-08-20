package com.kutalmis.cografi_nesne_takip.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "lighting_pole")
@DiscriminatorValue("LIGHTING_POLE")
public class LightingPole extends UrbanObject {
    @Column(name = "wattage", nullable = true)
    private Integer wattage;

    @Column(name = "height_m", nullable = true)
    private Double heightM;

    @Enumerated(EnumType.STRING)
    @Column(name = "light_type", nullable = false)
    private LightType lightType;

    @Enumerated(EnumType.STRING)
    @Column(name = "power_source", nullable = false)
    private PowerSource powerSource;

    public Integer getWattage() {
        return wattage;
    }

    public void setWattage(Integer wattage) {
        this.wattage = wattage;
    }

    public Double getHeightM() {
        return heightM;
    }

    public void setHeightM(Double heightM) {
        this.heightM = heightM;
    }

    public LightType getLightType() {
        return lightType;
    }

    public PowerSource getPowerSource() {
        return powerSource;
    }

    public void setLightType(LightType lightType) {
        this.lightType = lightType;
    }

    public void setPowerSource(PowerSource powerSource) {
        this.powerSource = powerSource;
    }

}
