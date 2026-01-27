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
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Inter', sans-serif; background: #09090b; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px; color: #e4e4e7; }
        .container { background: #18181b; padding: 70px; border-radius: 24px; box-shadow: 0 10px 50px rgba(0,0,0,0.5); text-align: center; max-width: 700px; border: 1px solid #27272a; }
        h1 { color: #fafafa; font-size: 3.5em; margin-bottom: 20px; font-weight: 900; background: linear-gradient(135deg, #60a5fa, #a78bfa); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .subtitle { color: #a1a1aa; font-size: 1.3em; margin-bottom: 50px; font-weight: 500; }
        .branches { display: flex; gap: 30px; justify-content: center; flex-wrap: wrap; }
        .branch-link { display: block; padding: 35px 60px; background: linear-gradient(135deg, #1e3a8a, #1e40af); color: white; text-decoration: none; border-radius: 16px; font-size: 1.4em; font-weight: 700; transition: all 0.3s; border: 2px solid #1e40af; box-shadow: 0 4px 20px rgba(30,58,138,0.4); text-transform: uppercase; letter-spacing: 1px; }
        .branch-link:hover { transform: translateY(-8px); box-shadow: 0 8px 30px rgba(30,58,138,0.6); background: linear-gradient(135deg, #1e40af, #2563eb); }
        .chainguard { background: linear-gradient(135deg, #0e7490, #0891b2); border-color: #0891b2; box-shadow: 0 4px 20px rgba(8,145,178,0.4); }
        .chainguard:hover { background: linear-gradient(135deg, #0891b2, #06b6d4); box-shadow: 0 8px 30px rgba(8,145,178,0.6); }
        .icon { font-size: 1.2em; margin-right: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Security Scan Results</h1>
        <p class="subtitle">Container Image Vulnerability Scans</p>
        <div class="branches">
            <a href="original/" class="branch-link">
                <span class="icon">🐳</span> Original Branch
            </a>
            <a href="chainguard/" class="branch-link chainguard">
                <span class="icon">🔒</span> Chainguard Branch
            </a>
        </div>
    </div>
</body>
</html>
MAINHTML
