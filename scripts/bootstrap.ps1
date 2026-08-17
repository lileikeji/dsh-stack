# dsh-stack 装配脚本 (Windows / PowerShell)
# 用法:
#   powershell -ExecutionPolicy Bypass -File scripts/bootstrap.ps1  [-DshRoot E:\deepseek-harness]
param(
  [string]$DshRoot = (Join-Path (Get-Location) 'deepseek-harness')
)

$ErrorActionPreference = 'Stop'
$Stack   = Split-Path -Parent $PSScriptRoot
$Plugins = Join-Path $Stack 'plugins'
$DshHome = if ($env:DSH_HOME) { $env:DSH_HOME } else { Join-Path $env:USERPROFILE '.dsh' }
$Profile = Join-Path $DshHome 'profiles\web'

New-Item -ItemType Directory -Force -Path $Plugins | Out-Null

$repos = @(
  # 自有/核心（★ 建议必装）
  'lileikeji/dsh-llm-auto-router'
  'lileikeji/dsh-crosstalk'
  'lileikeji/dsh-vision-toolkit'
  'lileikeji/dsh-vision-assist'
  'lileikeji/dsh-image-gen'
  'lileikeji/dsh-auto-compact'
  'lileikeji/dsh-auto-continue'
  'lileikeji/dsh-super-injector'
  'lileikeji/dsh-token-usage'
  # 第三方
  'ishuowang/dsh-agent-team-room'
  'xiaobright/dsh-anchored-standard'
  'Khorsheed/dsh-ankh-guard'
  'mayf3/dsh-session-doctor'
  'jiamuAi/dsh-token-usage'
  'yjh051108/dsh-routing-suite'
  'zhu1090093659/dsh-web-ui'
)

Write-Host "==> DSH home: $DshHome" -ForegroundColor Cyan
Write-Host "==> DSH root: $DshRoot" -ForegroundColor Cyan
Write-Host "==> Target profile: $Profile" -ForegroundColor Cyan

foreach ($repo in $repos) {
  $name = Split-Path -Leaf $repo
  $dir  = Join-Path $Plugins $name
  if (-not (Test-Path $dir)) {
    Write-Host "==> cloning $repo" -ForegroundColor Yellow
    git clone --depth 1 "https://github.com/$repo.git" $dir
  }
  # build 若存在 scripts/build.sh 无法在 Windows 直接跑 bash，尝试 npm/pnpm 脚本
  Push-Location $dir
  try {
    if (Test-Path package.json) {
      Write-Host "==> building $name" -ForegroundColor Yellow
      # 尝试 pnpm build / npm run build（静默忽略缺失）
      pnpm build 2>$null; if ($LASTEXITCODE -ne 0) { npm run build 2>$null }
    }
  } finally { Pop-Location }
  Write-Host "==> adding $name to profile" -ForegroundColor Yellow
  Push-Location $DshRoot
  try { pnpm dsh plugin --profile web add $dir 2>$null } finally { Pop-Location }
}

Write-Host "`n==> done." -ForegroundColor Green
Write-Host "    cp $(Join-Path $Stack 'config-templates\settings.example.yaml') -> $DshHome\settings.yaml"
Write-Host "    copy presets: Copy-Item (Join-Path $Stack 'presets\*') $DshHome\.agent-presets\ -Recurse"
Write-Host "    run: pnpm dsh --profile web"
