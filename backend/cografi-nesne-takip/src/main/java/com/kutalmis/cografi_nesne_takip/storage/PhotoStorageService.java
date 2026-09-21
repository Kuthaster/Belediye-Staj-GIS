package com.kutalmis.cografi_nesne_takip.storage;

import java.io.IOException;

import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

public interface PhotoStorageService {
    String store(Long objectId, MultipartFile file) throws IOException;

    void delete(String path) throws IOException;

    Resource load(String path) throws IOException;
}
