package com.kutalmis.cografi_nesne_takip.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Set;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.kutalmis.cografi_nesne_takip.exception.InvalidFileTypeException;
import com.kutalmis.cografi_nesne_takip.storage.PhotoStorageService;

@Service
public class LocalPhotoStorageService implements PhotoStorageService {

    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of(
            "image/jpeg", "image/png", "image/webp");

    @Value("${app.photo-storage.base-path}")
    private String basePath;

    @Override
    public String store(Long objectId, MultipartFile file) throws IOException {
        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_CONTENT_TYPES.contains(contentType)) {
            throw new InvalidFileTypeException(contentType);
        }

        String ext = getExtension(contentType);
        String filename = UUID.randomUUID() + "." + ext;
        String relativePath = objectId + "/" + filename;
        Path target = Paths.get(basePath, relativePath);
        Files.createDirectories(target.getParent());
        file.transferTo(target);
        return relativePath;
    }

    @Override
    public void delete(String path) throws IOException {
        Files.deleteIfExists(Paths.get(basePath, path));
    }

    @Override
    public Resource load(String path) throws IOException {
        return new UrlResource(Paths.get(basePath, path).toUri());
    }

    private String getExtension(String contentType) {
        return switch (contentType) {
            case "image/jpeg" -> "jpg";
            case "image/png" -> "png";
            case "image/webp" -> "webp";
            default -> throw new InvalidFileTypeException(contentType); // unreachable given the check above, but keeps
                                                                        // this method honest on its own
        };
    }
}