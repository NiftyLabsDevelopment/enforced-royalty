_**Note**: This code is for discussion purposes only and has not been tested thoroughly._

## HOW IT WORKS 

Force the NFT operator (marketplace contract) to instead call marketplaceTransferNFT and to include a msg.value of the royalty fee + sellers fee.

The NFT contract will then pay the seller and take the royalty fee.

By overriding _beforeTokenTransfer if the operator is a marketplace we can check if that royalty has been paid and fails if not.

