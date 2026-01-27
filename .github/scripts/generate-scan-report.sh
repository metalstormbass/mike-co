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

# Generate HTML
cat > "$OUTPUT_HTML" << 'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Security Scan: IMAGE_PLACEHOLDER</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.6; color: #333; background: #f5f5f5; padding: 20px; }
        .container { max-width: 1400px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #2c3e50; margin-bottom: 10px; font-size: 2em; }
        h2 { color: #34495e; margin: 30px 0 15px; padding-bottom: 10px; border-bottom: 2px solid #3498db; }
        .badge { display: inline-block; padding: 4px 12px; border-radius: 12px; font-size: 0.85em; font-weight: 600; margin: 0 4px; }
        .badge-critical { background: #e74c3c; color: white; }
        .badge-high { background: #e67e22; color: white; }
        .badge-medium { background: #f39c12; color: white; }
        .badge-low { background: #95a5a6; color: white; }
        .badge-negligible { background: #bdc3c7; color: #333; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #34495e; color: white; font-weight: 600; }
        tr:hover { background: #f8f9fa; }
        .back-link { display: inline-block; margin-bottom: 20px; color: #3498db; text-decoration: none; }
        .back-link:hover { text-decoration: underline; }
        .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin: 20px 0; }
        .info-item { background: #ecf0f1; padding: 15px; border-radius: 6px; }
        .info-label { font-weight: 600; color: #7f8c8d; font-size: 0.9em; }
        .info-value { color: #2c3e50; font-size: 1.1em; margin-top: 5px; }
        .summary-box { background: #ecf0f1; padding: 20px; border-radius: 6px; margin: 20px 0; }
        code { background: #f8f9fa; padding: 2px 6px; border-radius: 3px; font-family: 'Courier New', monospace; }
    </style>
</head>
<body>
    <div class="container">
        <a href="../index.html" class="back-link">← Back to Summary</a>

        <h1>Security Scan Report</h1>
        <p style="color: #7f8c8d; margin-bottom: 30px;">IMAGE_PLACEHOLDER</p>

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
                <span class="badge badge-low">🟢 Low: LOW_PLACEHOLDER</span>
                <span class="badge badge-negligible">⚪ Negligible: NEGLIGIBLE_PLACEHOLDER</span>
                <span class="badge" style="background: #3498db; color: white;">Total: TOTAL_PLACEHOLDER</span>
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
    echo '<p style="color: #27ae60; font-size: 1.2em; margin: 20px 0;">✅ No vulnerabilities found!</p>' >> "$OUTPUT_HTML"
fi

# Close HTML
cat >> "$OUTPUT_HTML" << 'HTMLEOF2'

        <p style="margin-top: 30px; color: #7f8c8d; font-size: 0.9em;">
            <a href="WORKFLOW_URL_PLACEHOLDER" target="_blank">View Workflow Run →</a>
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
