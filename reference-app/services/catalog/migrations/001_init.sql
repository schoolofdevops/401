-- Reference app schema for Agentic DevOps course labs
-- Used by: catalog (reads), worker (writes), database agents (Module 10)

CREATE TABLE IF NOT EXISTS items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS events (
    id SERIAL PRIMARY KEY,
    source VARCHAR(100) NOT NULL,
    event_type VARCHAR(100) NOT NULL,
    payload JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Service registry seed data (agents query this in Module 10)
INSERT INTO items (name, description, status) VALUES
    ('auth-service',         'JWT authentication, session management, OAuth2 provider', 'active'),
    ('api-gateway',          'Request routing, rate limiting, TLS termination',          'active'),
    ('payment-processor',    'Stripe integration, billing cycles, invoice generation',   'active'),
    ('notification-service', 'Email/SMS/push notifications via SendGrid and Twilio',     'degraded'),
    ('data-pipeline',        'Kafka consumer → Snowflake ETL, nightly batch jobs',       'active'),
    ('web-frontend',         'SvelteKit SPA served via CDN, feature-flagged releases',   'active'),
    ('search-service',       'Elasticsearch-backed full-text and faceted search',        'active'),
    ('audit-logger',         'Append-only compliance event writer, 7-year retention',    'maintenance')
ON CONFLICT DO NOTHING;

-- Pre-seeded operational events (gives the event log something to show on first load)
INSERT INTO events (source, event_type, payload, created_at) VALUES
    ('ci-pipeline',      'deploy',        '{"service":"auth-service","version":"2.4.1","environment":"production","triggered_by":"github-actions"}',                           NOW() - INTERVAL '2 hours'),
    ('monitoring',       'health_check',  '{"service":"notification-service","status":"degraded","reason":"SendGrid API timeout","check_duration_ms":4821}',                    NOW() - INTERVAL '90 minutes'),
    ('pagerduty-bridge', 'alert',         '{"incident":"INC-4471","severity":"warning","service":"notification-service","message":"Email delivery latency > 30s"}',             NOW() - INTERVAL '88 minutes'),
    ('ci-pipeline',      'deploy',        '{"service":"data-pipeline","version":"1.9.0","environment":"production","triggered_by":"scheduled-release"}',                        NOW() - INTERVAL '45 minutes'),
    ('monitoring',       'health_check',  '{"service":"payment-processor","status":"healthy","latency_ms":142,"check_duration_ms":156}',                                        NOW() - INTERVAL '30 minutes'),
    ('worker',           'heartbeat',     '{"status":"alive","uptime_seconds":5400}',                                                                                           NOW() - INTERVAL '20 minutes'),
    ('ci-pipeline',      'deploy',        '{"service":"search-service","version":"3.1.2","environment":"production","triggered_by":"manual","deployer":"ops-team"}',            NOW() - INTERVAL '15 minutes'),
    ('monitoring',       'health_check',  '{"service":"auth-service","status":"healthy","latency_ms":38,"active_sessions":1842}',                                               NOW() - INTERVAL '10 minutes'),
    ('pagerduty-bridge', 'alert',         '{"incident":"INC-4471","severity":"resolved","service":"notification-service","message":"Email delivery latency returned to normal"}', NOW() - INTERVAL '5 minutes'),
    ('worker',           'heartbeat',     '{"status":"alive","uptime_seconds":6000}',                                                                                           NOW() - INTERVAL '2 minutes')
ON CONFLICT DO NOTHING;
