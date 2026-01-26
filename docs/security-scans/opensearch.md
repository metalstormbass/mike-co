# opensearch

**Chainguard hardened container image** for the **opensearch** service.

## Image Details

| Property | Value |
|----------|-------|
| **Source Image** | `cgr.dev/mikeco.com/opensearch:2` |
| **Digest** | `cgr.dev/mikeco.com/opensearch@sha256:07a926b66cb1bbdaafc101d0266ec112b03dadac9cf130d74b19f70e9362d80e` |
| **Size** | 816.71 MB |
| **Scan Date** | 2026-01-26 21:27:23 UTC |
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
| 🟠 High | glibc | 2.42-r7 | CVE-2025-15281 | N/A |
| 🟡 Medium | log4j-core | 2.21.0 | GHSA-vc5p-v9hr-52mj | 2.25.3 |
| 🟡 Medium | busybox | 1.37.0-r52 | CVE-2025-60876 | N/A |
