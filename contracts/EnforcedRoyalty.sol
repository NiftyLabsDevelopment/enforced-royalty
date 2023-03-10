// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EnforcedRoyalty {

    uint256 royaltyPercent = 0; //550 is 5.5%
    address royaltyPayout = address(0);
    address paymentToken = address (0);

    uint256 constant BASIS_POINTS = 10000;

    uint256 royaltyPaid = 1;

    //do we cap royalty percentage?
    constructor(uint256 percentage, address payoutAddress, address erc20Token) {
        require(percentage <= BASIS_POINTS, "Royalty percentage can't be 100% or more");

        royaltyPercent = percentage;
        royaltyPayout = payoutAddress;
        paymentToken = erc20Token;
    }

    function isRoyaltyPaid() internal view returns (bool) {
        return royaltyPaid == 2;
    }

    function _handleRoyaltyPaymentWithEth(uint256 cost, address from) internal {

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

    function _handleRoyaltyPaymentWithWETH(uint256 cost, address from) internal {

        _setRoyaltyPaid(true);

        uint256 royaltyPayment = 0;

        if(cost == 0) return;

        if(royaltyPercent > 0)
            royaltyPayment = (cost * royaltyPercent) / BASIS_POINTS;


        if(royaltyPayment > 0) {
            IERC20(paymentToken).transferFrom(
                address(this),
                royaltyPayout,
                royaltyPayment
            );
        }

        IERC20(paymentToken).transferFrom(
            address(this),
            from,
            cost - royaltyPayment
        );
    }

    function _checkRoyalty(address from) internal {

        bool wasRoyaltyPaid = isRoyaltyPaid();

        if(wasRoyaltyPaid) _setRoyaltyPaid(false);

        if(from == msg.sender || from == address(0))
            return;
        
        require(wasRoyaltyPaid, "Royalty payment not recieved for transfer");
    }

    function _changeRoyaltyData(uint256 percent, address to, address erc20Token) internal {
        require(percent <= BASIS_POINTS, "Royalty percentage can't be more than 100%");

        royaltyPercent = percent;
        royaltyPayout = to;
        paymentToken = erc20Token;
    }

    function _setRoyaltyPaid(bool state) internal {
        royaltyPaid = state ? 2 : 1;
    }

}
