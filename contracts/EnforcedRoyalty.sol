// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract EnforcedRoyalty {

    uint256 royaltyPercent = 0; //550 is 5.5%
    address royaltyPayout = address(0);

    uint256 constant BASIS_POINTS = 10000;

    uint256 royaltyPaid = 1;

    modifier payRoyalty {
        royaltyPaid = 2;
        _;
        royaltyPaid = 1;
    }

    //Do we cap royalty percentage.
    constructor(uint256 percentage, address payoutAddress) {
        require(percentage <= BASIS_POINTS, "Royalty percentage can't be more than 100%");

        royaltyPercent = percentage;
        royaltyPayout = payoutAddress;
    }

    function isRoyaltyPaid() internal view returns (bool) {
        return royaltyPaid == 2;
    }

    function _handleRoyaltyPayment(uint256 cost, address from) internal payRoyalty {
        uint256 royaltyPayment = (cost * royaltyPercent) / BASIS_POINTS;
        uint256 remainder = cost - royaltyPayment;

        (bool royaltySuccess, ) = payable(royaltyPayout).call{value: royaltyPayment}("");
        require(royaltySuccess);

        (bool sellerSuccess, ) = payable(from).call{value: remainder}("");
        require(sellerSuccess);
    }

    function _changeRoyaltyData(uint256 percent, address to) internal {
        require(percent <= BASIS_POINTS, "Royalty percentage can't be more than 100%");

        royaltyPercent = percent;
        royaltyPayout = to;
    }

}