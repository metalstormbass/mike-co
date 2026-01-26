# llm-service

Container image for the **llm-service** service.

## Image Details

| Property | Value |
|----------|-------|
| **Image** | `ghcr.io/metalstormbass/mike-co/llm-service` |
| **Digest** | `sha256:65b525c13dcbdbf9d84f641b8027eb20015bc39c76b6c1b6efd09fc6817aac12` |
| **Size** | 688.55 MB |
| **Scan Date** | 2026-01-26 21:54:30 UTC |
| **Scanner** | Grype |

## Vulnerability Summary

| Severity | Count |
|----------|-------|
| $\color{red}{\textsf{Critical}}$ | 1 |
| $\color{orange}{\textsf{High}}$ | 6 |
| $\color{gold}{\textsf{Medium}}$ | 17 |
| $\color{green}{\textsf{Low}}$ | 7 |
| $\color{gray}{\textsf{Negligible}}$ | 0 |
| **Total** | **31** |

## Detailed Findings

| Severity | Package | Version | Vulnerability | Fixed In |
|----------|---------|---------|---------------|----------|
| 🔴 Critical | python-3.11 | 3.11.14-r3 | CVE-2025-13836 | N/A |
| 🟠 High | aiohttp | 3.9.0 | GHSA-5h86-8mv2-jq9f | 3.9.2 |
| 🟠 High | aiohttp | 3.9.0 | GHSA-5m98-qgg9-wh84 | 3.9.4 |
| 🟠 High | starlette | 0.27.0 | GHSA-f96h-pmfr-66vw | 0.40.0 |
| 🟠 High | aiohttp | 3.9.0 | GHSA-6mq8-rvhq-8wgg | 3.13.3 |
| 🟠 High | glibc | 2.42-r6 | CVE-2025-15281 | N/A |
| 🟠 High | wheel | 0.45.1 | GHSA-8rrh-rw8j-w5fx | 0.46.2 |
| 🟡 Medium | aiohttp | 3.9.0 | GHSA-7gpw-8wmc-pm8g | 3.9.4 |
| 🟡 Medium | aiohttp | 3.9.0 | GHSA-8495-4g3g-x7pr | 3.10.11 |
| 🟡 Medium | aiohttp | 3.9.0 | GHSA-8qpw-xqxj-h4r2 | 3.9.2 |
| 🟡 Medium | python-3.11 | 3.11.14-r3 | CVE-2025-12084 | N/A |
| 🟡 Medium | starlette | 0.27.0 | GHSA-2c2j-9gv5-cj73 | 0.47.2 |
| 🟡 Medium | python-3.11 | 3.11.14-r3 | CVE-2026-0865 | N/A |
| 🟡 Medium | busybox | 1.37.0-r51 | CVE-2025-60876 | N/A |
| 🟡 Medium | python-3.11 | 3.11.14-r3 | CVE-2025-12781 | N/A |
| 🟡 Medium | aiohttp | 3.9.0 | GHSA-6jhg-hg63-jvvf | 3.13.3 |
| 🟡 Medium | aiohttp | 3.9.0 | GHSA-jj3x-wxrx-4x23 | 3.13.3 |
| 🟡 Medium | python-3.11 | 3.11.14-r3 | CVE-2025-15282 | N/A |
| 🟡 Medium | python-3.11 | 3.11.14-r3 | CVE-2026-0672 | N/A |
| 🟡 Medium | aiohttp | 3.9.0 | GHSA-g84x-mcqj-x9qq | 3.13.3 |
| 🟡 Medium | python-3.11 | 3.11.14-r3 | CVE-2025-15366 | N/A |
| 🟡 Medium | python-3.11 | 3.11.14-r3 | CVE-2025-15367 | N/A |
| 🟡 Medium | python-3.11 | 3.11.14-r3 | CVE-2025-11468 | N/A |
| 🟡 Medium | python-3.11 | 3.11.14-r3 | CVE-2025-13837 | N/A |
| 🟢 Low | aiohttp | 3.9.0 | GHSA-54jq-c3m8-4m76 | 3.13.3 |
| 🟢 Low | rsa | 0.9.9 | GHSA-9c48-w39g-hm26 | 0.9.10 |
| 🟢 Low | rsa | 0.9.9 | GHSA-9c48-w39g-hm26 | 0.9.10 |
| 🟢 Low | aiohttp | 3.9.0 | GHSA-9548-qrrj-x5pj | 3.12.14 |
| 🟢 Low | aiohttp | 3.9.0 | GHSA-mqqc-3gqh-h2x8 | 3.13.3 |
| 🟢 Low | aiohttp | 3.9.0 | GHSA-69f9-5gxw-wvc2 | 3.13.3 |
| 🟢 Low | aiohttp | 3.9.0 | GHSA-fh55-r93g-j68g | 3.13.3 |
