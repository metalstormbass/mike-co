#!/bin/bash
# Generate summary HTML page
# Usage: generate-summary.sh <scan_data_file> <output_html> <branch_name>

SCAN_DATA_FILE="$1"
OUTPUT_HTML="$2"
BRANCH_NAME="$3"

SCAN_DATE=$(date -u '+%Y-%m-%d')
BRANCH_LABEL=$(echo "$BRANCH_NAME" | sed 's/./\U&/')

if [ "$BRANCH_NAME" = "chainguard" ]; then
  BRANCH_DESCRIPTION="Chainguard Hardened Images"
  BADGE_COLOR="#00B4D8"
else
  BRANCH_DESCRIPTION="Original Images"
  BADGE_COLOR="#6C757D"
fi

# Read scan data and convert to JSON array
if [ -f "$SCAN_DATA_FILE" ]; then
  SCAN_DATA_JSON=$(cat "$SCAN_DATA_FILE" | jq -R -s -c 'split("\n") | map(select(length > 0))')
else
  SCAN_DATA_JSON="[]"
fi

# Generate HTML
cat > "$OUTPUT_HTML" << 'ENDHTML'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Security Scans - BRANCH_LABEL_PH</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.6; color: #333; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 40px 20px; }
        .container { max-width: 1400px; margin: 0 auto; background: white; padding: 40px; border-radius: 12px; box-shadow: 0 10px 40px rgba(0,0,0,0.2); }
        .header { text-align: center; margin-bottom: 40px; }
        h1 { color: #2c3e50; font-size: 2.5em; margin-bottom: 10px; }
        .branch-badge { display: inline-block; padding: 8px 20px; border-radius: 20px; color: white; font-weight: 600; margin: 10px 0; }
        .subtitle { color: #7f8c8d; font-size: 1.1em; }
        table { width: 100%; border-collapse: collapse; margin: 30px 0; }
        th, td { padding: 15px; text-align: left; }
        th { background: #34495e; color: white; font-weight: 600; border-bottom: 3px solid #2c3e50; }
        td { border-bottom: 1px solid #ecf0f1; }
        tr:hover { background: #f8f9fa; }
        .badge { display: inline-block; padding: 4px 10px; border-radius: 12px; font-size: 0.85em; font-weight: 600; min-width: 30px; text-align: center; }
        .badge-critical { background: #e74c3c; color: white; }
        .badge-high { background: #e67e22; color: white; }
        .badge-medium { background: #f39c12; color: white; }
        .badge-low { background: #95a5a6; color: white; }
        .badge-negligible { background: #bdc3c7; color: #333; }
        .badge-total { background: #3498db; color: white; }
        a { color: #3498db; text-decoration: none; font-weight: 500; }
        a:hover { text-decoration: underline; }
        code { background: #f8f9fa; padding: 2px 8px; border-radius: 4px; font-family: 'Courier New', monospace; font-size: 0.9em; }
        .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 20px; margin: 30px 0; }
        .stat-card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 8px; text-align: center; }
        .stat-value { font-size: 2.5em; font-weight: 700; }
        .stat-label { font-size: 0.9em; opacity: 0.9; margin-top: 5px; }
        .footer { text-align: center; margin-top: 40px; padding-top: 20px; border-top: 2px solid #ecf0f1; color: #7f8c8d; font-size: 0.9em; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Security Scan Results</h1>
            <div class="branch-badge" style="background: BADGE_COLOR_PH;">BRANCH_DESC_PH</div>
            <p class="subtitle">Last Updated: SCAN_DATE_PH</p>
        </div>

        <div class="stats">
            <div class="stat-card">
                <div class="stat-value" id="total-images">0</div>
                <div class="stat-label">Images Scanned</div>
            </div>
            <div class="stat-card">
                <div class="stat-value" id="total-critical">0</div>
                <div class="stat-label">Critical</div>
            </div>
            <div class="stat-card">
                <div class="stat-value" id="total-high">0</div>
                <div class="stat-label">High</div>
            </div>
            <div class="stat-card">
                <div class="stat-value" id="total-medium">0</div>
                <div class="stat-label">Medium</div>
            </div>
            <div class="stat-card">
                <div class="stat-value" id="total-low">0</div>
                <div class="stat-label">Low</div>
            </div>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Image</th>
                    <th>Size</th>
                    <th>Scan Date</th>
                    <th style="text-align:center;">Critical</th>
                    <th style="text-align:center;">High</th>
                    <th style="text-align:center;">Medium</th>
                    <th style="text-align:center;">Low</th>
                    <th style="text-align:center;">Negligible</th>
                    <th style="text-align:center;">Total</th>
                </tr>
            </thead>
            <tbody id="scan-results">
            </tbody>
        </table>

        <div class="footer">
            <p>Scanned with <a href="https://github.com/anchore/grype" target="_blank">Grype</a> |
               Powered by <a href="https://github.com/features/actions" target="_blank">GitHub Actions</a></p>
        </div>
    </div>

    <script>
        const scanData = SCAN_DATA_JSON_PH;

        let totalCritical = 0, totalHigh = 0, totalMedium = 0, totalLow = 0;

        const tbody = document.getElementById('scan-results');
        scanData.forEach(scan => {
            const [image, size, scanDate, critical, high, medium, low, negligible, total] = scan.split('|');

            totalCritical += parseInt(critical);
            totalHigh += parseInt(high);
            totalMedium += parseInt(medium);
            totalLow += parseInt(low);

            const safeName = image.replace(/[^a-zA-Z0-9._-]/g, '_');
            const row = `
                <tr>
                    <td><a href="scans/${safeName}.html"><code>${image}</code></a></td>
                    <td>${size}</td>
                    <td>${scanDate}</td>
                    <td style="text-align:center;"><span class="badge badge-critical">${critical}</span></td>
                    <td style="text-align:center;"><span class="badge badge-high">${high}</span></td>
                    <td style="text-align:center;"><span class="badge badge-medium">${medium}</span></td>
                    <td style="text-align:center;"><span class="badge badge-low">${low}</span></td>
                    <td style="text-align:center;"><span class="badge badge-negligible">${negligible}</span></td>
                    <td style="text-align:center;"><span class="badge badge-total">${total}</span></td>
                </tr>
            `;
            tbody.innerHTML += row;
        });

        document.getElementById('total-images').textContent = scanData.length;
        document.getElementById('total-critical').textContent = totalCritical;
        document.getElementById('total-high').textContent = totalHigh;
        document.getElementById('total-medium').textContent = totalMedium;
        document.getElementById('total-low').textContent = totalLow;
    </script>
</body>
</html>
ENDHTML

# Replace placeholders
sed -i "s|BRANCH_LABEL_PH|${BRANCH_LABEL}|g" "$OUTPUT_HTML"
sed -i "s|BRANCH_DESC_PH|${BRANCH_DESCRIPTION}|g" "$OUTPUT_HTML"
sed -i "s|BADGE_COLOR_PH|${BADGE_COLOR}|g" "$OUTPUT_HTML"
sed -i "s|SCAN_DATE_PH|${SCAN_DATE}|g" "$OUTPUT_HTML"
sed -i "s|SCAN_DATA_JSON_PH|${SCAN_DATA_JSON}|g" "$OUTPUT_HTML"
