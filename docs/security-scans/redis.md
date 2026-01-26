# redis

**Chainguard hardened container image** for the **redis** service.

## Image Details

| Property | Value |
|----------|-------|
| **Source Image** | `cgr.dev/mikeco.com/redis:7` |
| **Digest** | `cgr.dev/mikeco.com/redis@sha256:403c093acf4b3eff5ab830e8a3c762a2c1d6166fda696973af668871e50cc085` |
| **Size** | 10.12 MB |
| **Scan Date** | 2026-01-26 18:50:13 UTC |
| **Scanner** | Grype |

## Vulnerability Summary

| Severity | Count |
|----------|-------|
| $\color{red}{\textsf{Critical}}$ | 0 |
| $\color{orange}{\textsf{High}}$ | 1 |
| $\color{gold}{\textsf{Medium}}$ | 1 |
| $\color{green}{\textsf{Low}}$ | 1 |
| $\color{gray}{\textsf{Negligible}}$ | 0 |
| **Total** | **3** |

## Detailed Findings

| Severity | Package | Version | Vulnerability | Fixed In |
|----------|---------|---------|---------------|----------|
| 🟠 High | glibc | 2.42-r7 | CVE-2025-15281 | N/A |
| 🟡 Medium | busybox | 1.37.0-r51 | CVE-2025-60876 | N/A |
| 🟢 Low | redis-7.4 | 7.4.7-r2 | CVE-2025-49112 | N/A |
