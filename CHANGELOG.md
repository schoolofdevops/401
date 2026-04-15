# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-04-15

### Added

- **Module 11**: Telegram conversational chat integration with hermes gateway setup
- **Module 11**: Slack integration (optional) to Track C triggers lab
- **Module 11**: Multi-bot setup guidance and /sethome + delivery features
- **Explainer Framework**: Automated gitignore for generated explainer screenshots and sequences

### Fixed

- **Module 11**: Gateway start and tail -f log instructions in prerequisites
- **Module 11**: Telegram profile vs default agent configuration
- **Module 11**: AlertManager pod naming and configuration references
- **Module 11**: AlertManager webhook output visibility
- **Module 11**: Hermes cron command signature and global skills API key handling
- **Lab Infrastructure**: Kubernetes validation commands and gateway state management

## [0.1.1] - 2026-04-09

### Fixed

- **Module 08**: Clean up stray formatting in Track C lab Step 1
- **Module 07**: Correct Track A/B/C/D naming conventions in README
- **Module 12**: Fix `hermes cron create` command signature (use positional schedule/prompt arguments)
- **Lab Infrastructure**: Fix mock-kubectl/aws/psql PATH interception wrapper logic
- **Lab Setup**: Route kubectl, aws, and psql commands through ~/.bash_profile aliases (macOS and Windows compatibility)
- **Lab 08**: Fix broken lab scenario and instructions

## [0.1.0] - 2026-04-06

### Added

- **Module 01 — Welcome & Foundations**: Course intro, DevOps-to-AI mental model, labs, reading, quiz, and explainers
- **Module 02 — AI Foundations**: LLMs, context engineering, prompt mechanics, hands-on labs with Claude Code
- **Module 03 — Platform AI**: AWS built-in AI features walkthrough, platform AI patterns
- **Module 04 — MCP (Model Context Protocol)**: MCP architecture, tool wiring, server setup labs
- **Module 05 — Structured Coding & AI Internals**: Superpowers workflow for IaC, TDD with AI assistance, AI internals explainer
- Reference application with dashboard (Docker/K8s topology visualization, PostgreSQL health status)
- KIND-based Kubernetes lab infrastructure (Helm charts, nginx proxy, service mesh)
- Course site scaffold (Docusaurus)
- Workshop 5-day variant outline (`WORKSHOP-5DAY.md`)
- Governance and skills framework scaffolding
- Instructor materials and setup guides
