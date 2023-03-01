// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract EnforcedRoyalty {

    uint256 royaltyPercent = 0; //550 is 5.5%
    address royaltyPayout = address(0);

    uint256 constant BASIS_POINTS = 10000;

    uint256 royaltyPaid = 1;

    //Do we cap royalty percentage.
    constructor(uint256 percentage, address payoutAddress) {
        require(percentage <= BASIS_POINTS, "Royalty percentage can't be more than 100%");

        royaltyPercent = percentage;
        royaltyPayout = payoutAddress;
    }

    function isRoyaltyPaid() internal view returns (bool) {
        return royaltyPaid == 2;
    }

    function _handleRoyaltyPayment(uint256 cost, address from) internal {
        
        _setRoyaltyPaid(true);

        uint256 royaltyPayment = 0;

        if(cost == 0) return;

        if(royaltyPercent > 0)
            royaltyPayment = (cost * royaltyPercent) / BASIS_POINTS;


        if(royaltyPayment > 0) {
            (bool royaltySuccess, ) = payable(royaltyPayout).call{value: royaltyPayment}("");
            require(royaltySuccess);
        }

        (bool sellerSuccess, ) = payable(from).call{value: cost - royaltyPayment}("");
        require(sellerSuccess);
    }

    function _changeRoyaltyData(uint256 percent, address to) internal {
        require(percent <= BASIS_POINTS, "Royalty percentage can't be more than 100%");

        royaltyPercent = percent;
        royaltyPayout = to;
    }

    function _setRoyaltyPaid(bool state) internal {
        royaltyPaid = state ? 2 : 1;
    }

}