package com.kutalmis.cografi_nesne_takip.entity;

import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "tree")
@DiscriminatorValue("TREE")
public class Tree extends UrbanObject {

    @Column(name = "species")
    private String species;

    @Column(name = "trunk_diameter_cm")
    private Double trunkDiameterCm;

    @Column(name = "planting_date")
    private LocalDate plantingDate;

    @Column(name = "height_m")
    private Double heightM;

    @Column(name = "health_status")
    private String healthStatus;

    public String getSpecies() {
        return species;
    }

    public void setSpecies(String species) {
        this.species = species;
    }

    public Double getTrunkDiameterCm() {
        return trunkDiameterCm;
    }

    public void setTrunkDiameterCm(Double trunkDiameterCm) {
        this.trunkDiameterCm = trunkDiameterCm;
    }

    public LocalDate getPlantingDate() {
        return plantingDate;
    }

    public void setPlantingDate(LocalDate plantingDate) {
        this.plantingDate = plantingDate;
    }

    public Double getHeightM() {
        return heightM;
    }

    public void setHeightM(Double heightM) {
        this.heightM = heightM;
    }

    public String getHealthStatus() {
        return healthStatus;
    }

    public void setHealthStatus(String healthStatus) {
        this.healthStatus = healthStatus;
    }

}
