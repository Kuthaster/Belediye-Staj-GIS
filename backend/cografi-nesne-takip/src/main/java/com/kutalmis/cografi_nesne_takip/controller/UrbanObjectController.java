package com.kutalmis.cografi_nesne_takip.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
import com.kutalmis.cografi_nesne_takip.entity.ObjectStatus;
import com.kutalmis.cografi_nesne_takip.entity.ObjectType;
import com.kutalmis.cografi_nesne_takip.service.UrbanObjectService;
import com.kutalmis.cografi_nesne_takip.Dto.StatusUpdateDTO;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PutMapping;

@RestController
@PreAuthorize("isAuthenticated()")
@RequestMapping("/api/objects")
public class UrbanObjectController {

    private final UrbanObjectService urbanObjectService;

    public UrbanObjectController(UrbanObjectService urbanObjectService) {
        this.urbanObjectService = urbanObjectService;
    }

    @GetMapping()
public List<UrbanObjectSummaryDTO> getAllObjects(
        @RequestParam (required = false) ObjectType type,
        @RequestParam(required = false) ObjectStatus status,
        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate createdFrom,
        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate createdTo) {

    LocalDateTime from = createdFrom != null ? createdFrom.atStartOfDay() : null;
    LocalDateTime to = createdTo != null ? createdTo.atTime(LocalTime.MAX) : null;

    return urbanObjectService.searchUrbanObjects(type, status, from, to);
}

    @GetMapping("/{id}")
    public Object getObjectById(@PathVariable Long id) {
        return urbanObjectService.getUrbanObjectById(id);
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'FIELD_WORKER')")
    @PostMapping("/benches")
    public BenchDTO createBench(@RequestBody BenchCreateDTO dto) {

        return urbanObjectService.createBench(dto);
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'FIELD_WORKER')")
    @PostMapping("/trees")
    public TreeDTO createTree(@RequestBody TreeCreateDTO dto) {

        return urbanObjectService.createTree(dto);
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'FIELD_WORKER')")
    @PostMapping("/lighting-poles")
    public LightingPoleDTO createLightingPole(@RequestBody LightingPoleCreateDTO dto) {

        return urbanObjectService.createLightingPole(dto);
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'FIELD_WORKER')")
    @PostMapping("/playground-equipment")
    public PlaygroundEquipmentDTO createPlaygroundEquipment(@RequestBody PlaygroundEquipmentCreateDTO dto) {

        return urbanObjectService.createPlaygroundEquipment(dto);
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'FIELD_WORKER')")
    @PostMapping("/trash-bins")
    public TrashBinDTO createTrashBin(@RequestBody TrashBinCreateDTO dto) {

        return urbanObjectService.createTrashBin(dto);
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'FIELD_SUPERVISOR')")
    @DeleteMapping("{id}")
    public ResponseEntity<Void> deleteObject(@PathVariable Long id) {
        urbanObjectService.deleteUrbanObject(id);
        return ResponseEntity.noContent().build();
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'FIELD_WORKER')")
    @PutMapping("/benches/{id}")
    public BenchDTO updateBench(@PathVariable Long id, @RequestBody BenchCreateDTO request) {
        return urbanObjectService.updateBench(id, request);
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'FIELD_WORKER')")
    @PutMapping("/trash-bins/{id}")
    public TrashBinDTO updateTrashBin(@PathVariable Long id, @RequestBody TrashBinCreateDTO request) {
        return urbanObjectService.updateTrashBin(id, request);
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'FIELD_WORKER')")
    @PutMapping("/trees/{id}")
    public TreeDTO updateTree(@PathVariable Long id, @RequestBody TreeCreateDTO request) {
        return urbanObjectService.updateTree(id, request);
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'FIELD_WORKER')")
    @PutMapping("/lighting-poles/{id}")
    public LightingPoleDTO updateLightingPole(@PathVariable Long id, @RequestBody LightingPoleCreateDTO request) {
        return urbanObjectService.updateLightingPole(id, request);
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'FIELD_WORKER')")
    @PutMapping("/playground-equipment/{id}")
    public PlaygroundEquipmentDTO updatePlaygroundEquipment(@PathVariable Long id,
            @RequestBody PlaygroundEquipmentCreateDTO request) {
        return urbanObjectService.updatePlaygroundEquipment(id, request);
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'FIELD_SUPERVISOR')")
    @PatchMapping("/{id}/status")
    public UrbanObjectSummaryDTO updateStatus(@PathVariable Long id, @RequestBody StatusUpdateDTO request) {
        return urbanObjectService.updateStatus(id, request);
    }

}
