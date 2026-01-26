# llm-service

Container image for the **llm-service** service.

## Image Details

| Property | Value |
|----------|-------|
| **Image** | `ghcr.io/metalstormbass/mike-co/llm-service` |
| **Digest** | `sha256:b4471655eaae7ab12539b4d96227f443d5117cf2bbcab8ff0ac30411fa0003d0` |
| **Size** | 456.78 MB |
| **Scan Date** | 2026-01-26 17:04:11 UTC |
| **Scanner** | Grype |

## Vulnerability Summary

| Severity | Count |
|----------|-------|
| $\color{red}{\textsf{Critical}}$ | 2 |
| $\color{orange}{\textsf{High}}$ | 23 |
| $\color{gold}{\textsf{Medium}}$ | 40 |
| $\color{green}{\textsf{Low}}$ | 9 |
| $\color{gray}{\textsf{Negligible}}$ | 416 |
| **Total** | **491** |

## Detailed Findings

| Severity | Package | Version | Vulnerability | Fixed In |
|----------|---------|---------|---------------|----------|
| 🔴 Critical | python | 3.11.14 | CVE-2025-13836 | 3.13.11 |
| 🔴 Critical | libsqlite3-0 | 3.40.1-2+deb12u2 | CVE-2025-7458 | N/A |
| 🟠 High | aiohttp | 3.9.0 | GHSA-5h86-8mv2-jq9f | 3.9.2 |
| 🟠 High | aiohttp | 3.9.0 | GHSA-5m98-qgg9-wh84 | 3.9.4 |
| 🟠 High | dpkg | 1.21.22 | CVE-2025-6297 | N/A |
| 🟠 High | dpkg-dev | 1.21.22 | CVE-2025-6297 | N/A |
| 🟠 High | libdpkg-perl | 1.21.22 | CVE-2025-6297 | N/A |
| 🟠 High | starlette | 0.27.0 | GHSA-f96h-pmfr-66vw | 0.40.0 |
| 🟠 High | aiohttp | 3.9.0 | GHSA-6mq8-rvhq-8wgg | 3.13.3 |
| 🟠 High | libtasn1-6 | 4.19.0-2+deb12u1 | CVE-2025-13151 | N/A |
| 🟠 High | jaraco-context | 5.3.0 | GHSA-58pv-8j8x-9vj2 | 6.1.0 |
| 🟠 High | libc-bin | 2.36-9+deb12u13 | CVE-2026-0915 | N/A |
| 🟠 High | libc-dev-bin | 2.36-9+deb12u13 | CVE-2026-0915 | N/A |
| 🟠 High | libc6 | 2.36-9+deb12u13 | CVE-2026-0915 | N/A |
| 🟠 High | libc6-dev | 2.36-9+deb12u13 | CVE-2026-0915 | N/A |
| 🟠 High | libc-bin | 2.36-9+deb12u13 | CVE-2025-15281 | N/A |
| 🟠 High | libc-dev-bin | 2.36-9+deb12u13 | CVE-2025-15281 | N/A |
| 🟠 High | libc6 | 2.36-9+deb12u13 | CVE-2025-15281 | N/A |
| 🟠 High | libc6-dev | 2.36-9+deb12u13 | CVE-2025-15281 | N/A |
| 🟠 High | wheel | 0.45.1 | GHSA-8rrh-rw8j-w5fx | 0.46.2 |
| 🟠 High | wheel | 0.45.1 | GHSA-8rrh-rw8j-w5fx | 0.46.2 |
| 🟠 High | libc-bin | 2.36-9+deb12u13 | CVE-2026-0861 | N/A |
| 🟠 High | libc-dev-bin | 2.36-9+deb12u13 | CVE-2026-0861 | N/A |
| 🟠 High | libc6 | 2.36-9+deb12u13 | CVE-2026-0861 | N/A |
| 🟠 High | libc6-dev | 2.36-9+deb12u13 | CVE-2026-0861 | N/A |
| 🟡 Medium | aiohttp | 3.9.0 | GHSA-7gpw-8wmc-pm8g | 3.9.4 |
| 🟡 Medium | aiohttp | 3.9.0 | GHSA-8495-4g3g-x7pr | 3.10.11 |
| 🟡 Medium | aiohttp | 3.9.0 | GHSA-8qpw-xqxj-h4r2 | 3.9.2 |
| 🟡 Medium | python | 3.11.14 | CVE-2025-12084 | 3.13.11 |
| 🟡 Medium | starlette | 0.27.0 | GHSA-2c2j-9gv5-cj73 | 0.47.2 |
| 🟡 Medium | libsqlite3-0 | 3.40.1-2+deb12u2 | CVE-2025-7709 | N/A |
| 🟡 Medium | python | 3.11.14 | CVE-2026-0865 | 3.15.0 |
| 🟡 Medium | libncursesw6 | 6.4-4 | CVE-2023-50495 | N/A |
| 🟡 Medium | libtinfo6 | 6.4-4 | CVE-2023-50495 | N/A |
| 🟡 Medium | ncurses-base | 6.4-4 | CVE-2023-50495 | N/A |
| 🟡 Medium | ncurses-bin | 6.4-4 | CVE-2023-50495 | N/A |
| 🟡 Medium | python | 3.11.14 | CVE-2025-12781 | 3.15.0 |
| 🟡 Medium | aiohttp | 3.9.0 | GHSA-6jhg-hg63-jvvf | 3.13.3 |
| 🟡 Medium | aiohttp | 3.9.0 | GHSA-jj3x-wxrx-4x23 | 3.13.3 |
| 🟡 Medium | python | 3.11.14 | CVE-2025-15282 | 3.15.0 |
| 🟡 Medium | python | 3.11.14 | CVE-2026-0672 | 3.15.0 |
| 🟡 Medium | aiohttp | 3.9.0 | GHSA-g84x-mcqj-x9qq | 3.13.3 |
| 🟡 Medium | python | 3.11.14 | CVE-2025-15366 | 3.15.0 |
| 🟡 Medium | python | 3.11.14 | CVE-2025-15367 | 3.15.0 |
| 🟡 Medium | python | 3.11.14 | CVE-2025-11468 | 3.15.0 |
| 🟡 Medium | libpam-modules | 1.5.2-6+deb12u2 | CVE-2024-10041 | N/A |
| 🟡 Medium | libpam-modules-bin | 1.5.2-6+deb12u2 | CVE-2024-10041 | N/A |
| 🟡 Medium | libpam-runtime | 1.5.2-6+deb12u2 | CVE-2024-10041 | N/A |
| 🟡 Medium | libpam0g | 1.5.2-6+deb12u2 | CVE-2024-10041 | N/A |
| 🟡 Medium | gpgv | 2.2.40-1.1+deb12u2 | CVE-2025-30258 | N/A |

*Showing top 50 of 491 vulnerabilities (sorted by severity)*
