#!/bin/bash
# Generate migration page showing diffs between branches
# Usage: generate-migration-page.sh <output_html>

OUTPUT_HTML="$1"

# Function to generate diff HTML for a file
generate_diff_html() {
    local file_path="$1"
    local safe_id="$2"
    local display_name="$3"

    # Get the diff between branches
    git diff origin/original:${file_path} origin/chainguard:${file_path} 2>/dev/null || echo "# Files are identical or don't exist in both branches"
}

# Get list of all Dockerfiles
DOCKERFILES=(
    "services/api-gateway/Dockerfile"
    "services/document-processor/Dockerfile"
    "services/embedding-service/Dockerfile"
    "services/frontend/Dockerfile"
    "services/llm-service/Dockerfile"
    "services/nginx/Dockerfile"
)

# Start generating HTML
cat > "$OUTPUT_HTML" << 'HTMLSTART'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Migration Guide - Branch Differences</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Inter', sans-serif;
            background: #09090b;
            min-height: 100vh;
            padding: 40px 20px;
            color: #e4e4e7;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: #18181b;
            padding: 60px;
            border-radius: 24px;
            box-shadow: 0 10px 50px rgba(0,0,0,0.5);
            border: 1px solid #27272a;
        }
        .header {
            text-align: center;
            margin-bottom: 50px;
        }
        h1 {
            color: #fafafa;
            font-size: 3.5em;
            margin-bottom: 20px;
            font-weight: 900;
            background: linear-gradient(135deg, #60a5fa, #a78bfa);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .subtitle {
            color: #a1a1aa;
            font-size: 1.3em;
            margin-bottom: 20px;
            font-weight: 500;
        }
        .description {
            color: #71717a;
            font-size: 1em;
            max-width: 700px;
            margin: 0 auto;
            line-height: 1.8;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 30px;
            padding: 12px 24px;
            background: #27272a;
            color: #60a5fa;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s;
        }
        .back-link:hover {
            background: #3f3f46;
            transform: translateX(-4px);
        }

        .diff-section {
            margin: 30px 0;
            background: #09090b;
            border: 1px solid #27272a;
            border-radius: 12px;
            overflow: hidden;
        }

        .diff-header {
            padding: 20px 24px;
            background: #18181b;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: background 0.3s;
            border-bottom: 1px solid #27272a;
        }

        .diff-header:hover {
            background: #1c1c1f;
        }

        .diff-title {
            font-size: 1.1em;
            font-weight: 600;
            color: #fafafa;
            display: flex;
            align-items: center;
            gap: 12px;
            flex: 1;
        }

        .file-icon {
            color: #60a5fa;
            font-size: 1.2em;
        }

        .vuln-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: 6px;
            font-size: 0.85em;
            font-weight: 600;
            margin-left: auto;
            margin-right: 12px;
        }

        .vuln-badge.positive {
            background: linear-gradient(135deg, #065f46, #047857);
            color: white;
        }

        .vuln-badge.negative {
            background: linear-gradient(135deg, #7f1d1d, #991b1b);
            color: white;
        }

        .vuln-badge.neutral {
            background: #3f3f46;
            color: #a1a1aa;
        }

        .vuln-badge.loading {
            background: #27272a;
            color: #71717a;
        }

        .expand-icon {
            color: #71717a;
            transition: transform 0.3s;
            font-size: 1.2em;
        }

        .diff-header.expanded .expand-icon {
            transform: rotate(180deg);
        }

        .diff-content {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.4s ease-out;
        }

        .diff-content.expanded {
            max-height: 5000px;
            transition: max-height 0.6s ease-in;
        }

        .diff-code {
            padding: 24px;
            background: #000000;
            overflow-x: auto;
        }

        pre {
            margin: 0;
            font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
            font-size: 0.9em;
            line-height: 1.6;
            color: #e4e4e7;
        }

        .diff-line-add {
            background: #0d3a1f;
            color: #4ade80;
            display: block;
            padding: 2px 8px;
            margin: 0 -24px;
            padding-left: 32px;
        }

        .diff-line-remove {
            background: #3a0d1f;
            color: #f87171;
            display: block;
            padding: 2px 8px;
            margin: 0 -24px;
            padding-left: 32px;
        }

        .diff-line-context {
            color: #a1a1aa;
        }

        .diff-line-header {
            color: #60a5fa;
            font-weight: 600;
        }

        .no-diff {
            padding: 24px;
            text-align: center;
            color: #71717a;
            font-style: italic;
        }

        .section-header {
            margin: 50px 0 30px 0;
            padding-bottom: 15px;
            border-bottom: 2px solid #27272a;
        }

        .section-header h2 {
            color: #fafafa;
            font-size: 2em;
            font-weight: 700;
        }

        .stats {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin: 40px 0;
            flex-wrap: wrap;
        }

        .stat-card {
            background: #18181b;
            border: 1px solid #27272a;
            border-radius: 12px;
            padding: 24px 32px;
            text-align: center;
            min-width: 150px;
        }

        .stat-number {
            font-size: 2.5em;
            font-weight: 900;
            background: linear-gradient(135deg, #60a5fa, #a78bfa);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .stat-label {
            color: #a1a1aa;
            font-size: 0.9em;
            margin-top: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .footer {
            text-align: center;
            margin-top: 50px;
            padding-top: 30px;
            border-top: 2px solid #27272a;
            color: #71717a;
            font-size: 0.95em;
        }
        .footer a {
            color: #60a5fa;
            text-decoration: none;
        }
        .footer a:hover {
            color: #93c5fd;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="../" class="back-link">← Back to Overview</a>

        <div class="header">
            <h1>Migration Guide</h1>
            <p class="subtitle">Dockerfile & Configuration Differences</p>
            <p class="description">
                View the differences between the original and Chainguard branches to understand
                the changes required for migrating to Chainguard hardened images.
            </p>
        </div>

        <div class="stats">
            <div class="stat-card">
                <div class="stat-number" id="dockerfile-count">0</div>
                <div class="stat-label">Dockerfiles</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">1</div>
                <div class="stat-label">Compose File</div>
            </div>
        </div>

        <div class="section-header">
            <h2>📦 Docker Compose Configuration</h2>
        </div>

        <div class="diff-section">
            <div class="diff-header" onclick="toggleDiff('compose')">
                <div class="diff-title">
                    <span class="file-icon">📄</span>
                    <span>docker-compose.yaml</span>
                    <span class="vuln-badge loading" id="vuln-compose">Loading...</span>
                </div>
                <span class="expand-icon">▼</span>
            </div>
            <div class="diff-content" id="diff-compose">
                <div class="diff-code">
                    <pre id="compose-diff">Loading diff...</pre>
                </div>
            </div>
        </div>

        <div class="section-header">
            <h2>🐳 Service Dockerfiles</h2>
        </div>

HTMLSTART

# Generate diff sections for each Dockerfile
for dockerfile in "${DOCKERFILES[@]}"; do
    safe_id=$(echo "$dockerfile" | sed 's/[\/.]/_/g')
    display_name="$dockerfile"

    cat >> "$OUTPUT_HTML" << HTMLDIFF
        <div class="diff-section">
            <div class="diff-header" onclick="toggleDiff('${safe_id}')">
                <div class="diff-title">
                    <span class="file-icon">🐳</span>
                    <span>${display_name}</span>
                    <span class="vuln-badge loading" id="vuln-${safe_id}">Loading...</span>
                </div>
                <span class="expand-icon">▼</span>
            </div>
            <div class="diff-content" id="diff-${safe_id}">
                <div class="diff-code">
                    <pre id="${safe_id}-diff">Loading diff...</pre>
                </div>
            </div>
        </div>

HTMLDIFF
done

# Close HTML and add JavaScript
cat >> "$OUTPUT_HTML" << 'HTMLEND'
        <div class="footer">
            <p>Generated from git diff between <strong>original</strong> and <strong>chainguard</strong> branches</p>
        </div>
    </div>

    <script>
        function toggleDiff(id) {
            const content = document.getElementById('diff-' + id);
            const header = content.previousElementSibling;

            content.classList.toggle('expanded');
            header.classList.toggle('expanded');
        }

        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        function formatDiff(diffText) {
            if (!diffText || diffText.includes('Files are identical') || diffText.trim() === '') {
                return '<span class="no-diff">No differences between branches</span>';
            }

            const lines = diffText.split('\n');
            return lines.map(line => {
                const escaped = escapeHtml(line);
                if (line.startsWith('+') && !line.startsWith('+++')) {
                    return `<span class="diff-line-add">${escaped}</span>`;
                } else if (line.startsWith('-') && !line.startsWith('---')) {
                    return `<span class="diff-line-remove">${escaped}</span>`;
                } else if (line.startsWith('@@')) {
                    return `<span class="diff-line-header">${escaped}</span>`;
                } else if (line.startsWith('diff') || line.startsWith('index') || line.startsWith('---') || line.startsWith('+++')) {
                    return `<span class="diff-line-header">${escaped}</span>`;
                } else {
                    return `<span class="diff-line-context">${escaped}</span>`;
                }
            }).join('\n');
        }

        // Service name mapping from dockerfile paths
        const serviceMapping = {
            'services_api-gateway_Dockerfile': 'api-gateway',
            'services_document-processor_Dockerfile': 'document-processor',
            'services_embedding-service_Dockerfile': 'embedding-service',
            'services_frontend_Dockerfile': 'frontend',
            'services_llm-service_Dockerfile': 'llm-service',
            'services_nginx_Dockerfile': 'nginx'
        };

        // Infrastructure images affected by docker-compose changes
        const composeAffectedImages = [
            'ollama/ollama:latest',
            'opensearchproject/opensearch:2.11.0',
            'postgres:16-bookworm',
            'redis:7-bookworm'
        ];

        async function loadVulnerabilityStats() {
            try {
                // Add cache-busting timestamp
                const cacheBuster = new Date().getTime();

                // Fetch both index pages with cache-busting
                const [origResponse, cgResponse] = await Promise.all([
                    fetch(`../original/index.html?v=${cacheBuster}`, {
                        cache: 'no-cache',
                        headers: { 'Cache-Control': 'no-cache, no-store, must-revalidate' }
                    }),
                    fetch(`../chainguard/index.html?v=${cacheBuster}`, {
                        cache: 'no-cache',
                        headers: { 'Cache-Control': 'no-cache, no-store, must-revalidate' }
                    })
                ]);

                const origText = await origResponse.text();
                const cgText = await cgResponse.text();

                // Extract scan data
                const extractData = (html) => {
                    const match = html.match(/const scanData = (\[[\s\S]*?\]);/);
                    if (!match) return null;
                    try {
                        return JSON.parse(match[1]);
                    } catch (e) {
                        console.error('Failed to parse scanData:', e);
                        return null;
                    }
                };

                const origData = extractData(origText);
                const cgData = extractData(cgText);

                if (!origData || !cgData) return;

                // Parse scan data into maps
                const parseScans = (data) => {
                    const map = {};
                    data.forEach(scan => {
                        const parts = scan.split('|');
                        map[parts[0]] = {
                            critical: parseInt(parts[3]) || 0,
                            high: parseInt(parts[4]) || 0,
                            medium: parseInt(parts[5]) || 0,
                            low: parseInt(parts[6]) || 0,
                            total: parseInt(parts[8]) || 0
                        };
                    });
                    return map;
                };

                const origScans = parseScans(origData);
                const cgScans = parseScans(cgData);

                // Image name mapping
                const imageMapping = {
                    'ollama/ollama:latest': 'cgr.dev/mikeco.com/ollama:latest-dev',
                    'opensearchproject/opensearch:2.11.0': 'cgr.dev/mikeco.com/opensearch:2',
                    'postgres:16-bookworm': 'cgr.dev/mikeco.com/postgres:16',
                    'redis:7-bookworm': 'cgr.dev/mikeco.com/redis:7'
                };

                // Update docker-compose badge (sum of infrastructure images)
                let composeTotalOrig = 0;
                let composeTotalCg = 0;
                composeAffectedImages.forEach(img => {
                    composeTotalOrig += (origScans[img]?.total || 0);
                    composeTotalCg += (cgScans[imageMapping[img] || img]?.total || 0);
                });
                updateVulnBadge('compose', composeTotalOrig, composeTotalCg);

                // Update service badges
                Object.entries(serviceMapping).forEach(([key, serviceName]) => {
                    const origTotal = origScans[serviceName]?.total || 0;
                    const cgTotal = cgScans[serviceName]?.total || 0;
                    updateVulnBadge(key, origTotal, cgTotal);
                });

            } catch (error) {
                console.error('Error loading vulnerability stats:', error);
            }
        }

        function updateVulnBadge(id, origTotal, cgTotal) {
            const badge = document.getElementById('vuln-' + id);
            if (!badge) return;

            const reduction = origTotal - cgTotal;
            const reductionPercent = origTotal > 0 ? ((reduction / origTotal) * 100).toFixed(1) : 0;

            badge.classList.remove('loading', 'positive', 'negative', 'neutral');

            if (reduction > 0) {
                badge.classList.add('positive');
                badge.innerHTML = `↓ ${reduction} vulns (-${reductionPercent}%)`;
            } else if (reduction < 0) {
                badge.classList.add('negative');
                badge.innerHTML = `↑ ${Math.abs(reduction)} vulns (+${Math.abs(reductionPercent)}%)`;
            } else {
                badge.classList.add('neutral');
                badge.innerHTML = 'No change';
            }
        }

        // Load diff data
        const diffs = DIFF_DATA_PLACEHOLDER;

        // Apply diffs
        Object.keys(diffs).forEach(key => {
            const element = document.getElementById(key + '-diff');
            if (element) {
                element.innerHTML = formatDiff(diffs[key]);
            }
        });

        // Update stats
        const dockerfileCount = Object.keys(diffs).filter(k => k !== 'compose').length;
        document.getElementById('dockerfile-count').textContent = dockerfileCount;

        // Load vulnerability stats
        loadVulnerabilityStats();
    </script>
</body>
</html>
HTMLEND

# Now generate the actual diffs and create the JavaScript data object
echo "Generating diffs..."

# Start building the JavaScript object
DIFF_JS="{"

# Remote refs are already fetched by the workflow
# No need to fetch again here

# Use Python to generate diffs and create the JavaScript object
python3 << PYTHON_DIFF_SCRIPT
import subprocess
import json
import sys
import os

# File paths to compare
files_to_compare = {
    "compose": "docker-compose.yaml",
    "services_api-gateway_Dockerfile": "services/api-gateway/Dockerfile",
    "services_document-processor_Dockerfile": "services/document-processor/Dockerfile",
    "services_embedding-service_Dockerfile": "services/embedding-service/Dockerfile",
    "services_frontend_Dockerfile": "services/frontend/Dockerfile",
    "services_llm-service_Dockerfile": "services/llm-service/Dockerfile",
    "services_nginx_Dockerfile": "services/nginx/Dockerfile"
}

diffs = {}

for key, filepath in files_to_compare.items():
    print(f"  - {filepath}", file=sys.stderr)
    try:
        # Try with origin/ first
        result = subprocess.run(
            ['git', 'diff', f'origin/original:{filepath}', f'origin/chainguard:{filepath}'],
            capture_output=True,
            text=True
        )
        diff_text = result.stdout

        # If that fails, try without origin/
        if not diff_text or result.returncode != 0:
            result = subprocess.run(
                ['git', 'diff', f'original:{filepath}', f'chainguard:{filepath}'],
                capture_output=True,
                text=True
            )
            diff_text = result.stdout

        diffs[key] = diff_text
    except Exception as e:
        print(f"Error getting diff for {filepath}: {e}", file=sys.stderr)
        diffs[key] = ""

# Read the HTML template
with open('$OUTPUT_HTML', 'r') as f:
    html_content = f.read()

# Create JavaScript object
js_obj = 'const diffs = ' + json.dumps(diffs) + ';'

# Replace placeholder
html_content = html_content.replace('const diffs = DIFF_DATA_PLACEHOLDER;', js_obj)

# Write back
with open('$OUTPUT_HTML', 'w') as f:
    f.write(html_content)

print("Diffs generated successfully", file=sys.stderr)
PYTHON_DIFF_SCRIPT

echo "Migration page generated: $OUTPUT_HTML"
