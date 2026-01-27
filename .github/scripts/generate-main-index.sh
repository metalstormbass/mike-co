#!/bin/bash
# Generate main index HTML page
# Usage: generate-main-index.sh <output_html>

OUTPUT_HTML="$1"

cat > "$OUTPUT_HTML" << 'MAINHTML'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Security Scan Results</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Inter', sans-serif; background: #09090b; min-height: 100vh; padding: 40px 20px; color: #e4e4e7; }
        .container { max-width: 1400px; margin: 0 auto; background: #18181b; padding: 60px; border-radius: 24px; box-shadow: 0 10px 50px rgba(0,0,0,0.5); border: 1px solid #27272a; }
        .header { text-align: center; margin-bottom: 50px; }
        h1 { color: #fafafa; font-size: 3.5em; margin-bottom: 20px; font-weight: 900; background: linear-gradient(135deg, #60a5fa, #a78bfa); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .subtitle { color: #a1a1aa; font-size: 1.3em; margin-bottom: 20px; font-weight: 500; }
        .description { color: #71717a; font-size: 1em; max-width: 700px; margin: 0 auto; line-height: 1.8; }

        .comparison { margin: 50px 0; }
        .comparison h2 { color: #fafafa; font-size: 2em; margin-bottom: 30px; text-align: center; font-weight: 700; }
        .comparison-table { width: 100%; background: #09090b; border-radius: 16px; overflow: hidden; margin-bottom: 50px; }
        .comparison-table th, .comparison-table td { padding: 20px; text-align: center; }
        .comparison-table th { background: #27272a; color: #fafafa; font-weight: 600; text-transform: uppercase; font-size: 0.85em; letter-spacing: 0.5px; }
        .comparison-table td { border-bottom: 1px solid #27272a; font-size: 1.1em; }
        .comparison-table tr:last-child td { border-bottom: none; }
        .comparison-table .metric-name { text-align: left; font-weight: 600; color: #e4e4e7; }
        .original-col { color: #a78bfa; font-weight: 700; }
        .chainguard-col { color: #06b6d4; font-weight: 700; }
        .winner { background: linear-gradient(135deg, #065f46, #047857); color: white !important; font-weight: 800 !important; padding: 8px 16px !important; border-radius: 8px; }
        .loading { color: #71717a; font-style: italic; }

        .branches { display: flex; gap: 30px; justify-content: center; flex-wrap: wrap; margin-top: 40px; }
        .branch-link { display: block; padding: 35px 60px; background: linear-gradient(135deg, #1e3a8a, #1e40af); color: white; text-decoration: none; border-radius: 16px; font-size: 1.4em; font-weight: 700; transition: all 0.3s; border: 2px solid #1e40af; box-shadow: 0 4px 20px rgba(30,58,138,0.4); text-transform: uppercase; letter-spacing: 1px; }
        .branch-link:hover { transform: translateY(-8px); box-shadow: 0 8px 30px rgba(30,58,138,0.6); background: linear-gradient(135deg, #1e40af, #2563eb); }
        .chainguard { background: linear-gradient(135deg, #0e7490, #0891b2); border-color: #0891b2; box-shadow: 0 4px 20px rgba(8,145,178,0.4); }
        .chainguard:hover { background: linear-gradient(135deg, #0891b2, #06b6d4); box-shadow: 0 8px 30px rgba(8,145,178,0.6); }
        .migration { background: linear-gradient(135deg, #7c3aed, #8b5cf6); border-color: #8b5cf6; box-shadow: 0 4px 20px rgba(139,92,246,0.4); }
        .migration:hover { background: linear-gradient(135deg, #8b5cf6, #a78bfa); box-shadow: 0 8px 30px rgba(139,92,246,0.6); }
        .icon { font-size: 1.2em; margin-right: 10px; }

        .footer { text-align: center; margin-top: 50px; padding-top: 30px; border-top: 2px solid #27272a; color: #71717a; font-size: 0.95em; }
        .footer a { color: #60a5fa; text-decoration: none; }
        .footer a:hover { color: #93c5fd; }

        /* Per-image comparison styles */
        .per-image-section { margin: 50px 0; }
        .per-image-header { cursor: pointer; padding: 20px; background: #27272a; border-radius: 12px; display: flex; justify-content: space-between; align-items: center; transition: all 0.3s; margin-bottom: 20px; }
        .per-image-header:hover { background: #3f3f46; }
        .per-image-header h2 { color: #fafafa; font-size: 2em; font-weight: 700; margin: 0; }
        .toggle-icon { color: #71717a; transition: transform 0.3s; font-size: 1.5em; }
        .per-image-header.expanded .toggle-icon { transform: rotate(180deg); }
        .per-image-content { max-height: 0; overflow: hidden; transition: max-height 0.4s ease-out; }
        .per-image-content.expanded { max-height: 5000px; transition: max-height 0.6s ease-in; }
        .image-comparison-table { width: 100%; background: #09090b; border-radius: 16px; overflow: hidden; margin-top: 20px; }
        .image-comparison-table th { background: #27272a; color: #fafafa; font-weight: 600; text-transform: uppercase; font-size: 0.75em; letter-spacing: 0.5px; padding: 12px 8px; }
        .image-comparison-table th.cg-header { background: linear-gradient(135deg, #0e7490, #0891b2); color: white; }
        .image-comparison-table td { border-bottom: 1px solid #27272a; font-size: 0.9em; padding: 12px 8px; text-align: center; }
        .image-comparison-table tr:last-child td { border-bottom: none; }
        .image-comparison-table .image-name { text-align: left; font-weight: 600; color: #e4e4e7; font-size: 0.85em; max-width: 300px; word-break: break-word; }
        .severity-cell { font-weight: 600; }
        .severity-cell.cg-cell { background: #0e7490; background: rgba(8, 145, 178, 0.1); }
        .improvement-cell { font-weight: 700; color: #4ade80; }
        .improvement-negative { color: #f87171; }
        .small-winner { background: linear-gradient(135deg, #065f46, #047857); color: white !important; font-weight: 700 !important; padding: 4px 8px !important; border-radius: 6px; }

        /* Loading spinner animation */
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .error-state { color: #f87171; text-align: center; padding: 30px; }
        .error-icon { font-size: 2em; margin-bottom: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Security Scan Results</h1>
            <p class="subtitle">Container Image Vulnerability Comparison</p>
        </div>

        <div class="comparison">
            <h2>📊 Vulnerability Comparison</h2>
            <table class="comparison-table">
                <thead>
                    <tr>
                        <th class="metric-name">Metric</th>
                        <th class="original-col">Original Images</th>
                        <th class="chainguard-col">Chainguard Images</th>
                        <th>Improvement</th>
                    </tr>
                </thead>
                <tbody id="comparison-body">
                    <tr>
                        <td class="metric-name">Images Scanned</td>
                        <td class="original-col loading" id="orig-images">Loading...</td>
                        <td class="chainguard-col loading" id="cg-images">Loading...</td>
                        <td id="diff-images">-</td>
                    </tr>
                    <tr>
                        <td class="metric-name">🔴 Critical Vulnerabilities</td>
                        <td class="original-col loading" id="orig-critical">Loading...</td>
                        <td class="chainguard-col loading" id="cg-critical">Loading...</td>
                        <td id="diff-critical">-</td>
                    </tr>
                    <tr>
                        <td class="metric-name">🟠 High Vulnerabilities</td>
                        <td class="original-col loading" id="orig-high">Loading...</td>
                        <td class="chainguard-col loading" id="cg-high">Loading...</td>
                        <td id="diff-high">-</td>
                    </tr>
                    <tr>
                        <td class="metric-name">🟡 Medium Vulnerabilities</td>
                        <td class="original-col loading" id="orig-medium">Loading...</td>
                        <td class="chainguard-col loading" id="cg-medium">Loading...</td>
                        <td id="diff-medium">-</td>
                    </tr>
                    <tr>
                        <td class="metric-name">🟣 Low Vulnerabilities</td>
                        <td class="original-col loading" id="orig-low">Loading...</td>
                        <td class="chainguard-col loading" id="cg-low">Loading...</td>
                        <td id="diff-low">-</td>
                    </tr>
                    <tr>
                        <td class="metric-name"><strong>Total Vulnerabilities</strong></td>
                        <td class="original-col loading" id="orig-total"><strong>Loading...</strong></td>
                        <td class="chainguard-col loading" id="cg-total"><strong>Loading...</strong></td>
                        <td id="diff-total"><strong>-</strong></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="per-image-section">
            <div class="per-image-header" onclick="togglePerImageSection()">
                <h2>📦 Per-Image Vulnerability Comparison</h2>
                <span class="toggle-icon">▼</span>
            </div>
            <div class="per-image-content" id="per-image-content">
                <table class="image-comparison-table">
                    <thead>
                        <tr>
                            <th class="image-name">Image</th>
                            <th>Orig<br>Critical</th>
                            <th class="cg-header">CG<br>Critical</th>
                            <th>Orig<br>High</th>
                            <th class="cg-header">CG<br>High</th>
                            <th>Orig<br>Medium</th>
                            <th class="cg-header">CG<br>Medium</th>
                            <th>Orig<br>Low</th>
                            <th class="cg-header">CG<br>Low</th>
                            <th>Orig<br>Total</th>
                            <th class="cg-header">CG<br>Total</th>
                            <th>Improvement</th>
                        </tr>
                    </thead>
                    <tbody id="per-image-tbody">
                        <tr>
                            <td colspan="12" class="loading" style="text-align: center; padding: 30px;">Loading per-image data...</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="branches">
            <a href="original/" class="branch-link">
                <span class="icon">🐳</span> Original Branch
            </a>
            <a href="chainguard/" class="branch-link chainguard">
                <span class="icon">🔒</span> Chainguard Branch
            </a>
            <a href="migration/" class="branch-link migration">
                <span class="icon">🔄</span> Migration Guide
            </a>
        </div>

        <div class="footer">
            <p>Scanned with <a href="https://github.com/anchore/grype" target="_blank">Grype</a> |
               Powered by <a href="https://github.com/features/actions" target="_blank">GitHub Actions</a></p>
        </div>
    </div>

    <script>
        let scanDataLoaded = false;

        async function loadComparisonData() {
            try {
                // Fetch JSON data files directly
                const [origResponse, cgResponse] = await Promise.all([
                    fetch('data/original.json'),
                    fetch('data/chainguard.json')
                ]);

                // Verify both responses are OK
                if (!origResponse.ok || !cgResponse.ok) {
                    throw new Error(`Failed to fetch scan data: Original=${origResponse.status}, Chainguard=${cgResponse.status}`);
                }

                const origData = await origResponse.json();
                const cgData = await cgResponse.json();

                // Verify both datasets have data
                if (!Array.isArray(origData) || !Array.isArray(cgData)) {
                    throw new Error('Scan data is not in expected format');
                }

                if (origData.length === 0 || cgData.length === 0) {
                    throw new Error('Scan data is empty for one or both branches');
                }

                // Calculate totals
                const calculateTotals = (data) => {
                    let critical = 0, high = 0, medium = 0, low = 0, total = 0;
                    data.forEach(scan => {
                        critical += scan.critical || 0;
                        high += scan.high || 0;
                        medium += scan.medium || 0;
                        low += scan.low || 0;
                        total += scan.total || 0;
                    });
                    return { images: data.length, critical, high, medium, low, total };
                };

                const orig = calculateTotals(origData);
                const cg = calculateTotals(cgData);

                // Update table
                const updateCell = (id, value, isWinner = false) => {
                    const cell = document.getElementById(id);
                    if (cell) {
                        cell.textContent = value;
                        cell.classList.remove('loading');
                        if (isWinner) cell.classList.add('winner');
                    }
                };

                const calcImprovement = (origVal, cgVal) => {
                    if (origVal === 0) return cgVal === 0 ? '=' : '↑';
                    const reduction = ((origVal - cgVal) / origVal * 100).toFixed(1);
                    return reduction > 0 ? `↓ ${reduction}%` : reduction < 0 ? `↑ ${Math.abs(reduction)}%` : '=';
                };

                updateCell('orig-images', orig.images);
                updateCell('cg-images', cg.images);
                updateCell('diff-images', orig.images === cg.images ? '=' : `${cg.images - orig.images}`);

                updateCell('orig-critical', orig.critical);
                updateCell('cg-critical', cg.critical, cg.critical < orig.critical);
                updateCell('diff-critical', calcImprovement(orig.critical, cg.critical));

                updateCell('orig-high', orig.high);
                updateCell('cg-high', cg.high, cg.high < orig.high);
                updateCell('diff-high', calcImprovement(orig.high, cg.high));

                updateCell('orig-medium', orig.medium);
                updateCell('cg-medium', cg.medium, cg.medium < orig.medium);
                updateCell('diff-medium', calcImprovement(orig.medium, cg.medium));

                updateCell('orig-low', orig.low);
                updateCell('cg-low', cg.low, cg.low < orig.low);
                updateCell('diff-low', calcImprovement(orig.low, cg.low));

                updateCell('orig-total', orig.total);
                updateCell('cg-total', cg.total, cg.total < orig.total);
                updateCell('diff-total', calcImprovement(orig.total, cg.total));

                // Load per-image comparison
                loadPerImageComparison(origData, cgData);

            } catch (error) {
                console.error('Error loading comparison data:', error);
                // Show error state to user
                document.getElementById('comparison-body').innerHTML = `
                    <tr><td colspan="4" class="error-state">
                        <div class="error-icon">⚠️</div>
                        <div><strong>Failed to load scan data</strong></div>
                        <div style="font-size: 0.9em; margin-top: 10px; color: #a1a1aa;">
                            ${error.message || 'Unable to fetch scan results. Please try again later.'}
                        </div>
                    </td></tr>
                `;

                // Also show error in per-image section
                const tbody = document.getElementById('per-image-tbody');
                tbody.innerHTML = `<tr><td colspan="12" class="error-state">
                    Unable to load per-image comparison data
                </td></tr>`;
            }
        }

        function togglePerImageSection() {
            const content = document.getElementById('per-image-content');
            const header = content.previousElementSibling;
            content.classList.toggle('expanded');
            header.classList.toggle('expanded');
        }

        function loadPerImageComparison(origData, cgData) {
            try {
                // Image mapping between original and chainguard branches
                const imageMapping = {
                    'ollama/ollama:latest': 'cgr.dev/mikeco.com/ollama:latest-dev-cg',
                    'opensearchproject/opensearch:2.11.0': 'cgr.dev/mikeco.com/opensearch:2-cg',
                    'postgres:16-bookworm': 'cgr.dev/mikeco.com/postgres:16-cg',
                    'redis:7-bookworm': 'cgr.dev/mikeco.com/redis:7-cg'
                };

                // Reverse mapping for looking up
                const reverseMapping = {};
                Object.entries(imageMapping).forEach(([orig, cg]) => {
                    reverseMapping[cg] = orig;
                });

                // Parse image data from both branches
                const parseImageData = (data) => {
                    const imageMap = {};
                    data.forEach(scan => {
                        imageMap[scan.image] = {
                            critical: scan.critical || 0,
                            high: scan.high || 0,
                            medium: scan.medium || 0,
                            low: scan.low || 0,
                            total: scan.total || 0
                        };
                    });
                    return imageMap;
                };

                const origImages = parseImageData(origData);
                const cgImages = parseImageData(cgData);

                // Create unified comparison list
                const comparisons = [];

                // Process all original images
                Object.keys(origImages).forEach(origName => {
                    // For service names (no slash), append -cg to find CG version
                    // For full image paths, use the mapping
                    const cgName = origName.includes('/')
                        ? (imageMapping[origName] || origName + '-cg')
                        : origName + '-cg';
                    const displayName = origName.includes('cgr.dev') ? origName : origName;

                    comparisons.push({
                        displayName: displayName,
                        orig: origImages[origName],
                        cg: cgImages[cgName] || { critical: 0, high: 0, medium: 0, low: 0, total: 0 }
                    });
                });

                // Add any CG-only images that weren't mapped
                Object.keys(cgImages).forEach(cgName => {
                    // Strip -cg suffix to find original name
                    const origName = reverseMapping[cgName] || cgName.replace(/-cg$/, '');
                    if (!origImages[origName] && !origImages[cgName]) {
                        comparisons.push({
                            displayName: cgName,
                            orig: { critical: 0, high: 0, medium: 0, low: 0, total: 0 },
                            cg: cgImages[cgName]
                        });
                    }
                });

                // Sort by display name
                comparisons.sort((a, b) => a.displayName.localeCompare(b.displayName));

                // Generate table rows
                const tbody = document.getElementById('per-image-tbody');
                tbody.innerHTML = '';

                comparisons.forEach(comp => {
                    const { displayName, orig, cg } = comp;

                    const improvement = orig.total === 0
                        ? (cg.total === 0 ? 0 : -100)
                        : ((orig.total - cg.total) / orig.total * 100);

                    const row = document.createElement('tr');

                    // Apply winner class and cg-cell class to better performing cells
                    const getCellClass = (origVal, cgVal, isCg) => {
                        const base = isCg ? 'severity-cell cg-cell' : 'severity-cell';
                        const winner = cgVal < origVal ? ' small-winner' : '';
                        const col = isCg ? ' chainguard-col' : ' original-col';
                        return base + winner + col;
                    };

                    row.innerHTML = `
                        <td class="image-name">${displayName}</td>
                        <td class="severity-cell original-col">${orig.critical}</td>
                        <td class="${getCellClass(orig.critical, cg.critical, true)}">${cg.critical}</td>
                        <td class="severity-cell original-col">${orig.high}</td>
                        <td class="${getCellClass(orig.high, cg.high, true)}">${cg.high}</td>
                        <td class="severity-cell original-col">${orig.medium}</td>
                        <td class="${getCellClass(orig.medium, cg.medium, true)}">${cg.medium}</td>
                        <td class="severity-cell original-col">${orig.low}</td>
                        <td class="${getCellClass(orig.low, cg.low, true)}">${cg.low}</td>
                        <td class="severity-cell original-col"><strong>${orig.total}</strong></td>
                        <td class="${getCellClass(orig.total, cg.total, true)}"><strong>${cg.total}</strong></td>
                        <td class="${improvement > 0 ? 'improvement-cell' : (improvement < 0 ? 'improvement-negative' : '')}">
                            ${improvement > 0 ? '↓ ' + improvement.toFixed(1) + '%' : (improvement < 0 ? '↑ ' + Math.abs(improvement).toFixed(1) + '%' : '=')}
                        </td>
                    `;

                    tbody.appendChild(row);
                });

            } catch (error) {
                console.error('Error loading per-image comparison:', error);
                const tbody = document.getElementById('per-image-tbody');
                tbody.innerHTML = '<tr><td colspan="12" style="text-align: center; padding: 30px; color: #f87171;">Error loading per-image data</td></tr>';
            }
        }

        // Load data when page loads
        loadComparisonData();
    </script>
</body>
</html>
MAINHTML
