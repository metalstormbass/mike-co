# api-gateway

Container image for the **api-gateway** service.

## Image Details

| Property | Value |
|----------|-------|
| **Image** | `ghcr.io/metalstormbass/mike-co/api-gateway` |
| **Digest** | `sha256:d2274bdc03e7d52d1f8c58fed5b4eadee8faa03771fe0479156562091d6f0bad` |
| **Size** | 291.84 MB |
| **Scan Date** | 2026-01-26 15:43:00 UTC |
| **Scanner** | Grype |

## Vulnerability Summary

| Severity | Count |
|----------|-------|
| $\color{red}{\textsf{Critical}}$ | 0 |
| $\color{orange}{\textsf{High}}$ | 16 |
| $\color{gold}{\textsf{Medium}}$ | 20 |
| $\color{green}{\textsf{Low}}$ | 5 |
| $\color{gray}{\textsf{Negligible}}$ | 46 |
| **Total** | **88** |

## Detailed Findings

| Severity | Package | Version | Vulnerability | Fixed In |
|----------|---------|---------|---------------|----------|
| 🟠 High | dpkg | 1.21.22 | CVE-2025-6297 | N/A |
| 🟠 High | multer | 1.4.5-lts.2 | GHSA-g5hg-p3ph-g8qg | 2.0.1 |
| 🟠 High | cross-spawn | 7.0.3 | GHSA-3xgq-45jj-v275 | 7.0.5 |
| 🟠 High | libtasn1-6 | 4.19.0-2+deb12u1 | CVE-2025-13151 | N/A |
| 🟠 High | multer | 1.4.5-lts.2 | GHSA-44fp-w29j-9vj5 | 2.0.0 |
| 🟠 High | libc-bin | 2.36-9+deb12u13 | CVE-2026-0915 | N/A |
| 🟠 High | libc6 | 2.36-9+deb12u13 | CVE-2026-0915 | N/A |
| 🟠 High | libc-bin | 2.36-9+deb12u13 | CVE-2025-15281 | N/A |
| 🟠 High | libc6 | 2.36-9+deb12u13 | CVE-2025-15281 | N/A |
| 🟠 High | glob | 10.4.2 | GHSA-5j98-mcp5-4vw2 | 10.5.0 |
| 🟠 High | libc-bin | 2.36-9+deb12u13 | CVE-2026-0861 | N/A |
| 🟠 High | libc6 | 2.36-9+deb12u13 | CVE-2026-0861 | N/A |
| 🟠 High | tar | 6.2.1 | GHSA-r6q2-hw4h-h46w | 7.5.4 |
| 🟠 High | multer | 1.4.5-lts.2 | GHSA-4pg4-qvpc-4q3h | 2.0.0 |
| 🟠 High | multer | 1.4.5-lts.2 | GHSA-fjgf-rc76-4x9p | 2.0.2 |
| 🟠 High | tar | 6.2.1 | GHSA-8qq5-rm4j-mr97 | 7.5.3 |
| 🟡 Medium | libtinfo6 | 6.4-4 | CVE-2023-50495 | N/A |
| 🟡 Medium | ncurses-base | 6.4-4 | CVE-2023-50495 | N/A |
| 🟡 Medium | ncurses-bin | 6.4-4 | CVE-2023-50495 | N/A |
| 🟡 Medium | libpam-modules | 1.5.2-6+deb12u2 | CVE-2024-10041 | N/A |
| 🟡 Medium | libpam-modules-bin | 1.5.2-6+deb12u2 | CVE-2024-10041 | N/A |
| 🟡 Medium | libpam-runtime | 1.5.2-6+deb12u2 | CVE-2024-10041 | N/A |
| 🟡 Medium | libpam0g | 1.5.2-6+deb12u2 | CVE-2024-10041 | N/A |
| 🟡 Medium | gpgv | 2.2.40-1.1+deb12u2 | CVE-2025-30258 | N/A |
| 🟡 Medium | bsdutils | 1:2.38.1-5+deb12u3 | CVE-2025-14104 | N/A |
| 🟡 Medium | libblkid1 | 2.38.1-5+deb12u3 | CVE-2025-14104 | N/A |
| 🟡 Medium | libmount1 | 2.38.1-5+deb12u3 | CVE-2025-14104 | N/A |
| 🟡 Medium | libsmartcols1 | 2.38.1-5+deb12u3 | CVE-2025-14104 | N/A |
| 🟡 Medium | libuuid1 | 2.38.1-5+deb12u3 | CVE-2025-14104 | N/A |
| 🟡 Medium | mount | 2.38.1-5+deb12u3 | CVE-2025-14104 | N/A |
| 🟡 Medium | util-linux | 2.38.1-5+deb12u3 | CVE-2025-14104 | N/A |
| 🟡 Medium | util-linux-extra | 2.38.1-5+deb12u3 | CVE-2025-14104 | N/A |
| 🟡 Medium | libtinfo6 | 6.4-4 | CVE-2025-6141 | N/A |
| 🟡 Medium | ncurses-base | 6.4-4 | CVE-2025-6141 | N/A |
| 🟡 Medium | ncurses-bin | 6.4-4 | CVE-2025-6141 | N/A |
| 🟡 Medium | gpgv | 2.2.40-1.1+deb12u2 | CVE-2025-68972 | N/A |
| 🟢 Low | login | 1:4.13+dfsg1-1+deb12u2 | CVE-2024-56433 | N/A |
| 🟢 Low | passwd | 1:4.13+dfsg1-1+deb12u2 | CVE-2024-56433 | N/A |
| 🟢 Low | coreutils | 9.1-1 | CVE-2016-2781 | N/A |
| 🟢 Low | diff | 5.2.0 | GHSA-73rr-hh4g-fpgx | 5.2.2 |
| 🟢 Low | brace-expansion | 2.0.1 | GHSA-v6h2-p8h4-qcjw | 2.0.2 |
| ⚪ Negligible | libgnutls30 | 3.7.9-2+deb12u5 | CVE-2011-3389 | N/A |
| ⚪ Negligible | tar | 1.34+dfsg-1.2+deb12u1 | CVE-2005-2541 | N/A |
| ⚪ Negligible | apt | 2.6.1 | CVE-2011-3374 | N/A |
| ⚪ Negligible | libapt-pkg6.0 | 2.6.1 | CVE-2011-3374 | N/A |
| ⚪ Negligible | libc-bin | 2.36-9+deb12u13 | CVE-2018-20796 | N/A |
| ⚪ Negligible | libc6 | 2.36-9+deb12u13 | CVE-2018-20796 | N/A |
| ⚪ Negligible | libc-bin | 2.36-9+deb12u13 | CVE-2019-1010025 | N/A |
| ⚪ Negligible | libc6 | 2.36-9+deb12u13 | CVE-2019-1010025 | N/A |
| ⚪ Negligible | libc-bin | 2.36-9+deb12u13 | CVE-2019-9192 | N/A |

*Showing top 50 of 88 vulnerabilities (sorted by severity)*
