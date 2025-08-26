-- Insert synthetic patient medical history data
-- This data will be used to fetch patient history based on email

INSERT INTO patients (
    patient_id, case_id, encrypted_data, phi_fields,
    assigned_specialist_id, urgency_level, specialty, status
) VALUES 
(
    'patient-001',
    'CASE-DEMO-001',
    '{"email": "john.doe@email.com", "phone": "+15551234567"}',
    '{"email", "phone"}',
    'dr-smith',
    'Medium',
    'Cardiology',
    'completed'
),
(
    'patient-002', 
    'CASE-DEMO-002',
    '{"email": "jane.smith@email.com", "phone": "+15559876543"}',
    '{"email", "phone"}',
    'dr-williams',
    'High',
    'Endocrinology',
    'completed'
);

-- Create medical history table with synthetic data
CREATE TABLE IF NOT EXISTS patient_medical_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_email TEXT NOT NULL,
    allergies TEXT[],
    medications TEXT[],
    medical_conditions TEXT[],
    previous_procedures TEXT[],
    lab_results JSONB,
    family_history TEXT,
    emergency_contact TEXT,
    insurance_info TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert synthetic medical history
INSERT INTO patient_medical_history (
    patient_email, allergies, medications, medical_conditions,
    previous_procedures, lab_results, family_history, emergency_contact, insurance_info
) VALUES 
(
    'john.doe@email.com',
    '{"Penicillin", "Shellfish"}',
    '{"Lisinopril 10mg daily", "Metformin 500mg twice daily", "Aspirin 81mg daily"}',
    '{"Hypertension", "Type 2 Diabetes", "Hyperlipidemia"}',
    '{"Cardiac catheterization (2022)", "Colonoscopy (2023)"}',
    '{"cholesterol": "185 mg/dL", "hba1c": "7.2%", "blood_pressure": "140/90", "weight": "185 lbs"}',
    'Father - Myocardial infarction at age 65, Mother - Diabetes',
    'Jane Doe - Spouse - +15551234568',
    'Blue Cross Blue Shield - Policy #BC123456789'
),
(
    'jane.smith@email.com', 
    '{"Latex", "Iodine"}',
    '{"Levothyroxine 75mcg daily", "Calcium carbonate 500mg daily"}',
    '{"Hypothyroidism", "Osteopenia"}',
    '{"Thyroidectomy (2021)", "DEXA scan (2023)"}',
    '{"tsh": "2.1 mIU/L", "t4": "1.0 ng/dL", "bone_density": "-1.8 T-score"}',
    'Mother - Thyroid cancer, Sister - Autoimmune thyroiditis',
    'Michael Smith - Brother - +15559876544',
    'Aetna - Policy #AET987654321'
),
(
    'robert.jones@email.com',
    '{"None known"}',
    '{"Atorvastatin 20mg daily", "Omeprazole 20mg daily"}',
    '{"Hyperlipidemia", "GERD"}',
    '{"Upper endoscopy (2022)"}',
    '{"cholesterol": "220 mg/dL", "ldl": "145 mg/dL", "hdl": "38 mg/dL"}',
    'Father - Stroke at age 70, Mother - High cholesterol',
    'Sarah Jones - Wife - +15555551111',
    'United Healthcare - Policy #UHC555666777'
),
(
    'mary.wilson@email.com',
    '{"Sulfa drugs", "Codeine"}',
    '{"Sertraline 50mg daily", "Lorazepam 0.5mg as needed"}',
    '{"Generalized Anxiety Disorder", "Depression"}',
    '{"None"}',
    '{"vitamin_d": "18 ng/mL", "b12": "180 pg/mL"}',
    'Mother - Depression, Father - Anxiety disorder',
    'Tom Wilson - Husband - +15555552222',
    'Cigna - Policy #CIG888999000'
),
(
    'david.brown@email.com',
    '{"Aspirin", "NSAIDs"}',
    '{"Prednisone 5mg daily", "Methotrexate 15mg weekly", "Folic acid 1mg daily"}',
    '{"Rheumatoid Arthritis", "Hypertension"}',
    '{"Joint injections (2023)", "Echocardiogram (2022)"}',
    '{"rf": "45 IU/mL", "crp": "8.2 mg/L", "esr": "35 mm/hr"}',
    'Sister - Lupus, Mother - Rheumatoid arthritis',
    'Lisa Brown - Wife - +15555553333',
    'Kaiser Permanente - Policy #KP111222333'
);

-- Create specialists table
CREATE TABLE IF NOT EXISTS specialists (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    specialty TEXT NOT NULL,
    slack_id TEXT,
    email TEXT NOT NULL,
    phone TEXT,
    availability TEXT DEFAULT 'medium'
);

-- Insert specialist data
INSERT INTO specialists (id, name, specialty, slack_id, email, phone, availability) VALUES
('dr-smith', 'Dr. James Smith', 'Cardiology', 'U123456', 'dr.smith@hospital.com', '+15551111111', 'high'),
('dr-jones', 'Dr. Sarah Jones', 'Cardiology', 'U789012', 'dr.jones@hospital.com', '+15551111112', 'medium'),
('dr-williams', 'Dr. Michael Williams', 'Endocrinology', 'U345678', 'dr.williams@hospital.com', '+15551111113', 'high'),
('dr-brown', 'Dr. Lisa Brown', 'Neurology', 'U901234', 'dr.brown@hospital.com', '+15551111114', 'low'),
('dr-davis', 'Dr. Robert Davis', 'Internal Medicine', 'U567890', 'dr.davis@hospital.com', '+15551111115', 'high'),
('dr-garcia', 'Dr. Maria Garcia', 'Psychiatry', 'U234567', 'dr.garcia@hospital.com', '+15551111116', 'medium'),
('dr-martinez', 'Dr. Carlos Martinez', 'Rheumatology', 'U678901', 'dr.martinez@hospital.com', '+15551111117', 'high'),
('dr-taylor', 'Dr. Jennifer Taylor', 'Gastroenterology', 'U345612', 'dr.taylor@hospital.com', '+15551111118', 'medium'),
('dr-anderson', 'Dr. William Anderson', 'Pulmonology', 'U789123', 'dr.anderson@hospital.com', '+15551111119', 'low'),
('dr-thomas', 'Dr. Emily Thomas', 'Dermatology', 'U456789', 'dr.thomas@hospital.com', '+15551111120', 'high');
