CREATE TABLE trash_bin (
    id BIGINT PRIMARY KEY REFERENCES urban_object(id),
    volume_liters DOUBLE PRECISION,
    bin_type VARCHAR(30),
    material VARCHAR(50),
    collection_frequency_days INT
);

CREATE TABLE bench (
    id BIGINT PRIMARY KEY REFERENCES urban_object(id),
    material VARCHAR(50),
    seat_count INT,
    has_backrest BOOLEAN
);

CREATE TABLE tree (
    id BIGINT PRIMARY KEY REFERENCES urban_object(id),
    species VARCHAR(100),
    planting_date DATE,
    trunk_diameter_cm DOUBLE PRECISION,
    height_m DOUBLE PRECISION,
    health_status VARCHAR(30)
);

CREATE TABLE lighting_pole (
    id BIGINT PRIMARY KEY REFERENCES urban_object(id),
    light_type VARCHAR(30),
    power_source VARCHAR(30),
    height_m DOUBLE PRECISION,
    wattage INT
);

CREATE TABLE playground_equipment (
    id BIGINT PRIMARY KEY REFERENCES urban_object(id),
    equipment_type VARCHAR(30),
    age_group VARCHAR(30),
    safety_cert_date DATE
);