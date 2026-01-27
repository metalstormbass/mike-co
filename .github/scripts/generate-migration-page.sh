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
    "services/embedding-service/Dockerfile.cpu"
    "services/frontend/Dockerfile"
    "services/llm-service/Dockerfile"
    "services/llm-service/Dockerfile.cpu"
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
        }

        .file-icon {
            color: #60a5fa;
            font-size: 1.2em;
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
    </script>
</body>
</html>
HTMLEND

# Now generate the actual diffs and create the JavaScript data object
echo "Generating diffs..."

# Start building the JavaScript object
DIFF_JS="{"

# Generate compose diff
echo "  - docker-compose.yaml"
COMPOSE_DIFF=$(git diff origin/original:docker-compose.yaml origin/chainguard:docker-compose.yaml 2>/dev/null | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | awk '{printf "%s\\n", $0}')
DIFF_JS="${DIFF_JS}\"compose\": \"${COMPOSE_DIFF}\","

# Generate diffs for each Dockerfile
for dockerfile in "${DOCKERFILES[@]}"; do
    echo "  - $dockerfile"
    safe_id=$(echo "$dockerfile" | sed 's/[\/.]/_/g')

    DOCKERFILE_DIFF=$(git diff origin/original:${dockerfile} origin/chainguard:${dockerfile} 2>/dev/null | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | awk '{printf "%s\\n", $0}')
    DIFF_JS="${DIFF_JS}\"${safe_id}\": \"${DOCKERFILE_DIFF}\","
done

# Remove trailing comma and close object
DIFF_JS="${DIFF_JS%,}}"

# Write the diff data to a temporary file
TEMP_FILE=$(mktemp)
echo "const diffs = ${DIFF_JS};" > "$TEMP_FILE"

# Replace placeholder by reading from file
python3 << PYTHON_SCRIPT
import sys

# Read the HTML file
with open('$OUTPUT_HTML', 'r') as f:
    html_content = f.read()

# Read the JavaScript data
with open('$TEMP_FILE', 'r') as f:
    js_data = f.read().strip()

# Replace the placeholder
html_content = html_content.replace('const diffs = DIFF_DATA_PLACEHOLDER;', js_data)

# Write back
with open('$OUTPUT_HTML', 'w') as f:
    f.write(html_content)
PYTHON_SCRIPT

rm -f "$TEMP_FILE"

echo "Migration page generated: $OUTPUT_HTML"
