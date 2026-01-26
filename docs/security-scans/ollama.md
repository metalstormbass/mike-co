# ollama

External container image for the **ollama** service.

## Image Details

| Property | Value |
|----------|-------|
| **Source Image** | `ollama/ollama:latest` |
| **Digest** | `ollama/ollama@sha256:e0ae5354a9e4c85160df4698a45ae360cd0c12ef90e484b12fc870c28f491892` |
| **Size** | 5.23 GB |
| **Scan Date** | 2026-01-26 22:25:08 UTC |
| **Scanner** | Grype |

## Vulnerability Summary

| Severity | Count |
|----------|-------|
| $\color{red}{\textsf{Critical}}$ | 1 |
| $\color{orange}{\textsf{High}}$ | 8 |
| $\color{gold}{\textsf{Medium}}$ | 29 |
| $\color{green}{\textsf{Low}}$ | 15 |
| $\color{gray}{\textsf{Negligible}}$ | 0 |
| **Total** | **53** |

## Detailed Findings

| Severity | Package | Version | Vulnerability | Fixed In |
|----------|---------|---------|---------------|----------|
| 🔴 Critical | stdlib | go1.24.1 | CVE-2025-22871 | 1.23.8 |
| 🟠 High | stdlib | go1.24.1 | CVE-2025-61723 | 1.24.8 |
| 🟠 High | stdlib | go1.24.1 | CVE-2025-61725 | 1.24.8 |
| 🟠 High | stdlib | go1.24.1 | CVE-2025-61729 | 1.24.11 |
| 🟠 High | stdlib | go1.24.1 | CVE-2025-47907 | 1.23.12 |
| 🟠 High | stdlib | go1.24.1 | CVE-2025-58187 | 1.24.9 |
| 🟠 High | stdlib | go1.24.1 | CVE-2025-58188 | 1.24.8 |
| 🟠 High | stdlib | go1.24.1 | CVE-2025-22874 | 1.24.4 |
| 🟠 High | stdlib | go1.24.1 | CVE-2025-4674 | 1.23.11 |
| 🟡 Medium | libxml2 | 2.9.14+dfsg-1.3ubuntu3.6 | CVE-2026-0990 | 2.9.14+dfsg-1.3ubuntu3.7 |
| 🟡 Medium | libexpat1 | 2.6.1-2ubuntu0.3 | CVE-2025-59375 | N/A |
| 🟡 Medium | golang.org/x/crypto | v0.43.0 | GHSA-j5w8-q4qc-rx2x | 0.45.0 |
| 🟡 Medium | libxml2 | 2.9.14+dfsg-1.3ubuntu3.6 | CVE-2026-0992 | 2.9.14+dfsg-1.3ubuntu3.7 |
| 🟡 Medium | libxml2 | 2.9.14+dfsg-1.3ubuntu3.6 | CVE-2026-0989 | 2.9.14+dfsg-1.3ubuntu3.7 |
| 🟡 Medium | tar | 1.35+dfsg-3build1 | CVE-2025-45582 | N/A |
| 🟡 Medium | libc-bin | 2.39-0ubuntu8.6 | CVE-2026-0915 | N/A |
| 🟡 Medium | libc6 | 2.39-0ubuntu8.6 | CVE-2026-0915 | N/A |
| 🟡 Medium | libc-bin | 2.39-0ubuntu8.6 | CVE-2025-15281 | N/A |
| 🟡 Medium | libc6 | 2.39-0ubuntu8.6 | CVE-2025-15281 | N/A |
| 🟡 Medium | stdlib | go1.24.1 | CVE-2025-58185 | 1.24.8 |
| 🟡 Medium | stdlib | go1.24.1 | CVE-2025-47912 | 1.24.8 |
| 🟡 Medium | stdlib | go1.24.1 | CVE-2025-58186 | 1.24.8 |
| 🟡 Medium | stdlib | go1.24.1 | CVE-2025-61724 | 1.24.8 |
| 🟡 Medium | stdlib | go1.24.1 | CVE-2025-47906 | 1.23.12 |
| 🟡 Medium | stdlib | go1.24.1 | CVE-2025-58189 | 1.24.8 |
| 🟡 Medium | golang.org/x/crypto | v0.43.0 | GHSA-f6x5-jh6r-wrfv | 0.45.0 |
| 🟡 Medium | libc-bin | 2.39-0ubuntu8.6 | CVE-2026-0861 | N/A |
| 🟡 Medium | libc6 | 2.39-0ubuntu8.6 | CVE-2026-0861 | N/A |
| 🟡 Medium | stdlib | go1.24.1 | CVE-2025-58183 | 1.24.8 |
| 🟡 Medium | libexpat1 | 2.6.1-2ubuntu0.3 | CVE-2025-66382 | N/A |
| 🟡 Medium | stdlib | go1.24.1 | CVE-2025-4673 | 1.23.10 |
| 🟡 Medium | libpam-modules | 1.5.3-5ubuntu5.5 | CVE-2025-8941 | N/A |
| 🟡 Medium | libpam-modules-bin | 1.5.3-5ubuntu5.5 | CVE-2025-8941 | N/A |
| 🟡 Medium | libpam-runtime | 1.5.3-5ubuntu5.5 | CVE-2025-8941 | N/A |
| 🟡 Medium | libpam0g | 1.5.3-5ubuntu5.5 | CVE-2025-8941 | N/A |
| 🟡 Medium | stdlib | go1.24.1 | CVE-2025-61727 | 1.24.11 |
| 🟡 Medium | gpgv | 2.4.4-2ubuntu17.4 | CVE-2025-68972 | N/A |
| 🟡 Medium | libexpat1 | 2.6.1-2ubuntu0.3 | CVE-2026-24515 | N/A |
| 🟢 Low | login | 1:4.13+dfsg1-4ubuntu3.2 | CVE-2024-56433 | N/A |
| 🟢 Low | passwd | 1:4.13+dfsg1-4ubuntu3.2 | CVE-2024-56433 | N/A |
| 🟢 Low | libelf1t64 | 0.190-1.1ubuntu0.1 | CVE-2025-1352 | N/A |
| 🟢 Low | libgcrypt20 | 1.10.3-2build1 | CVE-2024-2236 | N/A |
| 🟢 Low | coreutils | 9.4-3ubuntu6.1 | CVE-2016-2781 | N/A |
| 🟢 Low | libelf1t64 | 0.190-1.1ubuntu0.1 | CVE-2025-1376 | N/A |
| 🟢 Low | libicu74 | 74.2-1ubuntu3.1 | CVE-2025-5222 | N/A |
| 🟢 Low | gpgv | 2.4.4-2ubuntu17.4 | CVE-2022-3219 | N/A |
| 🟢 Low | coreutils | 9.4-3ubuntu6.1 | CVE-2025-5278 | N/A |
| 🟢 Low | libncursesw6 | 6.4+20240113-1ubuntu2 | CVE-2025-6141 | N/A |
| 🟢 Low | libtinfo6 | 6.4+20240113-1ubuntu2 | CVE-2025-6141 | N/A |
| 🟢 Low | ncurses-base | 6.4+20240113-1ubuntu2 | CVE-2025-6141 | N/A |

*Showing top 50 of 53 vulnerabilities (sorted by severity)*
