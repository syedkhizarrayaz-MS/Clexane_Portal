/*
  # Store Locator Database Schema

  1. New Tables
    - `doctors`: Stores doctor information
      - `id` (uuid, primary key)
      - `name` (text)
      - `email` (text, unique)
      - `phone` (text)
      - `specialty` (text)
      - `qr_code_identifier` (text, unique)
      - `status` (text)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

    - `stores`: Stores medical store information
      - `id` (uuid, primary key)
      - `name` (text)
      - `contact_number` (text)
      - `address` (text)
      - `city` (text)
      - `country` (text)
      - `latitude` (decimal)
      - `longitude` (decimal)
      - `status` (text)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

    - `doctor_store_relations`: Links doctors to stores
      - `id` (uuid, primary key)
      - `doctor_id` (uuid, foreign key)
      - `store_id` (uuid, foreign key)
      - `created_at` (timestamp)

    - `patient_visits`: Tracks store visits and interactions
      - `id` (uuid, primary key)
      - `store_id` (uuid, foreign key)
      - `session_id` (text)
      - `user_ip` (text)
      - `user_agent` (text)
      - `action_type` (text)
      - `visited_at` (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated access
*/

-- Create enum types
CREATE TYPE store_status AS ENUM ('active', 'inactive');
CREATE TYPE doctor_status AS ENUM ('active', 'inactive');
CREATE TYPE visit_action_type AS ENUM ('view', 'direction_click');

-- Create doctors table
CREATE TABLE IF NOT EXISTS doctors (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    email text UNIQUE,
    phone text,
    specialty text,
    qr_code_identifier text UNIQUE NOT NULL,
    status doctor_status DEFAULT 'active',
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Create stores table
CREATE TABLE IF NOT EXISTS stores (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    contact_number text NOT NULL,
    address text NOT NULL,
    city text NOT NULL,
    country text NOT NULL,
    latitude decimal(10,8) NOT NULL,
    longitude decimal(11,8) NOT NULL,
    status store_status DEFAULT 'active',
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Create doctor_store_relations table
CREATE TABLE IF NOT EXISTS doctor_store_relations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    doctor_id uuid NOT NULL REFERENCES doctors(id),
    store_id uuid NOT NULL REFERENCES stores(id),
    created_at timestamptz DEFAULT now(),
    UNIQUE(doctor_id, store_id)
);

-- Create patient_visits table
CREATE TABLE IF NOT EXISTS patient_visits (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id uuid NOT NULL REFERENCES stores(id),
    session_id text NOT NULL,
    user_ip text,
    user_agent text,
    action_type visit_action_type NOT NULL,
    visited_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE doctors ENABLE ROW LEVEL SECURITY;
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE doctor_store_relations ENABLE ROW LEVEL SECURITY;
ALTER TABLE patient_visits ENABLE ROW LEVEL SECURITY;

-- Create policies for stores (public read access)
CREATE POLICY "Allow public read access to active stores"
    ON stores
    FOR SELECT
    USING (status = 'active');

-- Create policies for patient_visits (insert only for public)
CREATE POLICY "Allow public to record visits"
    ON patient_visits
    FOR INSERT
    WITH CHECK (true);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_doctors_updated_at
    BEFORE UPDATE ON doctors
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_stores_updated_at
    BEFORE UPDATE ON stores
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_stores_location ON stores(latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_stores_status ON stores(status);
CREATE INDEX IF NOT EXISTS idx_patient_visits_date ON patient_visits(visited_at);
CREATE INDEX IF NOT EXISTS idx_doctor_store_relations_doctor ON doctor_store_relations(doctor_id);
CREATE INDEX IF NOT EXISTS idx_doctor_store_relations_store ON doctor_store_relations(store_id);