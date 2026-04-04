.PHONY: deploy destroy build load-images status cluster db monitoring app

CLUSTER_NAME    := lab
APP_NAMESPACE   := app
DB_NAMESPACE    := db
MON_NAMESPACE   := monitoring
HELM_CHART      := ./helm/reference-app
KIND_CONFIG     := ../infrastructure/kind/cluster-config.yaml
PROM_VALUES     := ../infrastructure/helm/prometheus-lab-values.yaml
IMAGE_TAG       := 1.0.0

# One-command deploy: creates cluster, installs DB + monitoring, builds images, deploys app
deploy: cluster db monitoring build load-images app
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

build:
	docker build --build-arg GIT_SHA=$(shell git rev-parse --short HEAD 2>/dev/null || echo "dev") \
		-t reference-app/api-gateway:$(IMAGE_TAG) services/api-gateway/
	docker build --build-arg GIT_SHA=$(shell git rev-parse --short HEAD 2>/dev/null || echo "dev") \
		-t reference-app/catalog:$(IMAGE_TAG) services/catalog/
	docker build --build-arg GIT_SHA=$(shell git rev-parse --short HEAD 2>/dev/null || echo "dev") \
		-t reference-app/worker:$(IMAGE_TAG) services/worker/
	docker build -t reference-app/dashboard:$(IMAGE_TAG) dashboard/

load-images:
	kind load docker-image reference-app/api-gateway:$(IMAGE_TAG) --name $(CLUSTER_NAME)
	kind load docker-image reference-app/catalog:$(IMAGE_TAG) --name $(CLUSTER_NAME)
	kind load docker-image reference-app/worker:$(IMAGE_TAG) --name $(CLUSTER_NAME)
	kind load docker-image reference-app/dashboard:$(IMAGE_TAG) --name $(CLUSTER_NAME)

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
