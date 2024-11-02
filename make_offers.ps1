# 
# Create offer files for NFTs. Assume all are priced at same amount. Filename will be the NFT ID with an extension of ".offer"
# 
# NOTE: Using the RPC to create the offers requires us to have the Launcher ID for the NFT, not the NFT ID. The input file should contain a list of Launcher IDs.
#       I wrote a script for that also called 'get_launcherids.ps1'
#

$blockchains = @("chia","aba")
Write-Host "--Blockchain Selection--"
$outcount = 1
$loopcount = 1
foreach ($chain in $blockchains) {
	#if ($loopcount % 2 -eq 1) {
	#	$option = [string]$outcount + ": " + [string]$chain + " - "
	#} else {
	#	
	#}
	$option = "$loopcount. " + [string]$chain
	Write-Host $option
	$outcount++
	$loopcount++
}
$choice = Read-Host "Choose blockchain"
$choice = [int]$choice - 1
$blockchain = $blockchains[$choice]
Write-Host "Selected blockchain: $blockchain"
Write-Host ""

$fee = Read-Host "Enter fee amount in mojos"
$price = Read-Host "Enter price amount"
$cat = Read-Host "Enter the Wallet ID for price. 1 for XCH"

$subfolderPath = Read-Host "Enter folder for offer files"

if (-not (Test-Path -Path $subfolderPath -PathType Container)) {
    New-Item -Path $subfolderPath -ItemType Directory | Out-Null
    Write-Host "Folder created: $subfolderPath"
} else {
    Write-Host "Folder already exists: $subfolderPath"
}
$filename = Read-Host "Enter filename with Launcher Coin IDs for offers"

$total_lines = (Get-Content -Path $filename | Where-Object { $_ -ne "" }).Count

$fileContent = Get-Content -Path $filename

foreach ($line in $fileContent) {
    Write-Host "Processing: $line"
	Set-Content -Path "tempfile.json" -Value "{""offer"":{""$cat"":$price,""$line"":-1},""fee"":$fee,""driver_dict"":{},""validate_only"":false}"
	$jsonResponse = Invoke-Expression "$blockchain rpc wallet create_offer_for_ids -j tempfile.json"
	$jsonObject = $jsonResponse | ConvertFrom-Json
	$offer = $jsonObject.offer
	Set-Content -Path "$subfolderPath\$line.offer" -Value $offer
}
Remove-Item -Path "tempfile.json"
Write-Host "Done."
