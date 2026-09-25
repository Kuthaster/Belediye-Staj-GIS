package com.kutalmis.cografi_nesne_takip.service;

import java.time.LocalDateTime;

import org.springframework.data.jpa.domain.Specification;

import com.kutalmis.cografi_nesne_takip.entity.Bench;
import com.kutalmis.cografi_nesne_takip.entity.LightingPole;
import com.kutalmis.cografi_nesne_takip.entity.ObjectStatus;
import com.kutalmis.cografi_nesne_takip.entity.ObjectType;
import com.kutalmis.cografi_nesne_takip.entity.PlaygroundEquipment;
import com.kutalmis.cografi_nesne_takip.entity.TrashBin;
import com.kutalmis.cografi_nesne_takip.entity.Tree;
import com.kutalmis.cografi_nesne_takip.entity.UrbanObject;

public class UrbanObjectSpecifications {

    public static Specification<UrbanObject> hasStatus(ObjectStatus status) {
        return (root, query, cb) -> status == null ? null : cb.equal(root.get("status"), status);
    }

    public static Specification<UrbanObject> hasType(ObjectType type) {
        if (type == null)
            return (root, query, cb) -> null;
        Class<? extends UrbanObject> entityClass = resolveEntityClass(type);
        return (root, query, cb) -> cb.equal(root.type(), entityClass);
    }

    public static Specification<UrbanObject> createdBetween(LocalDateTime from, LocalDateTime to) {
        return (root, query, cb) -> {
            if (from == null && to == null)
                return null;
            if (from != null && to != null)
                return cb.between(root.get("createdAt"), from, to);
            if (from != null)
                return cb.greaterThanOrEqualTo(root.get("createdAt"), from);
            return cb.lessThanOrEqualTo(root.get("createdAt"), to);
        };
    }

    private static Class<? extends UrbanObject> resolveEntityClass(ObjectType type) {
        return switch (type) {
            case BENCH -> Bench.class;
            case TREE -> Tree.class;
            case TRASH_BIN -> TrashBin.class;
            case LIGHTING_POLE -> LightingPole.class;
            case PLAYGROUND_EQUIPMENT -> PlaygroundEquipment.class;
        };
    }
}