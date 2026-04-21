# mdatp-quick-scan

## Overview

`mdatp-quick-scan` is a production-ready Bash utility designed to safely trigger a Microsoft Defender for Endpoint (`mdatp`) quick scan on Linux systems.

Unlike a simple command wrapper, this tool includes:

- Pre-execution validation (disk space, permissions, installation checks)
- Structured logging with size control
- Clear exit codes for automation systems
- Safe execution in managed environments

This script is intended for use in **enterprise environments** where consistency, observability, and reliability are required.

---

## Purpose

Microsoft currently supports scheduling Microsoft Defender for Endpoint (mdatp) quick scans on Linux primarily through **cron-based scheduling**. This tool is designed to formalize and harden that approach while making it suitable for enterprise automation environments.

Run a daily quick scan while ensuring:

- The system is in a valid state to execute the scan  
- Failures are visible and actionable through consistent exit codes and logging  
- Logs are captured for auditing, troubleshooting, and operational visibility  
- Execution aligns with Microsoft’s intended model for Linux-based scan scheduling  

### Important Behavior Context

- Quick scans are intended to run while **Real-Time Protection (RTP) mode is enabled**
- This is by design and aligns with how Microsoft Defender for Endpoint operates on Linux
- RTP and scheduled quick scans are complementary:
  - RTP provides continuous protection
  - Quick scans provide periodic verification and additional signal coverage
- This tool assumes RTP is active and does not attempt to replace or disable it

By enforcing this model, the tool supports the intended operational behavior of Microsoft Defender for Endpoint and ensures scanning activity remains consistent with Microsoft’s supported configuration patterns.
Run a daily quick scan while ensuring:

---

## Requirements

- Linux system with `mdatp` installed  
- Appropriate permissions to:
  - Execute `mdatp`
  - Write logs (default: `/var/log/microsoft`)

---

## Usage

```bash
chmod +x mdatp-quick-scan.sh
./mdatp-quick-scan.sh
```

Execution Options

This tool is designed to be executed in automated environments. There are two primary approaches:

Option 1: Cron Job (Simple Scheduling)

Example:

```
# Run daily at 2 AM
0 2 * * * /path/to/mdatp-quick-scan.sh
```

## Pros
- **Simple and quick to set up**
- **No external dependencies**
- **Works well for standalone systems**

## Cons
- **No centralized visibility or control**
- **Harder to manage at scale**
- **No built-in reporting or orchestration**
- **Requires manual distribution across hosts**
- **Limited error handling beyond local system**

## Option 2: Infrastructure Orchestration Tool (Recommended)

### Examples include:
- Ansible  
- SCCM / MECM  
- Azure Automation  
- Puppet / Chef  

### Why this is best practice

Using an orchestration platform allows engineers to:

- Centrally manage execution across all endpoints  
- Standardize scheduling and configuration  
- Collect results and logs in a unified location  
- Enforce consistency across environments  
- Integrate with incident response workflows  

### Pros
- Centralized control and visibility  
- Scalable across large environments  
- Better error handling and reporting  
- Easier updates and version control  
- Integration with broader security operations  

### Cons
- Requires existing infrastructure/tooling  
- Slightly more complex to set up initially  

---

## Logging

- Default log location: `/var/log/microsoft/mdatp_quick_scan.log`  
- Log file is automatically truncated if it exceeds 1MB  
- Includes timestamps and hostname for traceability  

---

## Exit Codes

| Code | Meaning |
|------|--------|
| 0 | Success |
| 1 | `mdatp` not installed |
| 2 | Permissions issue |
| 3 | Scan execution failed |
| 4 | Log write failure |
| 5 | Low disk space |

Example output:

```bash
Starting script...
Checking log directory...
Checking disk space...
Starting quick scan with mdatp...
SUCCESS: Quick scan completed successfully.
```

## Design Considerations

- Assumes real-time protection is already enabled  
- Designed for non-interactive execution  
- Avoids running under unsafe system conditions  
- Prioritizes clear failure signaling for automation systems  

---

## Security Considerations

- Ensure only trusted users can modify the script  
- Restrict write access to the log directory  
- Validate execution context when used with orchestration tools  

---

## Future Enhancements

- Config file support  
- CLI flags (e.g., `--dry-run`, `--log-dir`)  
- Integration with centralized logging systems  
- Support for additional scan types  

---

## License

This project is licensed under the **Apache License 2.0**.

See the full license text here:  
https://www.apache.org/licenses/LICENSE-2.0
