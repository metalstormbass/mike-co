# api-gateway

Container image for the **api-gateway** service.

## Image Details

| Property | Value |
|----------|-------|
| **Image** | `ghcr.io/metalstormbass/mike-co/api-gateway` |
| **Digest** | `sha256:0a3267a2c99240b3b643b28199613d93b7489fd3c4d5572872b4bfc0fcfb99ac` |
| **Size** | 909.56 MB |
| **Scan Date** | 2026-01-26 16:53:26 UTC |
| **Scanner** | Grype |

## Vulnerability Summary

| Severity | Count |
|----------|-------|
| $\color{red}{\textsf{Critical}}$ | 12 |
| $\color{orange}{\textsf{High}}$ | 91 |
| $\color{gold}{\textsf{Medium}}$ | 162 |
| $\color{green}{\textsf{Low}}$ | 75 |
| $\color{gray}{\textsf{Negligible}}$ | 1139 |
| **Total** | **1480** |

## Detailed Findings

| Severity | Package | Version | Vulnerability | Fixed In |
|----------|---------|---------|---------------|----------|
| 🔴 Critical | zlib1g-dev | 1:1.2.13.dfsg-1 | CVE-2023-45853 | N/A |
| 🔴 Critical | libopenexr-3-1-30 | 3.1.5-5 | CVE-2023-5841 | N/A |
| 🔴 Critical | libopenexr-dev | 3.1.5-5 | CVE-2023-5841 | N/A |
| 🔴 Critical | libaom-dev | 3.6.0-1+deb12u2 | CVE-2023-6879 | N/A |
| 🔴 Critical | libaom3 | 3.6.0-1+deb12u2 | CVE-2023-6879 | N/A |
| 🔴 Critical | libpython3.11-minimal | 3.11.2-6+deb12u6 | CVE-2025-13836 | N/A |
| 🔴 Critical | libpython3.11-stdlib | 3.11.2-6+deb12u6 | CVE-2025-13836 | N/A |
| 🔴 Critical | python3.11 | 3.11.2-6+deb12u6 | CVE-2025-13836 | N/A |
| 🔴 Critical | python3.11-minimal | 3.11.2-6+deb12u6 | CVE-2025-13836 | N/A |
| 🔴 Critical | libsqlite3-0 | 3.40.1-2+deb12u2 | CVE-2025-7458 | N/A |
| 🔴 Critical | libmatio-dev | 1.5.23-2 | CVE-2025-50343 | N/A |
| 🔴 Critical | libmatio11 | 1.5.23-2 | CVE-2025-50343 | N/A |
| 🟠 High | git | 1:2.39.5-0+deb12u3 | CVE-2025-48384 | N/A |
| 🟠 High | git-man | 1:2.39.5-0+deb12u3 | CVE-2025-48384 | N/A |
| 🟠 High | libldap-2.5-0 | 2.5.13+dfsg-5 | CVE-2023-2953 | N/A |
| 🟠 High | hdf5-helpers | 1.10.8+repack1-1 | CVE-2018-11205 | N/A |
| 🟠 High | libhdf5-103-1 | 1.10.8+repack1-1 | CVE-2018-11205 | N/A |
| 🟠 High | libhdf5-cpp-103-1 | 1.10.8+repack1-1 | CVE-2018-11205 | N/A |
| 🟠 High | libhdf5-dev | 1.10.8+repack1-1 | CVE-2018-11205 | N/A |
| 🟠 High | libhdf5-fortran-102 | 1.10.8+repack1-1 | CVE-2018-11205 | N/A |
| 🟠 High | libhdf5-hl-100 | 1.10.8+repack1-1 | CVE-2018-11205 | N/A |
| 🟠 High | libhdf5-hl-cpp-100 | 1.10.8+repack1-1 | CVE-2018-11205 | N/A |
| 🟠 High | libhdf5-hl-fortran-100 | 1.10.8+repack1-1 | CVE-2018-11205 | N/A |
| 🟠 High | libmatio-dev | 1.5.23-2 | CVE-2025-2337 | N/A |
| 🟠 High | libmatio11 | 1.5.23-2 | CVE-2025-2337 | N/A |
| 🟠 High | libtiff-dev | 4.5.0-6+deb12u3 | CVE-2023-52355 | N/A |
| 🟠 High | libtiff6 | 4.5.0-6+deb12u3 | CVE-2023-52355 | N/A |
| 🟠 High | libtiffxx6 | 4.5.0-6+deb12u3 | CVE-2023-52355 | N/A |
| 🟠 High | p7zip | 16.02+dfsg-8 | CVE-2025-11001 | N/A |
| 🟠 High | p7zip-full | 16.02+dfsg-8 | CVE-2025-11001 | N/A |
| 🟠 High | p7zip | 16.02+dfsg-8 | CVE-2025-11002 | N/A |
| 🟠 High | p7zip-full | 16.02+dfsg-8 | CVE-2025-11002 | N/A |
| 🟠 High | libmatio-dev | 1.5.23-2 | CVE-2025-2338 | N/A |
| 🟠 High | libmatio11 | 1.5.23-2 | CVE-2025-2338 | N/A |
| 🟠 High | libexpat1 | 2.5.0-1+deb12u2 | CVE-2025-59375 | N/A |
| 🟠 High | libexpat1-dev | 2.5.0-1+deb12u2 | CVE-2025-59375 | N/A |
| 🟠 High | libpython3.11-minimal | 3.11.2-6+deb12u6 | CVE-2025-8194 | N/A |
| 🟠 High | libpython3.11-stdlib | 3.11.2-6+deb12u6 | CVE-2025-8194 | N/A |
| 🟠 High | python3.11 | 3.11.2-6+deb12u6 | CVE-2025-8194 | N/A |
| 🟠 High | python3.11-minimal | 3.11.2-6+deb12u6 | CVE-2025-8194 | N/A |
| 🟠 High | dpkg | 1.21.22 | CVE-2025-6297 | N/A |
| 🟠 High | p7zip | 16.02+dfsg-8 | CVE-2023-52168 | N/A |
| 🟠 High | p7zip-full | 16.02+dfsg-8 | CVE-2023-52168 | N/A |
| 🟠 High | multer | 1.4.5-lts.2 | GHSA-g5hg-p3ph-g8qg | 2.0.1 |
| 🟠 High | libaom-dev | 3.6.0-1+deb12u2 | CVE-2023-39616 | N/A |
| 🟠 High | libaom3 | 3.6.0-1+deb12u2 | CVE-2023-39616 | N/A |
| 🟠 High | cross-spawn | 7.0.3 | GHSA-3xgq-45jj-v275 | 7.0.5 |
| 🟠 High | gir1.2-harfbuzz-0.0 | 6.0.0+dfsg-3 | CVE-2023-25193 | N/A |
| 🟠 High | libharfbuzz-dev | 6.0.0+dfsg-3 | CVE-2023-25193 | N/A |
| 🟠 High | libharfbuzz-gobject0 | 6.0.0+dfsg-3 | CVE-2023-25193 | N/A |

*Showing top 50 of 1480 vulnerabilities (sorted by severity)*
