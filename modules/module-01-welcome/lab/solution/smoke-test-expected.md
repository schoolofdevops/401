# Smoke Test — Expected Results

This file documents what successful smoke test responses look like for Module 01.

## Test 1: Cluster Pod Query

**Prompt:** "What Kubernetes pods are running in my cluster? List them grouped by namespace with their status."

**Expected response should include:**

Namespace `app`:
- `api-gateway-xxxxx` — Running
- `catalog-xxxxx` — Running
- `worker-xxxxx` — Running
- `dashboard-xxxxx` — Running

Namespace `db`:
- `postgresql-0` — Running

Namespace `monitoring`:
- `monitoring-grafana-xxxxx` — Running
- `monitoring-kube-prometheus-stack-prometheus-xxxxx` — Running
- Various other monitoring pods — Running

Namespace `kube-system`:
- CoreDNS, etcd, kube-apiserver, etc. — Running

## Test 2: Database Schema Query

**Prompt:** "Connect to the PostgreSQL database and list all tables."

**Expected response should include:**
- Connection to `refapp` database confirmed
- Table listing (tables created by the reference app migrations)
- Schema information (column names and types)

## Test 3: Cross-Platform Health Check

**Prompt:** "Check if all pods in the 'app' namespace are healthy, then check the PostgreSQL database connection count. Give me a quick health summary."

**Expected response should include:**
- Pod health status from kubectl (all Running, ready)
- Database connection information from PostgreSQL
- A synthesized health summary combining both data sources

**Key indicator:** The agent should make at least two MCP calls — one to kubernetes and one to postgres — in the same response. This demonstrates cross-platform reasoning.
