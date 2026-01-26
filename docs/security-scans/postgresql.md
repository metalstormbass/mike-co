# postgresql

**Chainguard hardened container image** for the **postgresql** service.

## Image Details

| Property | Value |
|----------|-------|
| **Source Image** | `cgr.dev/mikeco.com/postgres:16` |
| **Digest** | `cgr.dev/mikeco.com/postgres@sha256:27d1dafa20c26970c5214cebeb5284d5a3803443d3315e1e121af030da08b347` |
| **Size** | 141.66 MB |
| **Scan Date** | 2026-01-26 18:50:13 UTC |
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
| 🟡 Medium | busybox | 1.37.0-r51 | CVE-2025-60876 | N/A |
