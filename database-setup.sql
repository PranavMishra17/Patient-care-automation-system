-- Healthcare Pipeline Database Setup Script
-- Create tables and insert synthetic data

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create PHI encryption function
CREATE OR REPLACE FUNCTION encrypt_phi(data text, key text)
RETURNS text AS $$
BEGIN
    RETURN encode(encrypt(data::bytea, key::bytea, 'aes'), 'base64');
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Create PHI decryption function  
CREATE OR REPLACE FUNCTION decrypt_phi(encrypted_data text, key text)
RETURNS text AS $$
BEGIN
    RETURN convert_from(decrypt(decode(encrypted_data, 'base64'), key::bytea, 'aes'), 'UTF8');
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Create audit log table
CREATE TABLE IF NOT EXISTS audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    timestamp TIMESTAMPTZ DEFAULT NOW(),
    user_id TEXT,
    action TEXT NOT NULL,
    resource_type TEXT,
    resource_id TEXT,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT
);

-- Create specialists table
CREATE TABLE IF NOT EXISTS specialists (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    specialty TEXT NOT NULL,
    email TEXT NOT NULL,
    slack_id TEXT,
    availability TEXT DEFAULT 'medium',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create patients table
CREATE TABLE IF NOT EXISTS patients (
    patient_id UUID PRIMARY KEY,
    case_id TEXT UNIQUE NOT NULL,
    encrypted_data JSONB,
    phi_fields TEXT[],
    assigned_specialist_id TEXT,
    urgency_level TEXT,
    specialty TEXT,
    status TEXT DEFAULT 'created',
    accepted_at TIMESTAMPTZ,
    accepting_specialist TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    FOREIGN KEY (assigned_specialist_id) REFERENCES specialists(id)
);

-- Create patient medical history table
CREATE TABLE IF NOT EXISTS patient_medical_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_email TEXT NOT NULL,
    allergies JSONB,
    medications JSONB,
    medical_conditions JSONB,
    previous_procedures JSONB,
    lab_results JSONB,
    family_history TEXT,
    last_visit DATE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create medical reports table
CREATE TABLE IF NOT EXISTS medical_reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id TEXT NOT NULL,
    patient_id UUID,
    report_type TEXT DEFAULT 'pre_visit_summary',
    generated_report TEXT,
    medical_history JSONB,
    generated_at TIMESTAMPTZ DEFAULT NOW(),
    generated_by TEXT DEFAULT 'ai_assistant',
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- Create appointments table
CREATE TABLE IF NOT EXISTS appointments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id TEXT NOT NULL,
    patient_id UUID,
    specialist_id TEXT,
    appointment_date DATE,
    appointment_time TIME,
    status TEXT DEFAULT 'scheduled',
    calendly_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (specialist_id) REFERENCES specialists(id)
);

-- Insert synthetic specialists data
INSERT INTO specialists (id, name, specialty, email, slack_id, availability) VALUES
('dr-smith', 'Dr. Emily Smith', 'Cardiology', 'emily.smith@hospital.com', 'U123456789', 'high'),
('dr-jones', 'Dr. Michael Jones', 'Cardiology', 'michael.jones@hospital.com', 'U234567890', 'medium'),
('dr-williams', 'Dr. Sarah Williams', 'Endocrinology', 'sarah.williams@hospital.com', 'U345678901', 'high'),
('dr-brown', 'Dr. David Brown', 'Neurology', 'david.brown@hospital.com', 'U456789012', 'low'),
('dr-davis', 'Dr. Lisa Davis', 'Internal Medicine', 'lisa.davis@hospital.com', 'U567890123', 'high'),
('dr-miller', 'Dr. James Miller', 'Psychiatry', 'james.miller@hospital.com', 'U678901234', 'medium'),
('dr-wilson', 'Dr. Maria Wilson', 'Rheumatology', 'maria.wilson@hospital.com', 'U789012345', 'high'),
('dr-moore', 'Dr. Robert Moore', 'Gastroenterology', 'robert.moore@hospital.com', 'U890123456', 'medium'),
('dr-taylor', 'Dr. Jennifer Taylor', 'Pulmonology', 'jennifer.taylor@hospital.com', 'U901234567', 'high'),
('dr-anderson', 'Dr. Christopher Anderson', 'Dermatology', 'christopher.anderson@hospital.com', 'U012345678', 'medium');

