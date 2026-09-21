package com.kutalmis.cografi_nesne_takip.controller;

import java.io.IOException;

import org.springframework.core.io.Resource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.kutalmis.cografi_nesne_takip.Dto.PhotoDTO;
import com.kutalmis.cografi_nesne_takip.service.ObjectPhotoService;

@RestController
@PreAuthorize("isAuthenticated()")
@RequestMapping("/api/objects/{id}/photo")
public class ObjectPhotoController {

    private final ObjectPhotoService photoService;

    public ObjectPhotoController(ObjectPhotoService photoService) {
        this.photoService = photoService;
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'FIELD_WORKER')")
    @PostMapping
    public PhotoDTO upload(@PathVariable Long id, @RequestParam MultipartFile file) throws IOException {
        return photoService.uploadOrReplace(id, file);
    }

    @GetMapping
    public ResponseEntity<Resource> get(@PathVariable Long id) throws IOException {
        var loaded = photoService.loadCurrentPhoto(id);
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(loaded.contentType()))
                .body(loaded.resource());
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'FIELD_WORKER')")
    @PostMapping("/revert")
    public PhotoDTO revert(@PathVariable Long id) throws IOException {
        return photoService.revertToPrevious(id);
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'FIELD_WORKER')")
    @DeleteMapping
    public ResponseEntity<Void> delete(@PathVariable Long id) throws IOException {
        photoService.deletePhoto(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/metadata")
    public PhotoDTO getMetadata(@PathVariable Long id) {
        return photoService.getMetadata(id);
    }
}