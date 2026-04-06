.PHONY: deploy deploy-from-source destroy build publish pull-images load-images status cluster db monitoring app \
        compose-up compose-down compose-logs compose-build-up

CLUSTER_NAME    := lab
APP_NAMESPACE   := app
DB_NAMESPACE    := db
MON_NAMESPACE   := monitoring
HELM_CHART      := ./helm/reference-app
KIND_CONFIG     := ../infrastructure/kind/cluster-config.yaml
PROM_VALUES     := ../infrastructure/helm/prometheus-lab-values.yaml

IMAGE_TAG       := 1.0.0
REGISTRY        := schoolofdevops
GIT_SHA         := $(shell git rev-parse --short HEAD 2>/dev/null || echo "dev")

# --- Kubernetes (KIND) deployment ---

# One-command deploy: creates cluster, installs DB + monitoring, pulls pre-built images, deploys app
# Uses pre-built images from Docker Hub — no local Rust compilation required.
# To build from source instead: make deploy-from-source
deploy: cluster db monitoring pull-images load-images app
	@echo ""
	@echo "=== Deployment Complete ==="
	@echo "Dashboard:  http://localhost:30080"
	@echo "Grafana:    http://localhost:30090  (admin/admin)"
	@echo "Prometheus: http://localhost:30091"
	@echo ""

cluster:
	@kind get clusters 2>/dev/null | grep -q "^$(CLUSTER_NAME)$$" || \
		kind create cluster --config $(KIND_CONFIG)

db:
	@helm repo add bitnami https://charts.bitnami.com/bitnami 2>/dev/null || true
	@helm repo update bitnami
	helm upgrade --install postgresql bitnami/postgresql \
		--namespace $(DB_NAMESPACE) --create-namespace \
		--set auth.username=refapp \
		--set auth.password=refapp-lab-password \
		--set auth.database=refapp \
		--set primary.resources.requests.cpu=50m \
		--set primary.resources.requests.memory=128Mi \
		--wait --timeout 120s

monitoring:
	@helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 2>/dev/null || true
	@helm repo update prometheus-community
	helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
		--namespace $(MON_NAMESPACE) --create-namespace \
		-f $(PROM_VALUES) \
		--wait --timeout 180s

# Pull pre-built images from Docker Hub (used by default deploy)
pull-images:
	docker pull $(REGISTRY)/refapp-gateway:$(IMAGE_TAG)
	docker pull $(REGISTRY)/refapp-catalog:$(IMAGE_TAG)
	docker pull $(REGISTRY)/refapp-worker:$(IMAGE_TAG)
	docker pull $(REGISTRY)/refapp-dashboard:$(IMAGE_TAG)

# Build from source (requires Rust toolchain — takes 5-10 min on first run)
deploy-from-source: cluster db monitoring build load-images app
	@echo ""
	@echo "=== Deployment Complete (built from source) ==="
	@echo "Dashboard:  http://localhost:30080"
	@echo "Grafana:    http://localhost:30090  (admin/admin)"
	@echo "Prometheus: http://localhost:30091"
	@echo ""

build:
	docker build --build-arg GIT_SHA=$(GIT_SHA) \
		-f services/api-gateway/Dockerfile \
		-t $(REGISTRY)/refapp-gateway:$(IMAGE_TAG) \
		-t $(REGISTRY)/refapp-gateway:latest .
	docker build --build-arg GIT_SHA=$(GIT_SHA) \
		-f services/catalog/Dockerfile \
		-t $(REGISTRY)/refapp-catalog:$(IMAGE_TAG) \
		-t $(REGISTRY)/refapp-catalog:latest .
	docker build --build-arg GIT_SHA=$(GIT_SHA) \
		-f services/worker/Dockerfile \
		-t $(REGISTRY)/refapp-worker:$(IMAGE_TAG) \
		-t $(REGISTRY)/refapp-worker:latest .
	docker build \
		-t $(REGISTRY)/refapp-dashboard:$(IMAGE_TAG) \
		-t $(REGISTRY)/refapp-dashboard:latest \
		dashboard/

publish: build
	docker push $(REGISTRY)/refapp-gateway:$(IMAGE_TAG)
	docker push $(REGISTRY)/refapp-gateway:latest
	docker push $(REGISTRY)/refapp-catalog:$(IMAGE_TAG)
	docker push $(REGISTRY)/refapp-catalog:latest
	docker push $(REGISTRY)/refapp-worker:$(IMAGE_TAG)
	docker push $(REGISTRY)/refapp-worker:latest
	docker push $(REGISTRY)/refapp-dashboard:$(IMAGE_TAG)
	docker push $(REGISTRY)/refapp-dashboard:latest
	@echo ""
	@echo "=== Published to Docker Hub ==="
	@echo "$(REGISTRY)/refapp-gateway:$(IMAGE_TAG)"
	@echo "$(REGISTRY)/refapp-catalog:$(IMAGE_TAG)"
	@echo "$(REGISTRY)/refapp-worker:$(IMAGE_TAG)"
	@echo "$(REGISTRY)/refapp-dashboard:$(IMAGE_TAG)"

load-images:
	kind load docker-image $(REGISTRY)/refapp-gateway:$(IMAGE_TAG) --name $(CLUSTER_NAME)
	kind load docker-image $(REGISTRY)/refapp-catalog:$(IMAGE_TAG) --name $(CLUSTER_NAME)
	kind load docker-image $(REGISTRY)/refapp-worker:$(IMAGE_TAG) --name $(CLUSTER_NAME)
	kind load docker-image $(REGISTRY)/refapp-dashboard:$(IMAGE_TAG) --name $(CLUSTER_NAME)

app:
	helm upgrade --install reference-app $(HELM_CHART) \
		--namespace $(APP_NAMESPACE) --create-namespace \
		--wait --timeout 120s

status:
	@echo "=== Pods ==="
	@kubectl get pods -n $(APP_NAMESPACE) 2>/dev/null || echo "App namespace not found"
	@kubectl get pods -n $(DB_NAMESPACE) 2>/dev/null || echo "DB namespace not found"
	@kubectl get pods -n $(MON_NAMESPACE) 2>/dev/null || echo "Monitoring namespace not found"

destroy:
	kind delete cluster --name $(CLUSTER_NAME)

# --- Docker Compose (no K8s required) ---

# Quick start: pulls pre-built images from Docker Hub
compose-up:
	docker compose up -d
	@echo ""
	@echo "=== Docker Compose Deployment ==="
	@echo "Dashboard:   http://localhost:3000"
	@echo "API Gateway: http://localhost:8080"
	@echo "Catalog:     http://localhost:8081"
	@echo "Worker:      http://localhost:8082"
	@echo "PostgreSQL:  localhost:5432"
	@echo ""
	@echo "Logs: make compose-logs"
	@echo "Stop: make compose-down"

# Build from source, then start
compose-build-up:
	GIT_SHA=$(GIT_SHA) \
		docker compose -f docker-compose.yml -f docker-compose.build.yml up --build -d
	@echo ""
	@echo "=== Docker Compose (built from source) ==="
	@echo "Dashboard:   http://localhost:3000"
	@echo "API Gateway: http://localhost:8080"
	@echo "Catalog:     http://localhost:8081"
	@echo "Worker:      http://localhost:8082"
	@echo ""
	@echo "Logs: make compose-logs"
	@echo "Stop: make compose-down"

compose-down:
	docker compose down

compose-logs:
	docker compose logs -f
