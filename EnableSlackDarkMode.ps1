$SlackBaseDir = "$env:LocalAppData\Slack"
$Installations = Get-ChildItem $SlackBaseDir -Directory | Where-Object { $_.Name.StartsWith("app-") }
$Version = $Installations | Sort-Object { [version]$_.Name.Substring(4) } | Select-Object -Last 1
Write-Output "Select highest intalled Slack version: $Version";

$ModInstalled = $false;
$CustomContent = @'

// SLACK DARK MODE

document.addEventListener('DOMContentLoaded', function() {
    fetch('https://raw.githubusercontent.com/deadalusai/slack-night-mode/master/css/raw/black.css')
        .then(resp => resp.text())
        .then(css => {
            const styleEl = document.createElement('style');
            styleEl.innerHTML = css;
            document.body.appendChild(styleEl);
        });
});
'@

function Install-StyleLoader ($JsFilePath) {
    if ((Get-Content $JsFilePath -Raw) -match "// SLACK DARK MODE") {
        return $false
    }
    Add-Content $JsFilePath $CustomContent
    Write-Host "Custom style loader added to $JsFilePath"
    return $true
}

$IndexJsPath = (Resolve-Path (Join-Path $Version.FullName "resources\app.asar.unpacked\src\static\index.js"))
if (Install-StyleLoader $IndexJsPath) {
    $ModInstalled = $true;
}

$SsbInteropPath = (Resolve-Path (Join-Path $Version.FullName "resources\app.asar.unpacked\src\static\ssb-interop.js"))
if (Install-StyleLoader $SsbInteropPath) {
    $ModInstalled = $true;
}

if ($ModInstalled) {
    Write-Host "Custom styles installed";
    if (Get-Process "slack" -ErrorAction SilentlyContinue) {
        Write-Host "New styles will take effect after Slack is restarted";
    }
} else {
    Write-Host "Custom styles already installed";
}
