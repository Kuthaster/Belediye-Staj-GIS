package com.kutalmis.cografi_nesne_takip.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import com.kutalmis.cografi_nesne_takip.entity.UrbanObject;

public interface UrbanObjectRepository extends JpaRepository<UrbanObject, Long>,
        JpaSpecificationExecutor<UrbanObject> {
}