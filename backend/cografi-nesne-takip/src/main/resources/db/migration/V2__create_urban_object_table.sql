CREATE TABLE urban_object (
    id BIGSERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    location geometry(Point, 4326) NOT NULL,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT now()
);