$destination = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\MiddleClickUtil.exe"
$source = "$PSScriptRoot\dist\MiddleClickUtil.exe"

function Install-MiddleClick {
    Write-Host "`n===========================================" -ForegroundColor Cyan
    Write-Host "   MiddleClick Utility Installer" -ForegroundColor Cyan
    Write-Host "===========================================" -ForegroundColor Cyan

    if (Test-Path $destination) {
        Write-Host "[INFO] MiddleClickUtil.exe is already installed in Startup." -ForegroundColor Yellow
    } else {
        Copy-Item -Path $source -Destination $destination -Force
        if (Test-Path $destination) {
            Write-Host "[SUCCESS] MiddleClickUtil.exe has been installed successfully and will run on the next reboot." -ForegroundColor Green
        } else {
            Write-Host "[ERROR] Failed to install MiddleClickUtil.exe." -ForegroundColor Red
            exit
        }
    }

    $runNow = Read-Host "Do you want to run MiddleClickUtil.exe now? (Y/N)"
    if ($runNow -match "^[Yy]$") {
        Start-Process $destination
        Write-Host "[INFO] MiddleClickUtil.exe has been started." -ForegroundColor Green
    }

    Read-Host "Press Enter to exit"
}

function Uninstall-MiddleClick {
    Write-Host "`n===========================================" -ForegroundColor Red
    Write-Host "   MiddleClick Utility Uninstaller" -ForegroundColor Red
    Write-Host "===========================================" -ForegroundColor Red

    if (Test-Path $destination) {
        Write-Host "Removing MiddleClickUtil.exe from Startup folder..."

        # Stop process if running
        $process = Get-Process | Where-Object { $_.ProcessName -like "MiddleClickUtil*" }
        if ($process) {
            Write-Host "Stopping running process..."
            Stop-Process -Name "MiddleClickUtil" -Force -ErrorAction SilentlyContinue
        }

        # Remove the executable
        Remove-Item -Path $destination -Force

        if (!(Test-Path $destination)) {
            Write-Host "[SUCCESS] MiddleClickUtil.exe has been successfully uninstalled." -ForegroundColor Green
        } else {
            Write-Host "[ERROR] Failed to remove MiddleClickUtil.exe. Try running as Administrator." -ForegroundColor Red
        }
    } else {
        Write-Host "[INFO] MiddleClickUtil.exe is not installed or has already been removed." -ForegroundColor Yellow
    }

    Read-Host "Press Enter to exit"
}

# Ask user for choice
Write-Host "`n==========================================="
Write-Host "   MiddleClick Utility Installer/Uninstaller"
Write-Host "==========================================="
Write-Host "1. Install MiddleClickUtil.exe"
Write-Host "2. Uninstall MiddleClickUtil.exe"
Write-Host "3. Exit"
Write-Host "==========================================="
$choice = Read-Host "Enter your choice (1/2/3)"

if ($choice -eq "1") {
    Install-MiddleClick
} elseif ($choice -eq "2") {
    Uninstall-MiddleClick
} else {
    Write-Host "Exiting..." -ForegroundColor Yellow
    exit
}