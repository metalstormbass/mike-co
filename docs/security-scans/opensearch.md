# opensearch

**Chainguard hardened container image** for the **opensearch** service.

## Image Details

| Property | Value |
|----------|-------|
| **Source Image** | `cgr.dev/mikeco.com/opensearch:2` |
| **Digest** | `cgr.dev/mikeco.com/opensearch@sha256:abfc040632cde1a59840d8cfd76add553587232ce8abad1feb5dfa706effa5d7` |
| **Size** | 816.71 MB |
| **Scan Date** | 2026-01-26 19:17:18 UTC |
| **Scanner** | Grype |

## Vulnerability Summary

| Severity | Count |
|----------|-------|
| $\color{red}{\textsf{Critical}}$ | 0 |
| $\color{orange}{\textsf{High}}$ | 1 |
| $\color{gold}{\textsf{Medium}}$ | 2 |
| $\color{green}{\textsf{Low}}$ | 0 |
| $\color{gray}{\textsf{Negligible}}$ | 0 |
| **Total** | **3** |

## Detailed Findings

| Severity | Package | Version | Vulnerability | Fixed In |
|----------|---------|---------|---------------|----------|
| 🟠 High | glibc | 2.42-r6 | CVE-2025-15281 | N/A |
| 🟡 Medium | log4j-core | 2.21.0 | GHSA-vc5p-v9hr-52mj | 2.25.3 |
| 🟡 Medium | busybox | 1.37.0-r51 | CVE-2025-60876 | N/A |
