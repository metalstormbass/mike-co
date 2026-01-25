# postgresql

Mirrored container image for the **postgresql** service.

## Image Details

| Property | Value |
|----------|-------|
| **Source Image** | `postgres:16-bookworm` |
| **GHCR Image** | `ghcr.io/metalstormbass/mike-co/postgresql` |
| **Digest** | `postgres@sha256:bb6a38138cb49ca6d4de376e06f0959db4e7906c0f5f3cfedb2cfe27d7472a0f` |
| **Scan Date** | 2026-01-25 20:52:00 UTC |
| **Scanner** | Grype |

## Vulnerability Summary

| Severity | Count |
|----------|-------|
| $\color{red}{\textsf{Critical}}$ | 1 |
| $\color{orange}{\textsf{High}}$ | 21 |
| $\color{gold}{\textsf{Medium}}$ | 52 |
| $\color{green}{\textsf{Low}}$ | 7 |
| $\color{gray}{\textsf{Negligible}}$ | 99 |
| **Total** | **181** |

## Detailed Findings

| Severity | Package | Version | Vulnerability | Fixed In |
|----------|---------|---------|---------------|----------|
| 🔴 Critical | libsqlite3-0 | 3.40.1-2+deb12u2 | CVE-2025-7458 | N/A |
| 🟠 High | libldap-2.5-0 | 2.5.13+dfsg-5 | CVE-2023-2953 | N/A |
| 🟠 High | dpkg | 1.21.22 | CVE-2025-6297 | N/A |
| 🟠 High | libtasn1-6 | 4.19.0-2+deb12u1 | CVE-2025-13151 | N/A |
| 🟠 High | libc-bin | 2.36-9+deb12u13 | CVE-2026-0915 | N/A |
| 🟠 High | libc-l10n | 2.36-9+deb12u13 | CVE-2026-0915 | N/A |
| 🟠 High | libc6 | 2.36-9+deb12u13 | CVE-2026-0915 | N/A |
| 🟠 High | locales | 2.36-9+deb12u13 | CVE-2026-0915 | N/A |
| 🟠 High | libc-bin | 2.36-9+deb12u13 | CVE-2025-15281 | N/A |
| 🟠 High | libc-l10n | 2.36-9+deb12u13 | CVE-2025-15281 | N/A |
| 🟠 High | libc6 | 2.36-9+deb12u13 | CVE-2025-15281 | N/A |
| 🟠 High | locales | 2.36-9+deb12u13 | CVE-2025-15281 | N/A |
| 🟠 High | stdlib | go1.24.6 | CVE-2025-61723 | 1.24.8 |
| 🟠 High | stdlib | go1.24.6 | CVE-2025-61725 | 1.24.8 |
| 🟠 High | libxslt1.1 | 1.1.35-1+deb12u3 | CVE-2025-7425 | N/A |
| 🟠 High | stdlib | go1.24.6 | CVE-2025-61729 | 1.24.11 |
| 🟠 High | libc-bin | 2.36-9+deb12u13 | CVE-2026-0861 | N/A |
| 🟠 High | libc-l10n | 2.36-9+deb12u13 | CVE-2026-0861 | N/A |
| 🟠 High | libc6 | 2.36-9+deb12u13 | CVE-2026-0861 | N/A |
| 🟠 High | locales | 2.36-9+deb12u13 | CVE-2026-0861 | N/A |
| 🟠 High | stdlib | go1.24.6 | CVE-2025-58187 | 1.24.9 |
| 🟠 High | stdlib | go1.24.6 | CVE-2025-58188 | 1.24.8 |
| 🟡 Medium | libxml2 | 2.9.14+dfsg-1.3~deb12u5 | CVE-2026-0990 | N/A |
| 🟡 Medium | libsqlite3-0 | 3.40.1-2+deb12u2 | CVE-2025-7709 | N/A |
| 🟡 Medium | libncursesw6 | 6.4-4 | CVE-2023-50495 | N/A |
| 🟡 Medium | libtinfo6 | 6.4-4 | CVE-2023-50495 | N/A |
| 🟡 Medium | ncurses-base | 6.4-4 | CVE-2023-50495 | N/A |
| 🟡 Medium | ncurses-bin | 6.4-4 | CVE-2023-50495 | N/A |
| 🟡 Medium | stdlib | go1.24.6 | CVE-2025-58185 | 1.24.8 |
| 🟡 Medium | stdlib | go1.24.6 | CVE-2025-47912 | 1.24.8 |
| 🟡 Medium | stdlib | go1.24.6 | CVE-2025-58186 | 1.24.8 |
| 🟡 Medium | stdlib | go1.24.6 | CVE-2025-61724 | 1.24.8 |
| 🟡 Medium | libpam-modules | 1.5.2-6+deb12u2 | CVE-2024-10041 | N/A |
| 🟡 Medium | libpam-modules-bin | 1.5.2-6+deb12u2 | CVE-2024-10041 | N/A |
| 🟡 Medium | libpam-runtime | 1.5.2-6+deb12u2 | CVE-2024-10041 | N/A |
| 🟡 Medium | libpam0g | 1.5.2-6+deb12u2 | CVE-2024-10041 | N/A |
| 🟡 Medium | dirmngr | 2.2.40-1.1+deb12u2 | CVE-2025-30258 | N/A |
| 🟡 Medium | gnupg | 2.2.40-1.1+deb12u2 | CVE-2025-30258 | N/A |
| 🟡 Medium | gnupg-l10n | 2.2.40-1.1+deb12u2 | CVE-2025-30258 | N/A |
| 🟡 Medium | gnupg-utils | 2.2.40-1.1+deb12u2 | CVE-2025-30258 | N/A |
| 🟡 Medium | gpg | 2.2.40-1.1+deb12u2 | CVE-2025-30258 | N/A |
| 🟡 Medium | gpg-agent | 2.2.40-1.1+deb12u2 | CVE-2025-30258 | N/A |
| 🟡 Medium | gpg-wks-client | 2.2.40-1.1+deb12u2 | CVE-2025-30258 | N/A |
| 🟡 Medium | gpg-wks-server | 2.2.40-1.1+deb12u2 | CVE-2025-30258 | N/A |
| 🟡 Medium | gpgconf | 2.2.40-1.1+deb12u2 | CVE-2025-30258 | N/A |
| 🟡 Medium | gpgsm | 2.2.40-1.1+deb12u2 | CVE-2025-30258 | N/A |
| 🟡 Medium | gpgv | 2.2.40-1.1+deb12u2 | CVE-2025-30258 | N/A |
| 🟡 Medium | stdlib | go1.24.6 | CVE-2025-58189 | 1.24.8 |
| 🟡 Medium | bsdutils | 1:2.38.1-5+deb12u3 | CVE-2025-14104 | N/A |
| 🟡 Medium | libblkid1 | 2.38.1-5+deb12u3 | CVE-2025-14104 | N/A |

*Showing top 50 of 181 vulnerabilities (sorted by severity)*
