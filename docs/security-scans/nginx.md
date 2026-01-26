# nginx

Container image for the **nginx** service.

## Image Details

| Property | Value |
|----------|-------|
| **Image** | `ghcr.io/metalstormbass/mike-co/nginx` |
| **Digest** | `sha256:98a5e5e17ab866f8dda5428f722263595b3c45c9d64c0f1c30d3cd62301e9077` |
| **Size** | 199.60 MB |
| **Scan Date** | 2026-01-26 17:37:27 UTC |
| **Scanner** | Grype |

## Vulnerability Summary

| Severity | Count |
|----------|-------|
| $\color{red}{\textsf{Critical}}$ | 1 |
| $\color{orange}{\textsf{High}}$ | 16 |
| $\color{gold}{\textsf{Medium}}$ | 34 |
| $\color{green}{\textsf{Low}}$ | 10 |
| $\color{gray}{\textsf{Negligible}}$ | 98 |
| **Total** | **160** |

## Detailed Findings

| Severity | Package | Version | Vulnerability | Fixed In |
|----------|---------|---------|---------------|----------|
| 🔴 Critical | libaom3 | 3.6.0-1+deb12u2 | CVE-2023-6879 | N/A |
| 🟠 High | nginx | 1.29.1-1~bookworm | CVE-2023-44487 | N/A |
| 🟠 High | libldap-2.5-0 | 2.5.13+dfsg-5 | CVE-2023-2953 | N/A |
| 🟠 High | libtiff6 | 4.5.0-6+deb12u3 | CVE-2023-52355 | N/A |
| 🟠 High | libexpat1 | 2.5.0-1+deb12u2 | CVE-2025-59375 | N/A |
| 🟠 High | dpkg | 1.21.22 | CVE-2025-6297 | N/A |
| 🟠 High | libaom3 | 3.6.0-1+deb12u2 | CVE-2023-39616 | N/A |
| 🟠 High | libtasn1-6 | 4.19.0-2+deb12u1 | CVE-2025-13151 | N/A |
| 🟠 High | libc-bin | 2.36-9+deb12u13 | CVE-2026-0915 | N/A |
| 🟠 High | libc6 | 2.36-9+deb12u13 | CVE-2026-0915 | N/A |
| 🟠 High | libc-bin | 2.36-9+deb12u13 | CVE-2025-15281 | N/A |
| 🟠 High | libc6 | 2.36-9+deb12u13 | CVE-2025-15281 | N/A |
| 🟠 High | libxslt1.1 | 1.1.35-1+deb12u3 | CVE-2025-7425 | N/A |
| 🟠 High | libpng16-16 | 1.6.39-2+deb12u1 | CVE-2026-22695 | N/A |
| 🟠 High | libc-bin | 2.36-9+deb12u13 | CVE-2026-0861 | N/A |
| 🟠 High | libc6 | 2.36-9+deb12u13 | CVE-2026-0861 | N/A |
| 🟠 High | libpng16-16 | 1.6.39-2+deb12u1 | CVE-2026-22801 | N/A |
| 🟡 Medium | libtiff6 | 4.5.0-6+deb12u3 | CVE-2023-6277 | N/A |
| 🟡 Medium | libde265-0 | 1.0.11-1+deb12u2 | CVE-2024-38950 | N/A |
| 🟡 Medium | libxml2 | 2.9.14+dfsg-1.3~deb12u5 | CVE-2026-0990 | N/A |
| 🟡 Medium | libde265-0 | 1.0.11-1+deb12u2 | CVE-2024-38949 | N/A |
| 🟡 Medium | curl | 7.88.1-10+deb12u14 | CVE-2025-10148 | N/A |
| 🟡 Medium | libcurl4 | 7.88.1-10+deb12u14 | CVE-2025-10148 | N/A |
| 🟡 Medium | libdav1d6 | 1.0.0-2+deb12u1 | CVE-2023-32570 | N/A |
| 🟡 Medium | libtinfo6 | 6.4-4 | CVE-2023-50495 | N/A |
| 🟡 Medium | ncurses-base | 6.4-4 | CVE-2023-50495 | N/A |
| 🟡 Medium | ncurses-bin | 6.4-4 | CVE-2023-50495 | N/A |
| 🟡 Medium | libheif1 | 1.15.1-1+deb12u1 | CVE-2025-68431 | N/A |
| 🟡 Medium | curl | 7.88.1-10+deb12u14 | CVE-2025-14819 | N/A |
| 🟡 Medium | libcurl4 | 7.88.1-10+deb12u14 | CVE-2025-14819 | N/A |
| 🟡 Medium | libpam-modules | 1.5.2-6+deb12u2 | CVE-2024-10041 | N/A |
| 🟡 Medium | libpam-modules-bin | 1.5.2-6+deb12u2 | CVE-2024-10041 | N/A |
| 🟡 Medium | libpam-runtime | 1.5.2-6+deb12u2 | CVE-2024-10041 | N/A |
| 🟡 Medium | libpam0g | 1.5.2-6+deb12u2 | CVE-2024-10041 | N/A |
| 🟡 Medium | gpgv | 2.2.40-1.1+deb12u2 | CVE-2025-30258 | N/A |
| 🟡 Medium | libxslt1.1 | 1.1.35-1+deb12u3 | CVE-2025-10911 | N/A |
| 🟡 Medium | curl | 7.88.1-10+deb12u14 | CVE-2025-14524 | N/A |
| 🟡 Medium | libcurl4 | 7.88.1-10+deb12u14 | CVE-2025-14524 | N/A |
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
| 🟡 Medium | libexpat1 | 2.5.0-1+deb12u2 | CVE-2025-66382 | N/A |

*Showing top 50 of 160 vulnerabilities (sorted by severity)*
