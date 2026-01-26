# redis

External container image for the **redis** service.

## Image Details

| Property | Value |
|----------|-------|
| **Source Image** | `redis:7-bookworm` |
| **Digest** | `redis@sha256:ba125ee995db4c9cf937bb5a771722f443ac96176c7aa5cd03711485ab77c852` |
| **Size** | 111.62 MB |
| **Scan Date** | 2026-01-26 21:51:47 UTC |
| **Scanner** | Grype |

## Vulnerability Summary

| Severity | Count |
|----------|-------|
| $\color{red}{\textsf{Critical}}$ | 8 |
| $\color{orange}{\textsf{High}}$ | 45 |
| $\color{gold}{\textsf{Medium}}$ | 49 |
| $\color{green}{\textsf{Low}}$ | 6 |
| $\color{gray}{\textsf{Negligible}}$ | 47 |
| **Total** | **156** |

## Detailed Findings

| Severity | Package | Version | Vulnerability | Fixed In |
|----------|---------|---------|---------------|----------|
| 🔴 Critical | stdlib | go1.18.2 | CVE-2023-24538 | 1.19.8 |
| 🔴 Critical | stdlib | go1.18.2 | CVE-2023-24531 | 1.21.0-0 |
| 🔴 Critical | stdlib | go1.18.2 | CVE-2023-29405 | 1.19.10 |
| 🔴 Critical | stdlib | go1.18.2 | CVE-2023-24540 | 1.19.9 |
| 🔴 Critical | stdlib | go1.18.2 | CVE-2023-29402 | 1.19.10 |
| 🔴 Critical | stdlib | go1.18.2 | CVE-2024-24790 | 1.21.11 |
| 🔴 Critical | stdlib | go1.18.2 | CVE-2023-29404 | 1.19.10 |
| 🔴 Critical | stdlib | go1.18.2 | CVE-2025-22871 | 1.23.8 |
| 🟠 High | stdlib | go1.18.2 | CVE-2023-44487 | 1.20.10 |
| 🟠 High | stdlib | go1.18.2 | CVE-2023-45288 | 1.21.9 |
| 🟠 High | stdlib | go1.18.2 | CVE-2024-24784 | 1.21.8 |
| 🟠 High | stdlib | go1.18.2 | CVE-2024-24791 | 1.21.12 |
| 🟠 High | stdlib | go1.18.2 | CVE-2024-34156 | 1.22.7 |
| 🟠 High | stdlib | go1.18.2 | CVE-2022-41723 | 1.19.6 |
| 🟠 High | stdlib | go1.18.2 | CVE-2023-45287 | 1.20.0 |
| 🟠 High | stdlib | go1.18.2 | CVE-2024-34158 | 1.22.7 |
| 🟠 High | dpkg | 1.21.22 | CVE-2025-6297 | N/A |
| 🟠 High | stdlib | go1.18.2 | CVE-2022-32189 | 1.17.13 |
| 🟠 High | stdlib | go1.18.2 | CVE-2022-30632 | 1.17.12 |
| 🟠 High | stdlib | go1.18.2 | CVE-2022-30633 | 1.17.12 |
| 🟠 High | stdlib | go1.18.2 | CVE-2022-30635 | 1.17.12 |
| 🟠 High | stdlib | go1.18.2 | CVE-2022-27664 | 1.18.6 |
| 🟠 High | stdlib | go1.18.2 | CVE-2023-24536 | 1.19.8 |
| 🟠 High | stdlib | go1.18.2 | CVE-2023-24539 | 1.19.9 |
| 🟠 High | stdlib | go1.18.2 | CVE-2023-39323 | 1.20.9 |
| 🟠 High | stdlib | go1.18.2 | CVE-2022-41725 | 1.19.6 |
| 🟠 High | stdlib | go1.18.2 | CVE-2023-45285 | 1.20.12 |
| 🟠 High | libtasn1-6 | 4.19.0-2+deb12u1 | CVE-2025-13151 | N/A |
| 🟠 High | stdlib | go1.18.2 | CVE-2023-29400 | 1.19.9 |
| 🟠 High | stdlib | go1.18.2 | CVE-2023-24534 | 1.19.8 |
| 🟠 High | stdlib | go1.18.2 | CVE-2022-30631 | 1.17.12 |
| 🟠 High | libc-bin | 2.36-9+deb12u13 | CVE-2026-0915 | N/A |
| 🟠 High | libc6 | 2.36-9+deb12u13 | CVE-2026-0915 | N/A |
| 🟠 High | libc-bin | 2.36-9+deb12u13 | CVE-2025-15281 | N/A |
| 🟠 High | libc6 | 2.36-9+deb12u13 | CVE-2025-15281 | N/A |
| 🟠 High | stdlib | go1.18.2 | CVE-2022-30630 | 1.17.12 |
| 🟠 High | stdlib | go1.18.2 | CVE-2022-2880 | 1.18.7 |
| 🟠 High | stdlib | go1.18.2 | CVE-2025-61723 | 1.24.8 |
| 🟠 High | stdlib | go1.18.2 | CVE-2025-61725 | 1.24.8 |
| 🟠 High | stdlib | go1.18.2 | CVE-2022-30580 | 1.17.11 |
| 🟠 High | stdlib | go1.18.2 | CVE-2022-41724 | 1.19.6 |
| 🟠 High | stdlib | go1.18.2 | CVE-2025-61729 | 1.24.11 |
| 🟠 High | libc-bin | 2.36-9+deb12u13 | CVE-2026-0861 | N/A |
| 🟠 High | libc6 | 2.36-9+deb12u13 | CVE-2026-0861 | N/A |
| 🟠 High | stdlib | go1.18.2 | CVE-2025-47907 | 1.23.12 |
| 🟠 High | stdlib | go1.18.2 | CVE-2022-41715 | 1.18.7 |
| 🟠 High | stdlib | go1.18.2 | CVE-2025-58187 | 1.24.9 |
| 🟠 High | stdlib | go1.18.2 | CVE-2025-58188 | 1.24.8 |
| 🟠 High | stdlib | go1.18.2 | CVE-2022-2879 | 1.18.7 |
| 🟠 High | stdlib | go1.18.2 | CVE-2022-28131 | 1.17.12 |

*Showing top 50 of 156 vulnerabilities (sorted by severity)*
