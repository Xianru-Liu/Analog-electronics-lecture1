# Quick deploy to GitHub Pages
# Usage:
#   1. Set $GITHUB_USER below to your GitHub username
#   2. Open PowerShell in this folder and run: .\deploy.ps1

param()

# === Set your GitHub username here ===
$GITHUB_USER = "Xianru-Liu"
$REPO_NAME   = "Analog-electronics-lecture1"
$BRANCH      = "main"
# =====================================

function Write-Step($msg)  { Write-Host "`n==> $msg" -ForegroundColor Cyan }
function Write-OK($msg)    { Write-Host "  [OK] $msg" -ForegroundColor Green }
function Write-Warn($msg)  { Write-Host "  [!] $msg" -ForegroundColor Yellow }
function Write-Err($msg)    { Write-Host "  [X] $msg" -ForegroundColor Red }

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Push-Location $scriptDir

Write-Step "0/6 Check Git"
try {
    $gitVersion = git --version 2>&1
    Write-OK "Git is installed: $gitVersion"
}
catch {
    Write-Err "Git is not installed. Install it first: https://git-scm.com/download/win"
    Pop-Location
    exit 1
}

if ([string]::IsNullOrWhiteSpace($GITHUB_USER) -or $GITHUB_USER -like "*your-github*") {
    Write-Err "Open this script in Notepad or VS Code and replace `$GITHUB_USER with your GitHub username."
    Pop-Location
    exit 1
}

Write-Step "1/6 Configure Git identity"
$name  = git config --global user.name
$email = git config --global user.email
if (-not $name) {
    $defaultName = "Liu Laoshi"
    git config --global user.name $defaultName
    Write-OK "Set global git user.name to: $defaultName"
}
else {
    Write-OK "Git user.name already configured: $name"
}
if (-not $email) {
    $defaultEmail = "liulaoshi@example.com"
    git config --global user.email $defaultEmail
    Write-OK "Set global git user.email to: $defaultEmail"
}
else {
    Write-OK "Git user.email already configured: $email"
}

Write-Step "2/6 Initialize repository"
if (-not (Test-Path ".git")) {
    git init | Out-Null
    git branch -M $BRANCH
    Write-OK "Initialized repository on branch: $BRANCH"
}
else {
    Write-OK "Repository already exists"
}

Write-Step "3/6 Stage files"
git add .
$status = git status --porcelain
if (-not $status) {
    Write-Warn "No file changes to commit"
}
else {
    Write-OK "Staged files:"
    $status | ForEach-Object { Write-Host "       $_" }
}

Write-Step "4/6 Create a commit"
if ($status) {
    git commit -m "deploy: preview site" 2>&1 | Out-Null
    $lastCommit = git log -1 --oneline
    Write-OK "Latest commit: $lastCommit"
}
else {
    Write-Warn "Skipping commit because there are no file changes."
}

Write-Step "5/6 Add remote repository"
$remoteUrl = "https://github.com/$GITHUB_USER/$REPO_NAME.git"
$existingRemote = git remote get-url origin 2>$null
if ($existingRemote) {
    if ($existingRemote -ne $remoteUrl) {
        Write-Warn "A remote already exists: $existingRemote"
        $confirm = Read-Host "       Replace it with $remoteUrl? (y/n)"
        if ($confirm -eq "y") {
            git remote set-url origin $remoteUrl
            Write-OK "Updated remote URL"
        }
    }
    else {
        Write-OK "Remote already configured: $existingRemote"
    }
}
else {
    git remote add origin $remoteUrl
    Write-OK "Added remote: $remoteUrl"
}

Write-Step "6/6 Push to GitHub"
Write-Host "  If a login window appears, follow the prompts to authorize Git." -ForegroundColor Gray
Write-Host "  GitHub no longer accepts password authentication; use a Personal Access Token." -ForegroundColor Gray
Write-Host "  For token setup, see the end of the guide file or GitHub docs." -ForegroundColor Gray

try {
    git push -u origin $BRANCH
    Write-OK "Push succeeded!"
}
catch {
    Write-Err "Push failed: $_"
    Write-Host ""
    Write-Host "  Common reasons:" -ForegroundColor Yellow
    Write-Host "    1. Repository $REPO_NAME does not exist on GitHub yet"
    Write-Host "    2. Username $GITHUB_USER is incorrect"
    Write-Host "    3. Token is missing or lacks repo permissions"
    Write-Host "    4. Network issue"
    Pop-Location
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Deployment complete. Next steps:" -ForegroundColor Green
Write-Host "  1. Open the GitHub repo and go to Settings -> Pages" -ForegroundColor Green
Write-Host "  2. Set Source to 'Deploy from a branch'" -ForegroundColor Green
Write-Host "  3. Select branch $BRANCH / (root), then Save" -ForegroundColor Green
Write-Host "  4. Wait 1-2 minutes, then open:" -ForegroundColor Green
Write-Host "     https://$GITHUB_USER.github.io/$REPO_NAME/" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Green

Pop-Location
