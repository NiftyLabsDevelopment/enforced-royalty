// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./EnforcedRoyalty.sol";

contract TestContract is Ownable, ERC721, EnforcedRoyalty {
    uint256 totalMinted = 0;

    constructor(
        uint256 royaltyPercentage,
        address royaltyAddress,
        address paymentToken
    )
        ERC721("NAME", "SYMBOL")
        EnforcedRoyalty(royaltyPercentage, royaltyAddress, paymentToken) {}

    function mint(uint256 amount) external payable {
        uint256 id = totalMinted + 1;

        for(uint i = 0; i < amount; i++)
            _safeMint(msg.sender, id++);

        totalMinted = id;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        return Strings.toString(tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override {
        _checkRoyalty(from);

        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function marketplaceTransferNFTWithETH(
        address from,
        address to,
        uint256 tokenId
    ) public payable {
        _handleRoyaltyPaymentWithEth(msg.value, from);

        super.transferFrom(from, to, tokenId);
    }

    function marketplaceTransferNFTWithWETH(
        address from,
        address to,
        uint256 tokenId,
        uint256 cost
    ) public {
        _handleRoyaltyPaymentWithWETH(cost, from);

        super.transferFrom(from, to, tokenId);
    }

}
