#
# Get all the Launcher IDs in your DID/NFT Wallet
#
# FINGERPRINT SELECTION
Write-Host ""
Write-Host "--Fingerprint Selection--"
$fingers = chia keys show | Select-String -Pattern "Label: (.*)", "Fingerprint: (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
$outcount = 1
$loopcount = 1
foreach ($record in $fingers) {
	if ($loopcount % 2 -eq 1) {
		#Write-Host "$number is an odd number."
		$option = [string]$outcount + ": " + [string]$record + " - "
	} else {
		#Write-Host "$number is not an odd number."
		$option += [string]$record
		Write-Host $option
		$outcount++
	}
	$loopcount++
}
$choice = Read-Host "Choose fingerprint to use"
$choice = [int]$choice * 2 - 1
$fingerprint = $fingers[$choice]
Write-Host "Selected fingerprint: $fingerprint" 
Write-Host ""

# WALLET ID SELECTION
Write-Host ""
Write-Host "--Wallet ID Selection--"
$wallet_ids = chia wallet show -w nft -f $fingerprint | Select-String -Pattern "(.*) NFT Wallet:", "-Wallet ID: (.*)" | ForEach-Object { $_.Matches.Groups[1].Value.Trim() }
$outcount = 1
$loopcount = 1
foreach ($record in $wallet_ids) {
	if ($loopcount % 2 -eq 1) {
		#Write-Host "$number is an odd number."
		$option = [string]$outcount + ": " + [string]$record + " - "
	} else {
		#Write-Host "$number is not an odd number."
		$option += [string]$record
		Write-Host $option
		$outcount++
	}
	$loopcount++
}
$choice = Read-Host "Choose Wallet ID to use"
$choice = [int]$choice * 2 - 1
$wallet_id = $wallet_ids[$choice]
Write-Host "Selected Wallet ID: $wallet_id" 
Write-Host ""

#$walletID = chia wallet show -f "$fingerprint" -w nft | Select-String "-Wallet ID:\s+(\d+)" | ForEach-Object { $_.Matches.Groups[1].Value }

$filename = Read-Host "Enter filename for results, or leave blank to print to screen"

if (-not [string]::IsNullOrWhiteSpace($filename)) {
	
	$launcherCoinID = ""
	$uri = ""
	$nextLineIsURI = $false
	
    #chia wallet nft list -f $fingerprint -i $wallet_id --num 1000 | Select-String "Launcher coin ID" | ForEach-Object { $_.Line.Substring(27) } | Out-File -FilePath $filename
	chia wallet nft list -f $fingerprint -i $wallet_id --num 1000 | 
	ForEach-Object { 
		if ($_ -match "Launcher coin ID:\s+(\S+)") {
			$launcherCoinID = $matches[1]
		}
		elseif ($_ -match "^URIs:") {
			$nextLineIsURI = $true
		}
		elseif ($nextLineIsURI) {
			$uri = $_.Trim()
			$nextLineIsURI = $false

			"$launcherCoinID $uri"
			if ($launcherCoinID -and $uri) {
				"$launcherCoinID $uri" | Out-File -FilePath $filename -Append
				$launcherCoinID = ""
				$uri = ""
			}
		}
	}
} else {
    chia wallet nft list -f $fingerprint -i $wallet_id --num 1000 | Select-String "Launcher coin ID" | ForEach-Object { $_.Line.Substring(27) }
}
