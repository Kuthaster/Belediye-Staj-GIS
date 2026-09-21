package com.kutalmis.cografi_nesne_takip.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.kutalmis.cografi_nesne_takip.entity.ObjectPhoto;

public interface ObjectPhotoRepository extends JpaRepository<ObjectPhoto, Long> {
    Optional<ObjectPhoto> findByUrbanObjectId(Long urbanObjectId);
}