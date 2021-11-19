// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AggregatorV3Interface.sol";

interface StupidAggregatorInterface is AggregatorV3Interface {
    function isOracleDead() external view returns (bool);
}
