// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/StupidAggregatorInterface.sol";
import "hardhat/console.sol";

contract StupidOracle is Ownable, StupidAggregatorInterface {
    uint80 public roundId;
    uint8 public override decimals;
    uint256 public override version;
    string public override description;
    uint256 public constant ALLOWED_NAP_TIME = 2 hours;

    struct Round {
        int256 price;
        uint256 startedAt;
        uint256 updatedAt;
    }

    mapping(uint80 => Round) private rounds;
    mapping(address => bool) public whitelisted;

    /****************************
     *      Events
     ****************************/
    event WhitelistedChanged(address indexed user, bool indexed whitelisted);

    /****************************
     *      MODIFIERS
     ****************************/
    modifier hasData() {
        require(roundId > 0, "no data");
        _;
    }

    constructor(
        uint8 _decimals,
        address _reporter,
        string memory _description
    ) Ownable() {
        roundId = 0;
        decimals = _decimals;
        whitelisted[_reporter] = true;
        version = 1;
        description = _description;
    }

    function latestRound() external view override returns (uint256) {
        return roundId;
    }

    function latestRoundData()
        external
        view
        override
        hasData
        returns (
            uint80 id,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        return (roundId, rounds[roundId].price, rounds[roundId].startedAt, rounds[roundId].updatedAt, 1);
    }

    function getRoundData(uint80 _roundId)
        external
        view
        override
        hasData
        returns (
            uint80 id,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        return (_roundId, rounds[_roundId].price, rounds[_roundId].startedAt, rounds[_roundId].updatedAt, 1);
    }

    function isOracleDead() external view hasData returns (bool) {
        if (block.timestamp >= rounds[roundId].updatedAt + ALLOWED_NAP_TIME) {
            return true;
        }
        return false;
    }

    /****************************
     *    ADMIN FUNCTIONS
     ****************************/
    function setWhitelisted(address user, bool isWhitelisted) external onlyOwner {
        whitelisted[user] = isWhitelisted;
        emit WhitelistedChanged(user, isWhitelisted);
    }

    function pushRound(int256 _price, uint256 _startedAt) external onlyOwner {
        require(whitelisted[msg.sender] == true, "no hack please");
        uint80 nextRoundId = roundId + 1;
        rounds[nextRoundId] = Round(_price, _startedAt, block.timestamp);
        roundId++;
    }
}
