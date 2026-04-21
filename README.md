# mdatp-toolkit

A collection of operational utilities for managing and automating Microsoft Defender for Endpoint (mdatp).

This repository is designed for security engineers, platform engineers, and incident responders who need reliable, scriptable tooling to interact with mdatp in real-world environments.

---

## Purpose

The goal of this toolkit is to provide:

- Repeatable and automation-friendly utilities
- Safe execution with built-in validation checks
- Consistent logging for observability and troubleshooting
- Modular tools that can evolve independently

---

## Tools

| Tool | Description |
|------|-------------|
| mdatp-quick-scan | Triggers a quick scan with pre-checks, logging, and error handling |

> Additional tools will be added over time.

---

## Design Principles

- **Idempotent where possible** – safe to run repeatedly
- **Automation-first** – designed for cron, Ansible, SCCM, etc.
- **Observable** – logs actions and failures clearly
- **Modular** – each tool is self-contained

---

## Repository Structure

mdatp-toolkit/
├── README.md
├── .gitignore
├── tools/
│ └── <tool-name>/
│ ├── run.sh
│ ├── README.md
│ └── examples/


---

## Getting Started

1. Clone the repository:

```bash
git clone https://github.com/<your-username>/mdatp-toolkit.git
cd mdatp-toolkit
Navigate to a tool:
cd tools/mdatp-quick-scan-runner
Run the script:
chmod +x run.sh
./run.sh
Requirements
Linux system with mdatp installed
Appropriate permissions to:
Execute mdatp
Write logs (default: /var/log/microsoft)
Contributing

This repo is intended to grow into a broader toolkit. Contributions should:

Follow existing structure
Include clear documentation
Provide meaningful logging and exit codes
```
