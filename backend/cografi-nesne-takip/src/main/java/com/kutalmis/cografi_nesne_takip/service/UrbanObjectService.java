package com.kutalmis.cografi_nesne_takip.service;

import java.util.List;

import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.PrecisionModel;
import org.springframework.stereotype.Service;

import com.kutalmis.cografi_nesne_takip.Dto.BenchCreateDTO;
import com.kutalmis.cografi_nesne_takip.Dto.BenchDTO;
import com.kutalmis.cografi_nesne_takip.Dto.LightingPoleCreateDTO;
import com.kutalmis.cografi_nesne_takip.Dto.LightingPoleDTO;
import com.kutalmis.cografi_nesne_takip.Dto.PlaygroundEquipmentCreateDTO;
import com.kutalmis.cografi_nesne_takip.Dto.PlaygroundEquipmentDTO;
import com.kutalmis.cografi_nesne_takip.Dto.TrashBinCreateDTO;
import com.kutalmis.cografi_nesne_takip.Dto.TrashBinDTO;
import com.kutalmis.cografi_nesne_takip.Dto.TreeCreateDTO;
import com.kutalmis.cografi_nesne_takip.Dto.TreeDTO;
import com.kutalmis.cografi_nesne_takip.Dto.UrbanObjectSummaryDTO;
import com.kutalmis.cografi_nesne_takip.entity.Bench;
import com.kutalmis.cografi_nesne_takip.entity.LightingPole;
import com.kutalmis.cografi_nesne_takip.entity.ObjectStatus;
import com.kutalmis.cografi_nesne_takip.entity.ObjectType;
import com.kutalmis.cografi_nesne_takip.entity.PlaygroundEquipment;
import com.kutalmis.cografi_nesne_takip.entity.TrashBin;
import com.kutalmis.cografi_nesne_takip.entity.Tree;
import com.kutalmis.cografi_nesne_takip.entity.UrbanObject;
import com.kutalmis.cografi_nesne_takip.exception.ObjectNotFoundException;
import com.kutalmis.cografi_nesne_takip.exception.WrongObjectTypeException;
import com.kutalmis.cografi_nesne_takip.repository.UrbanObjectRepository;

@Service
public class UrbanObjectService {
    private final UrbanObjectRepository urbanObjectRepository;

    public UrbanObjectService(UrbanObjectRepository urbanObjectRepository) {
        this.urbanObjectRepository = urbanObjectRepository;
    }

    public List<UrbanObjectSummaryDTO> getAllUrbanObjects() {
        return urbanObjectRepository.findAll()
                .stream()
                .map(this::toSummaryDTO)
                .toList();
    }

    public Object getUrbanObjectById(Long id) {
        UrbanObject obj = urbanObjectRepository.findById(id)
                .orElseThrow(() -> new ObjectNotFoundException(id));
        return toDetailDTO(obj);
    }

    public BenchDTO createBench(BenchCreateDTO dto) {
        Bench b = new Bench();

        GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);
        Point location = geometryFactory.createPoint(
                new Coordinate(dto.longitude(), dto.latitude()));
        b.setLocation(location);

        b.setStatus(ObjectStatus.ACTIVE);
        b.setSeatCount(dto.seatCount());
        b.setMaterial(dto.material());
        b.setHasBackrest(dto.hasBackrest());

        Bench saved = urbanObjectRepository.save(b);

