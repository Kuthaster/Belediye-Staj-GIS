package com.kutalmis.cografi_nesne_takip.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
import com.kutalmis.cografi_nesne_takip.service.UrbanObjectService;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PutMapping;

@RestController
// TODO @PreAuthorize("isAuthenticated()")
@RequestMapping("/api/objects")
public class UrbanObjectController {

    private final UrbanObjectService urbanObjectService;

    public UrbanObjectController(UrbanObjectService urbanObjectService) {
        this.urbanObjectService = urbanObjectService;
    }

    @GetMapping()
    public List<UrbanObjectSummaryDTO> getAllObjects() {
        return urbanObjectService.getAllUrbanObjects();
    }

    @GetMapping("/{id}")
    public Object getObjectById(@PathVariable Long id) {
        return urbanObjectService.getUrbanObjectById(id);
    }

    @PostMapping("/benches")
    public BenchDTO createBench(@RequestBody BenchCreateDTO dto) {

        return urbanObjectService.createBench(dto);
    }

    @PostMapping("/trees")
    public TreeDTO createTree(@RequestBody TreeCreateDTO dto) {

        return urbanObjectService.createTree(dto);
    }

    @PostMapping("/lighting-poles")
    public LightingPoleDTO createLightingPole(@RequestBody LightingPoleCreateDTO dto) {

        return urbanObjectService.createLightingPole(dto);
    }

    @PostMapping("/playground-equipments")
    public PlaygroundEquipmentDTO createPlaygroundEquipment(@RequestBody PlaygroundEquipmentCreateDTO dto) {

        return urbanObjectService.createPlaygroundEquipment(dto);
    }

    @PostMapping("/trash-bins")
    public TrashBinDTO createTrashBin(@RequestBody TrashBinCreateDTO dto) {

        return urbanObjectService.createTrashBin(dto);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<Void> deleteObject(@PathVariable Long id) {
        urbanObjectService.deleteUrbanObject(id);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/benches/{id}")
    public BenchDTO updateBench(@PathVariable Long id, @RequestBody BenchCreateDTO request) {
        return urbanObjectService.updateBench(id, request);
    }

    @PutMapping("/trash-bins/{id}")
    public TrashBinDTO updateTrashBin(@PathVariable Long id, @RequestBody TrashBinCreateDTO request) {
        return urbanObjectService.updateTrashBin(id, request);
    }

    @PutMapping("/trees/{id}")
    public TreeDTO updateTree(@PathVariable Long id, @RequestBody TreeCreateDTO request) {
        return urbanObjectService.updateTree(id, request);
    }

    @PutMapping("/lighting-poles/{id}")
    public LightingPoleDTO updateLightingPole(@PathVariable Long id, @RequestBody LightingPoleCreateDTO request) {
        return urbanObjectService.updateLightingPole(id, request);
    }

    @PutMapping("/playground-equipment/{id}")
    public PlaygroundEquipmentDTO updatePlaygroundEquipment(@PathVariable Long id,
            @RequestBody PlaygroundEquipmentCreateDTO request) {
        return urbanObjectService.updatePlaygroundEquipment(id, request);
    }

}
