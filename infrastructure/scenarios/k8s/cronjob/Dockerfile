# syntax=docker/dockerfile:1.6
# Phase 8 / TRIG-02: Minimal hermes-agent image for K8s CronJob
#
# Teaching artifact: demonstrates packaging an agent for K8s CronJob deployment.
# Used by infrastructure/scenarios/k8s/cronjob/agent-health-check.yaml.
#
# Why not nousresearch/hermes-agent:latest?
#   The official image is ~2-3GB because it bundles Playwright, ffmpeg, Node.js,
#   and Chromium for the web-browsing Hermes use cases. For a diagnostic
#   CronJob, we only need the core agent + messaging + cron extras.
#   python:3.12-slim keeps the image to ~700-900MB.
#
# Build:
#   docker build -t hermes-lab:cronjob infrastructure/scenarios/k8s/cronjob/
#
# Load into KIND:
#   kind load docker-image hermes-lab:cronjob --name lab
#
# Verify inside image:
#   docker run --rm hermes-lab:cronjob hermes --version
FROM python:3.12-slim

# System dependencies for hermes-agent (git for pip source install, ripgrep for
# in-image search, curl for health checks)
RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        curl \
        ripgrep \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install hermes-agent with the extras the CronJob actually needs.
# Use git+https because hermes-agent is not published to PyPI.
RUN pip install --no-cache-dir \
    "git+https://github.com/NousResearch/hermes-agent.git#egg=hermes-agent[messaging,cron]"

WORKDIR /work

# Default entrypoint is the hermes CLI; the CronJob spec overrides `command`
# to invoke a specific skill with a specific prompt.
ENTRYPOINT ["hermes"]
