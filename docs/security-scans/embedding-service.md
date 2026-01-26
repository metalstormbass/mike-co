# embedding-service

Container image for the **embedding-service** service.

## Image Details

| Property | Value |
|----------|-------|
| **Image** | `ghcr.io/metalstormbass/mike-co/embedding-service` |
| **Digest** | `sha256:530c027b6e447b4d977af83a14689a6fac756448abe2360bec857a787660e792` |
| **Size** | 7.07 GB |
| **Scan Date** | 2026-01-26 16:23:56 UTC |
| **Scanner** | Grype |

## Vulnerability Summary

| Severity | Count |
|----------|-------|
| $\color{red}{\textsf{Critical}}$ | 6 |
| $\color{orange}{\textsf{High}}$ | 53 |
| $\color{gold}{\textsf{Medium}}$ | 122 |
| $\color{green}{\textsf{Low}}$ | 77 |
| $\color{gray}{\textsf{Negligible}}$ | 6 |
| **Total** | **264** |

## Detailed Findings

| Severity | Package | Version | Vulnerability | Fixed In |
|----------|---------|---------|---------------|----------|
| 🔴 Critical | openssl | 3.0.11 | CVE-2024-5535 | 1.0.2zk |
| 🔴 Critical | pillow | 10.0.1 | GHSA-3f63-hfp8-52jq | 10.2.0 |
| 🔴 Critical | torch | 2.1.0 | GHSA-53q9-r3pm-6pq6 | 2.6.0 |
| 🔴 Critical | transformers | 4.35.0 | GHSA-3863-2447-669p | 4.36.0 |
| 🔴 Critical | python | 3.10.13 | CVE-2025-13836 | 3.13.11 |
| 🔴 Critical | python | 3.10.13 | CVE-2025-4517 | 3.9.23 |
| 🟠 High | transformers | 4.35.0 | GHSA-wrfc-pvp9-mr9g | 4.48.0 |
| 🟠 High | transformers | 4.35.0 | GHSA-hxxf-235m-72v3 | 4.48.0 |
| 🟠 High | transformers | 4.35.0 | GHSA-qxrp-vhvm-j765 | 4.48.0 |
| 🟠 High | setuptools | 68.0.0 | GHSA-cx63-2mw6-8hw5 | 70.0.0 |
| 🟠 High | openssl | 3.0.11 | CVE-2024-6119 | 3.0.15 |
| 🟠 High | openssl | 3.0.11 | CVE-2023-5363 | 3.0.12 |
| 🟠 High | python | 3.10.13 | CVE-2024-6232 | 3.8.20 |
| 🟠 High | python-multipart | 0.0.6 | GHSA-2jv5-9r88-3w3p | 0.0.7 |
| 🟠 High | python | 3.10.13 | CVE-2024-4032 | 3.8.20 |
| 🟠 High | python | 3.10.13 | CVE-2024-7592 | 3.8.20 |
| 🟠 High | urllib3 | 1.26.16 | GHSA-v845-jxx5-vc9f | 1.26.17 |
| 🟠 High | cryptography | 41.0.3 | GHSA-3ww4-gg4f-jr7f | 42.0.0 |
| 🟠 High | ffmpeg | 4.3 | CVE-2020-14212 | 4.3.1 |
| 🟠 High | ffmpeg | 4.3 | CVE-2025-9951 | 7.1.2 |
| 🟠 High | ffmpeg | 4.3 | CVE-2023-6603 | 5.0 |
| 🟠 High | python | 3.10.13 | CVE-2024-0397 | 3.8.20 |
| 🟠 High | cryptography | 41.0.3 | GHSA-6vqw-3v5j-54x4 | 42.0.4 |
| 🟠 High | ffmpeg | 4.3 | CVE-2025-1594 | 7.1.2 |
| 🟠 High | python | 3.10.13 | CVE-2024-8088 | 3.8.20 |
| 🟠 High | ffmpeg | 4.3 | CVE-2021-38291 | 4.1.7 |
| 🟠 High | ffmpeg | 4.3 | CVE-2023-49502 | 3.4.14 |
| 🟠 High | ffmpeg | 4.3 | CVE-2022-48434 | 5.1.2 |
| 🟠 High | ffmpeg | 4.3 | CVE-2020-36138 | N/A |
| 🟠 High | pillow | 10.0.1 | GHSA-44wm-f244-xhp3 | 10.3.0 |
| 🟠 High | openssl | 3.0.11 | CVE-2024-4741 | 1.1.1y |
| 🟠 High | transformers | 4.35.0 | GHSA-v68g-wm8c-6x7j | 4.36.0 |
| 🟠 High | ffmpeg | 4.3 | CVE-2024-7272 | 5.1.6 |
| 🟠 High | ffmpeg | 4.3 | CVE-2022-3109 | 5.0.3 |
| 🟠 High | ffmpeg | 4.3 | CVE-2023-6605 | 4.3.9 |
| 🟠 High | setuptools | 68.0.0 | GHSA-5rjg-fvgr-3xxf | 78.1.1 |
| 🟠 High | python | 3.10.13 | CVE-2025-8194 | 3.9.24 |
| 🟠 High | ffmpeg | 4.3 | CVE-2024-7055 | 4.3.8 |
| 🟠 High | python-multipart | 0.0.6 | GHSA-59g5-xgcq-4qw3 | 0.0.18 |
| 🟠 High | python | 3.10.13 | CVE-2023-36632 | N/A |
| 🟠 High | python | 3.10.13 | CVE-2025-4330 | 3.9.23 |
| 🟠 High | python | 3.10.13 | CVE-2025-4138 | 3.9.23 |
| 🟠 High | starlette | 0.27.0 | GHSA-f96h-pmfr-66vw | 0.40.0 |
| 🟠 High | ffmpeg | 4.3 | CVE-2023-51794 | 3.4.14 |
| 🟠 High | xz | 5.4.2 | CVE-2025-31115 | 5.8.1 |
| 🟠 High | python | 3.10.13 | CVE-2023-6597 | 3.8.19 |
| 🟠 High | python | 3.10.13 | CVE-2025-4435 | 3.9.23 |
| 🟠 High | python | 3.10.13 | CVE-2024-9287 | 3.9.21 |
| 🟠 High | torch | 2.1.0 | GHSA-pg7h-5qx3-wjr3 | 2.2.0 |
| 🟠 High | ffmpeg | 4.3 | CVE-2023-51798 | 3.4.14 |

*Showing top 50 of 264 vulnerabilities (sorted by severity)*