-- Insert synthetic patient medical history data
INSERT INTO patient_medical_history (
    patient_email, allergies, medications, medical_conditions, previous_procedures, lab_results, family_history, last_visit
) VALUES
(
    'john.doe@email.com',
    '["Penicillin", "Shellfish", "Latex"]'::jsonb,
    '["Lisinopril 10mg daily", "Metformin 500mg twice daily", "Aspirin 81mg daily"]'::jsonb,
    '["Hypertension", "Type 2 Diabetes", "Hyperlipidemia"]'::jsonb,
    '["Cardiac catheterization (2020)", "Colonoscopy (2022)"]'::jsonb,
    '{"HbA1c": "7.2%", "LDL": "95 mg/dL", "HDL": "42 mg/dL", "Blood Pressure": "140/90 mmHg"}'::jsonb,
    'Father: Heart disease, diabetes. Mother: Breast cancer, osteoporosis.',
    '2024-01-15'
),
(
    'jane.smith@email.com',
    '["Sulfa drugs", "NSAIDs"]'::jsonb,
    '["Sumatriptan 50mg as needed", "Propranolol 40mg daily", "Magnesium 400mg daily"]'::jsonb,
    '["Chronic migraines", "Anxiety disorder", "Iron deficiency anemia"]'::jsonb,
    '["MRI brain (2023)", "Upper endoscopy (2021)"]'::jsonb,
    '{"Hemoglobin": "11.8 g/dL", "Iron": "45 μg/dL", "Ferritin": "15 ng/mL", "TSH": "2.1 mIU/L"}'::jsonb,
    'Mother: Migraines, depression. Father: No significant history.',
    '2024-02-20'
),
(
    'robert.johnson@email.com',
    '["Codeine"]'::jsonb,
    '["Albuterol inhaler", "Fluticasone nasal spray", "Montelukast 10mg daily"]'::jsonb,
    '["Asthma", "Seasonal allergies", "GERD"]'::jsonb,
    '["Pulmonary function test (2023)", "Chest X-ray (2024)"]'::jsonb,
    '{"FEV1": "78% predicted", "Peak flow": "420 L/min", "IgE": "285 IU/mL"}'::jsonb,
    'Brother: Asthma, allergies. Sister: Eczema.',
    '2024-03-10'
),
(
    'mary.williams@email.com',
    '["Contrast dye", "Iodine"]'::jsonb,
    '["Levothyroxine 75mcg daily", "Calcium carbonate 1200mg daily", "Vitamin D3 2000IU daily"]'::jsonb,
    '["Hypothyroidism", "Osteoporosis", "History of thyroid nodules"]'::jsonb,
    '["Thyroid biopsy (2022)", "DEXA scan (2023)", "Thyroid ultrasound (2024)"]'::jsonb,
    '{"TSH": "2.8 mIU/L", "Free T4": "1.2 ng/dL", "T-score spine": "-2.7", "Vitamin D": "32 ng/mL"}'::jsonb,
    'Mother: Thyroid disease, osteoporosis. Maternal grandmother: Thyroid cancer.',
    '2024-01-28'
),
(
    'william.brown@email.com',
    '["Morphine", "Tramadol"]'::jsonb,
    '["Gabapentin 300mg three times daily", "Duloxetine 60mg daily", "Topical diclofenac gel"]'::jsonb,
    '["Fibromyalgia", "Depression", "Chronic low back pain"]'::jsonb,
    '["MRI lumbar spine (2023)", "Physical therapy (2023-2024)"]'::jsonb,
    '{"ESR": "25 mm/hr", "CRP": "3.2 mg/L", "Vitamin B12": "380 pg/mL", "Vitamin D": "18 ng/mL"}'::jsonb,
    'Mother: Fibromyalgia, depression. Father: Arthritis.',
    '2024-02-14'
),
(
    'linda.davis@email.com',
    '["Eggs", "Soy"]'::jsonb,
    '["Methotrexate 15mg weekly", "Folic acid 5mg weekly", "Prednisone 5mg daily", "Hydroxychloroquine 200mg twice daily"]'::jsonb,
    '["Rheumatoid arthritis", "Osteoarthritis", "Raynauds phenomenon"]'::jsonb,
    '["Joint X-rays (2024)", "Bone density scan (2023)"]'::jsonb,
    '{"RF": "45 IU/mL", "Anti-CCP": "78 units", "ESR": "35 mm/hr", "CRP": "8.1 mg/L"}'::jsonb,
    'Sister: Rheumatoid arthritis. Mother: Lupus.',
    '2024-03-05'
),
(
    'james.miller@email.com',
    '["Lithium"]'::jsonb,
    '["Sertraline 100mg daily", "Lorazepam 0.5mg as needed", "Melatonin 3mg at bedtime"]'::jsonb,
    '["Major depressive disorder", "Generalized anxiety disorder", "Insomnia"]'::jsonb,
    '["Psychological evaluation (2023)", "Sleep study (2022)"]'::jsonb,
    '{"TSH": "1.8 mIU/L", "B12": "450 pg/mL", "Folate": "8.2 ng/mL"}'::jsonb,
    'Father: Depression, anxiety. Mother: Bipolar disorder.',
    '2024-02-28'
),
(
    'patricia.wilson@email.com',
    '["Gluten", "Dairy"]'::jsonb,
    '["Omeprazole 20mg daily", "Probiotics", "Iron supplement 325mg daily"]'::jsonb,
    '["Celiac disease", "Iron deficiency anemia", "Lactose intolerance"]'::jsonb,
    '["Upper endoscopy with biopsy (2022)", "Colonoscopy (2023)"]'::jsonb,
    '{"Hemoglobin": "10.9 g/dL", "Iron": "35 μg/dL", "TIBC": "450 μg/dL", "Anti-tTG": "8 U/mL"}'::jsonb,
    'Mother: Celiac disease. Sister: Crohns disease.',
    '2024-01-22'
),
(
    'michael.moore@email.com',
    '["Dust mites", "Pollen"]'::jsonb,
    '["Budesonide/formoterol inhaler", "Ipratropium nebulizer", "Oxygen therapy at night"]'::jsonb,
    '["COPD", "Emphysema", "Former smoker (40 pack-years)"]'::jsonb,
    '["CT chest (2024)", "Pulmonary rehabilitation (2023)", "Smoking cessation program (2022)"]'::jsonb,
    '{"FEV1": "45% predicted", "FVC": "65% predicted", "Oxygen saturation": "91%", "Alpha-1 antitrypsin": "normal"}'::jsonb,
    'Father: COPD, lung cancer (smoker). Brother: Emphysema.',
    '2024-03-12'
),
(
    'jennifer.taylor@email.com',
    '["Nickel", "Fragrance"]'::jsonb,
    '["Triamcinolone cream", "Cetirizine 10mg daily", "Moisturizer with ceramides"]'::jsonb,
    '["Atopic dermatitis", "Contact dermatitis", "Seasonal allergies"]'::jsonb,
    '["Patch testing (2023)", "Skin biopsy (2022)"]'::jsonb,
    '{"IgE": "420 IU/mL", "Specific IgE to common allergens": "positive for multiple environmental allergens"}'::jsonb,
    'Mother: Eczema, allergies. Father: Psoriasis.',
    '2024-02-08'
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_specialists_specialty ON specialists(specialty);
CREATE INDEX IF NOT EXISTS idx_specialists_availability ON specialists(availability);
CREATE INDEX IF NOT EXISTS idx_patients_case_id ON patients(case_id);
CREATE INDEX IF NOT EXISTS idx_patients_status ON patients(status);
CREATE INDEX IF NOT EXISTS idx_patients_created_at ON patients(created_at);
CREATE INDEX IF NOT EXISTS idx_patient_history_email ON patient_medical_history(patient_email);
CREATE INDEX IF NOT EXISTS idx_medical_reports_case_id ON medical_reports(case_id);
CREATE INDEX IF NOT EXISTS idx_appointments_case_id ON appointments(case_id);
CREATE INDEX IF NOT EXISTS idx_appointments_date ON appointments(appointment_date);

-- Create views for easier querying
CREATE OR REPLACE VIEW active_cases AS
SELECT 
    p.case_id,
    p.patient_id,
    p.urgency_level,
    p.specialty,
    p.status,
    s.name as specialist_name,
    s.email as specialist_email,
    p.created_at
FROM patients p
LEFT JOIN specialists s ON p.assigned_specialist_id = s.id
WHERE p.status NOT IN ('completed', 'cancelled');

CREATE OR REPLACE VIEW specialist_workload AS
SELECT 
    s.name,
    s.specialty,
    s.availability,
    COUNT(p.case_id) as active_cases,
    COUNT(CASE WHEN p.urgency_level = 'Critical' THEN 1 END) as critical_cases,
    COUNT(CASE WHEN p.urgency_level = 'High' THEN 1 END) as high_priority_cases
FROM specialists s
LEFT JOIN patients p ON s.id = p.assigned_specialist_id 
    AND p.status NOT IN ('completed', 'cancelled')
GROUP BY s.id, s.name, s.specialty, s.availability
ORDER BY active_cases DESC;

-- Sample trigger for audit logging
CREATE OR REPLACE FUNCTION audit_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO audit_logs (action, resource_type, resource_id, old_values)
        VALUES ('DELETE', TG_TABLE_NAME, OLD.case_id, row_to_json(OLD));
        RETURN OLD;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_logs (action, resource_type, resource_id, old_values, new_values)
        VALUES ('UPDATE', TG_TABLE_NAME, NEW.case_id, row_to_json(OLD), row_to_json(NEW));
        RETURN NEW;
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO audit_logs (action, resource_type, resource_id, new_values)
        VALUES ('INSERT', TG_TABLE_NAME, NEW.case_id, row_to_json(NEW));
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create audit triggers
DROP TRIGGER IF EXISTS audit_patients ON patients;
CREATE TRIGGER audit_patients
    AFTER INSERT OR UPDATE OR DELETE ON patients
    FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

-- Grant permissions (adjust as needed for your environment)
-- GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO n8n;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO n8n;

-- Display setup confirmation
SELECT 'Database setup completed successfully!' as status,
       (SELECT COUNT(*) FROM specialists) as specialists_count,
       (SELECT COUNT(*) FROM patient_medical_history) as patient_histories_count;