        return new BenchDTO(
                saved.getId(), ObjectType.BENCH,
                saved.getLocation().getY(), saved.getLocation().getX(),
                saved.getStatus(), saved.getCreatedAt(), saved.getUpdatedAt(),
                saved.getSeatCount(), saved.getMaterial(), saved.getHasBackrest());
    }

    public TreeDTO createTree(TreeCreateDTO dto) {
        Tree t = new Tree();
        GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);
        Point location = geometryFactory.createPoint(
                new Coordinate(dto.longitude(), dto.latitude()));
        t.setLocation(location);

        t.setStatus(ObjectStatus.ACTIVE);

        t.setSpecies(dto.species());
        t.setTrunkDiameterCm(dto.trunkDiameterCm());
        t.setPlantingDate(dto.plantingDate());
        t.setHealthStatus(dto.healthStatus());
        t.setHeightM(dto.heightM());

        Tree saved = urbanObjectRepository.save(t);

        return new TreeDTO(
                saved.getId(), ObjectType.TREE, saved.getLocation().getY(), saved.getLocation().getX(),
                saved.getStatus(), saved.getCreatedAt(), saved.getUpdatedAt(), saved.getSpecies(),
                saved.getPlantingDate(), saved.getTrunkDiameterCm(), saved.getHeightM(), saved.getHealthStatus());
    }

    public LightingPoleDTO createLightingPole(LightingPoleCreateDTO dto) {
        LightingPole lp = new LightingPole();
        GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);
        Point location = geometryFactory.createPoint(
                new Coordinate(dto.longitude(), dto.latitude()));
        lp.setLocation(location);
        lp.setStatus(ObjectStatus.ACTIVE);

        lp.setWattage(dto.wattage());
        lp.setHeightM(dto.heightM());
        lp.setLightType(dto.lightType());
        lp.setPowerSource(dto.powerSource());

        LightingPole saved = urbanObjectRepository.save(lp);

        return new LightingPoleDTO(saved.getId(), ObjectType.LIGHTING_POLE, saved.getLocation().getY(),
                saved.getLocation().getX(), saved.getStatus(), saved.getCreatedAt(), saved.getUpdatedAt(),
                saved.getWattage(), saved.getHeightM(), saved.getLightType(), saved.getPowerSource());
    }

    public PlaygroundEquipmentDTO createPlaygroundEquipment(PlaygroundEquipmentCreateDTO dto) {
        PlaygroundEquipment pe = new PlaygroundEquipment();
        GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);
        Point location = geometryFactory.createPoint(
                new Coordinate(dto.longitude(), dto.latitude()));
        pe.setLocation(location);
        pe.setStatus(ObjectStatus.ACTIVE);

        pe.setEquipmentType(dto.equipmentType());
        pe.setAgeGroup(dto.ageGroup());
        pe.setSafetyCertificationDate(dto.safetyCertificationDate());

        PlaygroundEquipment saved = urbanObjectRepository.save(pe);

        return new PlaygroundEquipmentDTO(saved.getId(), ObjectType.LIGHTING_POLE, saved.getLocation().getY(),
                saved.getLocation().getX(), saved.getStatus(), saved.getCreatedAt(), saved.getUpdatedAt(),
                saved.getEquipmentType(), saved.getAgeGroup(), saved.getSafetyCertificationDate());
    }

    public TrashBinDTO createTrashBin(TrashBinCreateDTO dto) {
        TrashBin tb = new TrashBin();
        GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);
        Point location = geometryFactory.createPoint(
                new Coordinate(dto.longitude(), dto.latitude()));
        tb.setLocation(location);
        tb.setStatus(ObjectStatus.ACTIVE);

        tb.setVolumeLiters(dto.volumeLiters());
        tb.setBinType(dto.binType());
        tb.setMaterial(dto.material());
        tb.setCollectionFrequencyDays(dto.collectionFrequencyDays());

        TrashBin saved = urbanObjectRepository.save(tb);

        return new TrashBinDTO(saved.getId(), ObjectType.TRASH_BIN, saved.getLocation().getY(),
                saved.getLocation().getX(), saved.getStatus(), saved.getCreatedAt(), saved.getUpdatedAt(),
                saved.getVolumeLiters(), saved.getBinType(), saved.getMaterial(), saved.getCollectionFrequencyDays());
    }

    public void deleteUrbanObject(Long id) { // hibernate birleşik miraslanmış masaları kendisi sildiriyor
        if (!urbanObjectRepository.existsById(id)) {
            throw new ObjectNotFoundException(id);
        }

        urbanObjectRepository.deleteById(id);
    }

    public TrashBinDTO updateTrashBin(Long id, TrashBinCreateDTO request) {
        UrbanObject existing = urbanObjectRepository.findById(id)
                .orElseThrow(() -> new ObjectNotFoundException(id));

        if (!(existing instanceof TrashBin bin)) {
            throw new WrongObjectTypeException(id, ObjectType.TRASH_BIN, resolveType(existing));
        }

        GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);
        Point location = geometryFactory.createPoint(
                new Coordinate(request.longitude(), request.latitude()));
        bin.setLocation(location);

        bin.setVolumeLiters(request.volumeLiters());
        bin.setBinType(request.binType());
        bin.setMaterial(request.material());
        bin.setCollectionFrequencyDays(request.collectionFrequencyDays());

        TrashBin saved = urbanObjectRepository.save(bin);

        return new TrashBinDTO(
                saved.getId(), ObjectType.TRASH_BIN,
                saved.getLocation().getY(), saved.getLocation().getX(),
                saved.getStatus(), saved.getCreatedAt(), saved.getUpdatedAt(),
                saved.getVolumeLiters(), saved.getBinType(), saved.getMaterial(), saved.getCollectionFrequencyDays());
    }

    public TreeDTO updateTree(Long id, TreeCreateDTO request) {
        UrbanObject existing = urbanObjectRepository.findById(id)
                .orElseThrow(() -> new ObjectNotFoundException(id));

        if (!(existing instanceof Tree tree)) {
            throw new WrongObjectTypeException(id, ObjectType.TREE, resolveType(existing));
        }

        GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);
        Point location = geometryFactory.createPoint(
                new Coordinate(request.longitude(), request.latitude()));
        tree.setLocation(location);

        tree.setSpecies(request.species());
        tree.setPlantingDate(request.plantingDate());
        tree.setTrunkDiameterCm(request.trunkDiameterCm());
        tree.setHeightM(request.heightM());
        tree.setHealthStatus(request.healthStatus());

        Tree saved = urbanObjectRepository.save(tree);

        return new TreeDTO(
                saved.getId(), ObjectType.TREE,
                saved.getLocation().getY(), saved.getLocation().getX(),
                saved.getStatus(), saved.getCreatedAt(), saved.getUpdatedAt(),
                saved.getSpecies(), saved.getPlantingDate(), saved.getTrunkDiameterCm(),
                saved.getHeightM(), saved.getHealthStatus());
    }

    public LightingPoleDTO updateLightingPole(Long id, LightingPoleCreateDTO request) {
        UrbanObject existing = urbanObjectRepository.findById(id)
                .orElseThrow(() -> new ObjectNotFoundException(id));

        if (!(existing instanceof LightingPole pole)) {
            throw new WrongObjectTypeException(id, ObjectType.LIGHTING_POLE, resolveType(existing));
        }

        GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);
        Point location = geometryFactory.createPoint(
                new Coordinate(request.longitude(), request.latitude()));
        pole.setLocation(location);

        pole.setWattage(request.wattage());
        pole.setHeightM(request.heightM());
        pole.setLightType(request.lightType());
        pole.setPowerSource(request.powerSource());

        LightingPole saved = urbanObjectRepository.save(pole);

        return new LightingPoleDTO(
                saved.getId(), ObjectType.LIGHTING_POLE,
                saved.getLocation().getY(), saved.getLocation().getX(),
                saved.getStatus(), saved.getCreatedAt(), saved.getUpdatedAt(),
                saved.getWattage(), saved.getHeightM(), saved.getLightType(), saved.getPowerSource());
    }

    public PlaygroundEquipmentDTO updatePlaygroundEquipment(Long id, PlaygroundEquipmentCreateDTO request) {
        UrbanObject existing = urbanObjectRepository.findById(id)
                .orElseThrow(() -> new ObjectNotFoundException(id));

        if (!(existing instanceof PlaygroundEquipment pe)) {
            throw new WrongObjectTypeException(id, ObjectType.PLAYGROUND_EQUIPMENT, resolveType(existing));
        }

        GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);
        Point location = geometryFactory.createPoint(
                new Coordinate(request.longitude(), request.latitude()));
        pe.setLocation(location);

        pe.setEquipmentType(request.equipmentType());
        pe.setAgeGroup(request.ageGroup());
        pe.setSafetyCertificationDate(request.safetyCertificationDate());

        PlaygroundEquipment saved = urbanObjectRepository.save(pe);

        return new PlaygroundEquipmentDTO(
                saved.getId(), ObjectType.PLAYGROUND_EQUIPMENT,
                saved.getLocation().getY(), saved.getLocation().getX(),
                saved.getStatus(), saved.getCreatedAt(), saved.getUpdatedAt(),
                saved.getEquipmentType(), saved.getAgeGroup(), saved.getSafetyCertificationDate());
    }

    public BenchDTO updateBench(Long id, BenchCreateDTO request) {
        UrbanObject existing = urbanObjectRepository.findById(id)
                .orElseThrow(() -> new ObjectNotFoundException(id));

        if (!(existing instanceof Bench bench)) {
            throw new WrongObjectTypeException(id, ObjectType.BENCH, resolveType(existing));
        }

        GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);
        Point location = geometryFactory.createPoint(
                new Coordinate(request.longitude(), request.latitude()));
        bench.setLocation(location);

        bench.setSeatCount(request.seatCount());
        bench.setMaterial(request.material());
        bench.setHasBackrest(request.hasBackrest());

        Bench saved = urbanObjectRepository.save(bench);

        return new BenchDTO(
                saved.getId(), ObjectType.BENCH,
                saved.getLocation().getY(), saved.getLocation().getX(),
                saved.getStatus(), saved.getCreatedAt(), saved.getUpdatedAt(),
                saved.getSeatCount(), saved.getMaterial(), saved.getHasBackrest());
    }

    // private helpers
    private UrbanObjectSummaryDTO toSummaryDTO(UrbanObject obj) {
        Point p = obj.getLocation();
        return new UrbanObjectSummaryDTO(
                obj.getId(), resolveType(obj), p.getY(), p.getX(),
                obj.getStatus(), obj.getCreatedAt(), obj.getUpdatedAt());
    }

    private Object toDetailDTO(UrbanObject obj) {
        Point p = obj.getLocation();
        double lat = p.getY(), lng = p.getX();

        if (obj instanceof TrashBin b) {
            return new TrashBinDTO(b.getId(), ObjectType.TRASH_BIN, lat, lng, b.getStatus(),
                    b.getCreatedAt(), b.getUpdatedAt(),
                    b.getVolumeLiters(), b.getBinType(), b.getMaterial(), b.getCollectionFrequencyDays());
        }
        if (obj instanceof Bench b) {
            return new BenchDTO(b.getId(), ObjectType.BENCH, lat, lng, b.getStatus(),
                    b.getCreatedAt(), b.getUpdatedAt(),
                    b.getSeatCount(), b.getMaterial(), b.getHasBackrest());
        }
        if (obj instanceof Tree t) {
            return new TreeDTO(t.getId(), ObjectType.TREE, lat, lng, t.getStatus(),
                    t.getCreatedAt(), t.getUpdatedAt(),
                    t.getSpecies(), t.getPlantingDate(), t.getTrunkDiameterCm(), t.getHeightM(), t.getHealthStatus());
        }
        if (obj instanceof LightingPole lp) {
            return new LightingPoleDTO(lp.getId(), ObjectType.LIGHTING_POLE, lat, lng, lp.getStatus(),
                    lp.getCreatedAt(), lp.getUpdatedAt(),
                    lp.getWattage(), lp.getHeightM(), lp.getLightType(), lp.getPowerSource());
        }
        if (obj instanceof PlaygroundEquipment pe) {
            return new PlaygroundEquipmentDTO(pe.getId(), ObjectType.PLAYGROUND_EQUIPMENT, lat, lng, pe.getStatus(),
                    pe.getCreatedAt(), pe.getUpdatedAt(),
                    pe.getEquipmentType(), pe.getAgeGroup(), pe.getSafetyCertificationDate());
        }
        throw new IllegalStateException("Unknown subtype: " + obj.getClass());
    }

    private ObjectType resolveType(UrbanObject obj) {
        if (obj instanceof TrashBin)
            return ObjectType.TRASH_BIN;
        if (obj instanceof Bench)
            return ObjectType.BENCH;
        if (obj instanceof Tree)
            return ObjectType.TREE;
        if (obj instanceof LightingPole)
            return ObjectType.LIGHTING_POLE;
        if (obj instanceof PlaygroundEquipment)
            return ObjectType.PLAYGROUND_EQUIPMENT;
        throw new IllegalStateException("Unknown urban object subtype: " + obj.getClass());
    }
}
