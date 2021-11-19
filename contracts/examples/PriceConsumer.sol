// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "../interfaces/AggregatorV3Interface.sol";

contract PriceConsumerV3 {
    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Kovan
     * Aggregator: ETH/USD
     * Address: 0x9326BFA02ADD2366b30bacB125260Af641031331
     */
    constructor(address _oracle) {
        priceFeed = AggregatorV3Interface(_oracle);
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (int256) {
        (uint80 roundID, int256 price, uint256 startedAt, uint256 timeStamp, uint80 answeredInRound) = priceFeed
            .latestRoundData();
        return price;
    }
}
