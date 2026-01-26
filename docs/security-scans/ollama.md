# ollama

**Chainguard hardened container image** for the **ollama** service.

## Image Details

| Property | Value |
|----------|-------|
| **Source Image** | `cgr.dev/mikeco.com/ollama:latest-dev` |
| **Digest** | `N/A` |
| **Size** | 4.75 GB |
| **Scan Date** | 2026-01-26 21:08:34 UTC |
| **Scanner** | Grype |

## Vulnerability Summary

| Severity | Count |
|----------|-------|
| $\color{red}{\textsf{Critical}}$ | 0 |
| $\color{orange}{\textsf{High}}$ | 1 |
| $\color{gold}{\textsf{Medium}}$ | 1 |
| $\color{green}{\textsf{Low}}$ | 0 |
| $\color{gray}{\textsf{Negligible}}$ | 0 |
| **Total** | **2** |

## Detailed Findings

| Severity | Package | Version | Vulnerability | Fixed In |
|----------|---------|---------|---------------|----------|
| 🟠 High | glibc | 2.42-r7 | CVE-2025-15281 | N/A |
| 🟡 Medium | busybox | 1.37.0-r52 | CVE-2025-60876 | N/A |
