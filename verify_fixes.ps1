
Write-Host "Verifying Golden Seed Standardization and Overage Calculation (Regex Method)..." -ForegroundColor Cyan

# 1. Check SQL Seed for Hardcoded IDs
$sqlPath = "c:\Users\User\Desktop\GOLDEN FOLDERS\golden seed\golden_seed_destinations.sql"
$pattern = "^\(\d+,"

Write-Host "Checking $sqlPath for hardcoded integer IDs..."
$matches = Select-String -Path $sqlPath -Pattern $pattern

if ($matches) {
    Write-Host "FAILURE: Found hardcoded IDs in SQL seed file!" -ForegroundColor Red
    $matches | Select-Object -First 5
    exit 1
} else {
    Write-Host "SUCCESS: No hardcoded IDs found in SQL seed file." -ForegroundColor Green
}

# 2. Check Python FinancialOpsService for Method Definition (Regex)
$pyPath = "c:\Users\User\Desktop\GOLDEN FOLDERS\golden seed\backend\app\services\financial_ops.py"
Write-Host "Verifying Python Service Implementation in $pyPath..."

$pyContent = Get-Content $pyPath
$hasMethod = $pyContent | Select-String "def calculate_monthly_overage"

if ($hasMethod) {
    Write-Host "SUCCESS: calculate_monthly_overage method found in Python file." -ForegroundColor Green
} else {
    Write-Host "FAILURE: calculate_monthly_overage method MISSING in Python file." -ForegroundColor Red
    exit 1
}

Write-Host "All Checks Passed!" -ForegroundColor Green
