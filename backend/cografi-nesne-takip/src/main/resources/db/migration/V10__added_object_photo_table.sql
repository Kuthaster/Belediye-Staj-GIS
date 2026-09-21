CREATE TABLE object_photo (
    id BIGSERIAL PRIMARY KEY,
    urban_object_id BIGINT NOT NULL UNIQUE REFERENCES urban_object(id),
    current_path VARCHAR(255) NOT NULL,
    previous_path VARCHAR(255),
    content_type VARCHAR(50) NOT NULL,
    uploaded_at TIMESTAMP NOT NULL
);