# MakeNFTOffers
Two Powershell scripts to create offers for NFTs on the Chia Blockchain. 

## How to use

1. First you'll need a file with all the Launcher IDs for your NFTs. You can create this file using the first script `get_launcherids.ps1`. The resulting file will contain a single line for each NFT with both the Launcher ID and then first URI for the NFT. I use the URI to determine which Launcher IDs I want to keep to make offers for since the script will pull IDs for every NFT in the wallet and you may not want to create offers for every NFT. You will need to edit the file once created to remove the URIs from the file. 

	To run the script:  `.\get_launcherids.ps1`
	
	The script is interactive so will prompt you with any questions to answer before running.

2. Then you will run the `make_offers.ps1` script and use the ID file you created in step 1. Note that the price is based on mojos. For example if you want to price at 1 $XCH, you'll use 1000000000000. If you want to use a CAT you'll need to times your value by 1000 to get the correct number of mojos. So 35 $SBX would be 35000 for the amount. I also recommend using 0 for the fee amount. If you use more than 0, the offer will tie up a coin in your wallet which you don't want.

	To run the script:  `.\make_offers.ps1`
	
	The script is interactive so will prompt you with any questions to answer before running.
