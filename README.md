_**Note**: This is for discussion purposes only and has not been throughly tested._

## HOW IT WORKS 

Force the Operator (Marketplace Contract) to instead call marketplaceTransferNFTWithETH and to include a msg.value of a royalty & sellers fee.

For WETH/Bids, marketplaceTransferNFTWithWETH is called and includes a cost amount. **WETH must be sent to the contract prior to calling this function in the same transaction** _This method has not be tested._

The NFT contract will then pay the seller and take the royalty fee.

By overriding _beforeTokenTransfer if the operator is a marketplace we can check if that royalty has been paid and fails if not.

Transfers that are operated from the owner of the token can be transfered via standard calls (i.e. safe transfer)
