# Script để clone các branches về máy
# Chạy script này để xem code của các thành viên

Write-Host "=== Cloning Team Branches ===" -ForegroundColor Cyan

# Tạo folder merge
$mergeDir = "c:\Users\tenma\OneDrive\Documents\NetBeansProjects\Library-Merge"
if (-not (Test-Path $mergeDir)) {
    New-Item -ItemType Directory -Path $mergeDir | Out-Null
    Write-Host "Created folder: $mergeDir" -ForegroundColor Green
}

cd $mergeDir

# Repository URL
$repoUrl = "https://github.com/Saygaaww/swp391-gr3.git"

# Clone từng branch
Write-Host "`nCloning branch: hoang-authentication..." -ForegroundColor Yellow
if (Test-Path "member-hoang") {
    Write-Host "Folder member-hoang already exists. Skipping..." -ForegroundColor Yellow
} else {
    git clone -b hoang-authentication $repoUrl member-hoang
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Cloned hoang-authentication" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to clone hoang-authentication" -ForegroundColor Red
    }
}

Write-Host "`nCloning branch: dũng..." -ForegroundColor Yellow
if (Test-Path "member-dung") {
    Write-Host "Folder member-dung already exists. Skipping..." -ForegroundColor Yellow
} else {
    git clone -b dũng $repoUrl member-dung
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Cloned dũng" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to clone dũng" -ForegroundColor Red
    }
}

Write-Host "`nCloning branch: hao/SWP391..." -ForegroundColor Yellow
if (Test-Path "member-hao") {
    Write-Host "Folder member-hao already exists. Skipping..." -ForegroundColor Yellow
} else {
    git clone -b "hao/SWP391" $repoUrl member-hao
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Cloned hao/SWP391" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to clone hao/SWP391" -ForegroundColor Red
    }
}

Write-Host "`n=== Done ===" -ForegroundColor Cyan
Write-Host "Code location: $mergeDir" -ForegroundColor Cyan
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Open each folder to view code" -ForegroundColor White
Write-Host "2. Compare with your code in Library/" -ForegroundColor White
Write-Host "3. List new files and conflicts" -ForegroundColor White
Write-Host "4. Report back for detailed merge guide" -ForegroundColor White
