-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS clexane_store_locator;
USE clexane_store_locator;

-- Create doctors table
CREATE TABLE IF NOT EXISTS doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    specialty VARCHAR(100),
    qr_code_identifier VARCHAR(50) UNIQUE NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Create stores table
CREATE TABLE IF NOT EXISTS stores (
    store_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    latitude DECIMAL(10,8) NOT NULL,
    longitude DECIMAL(11,8) NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Create doctor_store_relations table
CREATE TABLE IF NOT EXISTS doctor_store_relations (
    relation_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_id INT NOT NULL,
    store_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    UNIQUE KEY unique_doctor_store (doctor_id, store_id)
) ENGINE=InnoDB;

-- Create patient_visits table
CREATE TABLE IF NOT EXISTS patient_visits (
    visit_id INT PRIMARY KEY AUTO_INCREMENT,
    store_id INT NOT NULL,
    session_id VARCHAR(64) NOT NULL,
    user_ip VARCHAR(45),
    user_agent VARCHAR(255),
    action_type ENUM('view', 'direction_click') NOT NULL,
    visited_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    INDEX idx_visit_date (visited_at)
) ENGINE=InnoDB;

-- Create indexes for better query performance
CREATE INDEX idx_stores_location ON stores(latitude, longitude);
CREATE INDEX idx_stores_status ON stores(status);
CREATE INDEX idx_doctor_store_relations_doctor ON doctor_store_relations(doctor_id);
CREATE INDEX idx_doctor_store_relations_store ON doctor_store_relations(store_id);

-- Insert sample data for testing
INSERT INTO stores (name, contact_number, address, city, country, latitude, longitude) VALUES
('Medical Store 1', '+1-234-567-8901', '123 Healthcare St', 'New York', 'USA', 40.7128, -74.0060),
('Medical Store 2', '+1-234-567-8902', '456 Pharmacy Ave', 'Los Angeles', 'USA', 34.0522, -118.2437),
('Medical Store 3', '+1-234-567-8903', '789 Medicine Rd', 'Chicago', 'USA', 41.8781, -87.6298);