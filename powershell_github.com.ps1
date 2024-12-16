#加速源来自 https://github.akams.cn/
# 定义要替换的旧网址前缀和新网址前缀
$oldPrefix = "https://github.com"
$newPrefix = "https://gh-proxy.com/https://github.com"
#如失效可以替换 https://ghproxy.cc/
#git全站反代github.store github.site

# 重写 Invoke-WebRequest 命令，使其自动替换输入的链接
function Invoke-WebRequest {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$Uri,
        [Parameter(Position = 1, Mandatory = $false)]
        [hashtable]$Headers,
        [Parameter(Position = 2, Mandatory = $false)]
        [string]$OutFile
    )

    # 替换链接
    if ($Uri -match "^$oldPrefix") {
        $Uri = $Uri -replace [regex]::Escape($oldPrefix), $newPrefix
    }

    # 调用原始的 Invoke-WebRequest
    Microsoft.PowerShell.Utility\Invoke-WebRequest -Uri $Uri -Headers $Headers -OutFile $OutFile
}

# 重写 Invoke-RestMethod 命令，使其自动替换输入的链接
function Invoke-RestMethod {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$Uri,
        [Parameter(Position = 1, Mandatory = $false)]
        [hashtable]$Headers
    )

    # 替换链接
    if ($Uri -match "^$oldPrefix") {
        $Uri = $Uri -replace [regex]::Escape($oldPrefix), $newPrefix
    }

    # 调用原始的 Invoke-RestMethod
    Microsoft.PowerShell.Utility\Invoke-RestMethod -Uri $Uri -Headers $Headers
}

# 重写 curl 别名（如果存在）
if (Get-Alias -Name curl -ErrorAction SilentlyContinue) {
    Remove-Item Alias:curl -Force
}
New-Alias -Name curl -Value Invoke-WebRequest

# 重写 wget 别名（如果存在）
if (Get-Alias -Name wget -ErrorAction SilentlyContinue) {
    Remove-Item Alias:wget -Force
}
New-Alias -Name wget -Value Invoke-WebRequest
