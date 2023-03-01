_**Note**: This is for discussion purposes only and has not been tested. This method does not currently support erc20 (WETH)_

## HOW IT WORKS 

Force the Operator (Marketplace Contract) to instead call marketplaceTransferNFTWithETH and to include a msg.value of a royalty & sellers fee.

The NFT contract will then pay the seller and take the royalty fee.

By overriding _beforeTokenTransfer if the operator is a marketplace we can check if that royalty has been paid and fails if not.

Transfers that are operated from the owner of the token can be transfered via standard calls (i.e. safe transfer)
