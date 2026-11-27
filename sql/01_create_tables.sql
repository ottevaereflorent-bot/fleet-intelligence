-- =============================================
-- Project: Fleet Intelligence
-- Description: Relational database schema
-- Database: PostgreSQL
-- =============================================


-- 1. Vehicles
-- Grain: one row per vehicle

CREATE TABLE vehicles (
    vehicle_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    fuel_type VARCHAR(20) NOT NULL,
    commissioning_date DATE NOT NULL,
    purchase_price NUMERIC(10, 2) NOT NULL
        CHECK (purchase_price > 0)
);


-- 2. Daily usage
-- Grain: one row per vehicle per day

CREATE TABLE daily_usage (
    usage_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    vehicle_id INTEGER NOT NULL,
    usage_date DATE NOT NULL,
    distance_km NUMERIC(8, 2) NOT NULL
        CHECK (distance_km >= 0),
    revenue NUMERIC(10, 2) NOT NULL
        CHECK (revenue >= 0),

    FOREIGN KEY (vehicle_id)
        REFERENCES vehicles(vehicle_id),

    UNIQUE (vehicle_id, usage_date)
);


-- 3. Maintenance
-- Grain: one row per maintenance intervention

CREATE TABLE maintenance (
    intervention_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    vehicle_id INTEGER NOT NULL,
    maintenance_date DATE NOT NULL,
    repair_cost NUMERIC(10, 2) NOT NULL
        CHECK (repair_cost >= 0),
    downtime_hours NUMERIC(8, 2) NOT NULL
        CHECK (downtime_hours >= 0),
    maintenance_type VARCHAR(20) NOT NULL
        CHECK (maintenance_type IN ('preventive', 'corrective')),

    FOREIGN KEY (vehicle_id)
        REFERENCES vehicles(vehicle_id)
);


-- 4. Failures
-- Grain: one row per failure

CREATE TABLE failures (
    failure_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    vehicle_id INTEGER NOT NULL,
    failure_date DATE NOT NULL,
    failure_type VARCHAR(50) NOT NULL,
    severity VARCHAR(10) NOT NULL
        CHECK (severity IN ('low', 'medium', 'high')),

    FOREIGN KEY (vehicle_id)
        REFERENCES vehicles(vehicle_id)
);