package com.kutalmis.cografi_nesne_takip.service;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneOffset;

import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.kutalmis.cografi_nesne_takip.Dto.PhotoDTO;
import com.kutalmis.cografi_nesne_takip.entity.ObjectPhoto;
import com.kutalmis.cografi_nesne_takip.entity.UrbanObject;
import com.kutalmis.cografi_nesne_takip.exception.NoPreviousPhotoException;
import com.kutalmis.cografi_nesne_takip.exception.ObjectNotFoundException;
import com.kutalmis.cografi_nesne_takip.exception.PhotoNotFoundException;
import com.kutalmis.cografi_nesne_takip.repository.ObjectPhotoRepository;
import com.kutalmis.cografi_nesne_takip.repository.UrbanObjectRepository;
import com.kutalmis.cografi_nesne_takip.storage.PhotoStorageService;

import jakarta.transaction.Transactional;

@Service
public class ObjectPhotoService {

    private final ObjectPhotoRepository photoRepository;
    private final UrbanObjectRepository urbanObjectRepository;
    private final PhotoStorageService storageService;

    public ObjectPhotoService(ObjectPhotoRepository photoRepository, UrbanObjectRepository urbanObjectRepository,
            PhotoStorageService storageService) {
        this.photoRepository = photoRepository;
        this.urbanObjectRepository = urbanObjectRepository;
        this.storageService = storageService;
    }

    @Transactional
    public PhotoDTO uploadOrReplace(Long objectId, MultipartFile file) throws IOException {
        UrbanObject obj = urbanObjectRepository.findById(objectId)
                .orElseThrow(() -> new ObjectNotFoundException(objectId));

        String newPath = storageService.store(objectId, file);
        String contentType = file.getContentType();

        ObjectPhoto photo = photoRepository.findByUrbanObjectId(objectId)
                .orElse(null);

        if (photo == null) {
            photo = new ObjectPhoto();
            photo.setUrbanObject(obj);
            photo.setCurrentPath(newPath);
        } else {
            if (photo.getPreviousPath() != null) {
                storageService.delete(photo.getPreviousPath());
            }
            photo.setPreviousContentType(photo.getContentType());
            photo.setPreviousPath(photo.getCurrentPath());
            photo.setCurrentPath(newPath);
        }

        photo.setContentType(contentType);
        photo.setUploadedAt(LocalDateTime.now(ZoneOffset.UTC));

        return toDTO(photoRepository.save(photo));
    }

    @Transactional
    public PhotoDTO revertToPrevious(Long objectId) throws IOException {
        ObjectPhoto photo = photoRepository.findByUrbanObjectId(objectId)
                .orElseThrow(() -> new PhotoNotFoundException(objectId));

        if (photo.getPreviousPath() == null) {
            throw new NoPreviousPhotoException(objectId);
        }

        storageService.delete(photo.getCurrentPath());
        photo.setCurrentPath(photo.getPreviousPath());
        photo.setContentType(photo.getPreviousContentType());
        photo.setPreviousPath(null);
        photo.setPreviousContentType(null);

        return toDTO(photoRepository.save(photo));
    }

    public LoadedPhoto loadCurrentPhoto(Long objectId) throws IOException {
        ObjectPhoto photo = photoRepository.findByUrbanObjectId(objectId)
                .orElseThrow(() -> new PhotoNotFoundException(objectId));
        Resource resource = storageService.load(photo.getCurrentPath());
        return new LoadedPhoto(resource, photo.getContentType());
    }

    public PhotoDTO getMetadata(Long objectId) {
        ObjectPhoto photo = photoRepository.findByUrbanObjectId(objectId)
                .orElseThrow(() -> new PhotoNotFoundException(objectId));
        return toDTO(photo);
    }

    private PhotoDTO toDTO(ObjectPhoto photo) {
        return new PhotoDTO(
                photo.getUrbanObject().getId(),
                "/api/objects/" + photo.getUrbanObject().getId() + "/photo",
                photo.getPreviousPath() != null,
                photo.getUploadedAt());
    }

    public record LoadedPhoto(Resource resource, String contentType) {
    }

    @Transactional
    public void deletePhoto(Long objectId) throws IOException {
        ObjectPhoto photo = photoRepository.findByUrbanObjectId(objectId).orElse(null);
        if (photo == null)
            return;

        storageService.delete(photo.getCurrentPath());
        if (photo.getPreviousPath() != null) {
            storageService.delete(photo.getPreviousPath());
        }
        photoRepository.delete(photo);
    }
}