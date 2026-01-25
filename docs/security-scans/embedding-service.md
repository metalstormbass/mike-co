# embedding-service

Container image for the **embedding-service** service.

## Image Details

| Property | Value |
|----------|-------|
| **Image** | `ghcr.io/metalstormbass/mike-co/embedding-service` |
| **Digest** | `sha256:4d6895f1d39ba657425ed425774ca28ee9aff6cd89643101128afac2efaf4799` |
| **Scan Date** | 2026-01-25 21:08:42 UTC |
| **Scanner** | Grype |

## Vulnerability Summary

| Severity | Count |
|----------|-------|
| $\color{red}{\textsf{Critical}}$ | 4 |
| $\color{orange}{\textsf{High}}$ | 28 |
| $\color{gold}{\textsf{Medium}}$ | 45 |
| $\color{green}{\textsf{Low}}$ | 7 |
| $\color{gray}{\textsf{Negligible}}$ | 416 |
| **Total** | **501** |

## Detailed Findings

| Severity | Package | Version | Vulnerability | Fixed In |
|----------|---------|---------|---------------|----------|
| 🔴 Critical | torch | 2.1.0 | GHSA-53q9-r3pm-6pq6 | 2.6.0 |
| 🔴 Critical | transformers | 4.35.0 | GHSA-3863-2447-669p | 4.36.0 |
| 🔴 Critical | python | 3.11.14 | CVE-2025-13836 | 3.13.11 |
| 🔴 Critical | libsqlite3-0 | 3.40.1-2+deb12u2 | CVE-2025-7458 | N/A |
| 🟠 High | transformers | 4.35.0 | GHSA-wrfc-pvp9-mr9g | 4.48.0 |
| 🟠 High | transformers | 4.35.0 | GHSA-hxxf-235m-72v3 | 4.48.0 |
| 🟠 High | transformers | 4.35.0 | GHSA-qxrp-vhvm-j765 | 4.48.0 |
| 🟠 High | python-multipart | 0.0.6 | GHSA-2jv5-9r88-3w3p | 0.0.7 |
| 🟠 High | transformers | 4.35.0 | GHSA-v68g-wm8c-6x7j | 4.36.0 |
| 🟠 High | python-multipart | 0.0.6 | GHSA-59g5-xgcq-4qw3 | 0.0.18 |
| 🟠 High | dpkg | 1.21.22 | CVE-2025-6297 | N/A |
| 🟠 High | dpkg-dev | 1.21.22 | CVE-2025-6297 | N/A |
| 🟠 High | libdpkg-perl | 1.21.22 | CVE-2025-6297 | N/A |
| 🟠 High | starlette | 0.27.0 | GHSA-f96h-pmfr-66vw | 0.40.0 |
| 🟠 High | libtasn1-6 | 4.19.0-2+deb12u1 | CVE-2025-13151 | N/A |
| 🟠 High | torch | 2.1.0 | GHSA-pg7h-5qx3-wjr3 | 2.2.0 |
| 🟠 High | jaraco-context | 5.3.0 | GHSA-58pv-8j8x-9vj2 | 6.1.0 |
| 🟠 High | libc-bin | 2.36-9+deb12u13 | CVE-2026-0915 | N/A |
| 🟠 High | libc-dev-bin | 2.36-9+deb12u13 | CVE-2026-0915 | N/A |
| 🟠 High | libc6 | 2.36-9+deb12u13 | CVE-2026-0915 | N/A |
| 🟠 High | libc6-dev | 2.36-9+deb12u13 | CVE-2026-0915 | N/A |
| 🟠 High | libc-bin | 2.36-9+deb12u13 | CVE-2025-15281 | N/A |
| 🟠 High | libc-dev-bin | 2.36-9+deb12u13 | CVE-2025-15281 | N/A |
| 🟠 High | libc6 | 2.36-9+deb12u13 | CVE-2025-15281 | N/A |
| 🟠 High | libc6-dev | 2.36-9+deb12u13 | CVE-2025-15281 | N/A |
| 🟠 High | torch | 2.1.0 | GHSA-5pcm-hx3q-hm94 | 2.2.0 |
| 🟠 High | wheel | 0.45.1 | GHSA-8rrh-rw8j-w5fx | 0.46.2 |
| 🟠 High | wheel | 0.45.1 | GHSA-8rrh-rw8j-w5fx | 0.46.2 |
| 🟠 High | libc-bin | 2.36-9+deb12u13 | CVE-2026-0861 | N/A |
| 🟠 High | libc-dev-bin | 2.36-9+deb12u13 | CVE-2026-0861 | N/A |
| 🟠 High | libc6 | 2.36-9+deb12u13 | CVE-2026-0861 | N/A |
| 🟠 High | libc6-dev | 2.36-9+deb12u13 | CVE-2026-0861 | N/A |
| 🟡 Medium | transformers | 4.35.0 | GHSA-4w7r-h757-3r74 | 4.53.0 |
| 🟡 Medium | transformers | 4.35.0 | GHSA-59p9-h35m-wg4g | 4.53.0 |
| 🟡 Medium | transformers | 4.35.0 | GHSA-rcv9-qm8p-9p6j | 4.53.0 |
| 🟡 Medium | transformers | 4.35.0 | GHSA-6rvg-6v2m-4j46 | 4.48.0 |
| 🟡 Medium | transformers | 4.35.0 | GHSA-qq3j-4f4f-9583 | 4.50.0 |
| 🟡 Medium | python | 3.11.14 | CVE-2025-12084 | 3.13.11 |
| 🟡 Medium | transformers | 4.35.0 | GHSA-9356-575x-2w9m | 4.53.0 |
| 🟡 Medium | transformers | 4.35.0 | GHSA-jjph-296x-mrcr | 4.51.0 |
| 🟡 Medium | transformers | 4.35.0 | GHSA-q2wp-rjmx-x6x9 | 4.51.0 |
| 🟡 Medium | transformers | 4.35.0 | GHSA-37mw-44qp-f5jm | 4.52.1 |
| 🟡 Medium | starlette | 0.27.0 | GHSA-2c2j-9gv5-cj73 | 0.47.2 |
| 🟡 Medium | libsqlite3-0 | 3.40.1-2+deb12u2 | CVE-2025-7709 | N/A |
| 🟡 Medium | transformers | 4.35.0 | GHSA-fpwr-67px-3qhx | 4.50.0 |
| 🟡 Medium | python | 3.11.14 | CVE-2026-0865 | 3.15.0 |
| 🟡 Medium | libncursesw6 | 6.4-4 | CVE-2023-50495 | N/A |
| 🟡 Medium | libtinfo6 | 6.4-4 | CVE-2023-50495 | N/A |
| 🟡 Medium | ncurses-base | 6.4-4 | CVE-2023-50495 | N/A |
| 🟡 Medium | ncurses-bin | 6.4-4 | CVE-2023-50495 | N/A |

*Showing top 50 of 501 vulnerabilities (sorted by severity)*
