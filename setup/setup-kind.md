# KIND Cluster Setup

KIND (Kubernetes IN Docker) runs a complete Kubernetes cluster as Docker containers on your local machine. You get a real Kubernetes API server, real nodes, and real pods — all without a cloud account or a virtual machine. Clusters start in under 60 seconds and require only Docker as a prerequisite. KIND is the Kubernetes platform for all Track C labs in this course.

**Time required:** 5–10 minutes

---

## Prerequisites

- Docker Desktop (macOS/Windows) or Docker Engine (Linux) — must be running before you begin
- `kubectl` installed (see installation notes below)
- ~2 GB of free disk space for the cluster node image

### Verify Docker is running

```bash
docker info
```

If this returns an error, start Docker Desktop or the Docker daemon and retry.

---

## Step 1: Install kubectl (if not already installed)

### macOS

```bash
brew install kubectl
```

Or download directly:

```bash
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl"
chmod +x kubectl && sudo mv kubectl /usr/local/bin/
```

### Linux (x86_64)

```bash
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl && sudo mv kubectl /usr/local/bin/
```

### Verify kubectl

```bash
kubectl version --client
```

---

## Step 2: Install KIND

### macOS

The easiest path is Homebrew:

```bash
brew install kind
```

Or install the binary directly (targets v0.31.0 or later):

```bash
# macOS arm64 (Apple Silicon)
curl -Lo kind https://github.com/kubernetes-sigs/kind/releases/download/v0.31.0/kind-darwin-arm64
chmod +x kind && sudo mv kind /usr/local/bin/

# macOS x86_64 (Intel)
curl -Lo kind https://github.com/kubernetes-sigs/kind/releases/download/v0.31.0/kind-darwin-amd64
chmod +x kind && sudo mv kind /usr/local/bin/
```

### Linux (x86_64)

```bash
curl -Lo kind https://github.com/kubernetes-sigs/kind/releases/download/v0.31.0/kind-linux-amd64
chmod +x kind && sudo mv kind /usr/local/bin/
```

### Verify KIND version

```bash
kind version
```

Expected output (v0.31.0 or later):

```
kind v0.31.0 go1.23.3 linux/amd64
```

> **Version requirement:** KIND >= v0.31.0 is required for the Kubernetes 1.32 node images used in Track C labs. If `kind version` shows an earlier release, update KIND using the commands above.

---

## Step 3: Create the Lab Cluster

> **IMPORTANT: The cluster name MUST be `lab`.** All lab scripts, `verify.sh`, and the Track C Hermes agent use the name `lab` in their kubectl context references. Using a different name will cause labs to fail.

```bash
kind create cluster --name lab --wait 60s
```

Expected output:

```
Creating cluster "lab" ...
 ✓ Ensuring node image (kindest/node:v1.32.0) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
Set kubectl context to "kind-lab"
Thanks for using kind! 😊
```

The cluster name `lab` produces a kubectl context named `kind-lab` (KIND automatically prefixes cluster names with `kind-`).

---

## Step 4: Verify kubectl Access

```bash
kubectl get nodes --context kind-lab
```

Expected output:

```
NAME                 STATUS   ROLES           AGE   VERSION
lab-control-plane    Ready    control-plane   30s   v1.32.0
```

The node must show `Ready` before proceeding to labs. If it shows `NotReady`, wait 15–30 seconds and retry.

---

## Step 5: Set the Default kubectl Context (Optional)

If you want `kubectl` to default to the lab cluster without specifying `--context` every time:

```bash
kubectl config use-context kind-lab
```

Verify:

```bash
kubectl config current-context
```

Expected output: `kind-lab`

---

## Step 6: Run verify.sh

With the cluster running, the KIND checks in the validation script should now pass:

```bash
bash course/setup/verify.sh
```

Expected output for KIND checks:

```
[PASS] KIND: v0.31.0 or later
[PASS] kind-lab context: cluster is reachable
[PASS] Node lab-control-plane: Ready
```

---

## Cleanup: Delete the Cluster After Labs

KIND clusters persist until you delete them. To free Docker resources (and disk space) after completing lab days:

```bash
kind delete cluster --name lab
```

To also reclaim Docker image and container disk space:

```bash
docker system prune
```

> **Tip:** You can recreate the cluster before the next lab day with the same `kind create cluster --name lab --wait 60s` command. Cluster creation is fast (~60 seconds) so there is no need to keep it running between sessions.

---

## Troubleshooting

| Problem | Likely cause | Fix |
|---------|-------------|-----|
| `kind: command not found` | Binary not in PATH | Re-check install path; add `/usr/local/bin` to PATH |
| `kind version` shows < v0.31.0 | Old KIND installed | Reinstall using binary download commands above |
| Cluster stuck on "Ensuring node image" | Docker not running or low disk | Verify Docker is running; free at least 2 GB of disk |
| `kubectl get nodes` — `connection refused` | Context not set | Run `kubectl config use-context kind-lab` |
| `kind get clusters` returns empty | Cluster creation failed | Check Docker resources and retry `kind create cluster --name lab` |
| `kind create cluster` fails with port conflict | Another KIND cluster exists | Run `kind delete cluster --name <other-name>` first |
| Node stuck in `NotReady` > 2 minutes | Networking issue inside Docker | Delete and recreate: `kind delete cluster --name lab && kind create cluster --name lab --wait 60s` |

---

## Windows Notes

KIND works on Windows with Docker Desktop. Lab shell scripts require WSL2 (Windows Subsystem for Linux). After installing WSL2:

1. Install KIND inside WSL2, not in Windows PowerShell
2. Ensure Docker Desktop has **WSL2 integration** enabled for your distro
3. Run all `bash course/setup/*.sh` commands from a WSL2 terminal
