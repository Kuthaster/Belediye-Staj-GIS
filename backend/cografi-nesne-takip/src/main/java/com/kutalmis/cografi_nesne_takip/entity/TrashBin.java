package com.kutalmis.cografi_nesne_takip.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "trash_bin")
@DiscriminatorValue("TRASH_BIN")
public class TrashBin extends UrbanObject {
    @Column(name = "volume_liters")
    private Double volumeLiters;

    @Enumerated(EnumType.STRING)
    @Column(name = "bin_type")
    private BinType binType;

    @Column(name = "material")
    private String material;

    @Column(name = "collection_frequency_days")
    private Integer collectionFrequencyDays;

    public Double getVolumeLiters() {
        return volumeLiters;
    }

    public void setVolumeLiters(Double volumeLiters) {
        this.volumeLiters = volumeLiters;
    }

    public BinType getBinType() {
        return binType;
    }

    public void setBinType(BinType binType) {
        this.binType = binType;
    }

    public String getMaterial() {
        return material;
    }

    public void setMaterial(String material) {
        this.material = material;
    }

    public Integer getCollectionFrequencyDays() {
        return collectionFrequencyDays;
    }

    public void setCollectionFrequencyDays(Integer collectionFrequencyDays) {
        this.collectionFrequencyDays = collectionFrequencyDays;
    }
}