param(
  [Parameter(Mandatory = $true)]
  [string]$RepoUrl
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

if (-not (Test-Path ".git")) {
  git init
}

git branch -M main

$remotes = git remote
if ($remotes -contains "origin") {
  git remote set-url origin $RepoUrl
} else {
  git remote add origin $RepoUrl
}

git add index.html data.csv README.md .gitignore
git -c user.name="Bloodstalkovo" -c user.email="boyuqik455@gmail.com" commit -m "Add 2026-27 La Liga interactive chart" 2>$null

Write-Host ""
Write-Host "现在开始 push。如果弹出 GitHub 登录窗口，请登录你自己的账号。" -ForegroundColor Cyan
git push -u origin main

Write-Host ""
Write-Host "push 成功后：GitHub 仓库 → Settings → Pages → Deploy from a branch → main / root" -ForegroundColor Green
Write-Host "网站地址：https://<你的用户名>.github.io/<仓库名>/" -ForegroundColor Green
