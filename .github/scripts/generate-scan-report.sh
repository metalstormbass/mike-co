#!/bin/bash
# Generate HTML scan report for a single image
# Usage: generate-scan-report.sh <json_file> <output_html> <image_name> <image_size> <scan_date> <workflow_url>

JSON_FILE="$1"
OUTPUT_HTML="$2"
IMAGE="$3"
IMAGE_SIZE="$4"
SCAN_DATE="$5"
WORKFLOW_URL="$6"

# Extract vulnerability counts
CRITICAL=$(jq '[.matches[] | select(.vulnerability.severity == "Critical")] | length' "$JSON_FILE")
HIGH=$(jq '[.matches[] | select(.vulnerability.severity == "High")] | length' "$JSON_FILE")
MEDIUM=$(jq '[.matches[] | select(.vulnerability.severity == "Medium")] | length' "$JSON_FILE")
LOW=$(jq '[.matches[] | select(.vulnerability.severity == "Low")] | length' "$JSON_FILE")
NEGLIGIBLE=$(jq '[.matches[] | select(.vulnerability.severity == "Negligible")] | length' "$JSON_FILE")
TOTAL=$((CRITICAL + HIGH + MEDIUM + LOW + NEGLIGIBLE))

# Generate HTML with modern dark mode
cat > "$OUTPUT_HTML" << 'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Security Scan: IMAGE_PLACEHOLDER</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Inter', sans-serif; line-height: 1.6; color: #e4e4e7; background: #09090b; padding: 20px; }
        .container { max-width: 1400px; margin: 0 auto; background: #18181b; padding: 40px; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.3); border: 1px solid #27272a; }
        h1 { color: #fafafa; margin-bottom: 10px; font-size: 2em; font-weight: 700; }
        h2 { color: #fafafa; margin: 30px 0 15px; padding-bottom: 10px; border-bottom: 2px solid #3b82f6; font-weight: 600; }
        .badge { display: inline-block; padding: 6px 14px; border-radius: 9999px; font-size: 0.85em; font-weight: 600; margin: 0 4px; text-transform: uppercase; letter-spacing: 0.5px; }
        .badge-critical { background: linear-gradient(135deg, #ef4444, #dc2626); color: white; box-shadow: 0 2px 8px rgba(239,68,68,0.4); }
        .badge-high { background: linear-gradient(135deg, #f97316, #ea580c); color: white; box-shadow: 0 2px 8px rgba(249,115,22,0.4); }
        .badge-medium { background: linear-gradient(135deg, #eab308, #ca8a04); color: white; box-shadow: 0 2px 8px rgba(234,179,8,0.4); }
        .badge-low { background: linear-gradient(135deg, #8b5cf6, #7c3aed); color: white; box-shadow: 0 2px 8px rgba(139,92,246,0.4); }
        .badge-negligible { background: #3f3f46; color: #d4d4d8; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; background: #09090b; border-radius: 12px; overflow: hidden; }
        th, td { padding: 16px; text-align: left; }
        th { background: #27272a; color: #fafafa; font-weight: 600; text-transform: uppercase; font-size: 0.85em; letter-spacing: 0.5px; }
        td { border-bottom: 1px solid #27272a; }
        tr:hover { background: #27272a; }
        tr:last-child td { border-bottom: none; }
        .back-link { display: inline-block; margin-bottom: 20px; color: #3b82f6; text-decoration: none; font-weight: 500; padding: 8px 16px; border-radius: 8px; background: #1e3a8a; transition: all 0.2s; }
        .back-link:hover { background: #1e40af; transform: translateX(-4px); }
        .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin: 20px 0; }
        .info-item { background: linear-gradient(135deg, #1e3a8a, #1e40af); padding: 20px; border-radius: 12px; border: 1px solid #1e40af; }
        .info-label { font-weight: 600; color: #93c5fd; font-size: 0.85em; text-transform: uppercase; letter-spacing: 0.5px; }
        .info-value { color: #fafafa; font-size: 1.1em; margin-top: 8px; font-weight: 500; }
        .summary-box { background: linear-gradient(135deg, #18181b, #27272a); padding: 24px; border-radius: 12px; margin: 20px 0; border: 1px solid #3f3f46; }
        code { background: #27272a; padding: 4px 8px; border-radius: 6px; font-family: 'JetBrains Mono', 'Fira Code', 'Courier New', monospace; font-size: 0.9em; color: #60a5fa; border: 1px solid #3f3f46; }
        a { color: #60a5fa; text-decoration: none; }
        a:hover { color: #93c5fd; text-decoration: underline; }
        .success-message { color: #22c55e; font-size: 1.2em; margin: 20px 0; padding: 20px; background: #14532d; border-radius: 12px; border: 1px solid #166534; }
    </style>
</head>
<body>
    <div class="container">
        <a href="../index.html" class="back-link">← Back to Summary</a>

        <h1>Security Scan Report</h1>
        <p style="color: #a1a1aa; margin-bottom: 30px; font-size: 1.1em;">IMAGE_PLACEHOLDER</p>

        <div class="info-grid">
            <div class="info-item">
                <div class="info-label">Image</div>
                <div class="info-value"><code>IMAGE_PLACEHOLDER</code></div>
            </div>
            <div class="info-item">
                <div class="info-label">Size</div>
                <div class="info-value">SIZE_PLACEHOLDER</div>
            </div>
            <div class="info-item">
                <div class="info-label">Scan Date</div>
                <div class="info-value">DATE_PLACEHOLDER</div>
            </div>
            <div class="info-item">
                <div class="info-label">Scanner</div>
                <div class="info-value">Grype</div>
            </div>
        </div>

        <div class="summary-box">
            <h2>Vulnerability Summary</h2>
            <div style="margin-top: 15px;">
                <span class="badge badge-critical">🔴 Critical: CRITICAL_PLACEHOLDER</span>
                <span class="badge badge-high">🟠 High: HIGH_PLACEHOLDER</span>
                <span class="badge badge-medium">🟡 Medium: MEDIUM_PLACEHOLDER</span>
                <span class="badge badge-low">🟣 Low: LOW_PLACEHOLDER</span>
                <span class="badge badge-negligible">⚪ Negligible: NEGLIGIBLE_PLACEHOLDER</span>
                <span class="badge" style="background: linear-gradient(135deg, #3b82f6, #2563eb); color: white; box-shadow: 0 2px 8px rgba(59,130,246,0.4);">Total: TOTAL_PLACEHOLDER</span>
            </div>
        </div>

        <h2>Detailed Findings</h2>
HTMLEOF

# Add vulnerability table if there are any
if [ "$TOTAL" -gt 0 ]; then
    echo '<table>' >> "$OUTPUT_HTML"
    echo '<thead><tr><th>Severity</th><th>Package</th><th>Installed</th><th>Vulnerability</th><th>Fixed In</th></tr></thead>' >> "$OUTPUT_HTML"
    echo '<tbody>' >> "$OUTPUT_HTML"

    jq -r '.matches | sort_by(
      if .vulnerability.severity == "Critical" then 0
      elif .vulnerability.severity == "High" then 1
      elif .vulnerability.severity == "Medium" then 2
      elif .vulnerability.severity == "Low" then 3
      else 4 end
    )[] |
      "<tr><td><span class=\"badge badge-" + (.vulnerability.severity | ascii_downcase) + "\">" + .vulnerability.severity + "</span></td>" +
      "<td><code>" + .artifact.name + "</code></td>" +
      "<td>" + .artifact.version + "</td>" +
      "<td><a href=\"" + (.vulnerability.dataSource // "#") + "\" target=\"_blank\">" + .vulnerability.id + "</a></td>" +
      "<td>" + ((.vulnerability.fix.versions[0] // "N/A") | tostring) + "</td></tr>"
    ' "$JSON_FILE" >> "$OUTPUT_HTML"

    echo '</tbody></table>' >> "$OUTPUT_HTML"
else
    echo '<div class="success-message">✅ No vulnerabilities found!</div>' >> "$OUTPUT_HTML"
fi

# Close HTML
cat >> "$OUTPUT_HTML" << 'HTMLEOF2'

        <p style="margin-top: 30px; color: #71717a; font-size: 0.9em;">
            <a href="WORKFLOW_URL_PLACEHOLDER" target="_blank" style="color: #60a5fa;">View Workflow Run →</a>
        </p>
    </div>
</body>
</html>
HTMLEOF2

# Replace placeholders
sed -i "s|IMAGE_PLACEHOLDER|${IMAGE}|g" "$OUTPUT_HTML"
sed -i "s|SIZE_PLACEHOLDER|${IMAGE_SIZE}|g" "$OUTPUT_HTML"
sed -i "s|DATE_PLACEHOLDER|${SCAN_DATE}|g" "$OUTPUT_HTML"
sed -i "s|CRITICAL_PLACEHOLDER|${CRITICAL}|g" "$OUTPUT_HTML"
sed -i "s|HIGH_PLACEHOLDER|${HIGH}|g" "$OUTPUT_HTML"
sed -i "s|MEDIUM_PLACEHOLDER|${MEDIUM}|g" "$OUTPUT_HTML"
sed -i "s|LOW_PLACEHOLDER|${LOW}|g" "$OUTPUT_HTML"
sed -i "s|NEGLIGIBLE_PLACEHOLDER|${NEGLIGIBLE}|g" "$OUTPUT_HTML"
sed -i "s|TOTAL_PLACEHOLDER|${TOTAL}|g" "$OUTPUT_HTML"
sed -i "s|WORKFLOW_URL_PLACEHOLDER|${WORKFLOW_URL}|g" "$OUTPUT_HTML"

# Output scan data for summary
echo "${IMAGE}|${IMAGE_SIZE}|${SCAN_DATE}|${CRITICAL}|${HIGH}|${MEDIUM}|${LOW}|${NEGLIGIBLE}|${TOTAL}"
