# opensearch

Mirrored container image for the **opensearch** service.

## Image Details

| Property | Value |
|----------|-------|
| **Source Image** | `opensearchproject/opensearch:2.11.0` |
| **GHCR Image** | `ghcr.io/metalstormbass/mike-co/opensearch` |
| **Digest** | `opensearchproject/opensearch@sha256:2f49c399988df5c9a3b25a05ec78ea75ac4b39ae76e1d2609f94a653224bb24b` |
| **Size** | 1.13 GB |
| **Scan Date** | 2026-01-26 16:14:28 UTC |
| **Scanner** | Grype |

## Vulnerability Summary

| Severity | Count |
|----------|-------|
| $\color{red}{\textsf{Critical}}$ | 1 |
| $\color{orange}{\textsf{High}}$ | 64 |
| $\color{gold}{\textsf{Medium}}$ | 151 |
| $\color{green}{\textsf{Low}}$ | 31 |
| $\color{gray}{\textsf{Negligible}}$ | 0 |
| **Total** | **247** |

## Detailed Findings

| Severity | Package | Version | Vulnerability | Fixed In |
|----------|---------|---------|---------------|----------|
| 🔴 Critical | cxf-core | 4.0.3 | GHSA-qmgx-j96g-4428 | 4.0.4 |
| 🟠 High | glibc | 2.34-52.amzn2023.0.7 | ALAS2023-2024-589 | 2.34-52.amzn2023.0.10 |
| 🟠 High | glibc-common | 2.34-52.amzn2023.0.7 | ALAS2023-2024-589 | 2.34-52.amzn2023.0.10 |
| 🟠 High | glibc-minimal-langpack | 2.34-52.amzn2023.0.7 | ALAS2023-2024-589 | 2.34-52.amzn2023.0.10 |
| 🟠 High | python3 | 3.9.16-1.amzn2023.0.6 | ALAS2023-2024-790 | 3.9.20-1.amzn2023.0.2 |
| 🟠 High | python3-libs | 3.9.16-1.amzn2023.0.6 | ALAS2023-2024-790 | 3.9.20-1.amzn2023.0.2 |
| 🟠 High | libnghttp2 | 1.57.0-1.amzn2023.0.1 | ALAS2023-2024-592 | 1.59.0-3.amzn2023.0.1 |
| 🟠 High | python3-setuptools-wheel | 59.6.0-2.amzn2023.0.4 | ALAS2023-2024-676 | 59.6.0-2.amzn2023.0.5 |
| 🟠 High | expat | 2.5.0-1.amzn2023.0.2 | ALAS2023-2024-759 | 2.6.3-1.amzn2023.0.1 |
| 🟠 High | expat | 2.5.0-1.amzn2023.0.2 | ALAS2023-2024-576 | 2.5.0-1.amzn2023.0.4 |
| 🟠 High | openjdk | 17.0.8+7 | CVE-2024-21147 | 1.8.0_422 |
| 🟠 High | cxf-core | 4.0.3 | GHSA-fh5r-crhr-qrrq | 4.0.6 |
| 🟠 High | json | 20230227 | GHSA-4jq9-2xhw-jpx7 | 20231013 |
| 🟠 High | json | 20230227 | GHSA-4jq9-2xhw-jpx7 | 20231013 |
| 🟠 High | json | 20230227 | GHSA-4jq9-2xhw-jpx7 | 20231013 |
| 🟠 High | json | 20230227 | GHSA-4jq9-2xhw-jpx7 | 20231013 |
| 🟠 High | json | 20230227 | GHSA-4jq9-2xhw-jpx7 | 20231013 |
| 🟠 High | libxml2 | 2.10.4-1.amzn2023.0.6 | ALAS2023-2025-1019 | 2.10.4-1.amzn2023.0.11 |
| 🟠 High | ion-java | 1.0.2 | GHSA-264p-99wq-f4j6 | N/A |
| 🟠 High | glib2 | 2.74.7-689.amzn2023.0.2 | ALAS2023-2025-1349 | 2.82.2-769.amzn2023 |
| 🟠 High | netty-handler | 4.1.100.Final | GHSA-4g8c-wm8x-jfhw | 4.1.118.Final |
| 🟠 High | netty-handler | 4.1.100.Final | GHSA-4g8c-wm8x-jfhw | 4.1.118.Final |
| 🟠 High | netty-handler | 4.1.100.Final | GHSA-4g8c-wm8x-jfhw | 4.1.118.Final |
| 🟠 High | netty-handler | 4.1.100.Final | GHSA-4g8c-wm8x-jfhw | 4.1.118.Final |
| 🟠 High | openjdk | 17.0.8+7 | CVE-2024-20952 | 1.8.0_402 |
| 🟠 High | libxml2 | 2.10.4-1.amzn2023.0.6 | ALAS2023-2025-1103 | 2.10.4-1.amzn2023.0.12 |
| 🟠 High | openjdk | 17.0.8+7 | CVE-2024-20918 | 1.8.0_402 |
| 🟠 High | openjdk | 17.0.8+7 | CVE-2025-30749 | 1.8.0_462 |
| 🟠 High | openjdk | 17.0.8+7 | CVE-2025-50106 | 1.8.0_462 |
| 🟠 High | commons-io | 2.11.0 | GHSA-78wr-2p64-hpwj | 2.14.0 |
| 🟠 High | commons-io | 2.13.0 | GHSA-78wr-2p64-hpwj | 2.14.0 |
| 🟠 High | commons-io | 2.7 | GHSA-78wr-2p64-hpwj | 2.14.0 |
| 🟠 High | commons-io | 2.8.0 | GHSA-78wr-2p64-hpwj | 2.14.0 |
| 🟠 High | expat | 2.5.0-1.amzn2023.0.2 | ALAS2023-2025-1196 | 2.6.3-1.amzn2023.0.3 |
| 🟠 High | python3-setuptools-wheel | 59.6.0-2.amzn2023.0.4 | ALAS2023-2025-1005 | 59.6.0-2.amzn2023.0.6 |
| 🟠 High | python3 | 3.9.16-1.amzn2023.0.6 | ALAS2023-2025-1146 | 3.9.23-1.amzn2023.0.3 |
| 🟠 High | python3-libs | 3.9.16-1.amzn2023.0.6 | ALAS2023-2025-1146 | 3.9.23-1.amzn2023.0.3 |
| 🟠 High | openjdk | 17.0.8+7 | CVE-2025-21587 | 1.8.0_452 |
| 🟠 High | sqlite-libs | 3.40.0-1.amzn2023.0.3 | ALAS2023-2024-490 | 3.40.0-1.amzn2023.0.4 |
| 🟠 High | openjdk | 17.0.8+7 | CVE-2024-20932 | 17.0.10 |
| 🟠 High | sqlite-libs | 3.40.0-1.amzn2023.0.3 | ALAS2023-2025-971 | 3.40.0-1.amzn2023.0.5 |
| 🟠 High | netty-codec-http2 | 4.1.100.Final | GHSA-prj3-ccx8-p6x4 | 4.1.124.Final |
| 🟠 High | netty-codec-http2 | 4.1.100.Final | GHSA-prj3-ccx8-p6x4 | 4.1.124.Final |
| 🟠 High | glib2 | 2.74.7-689.amzn2023.0.2 | ALAS2023-2025-1069 | 2.82.2-766.amzn2023 |
| 🟠 High | python3 | 3.9.16-1.amzn2023.0.6 | ALAS2023-2025-1046 | 3.9.23-1.amzn2023.0.1 |
| 🟠 High | python3-libs | 3.9.16-1.amzn2023.0.6 | ALAS2023-2025-1046 | 3.9.23-1.amzn2023.0.1 |
| 🟠 High | openjdk | 17.0.8+7 | CVE-2025-53066 | 1.8.0_472 |
| 🟠 High | libarchive | 3.5.3-2.amzn2023.0.3 | ALAS2023-2024-742 | 3.7.4-2.amzn2023.0.2 |
| 🟠 High | commons-beanutils | 1.9.4 | GHSA-wxr5-93ph-8wr9 | 1.11.0 |
| 🟠 High | commons-beanutils | 1.9.4 | GHSA-wxr5-93ph-8wr9 | 1.11.0 |

*Showing top 50 of 247 vulnerabilities (sorted by severity)*
