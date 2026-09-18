INSERT INTO subscription_plans (name, price_monthly, max_users) VALUES 
('Free Plan', 0.00, 5), ('Pro Plan', 49.00, 50), ('Enterprise Plan', 299.00, 9999);

INSERT INTO roles (role_name, permissions_tier) VALUES 
('Platform Admin', 3), ('Team Member', 2), ('Guest Viewer', 1);

INSERT INTO organizations (name, domain, plan_id) VALUES ('Acme Corporate Systems', 'acme-sys.com', 2);
INSERT INTO users (org_id, role_id, full_name, email, password_hash) VALUES (1, 1, 'John Doe', 'john@acme-sys.com', 'hashed_secure_password_123');

INSERT INTO activity_logs (user_id, action, ip_address, metadata_jsonb) VALUES 
(1, 'user.login', '192.168.1.50', '{"browser": "Chrome", "os": "Windows 11", "session_duration_seconds": 120, "device_type": "desktop"}'::jsonb),
(1, 'subscription.upgrade_clicked', '192.168.1.50', '{"current_plan": "Pro Plan", "target_plan": "Enterprise Plan", "ui_component": "pricing_table_cta"}'::jsonb);

CREATE INDEX idx_activity_logs_metadata_gin ON activity_logs USING gin (metadata_jsonb);

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE activity_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY tenant_invoice_isolation ON invoices FOR ALL USING (org_id = (SELECT org_id FROM users WHERE email = current_user));
