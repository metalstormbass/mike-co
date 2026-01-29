#!/bin/bash
# Generate vulnerabilities page with expandable issues
# Usage: generate-vulnerabilities-page.sh <output_html> <scan_data_json>

OUTPUT_HTML="$1"
SCAN_DATA_JSON="$2"

cat > "$OUTPUT_HTML" << 'VULNHTML'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vulnerability Tickets</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Inter', sans-serif; background: #09090b; min-height: 100vh; padding: 40px 20px; color: #e4e4e7; }
        .container { max-width: 1400px; margin: 0 auto; background: #18181b; padding: 60px; border-radius: 24px; box-shadow: 0 10px 50px rgba(0,0,0,0.5); border: 1px solid #27272a; }
        .header { text-align: center; margin-bottom: 50px; }
        h1 { color: #fafafa; font-size: 3em; margin-bottom: 20px; font-weight: 900; background: linear-gradient(135deg, #ef4444, #dc2626); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .subtitle { color: #a1a1aa; font-size: 1.2em; margin-bottom: 20px; font-weight: 500; }
        .back-link { display: inline-block; padding: 12px 24px; background: #27272a; color: #e4e4e7; text-decoration: none; border-radius: 8px; margin-bottom: 30px; transition: all 0.3s; }
        .back-link:hover { background: #3f3f46; transform: translateY(-2px); }

        .stats-bar { display: flex; gap: 20px; justify-content: center; margin-bottom: 40px; flex-wrap: wrap; }
        .stat-card { background: #27272a; padding: 20px 30px; border-radius: 12px; text-align: center; min-width: 150px; }
        .stat-number { font-size: 2.5em; font-weight: 900; margin-bottom: 5px; }
        .stat-label { color: #a1a1aa; font-size: 0.9em; text-transform: uppercase; letter-spacing: 1px; }
        .critical-stat .stat-number { color: #ef4444; }
        .high-stat .stat-number { color: #f97316; }
        .total-stat .stat-number { color: #a78bfa; }

        .filters { display: flex; gap: 15px; margin-bottom: 20px; flex-wrap: wrap; align-items: center; }
        .filter-btn { padding: 10px 20px; background: #27272a; color: #e4e4e7; border: 2px solid #27272a; border-radius: 8px; cursor: pointer; transition: all 0.3s; font-size: 0.9em; font-weight: 600; }
        .filter-btn:hover { background: #3f3f46; }
        .filter-btn.active { background: #1e40af; border-color: #2563eb; color: white; }
        .search-box { flex: 1; min-width: 250px; padding: 10px 15px; background: #27272a; border: 2px solid #27272a; border-radius: 8px; color: #e4e4e7; font-size: 0.9em; }
        .search-box:focus { outline: none; border-color: #2563eb; background: #18181b; }

        .result-counter { text-align: center; color: #a1a1aa; font-size: 0.95em; margin-bottom: 20px; padding: 10px; background: #27272a; border-radius: 8px; }
        .result-counter-number { color: #60a5fa; font-weight: 700; font-size: 1.2em; }

        .vuln-list { display: flex; flex-direction: column; gap: 15px; }
        .vuln-item { background: #27272a; border-radius: 12px; overflow: hidden; border: 2px solid #27272a; transition: all 0.3s; }
        .vuln-item.hidden { display: none; }
        .vuln-header { padding: 20px; cursor: pointer; display: flex; justify-content: space-between; align-items: center; transition: all 0.3s; }
        .vuln-header:hover { background: #3f3f46; }
        .vuln-header.expanded { background: #3f3f46; }
        .vuln-title { display: flex; align-items: center; gap: 15px; flex: 1; }
        .severity-badge { padding: 6px 14px; border-radius: 6px; font-weight: 700; font-size: 0.75em; text-transform: uppercase; letter-spacing: 0.5px; }
        .severity-critical { background: #7f1d1d; color: #fca5a5; }
        .severity-high { background: #7c2d12; color: #fdba74; }
        .severity-medium { background: #713f12; color: #fde047; }
        .severity-low { background: #1e3a8a; color: #93c5fd; }
        .vuln-id { font-size: 1.1em; font-weight: 700; color: #fafafa; }
        .vuln-image { color: #a1a1aa; font-size: 0.85em; margin-left: 10px; font-family: 'Courier New', monospace; }
        .toggle-icon { color: #71717a; transition: transform 0.3s; font-size: 1.3em; }
        .vuln-header.expanded .toggle-icon { transform: rotate(180deg); }

        .vuln-content { max-height: 0; overflow: hidden; transition: max-height 0.4s ease-out; }
        .vuln-content.expanded { max-height: 1000px; transition: max-height 0.6s ease-in; }
        .vuln-body { padding: 0 20px 20px 20px; }
        .vuln-section { margin-bottom: 20px; }
        .vuln-section-title { color: #a1a1aa; font-size: 0.8em; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; font-weight: 600; }
        .vuln-section-content { color: #e4e4e7; line-height: 1.6; }
        .code-block { background: #09090b; padding: 12px; border-radius: 8px; font-family: 'Courier New', monospace; font-size: 0.85em; overflow-x: auto; }
        .vuln-links { display: flex; gap: 10px; flex-wrap: wrap; }
        .vuln-link { display: inline-block; padding: 8px 16px; background: #1e40af; color: white; text-decoration: none; border-radius: 6px; font-size: 0.85em; transition: all 0.3s; }
        .vuln-link:hover { background: #2563eb; transform: translateY(-2px); }

        .empty-state { text-align: center; padding: 60px 20px; color: #71717a; }
        .empty-state-icon { font-size: 4em; margin-bottom: 20px; }
        .loading-state { text-align: center; padding: 60px 20px; color: #a1a1aa; }
        .loading-spinner { width: 40px; height: 40px; border: 4px solid #27272a; border-top-color: #60a5fa; border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto 20px; }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <a href="../" class="back-link">← Back to Summary</a>
            <h1>🎫 Vulnerability Tickets</h1>
            <p class="subtitle">Container Image Vulnerability Tracking</p>
        </div>

        <div class="stats-bar" id="stats-bar">
            <div class="stat-card critical-stat">
                <div class="stat-number" id="stat-critical">-</div>
                <div class="stat-label">Critical</div>
            </div>
            <div class="stat-card high-stat">
                <div class="stat-number" id="stat-high">-</div>
                <div class="stat-label">High</div>
            </div>
            <div class="stat-card total-stat">
                <div class="stat-number" id="stat-total">-</div>
                <div class="stat-label">Total Vulns</div>
            </div>
        </div>

        <div class="filters">
            <button class="filter-btn active" data-filter="all">All Severities</button>
            <button class="filter-btn" data-filter="critical">Critical</button>
            <button class="filter-btn" data-filter="high">High</button>
            <button class="filter-btn" data-filter="medium">Medium</button>
            <button class="filter-btn" data-filter="low">Low</button>
            <button class="filter-btn" id="kev-filter" style="margin-left: auto;">In KEV</button>
            <button class="filter-btn" id="epss-filter">EPSS &gt; 10%</button>
            <button class="filter-btn" id="fixable-filter">Has Fix</button>
            <button class="filter-btn" id="no-fix-filter">No Fix</button>
            <input type="text" class="search-box" id="search-box" placeholder="Search by CVE ID, image name, or package...">
        </div>

        <div class="result-counter" id="result-counter">
            Showing <span class="result-counter-number" id="result-count">0</span> vulnerabilities
        </div>

        <div class="vuln-list" id="vuln-list">
            <div class="loading-state">
                <div class="loading-spinner"></div>
                <div>Loading vulnerabilities...</div>
            </div>
        </div>
    </div>

    <script>
        let allVulnerabilities = [];
        let selectedSeverities = new Set(['all']);
        let currentSearch = '';
        let showOnlyFixable = false;
        let showOnlyNoFix = false;
        let showOnlyKEV = false;
        let showOnlyHighEPSS = false;

        async function loadVulnerabilities() {
            try {
                console.log('Loading vulnerabilities from original scan data...');

                // Fetch scan results
                const response = await fetch('../data/original.json');
                if (!response.ok) {
                    throw new Error('Failed to fetch scan data');
                }

                const scanData = await response.json();
                console.log('Scan data loaded:', scanData.length, 'images');

                // Define pulled images (infrastructure images that show ALL vulnerabilities)
                const pulledImages = [
                    'ollama/ollama:latest',
                    'opensearchproject/opensearch:2.11.0',
                    'postgres:16-bookworm',
                    'redis:7-bookworm',
                    'cgr.dev/mikeco.com/ollama:latest-dev',
                    'cgr.dev/mikeco.com/opensearch:2',
                    'cgr.dev/mikeco.com/postgres:16',
                    'cgr.dev/mikeco.com/redis:7'
                ];

                // Load detailed vulnerability data for each image
                const vulnerabilities = [];

                for (const scan of scanData) {
                    const imageName = scan.image;
                    // Match the shell script naming: keep alphanumeric, dots, underscores, and hyphens
                    const scanFile = scan.image.replace(/[^a-zA-Z0-9._-]/g, '_') + '.json';
                    const isPulledImage = pulledImages.includes(imageName);

                    try {
                        const scanResponse = await fetch(`../original/scan-results/${scanFile}`);
                        if (!scanResponse.ok) continue;

                        const scanResults = await scanResponse.json();

                        // Extract vulnerabilities
                        if (scanResults.matches) {
                            scanResults.matches.forEach(match => {
                                const artifact = match.artifact || {};
                                const vulnerability = match.vulnerability || {};
                                const packageType = artifact.type || '';

                                // For pulled images: show ALL vulnerabilities
                                // For built service images: show only OS package vulnerabilities
                                const shouldInclude = isPulledImage || ['deb', 'rpm', 'apk'].includes(packageType);

                                if (shouldInclude) {
                                    // Check for KEV (CISA Known Exploited Vulnerabilities)
                                    const isKEV = vulnerability.advisories?.some(adv =>
                                        adv.url?.includes('cisa.gov/known-exploited-vulnerabilities')
                                    ) || false;

                                    // Extract EPSS score
                                    const epssScore = vulnerability.epss?.score || null;
                                    const epssPercentile = vulnerability.epss?.percentile || null;

                                    vulnerabilities.push({
                                        id: vulnerability.id || 'UNKNOWN',
                                        severity: (vulnerability.severity || 'Unknown').toLowerCase(),
                                        image: imageName,
                                        package: artifact.name || 'Unknown',
                                        version: artifact.version || 'Unknown',
                                        packageType: packageType,
                                        fixedIn: vulnerability.fix?.versions?.join(', ') || 'No fix available',
                                        description: vulnerability.description || 'No description available',
                                        urls: vulnerability.urls || [],
                                        dataSource: vulnerability.dataSource || '',
                                        isKEV: isKEV,
                                        epssScore: epssScore,
                                        epssPercentile: epssPercentile
                                    });
                                }
                            });
                        }
                    } catch (err) {
                        console.warn('Failed to load scan for', imageName, err);
                    }
                }

                console.log('Total vulnerabilities found:', vulnerabilities.length);
                allVulnerabilities = vulnerabilities;

                updateStats();
                renderVulnerabilities();

            } catch (error) {
                console.error('Error loading vulnerabilities:', error);
                document.getElementById('vuln-list').innerHTML = `
                    <div class="empty-state">
                        <div class="empty-state-icon">⚠️</div>
                        <div><strong>Failed to load vulnerabilities</strong></div>
                        <div style="margin-top: 10px; font-size: 0.9em;">${error.message}</div>
                    </div>
                `;
            }
        }

        function updateStats() {
            const stats = {
                critical: 0,
                high: 0,
                total: allVulnerabilities.length
            };

            allVulnerabilities.forEach(v => {
                if (v.severity === 'critical') stats.critical++;
                if (v.severity === 'high') stats.high++;
            });

            document.getElementById('stat-critical').textContent = stats.critical;
            document.getElementById('stat-high').textContent = stats.high;
            document.getElementById('stat-total').textContent = stats.total;
        }

        function renderVulnerabilities() {
            const filtered = allVulnerabilities.filter(v => {
                // Filter by severity - allow multiple selections
                if (!selectedSeverities.has('all') && !selectedSeverities.has(v.severity)) {
                    return false;
                }

                // Filter by KEV
                if (showOnlyKEV && !v.isKEV) {
                    return false;
                }

                // Filter by high EPSS (> 10%)
                if (showOnlyHighEPSS && (!v.epssScore || v.epssScore <= 0.1)) {
                    return false;
                }

                // Filter by fixable (mutually exclusive with no-fix)
                if (showOnlyFixable && v.fixedIn === 'No fix available') {
                    return false;
                }

                // Filter by no fix (mutually exclusive with fixable)
                if (showOnlyNoFix && v.fixedIn !== 'No fix available') {
                    return false;
                }

                // Filter by search
                if (currentSearch) {
                    const search = currentSearch.toLowerCase();
                    return v.id.toLowerCase().includes(search) ||
                           v.image.toLowerCase().includes(search) ||
                           v.package.toLowerCase().includes(search) ||
                           v.description.toLowerCase().includes(search);
                }

                return true;
            });

            // Update result counter
            const resultCountEl = document.getElementById('result-count');
            if (resultCountEl) {
                resultCountEl.textContent = filtered.length;
            }

            const listEl = document.getElementById('vuln-list');

            if (filtered.length === 0) {
                listEl.innerHTML = `
                    <div class="empty-state">
                        <div class="empty-state-icon">✓</div>
                        <div><strong>No vulnerabilities found</strong></div>
                        <div style="margin-top: 10px; font-size: 0.9em;">Try adjusting your filters or search query</div>
                    </div>
                `;
                return;
            }

            listEl.innerHTML = filtered.map(v => `
                <div class="vuln-item" data-severity="${v.severity}">
                    <div class="vuln-header" onclick="toggleVuln(this)">
                        <div class="vuln-title">
                            <span class="severity-badge severity-${v.severity}">${v.severity}</span>
                            <div>
                                <div class="vuln-id">${v.id}</div>
                                <div class="vuln-image">${v.image}</div>
                            </div>
                        </div>
                        <span class="toggle-icon">▼</span>
                    </div>
                    <div class="vuln-content">
                        <div class="vuln-body">
                            <div class="vuln-section">
                                <div class="vuln-section-title">Package</div>
                                <div class="vuln-section-content code-block">${v.package} @ ${v.version}${v.packageType ? ` (${v.packageType})` : ''}</div>
                            </div>

                            <div class="vuln-section">
                                <div class="vuln-section-title">Fixed In</div>
                                <div class="vuln-section-content code-block">${v.fixedIn}</div>
                            </div>

                            ${v.epssScore !== null ? `
                            <div class="vuln-section">
                                <div class="vuln-section-title">Exploitation Probability</div>
                                <div class="vuln-section-content">
                                    <span style="background: #3f3f46; color: #e4e4e7; padding: 4px 12px; border-radius: 6px; font-weight: 600; font-size: 0.85em;">EPSS: ${(v.epssScore * 100).toFixed(2)}%${v.epssPercentile !== null ? ` (${v.epssPercentile.toFixed(1)}th percentile)` : ''}</span>
                                </div>
                            </div>
                            ` : ''}

                            <div class="vuln-section">
                                <div class="vuln-section-title">Description</div>
                                <div class="vuln-section-content">${v.description}</div>
                            </div>

                            ${v.urls.length > 0 ? `
                            <div class="vuln-section">
                                <div class="vuln-section-title">References</div>
                                <div class="vuln-links">
                                    ${v.urls.slice(0, 3).map(url => `<a href="${url}" target="_blank" class="vuln-link">View Details →</a>`).join('')}
                                </div>
                            </div>
                            ` : ''}
                        </div>
                    </div>
                </div>
            `).join('');
        }

        function toggleVuln(header) {
            const content = header.nextElementSibling;
            header.classList.toggle('expanded');
            content.classList.toggle('expanded');
        }

        // Severity filter buttons - allow multiple selections
        document.querySelectorAll('.filter-btn[data-filter]').forEach(btn => {
            btn.addEventListener('click', () => {
                const severity = btn.dataset.filter;

                if (severity === 'all') {
                    // If "All" is clicked, deselect everything else and select "All"
                    selectedSeverities.clear();
                    selectedSeverities.add('all');
                    document.querySelectorAll('.filter-btn[data-filter]').forEach(b => b.classList.remove('active'));
                    btn.classList.add('active');
                } else {
                    // Remove "All" if any specific severity is selected
                    if (selectedSeverities.has('all')) {
                        selectedSeverities.delete('all');
                        document.querySelector('.filter-btn[data-filter="all"]').classList.remove('active');
                    }

                    // Toggle this severity
                    if (selectedSeverities.has(severity)) {
                        selectedSeverities.delete(severity);
                        btn.classList.remove('active');

                        // If no severities selected, revert to "All"
                        if (selectedSeverities.size === 0) {
                            selectedSeverities.add('all');
                            document.querySelector('.filter-btn[data-filter="all"]').classList.add('active');
                        }
                    } else {
                        selectedSeverities.add(severity);
                        btn.classList.add('active');
                    }
                }

                renderVulnerabilities();
            });
        });

        // KEV filter button (toggle)
        document.getElementById('kev-filter').addEventListener('click', (e) => {
            showOnlyKEV = !showOnlyKEV;
            e.target.classList.toggle('active');
            renderVulnerabilities();
        });

        // EPSS filter button (toggle)
        document.getElementById('epss-filter').addEventListener('click', (e) => {
            showOnlyHighEPSS = !showOnlyHighEPSS;
            e.target.classList.toggle('active');
            renderVulnerabilities();
        });

        // Fixable filter button (toggle)
        document.getElementById('fixable-filter').addEventListener('click', (e) => {
            showOnlyFixable = !showOnlyFixable;
            e.target.classList.toggle('active');

            // Turn off "No Fix" filter if "Has Fix" is activated
            if (showOnlyFixable && showOnlyNoFix) {
                showOnlyNoFix = false;
                document.getElementById('no-fix-filter').classList.remove('active');
            }

            renderVulnerabilities();
        });

        // No Fix filter button (toggle)
        document.getElementById('no-fix-filter').addEventListener('click', (e) => {
            showOnlyNoFix = !showOnlyNoFix;
            e.target.classList.toggle('active');

            // Turn off "Has Fix" filter if "No Fix" is activated
            if (showOnlyNoFix && showOnlyFixable) {
                showOnlyFixable = false;
                document.getElementById('fixable-filter').classList.remove('active');
            }

            renderVulnerabilities();
        });

        // Search box
        document.getElementById('search-box').addEventListener('input', (e) => {
            currentSearch = e.target.value;
            renderVulnerabilities();
        });

        // Load data on page load
        loadVulnerabilities();
    </script>
</body>
</html>
VULNHTML
