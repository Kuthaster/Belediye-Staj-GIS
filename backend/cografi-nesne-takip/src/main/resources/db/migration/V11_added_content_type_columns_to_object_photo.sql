ALTER TABLE object_photo ADD COLUMN content_type VARCHAR(50) NOT NULL;
ALTER TABLE object_photo ADD COLUMN previous_content_type VARCHAR(50);