# Define the function to display the Help message
function Show-Help {
    Write-Host "==========================" -ForegroundColor Cyan
    Write-Host "  Welcome to AzureVault!" -ForegroundColor Green
    Write-Host "==========================" -ForegroundColor Cyan
    Write-Host "  Version : 1.0" -ForegroundColor White
    Write-Host ""
    Write-Host "- Important: Always keep an eye on colored text" -ForegroundColor Yellow
	Write-Host "- Filtered most common Vault names print always." -ForegroundColor White
    Write-Host "- Type 'x' and Press ENTER for a list of all options." -ForegroundColor White
    Write-Host "- Type 'number' to enter a valid number seen in the console." -ForegroundColor White
    Write-Host "- Type 'name' to refer to 'part or full' secret name." -ForegroundColor White
    Write-Host "- If 'name' given with 'part', there will be multiple secrets printed." -ForegroundColor White
    Write-Host "- 'Permission Error' means you don't have access to the selected vault." -ForegroundColor Red
    Write-Host "- Type 'H' and Press ENTER to print this message" -ForegroundColor White
    Write-Host ""
    Write-Host "** Security Alert **" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please ensure you follow these security best practices:" -ForegroundColor White
    Write-Host "- **Do not share your password** with anyone." -ForegroundColor Yellow
    Write-Host "- **Keep script updated** to guard against bugs/vulnerabilities." -ForegroundColor Yellow
    Write-Host "- **Report any suspicious/bug activity** immediately." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "For detailed documentation, visit: https://confluence.newfold.com/display/EMC/Get+Azure+Key+Vault+Secrets+in+Windows+Terminal" -ForegroundColor Blue
    Write-Host ""
    Write-Host "Happy exploring!`n" -ForegroundColor Green
}

$currentUsername = $Env:USERNAME
$filePath = "C:\Users\$currentUsername\KeyVaults.txt"
$number = 1
$oldVault = $null
$KeyVaults = $null
$KeyVaultsx = $null

