// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe{
    uint256 public minimumUSD=5e18;

    address public i_owner;

    address[] public funding;
    mapping(address funder => uint256 amountFunded) public amtToFunded;

    constructor(){
        i_owner=msg.sender;
    }

    function fund() public payable {
        require(getConversionRate(msg.value)>=minimumUSD,"Didn't send enough money");
        funding.push(msg.sender);
        amtToFunded[msg.sender]+=msg.value;
    }

    modifier onlyOwner {
        require(msg.sender == i_owner);
        _;
    }

    function withdraw() public{
        for (uint256 funderIndex=0; funderIndex < funding.length; funderIndex++){
            address funder = funding[funderIndex];
            amtToFunded[funder] = 0;
        }
        funding = new address[](0);
        
        (bool callSuccess,)=payable (msg.sender).call{value:address(this).balance}("");
        require(callSuccess,"Call failed");

    }
    function getPrice()public view returns (uint256){
        //Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        AggregatorV3Interface priceFeed=AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,)=priceFeed.latestRoundData();
        return uint256(price*1e10);
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice=getPrice();
        uint256 ethAmountUSD=(ethAmount*ethPrice)/1e18;
        return ethAmountUSD;
    }

    function getVersion() public view returns (uint256) {
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}