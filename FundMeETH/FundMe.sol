// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// 以ETH计价的fundMe

contract FundMe {
    // record the number of funding times
    uint public fundingCount = 0;

    address[] public funders;
    mapping(address => uint256) public fundingMap;

    uint256 public constant MINIMUM_ETH_TO_FUND = 1e17;
    address public immutable owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value >= MINIMUM_ETH_TO_FUND, "Plz fund more than 0.1 ETH");

        fundingCount ++;
        funders.push(msg.sender);
        fundingMap[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(owner == msg.sender, "Only owner can withdraw");

        payable(owner).transfer(address(this).balance);

        fundingCount = 0;
        for (uint256 index = 0; index < funders.length; index++) {
            fundingMap[funders[index]] = 0;
        }
        funders = new address[](0);
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}

