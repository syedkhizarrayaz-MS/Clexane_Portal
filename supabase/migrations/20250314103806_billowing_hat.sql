-- Insert dummy doctors
INSERT INTO doctors (name, email, phone, specialty, qr_code_identifier) VALUES
('Dr. John Smith', 'john.smith@example.com', '+1-555-0101', 'Cardiologist', 'QR001'),
('Dr. Sarah Johnson', 'sarah.j@example.com', '+1-555-0102', 'Neurologist', 'QR002'),
('Dr. Michael Brown', 'michael.b@example.com', '+1-555-0103', 'General Physician', 'QR003');

-- Insert dummy stores (in addition to existing ones)
INSERT INTO stores (name, contact_number, address, city, country, latitude, longitude) VALUES
('City Pharmacy', '+1-555-1001', '789 Health Avenue', 'Boston', 'USA', 42.3601, -71.0589),
('Central Medical Store', '+1-555-1002', '456 Wellness Road', 'Miami', 'USA', 25.7617, -80.1918),
('Healthcare Plus', '+1-555-1003', '123 Medical Plaza', 'Houston', 'USA', 29.7604, -95.3698);

-- Insert dummy doctor-store relations
INSERT INTO doctor_store_relations (doctor_id, store_id) VALUES
(1, 1), (1, 2), (1, 3),
(2, 2), (2, 4), (2, 5),
(3, 3), (3, 5), (3, 6);

-- Insert dummy patient visits
INSERT INTO patient_visits (store_id, session_id, user_ip, user_agent, action_type) VALUES
(1, 'session1', '192.168.1.1', 'Mozilla/5.0', 'view'),
(2, 'session2', '192.168.1.2', 'Chrome/91.0', 'direction_click'),
(3, 'session3', '192.168.1.3', 'Safari/14.0', 'view'),
(4, 'session4', '192.168.1.4', 'Firefox/89.0', 'direction_click'),
(5, 'session5', '192.168.1.5', 'Edge/91.0', 'view'),
(6, 'session6', '192.168.1.6', 'Chrome/92.0', 'direction_click');