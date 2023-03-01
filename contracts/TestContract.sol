// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./EnforcedRoyalty.sol";


contract TestContract is Ownable, ERC721, EnforcedRoyalty {

    uint256 totalMinted = 0;

    constructor() ERC721("NAME", "SYMBOL") EnforcedRoyalty(550, address(0)) {}

    function mint() external payable {
            _mint(msg.sender, 1);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        return Strings.toString(tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override {

        bool royaltyPaid = isRoyaltyPaid();

        if(royaltyPaid) _setRoyaltyPaid(false);

        if(from == msg.sender || from == address(0)) {
            super._beforeTokenTransfer(from, to, tokenId, batchSize);
            return;
        }
        
        require(royaltyPaid, "Royalty payment not recieved for transfer");
    
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function marketplaceTransferNFT(
        address from,
        address to,
        uint256 tokenId
    ) public payable {
        _handleRoyaltyPayment(msg.value, from);
        super.transferFrom(from, to, tokenId);
    }

}