function Show-Progress {
    param (
        [int]$Duration
    )
    $spinner = @("|", "/", "-", "\")
    $startTime = Get-Date
    $i = 0

    while ((Get-Date) -lt $startTime.AddSeconds($Duration)) {
        Write-Host -NoNewline "`rFetching secrets... $($spinner[$i % $spinner.Length])"
        Start-Sleep -Milliseconds 200
        $i++
    }

    Write-Host "`rFetching secrets... Done!`n" -NoNewline
}

function Get-SecretWithProgress {
    param (
        [string]$VaultName
    )

    # Start a background job to get the secrets
    $job = Start-Job -ScriptBlock {
        param ($VaultName)
        try {
            $result = Get-AzKeyVaultSecret -VaultName $VaultName -ErrorAction Stop | Select-Object -ExpandProperty Name
            [PSCustomObject]@{ Success = $true; Result = $result }
        } catch {
            [PSCustomObject]@{ Success = $false; ErrorMessage = $_.Exception.Message; StatusCode = $_.Exception.Response.StatusCode }
        }
    } -ArgumentList $VaultName

    # Display progress while job is running
    $startTime = Get-Date
    $spinner = @("|", "/", "-", "\")
    $i = 0

    while ($job.State -eq 'Running') {
        Write-Host -NoNewline "`rFetching secrets... $($spinner[$i % $spinner.Length])"
        Start-Sleep -Milliseconds 200
        $i++
    }

    # Wait for the job to complete and get results
    $jobResult = Receive-Job -Job $job -Wait
    Remove-Job -Job $job

    Write-Host "`rFetching secrets... Done!`n" -NoNewline

    return $jobResult
}

function keyz {
    if (Test-Path $filePath) {
        $KeyVaults = Get-Content -Path $filePath
        $KeyVaultsx = $KeyVaults | findstr /i "ops email database BMC"
        if ($KeyVaults) {
            function Print-Option {
                param([string[]]$opts)
                cls
                Write-Host "`n Welcome To AzureVault, " -NoNewline -ForegroundColor Green
                Write-Host "$currentUsername !" -ForegroundColor Cyan
                Write-Host "`n ===================== `n" -ForegroundColor DarkMagenta				
				for ($i = 0; $i -lt $opts.Length; $i++) {
                   Write-Host "`  $($opts[$i])"
                }
            }

            function Read-Option {
                $choice = 0
                while ($true) {
                    Write-Host "`n(Press 'x' and Enter to list all VaultName | Press 'H' help)`n" -ForegroundColor Magenta
					#Write-Host "`tImportant: Read All Colored Text`n" -ForegroundColor Red
                    $choice = Read-Host "Enter vault 'number'"

                    # Check if the input is 'x'
                    if ($choice -eq 'x') {
                        Print-Option -opts $KeyVaults
                        continue
                    }
					$allowedConditions = @("h", "H", "help", "Help")
					if ($allowedConditions -contains $choice) {
					# Fetch text from the URL
						cls
						Show-Help
						Read-Host -Prompt "Press Enter to continue/Clr+C to Cancel"
						Print-Option -opts $KeyVaultsx
						continue
					}
                    # Try to convert the input to an integer
                    if ([int]::TryParse($choice, [ref]$null)) {
                        $choice = [int]$choice
                        if ($choice -gt 0 -and $choice -le $KeyVaults.Length) {
                            break
                        } else {
                            Write-Host "Please enter a number between 1 and $($KeyVaults.Length)." -ForegroundColor Red
                        }
                    } else {
                        Write-Host "Invalid input. Please enter a number or 'x'." -ForegroundColor Red
                    }
                }
                return $KeyVaults[$choice - 1]
            }

            function Search-Option {
                param([string[]]$opts)
                $pattern = $null
                $taker = 0

                $selectedVault = $selectedOption -split ' '
                $filePathx = "C:\Users\$currentUsername\KeySecrets.txt"
                $KeySecrets = Get-Content -Path $filePathx

                if ($KeySecrets) {
                    if ($oldVault -ne $selectedVault[1]) {
                        $result = Get-SecretWithProgress -VaultName $selectedVault[1]
                        if ($result.Success) {
                            $result.Result > C:\Users\$currentUsername\KeySecrets.txt
                            $oldVault = $selectedVault[1]
                            Search-Option -opts $selectedOption
                        } else {
                            Write-Host "`n!! Permission Error !! You don't have access to this vault" -ForegroundColor Red
                            #Write-Host "Error Message: $($result.ErrorMessage)" -ForegroundColor Red
                            #Write-Host "Status Code: $($result.StatusCode)" -ForegroundColor Red
                            Read-Host -Prompt "Press Enter Key to continue/Clr+C to Cancel"
                            $selectedVault = $null
                            keyz
                        }
                    } else {
                        cls
                        Write-Host "Selected Location:" -NoNewline -ForegroundColor Magenta
						Write-Host "$selectedVault" -NoNewline -ForegroundColor Green
						Write-Host "|| (Press 'x' and Enter Key to list all SecretName)`n" -ForegroundColor Magenta
                        $pattern = Read-Host "Enter\Paste secret 'name'"
                        $ScList = Get-content "C:\Users\$currentUsername\KeySecrets.txt" | findstr $pattern
                        if ($pattern -match 'x') {
                            Write-Host "$selectedVault Secrets `n========================`n" -ForegroundColor Magenta
                            Get-content "C:\Users\$currentUsername\KeySecrets.txt"
							Write-Host "`nPlease copy SecretName," -NoNewline -ForegroundColor Magenta
                            Read-Host -Prompt "Press Enter key to continue" 
                            Search-Option -opts $selectedOption
                        } else {
                            if ($ScList.Count -eq 1) {
                                $opts = Get-AzKeyVaultSecret -VaultName $selectedVault[1] -Name $ScList -AsPlainText
                                Write-Host "`n=====================" -ForegroundColor DarkMagenta
                                Write-Host "SecretName : $ScList" -ForegroundColor Green
                                Write-Host "Password : $opts" -ForegroundColor DarkGray
                                Write-Host "===================== `n" -ForegroundColor DarkMagenta
                                Read-Host -Prompt "Press Enter Key to continue/Clr+C to Cancel"
                                keyz
                            }
                            if ($ScList.Count -gt 1) {
                                $taker = 0
                                Write-Host "`n"
                                for ($i = 0; $i -lt $ScList.Count; $i++) {
                                    Write-Host "$($i + 1). $($ScList[$i])"
                                }
                                Write-Host "`nSorry multiple entries !!`n" -ForegroundColor Red
                                [int]$taker = Read-Host "Enter secret number"
                                $opts = Get-AzKeyVaultSecret -VaultName $selectedVault[1] -Name $ScList[$taker -1] -AsPlainText
                                $SecretN = $ScList[$taker -1]
                                Write-Host "`n=====================" -ForegroundColor DarkMagenta
                                Write-Host "SecretName : $SecretN" -ForegroundColor Green
                                Write-Host "Password : $opts" -ForegroundColor DarkGray
                                Write-Host "===================== `n" -ForegroundColor DarkMagenta
                                Read-Host -Prompt "Press Enter to continue/Clr+C to Cancel"
                                keyz
                            }
                            if ($ScList.Count -lt 1) {
                                Write-Host "`nSorry no such host!`n" -ForegroundColor Red
                                Search-Option -opts $selectedOption
                            }
                        }
                    }
                } else {
                    $result = Get-SecretWithProgress -VaultName $selectedVault[1]
                    if ($result.Success) {
                        $result.Result > C:\Users\$currentUsername\KeySecrets.txt
                        $oldVault = $selectedVault[1]
                        Search-Option -opts $selectedOption
                    } else {
                        Write-Host "`n!! Permission Error !! You don't have access to this vault" -ForegroundColor Red
                        Write-Host "Error Message: $($result.ErrorMessage)" -ForegroundColor Red
                        Write-Host "Status Code: $($result.StatusCode)" -ForegroundColor Red
                        Read-Host -Prompt "Press Enter to continue/Clr+C to Cancel"
                        $selectedVault = $null
                        keyz
                    }
                }
            }
            Print-Option -opts $KeyVaultsx
            $selectedOption = Read-Option -opts $KeyVaultsx
            Search-Option -opts $selectedOption
        } else {
            $uniqueValue = Get-AzKeyVault | findstr /r "^Vault" | Select-String -Pattern '\b\w*kv-\w*-\w*-*\w*\b' -AllMatches
            foreach ($match in $uniqueValue.Matches) {
                $contentToAdd = "$number $match";
                Add-Content -Path "C:\Users\$currentUsername\KeyVaults.txt" -Value $contentToAdd;
                $number++
            }
            $filePath = "C:\Users\$currentUsername\KeyVaults.txt"
            $KeyVaults = Get-content $filePath
            $KeyVaultsx = $KeyVaults | findstr /i "ops email database BMC"
            keyz
        }
    } else {
        New-Item -Path C:\Users\$currentUsername\KeyVaults.txt -ItemType File
        New-Item -Path C:\Users\$currentUsername\KeySecrets.txt -ItemType File
        cls
        keyz
    }
}
keyz