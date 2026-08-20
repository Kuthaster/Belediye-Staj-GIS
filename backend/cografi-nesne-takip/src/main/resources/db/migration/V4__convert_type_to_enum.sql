UPDATE urban_object SET type = UPPER(REPLACE(type, ' ', '_')) WHERE type IS NOT NULL;
