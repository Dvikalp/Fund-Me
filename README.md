# Getting started
1. Go to [Remix](https://remix.ethereum.org/)
2. Paste the code from `FundMe.sol` into new files in Remix
3. Hit `Compile`
4. Hit `Deploy`
   
# FundMe
The "FundMe" smart contract is designed to allow users to fund it with Ether (ETH) and keeps track of the amount each address has contributed. It enforces a minimum funding amount in USD and provides a withdrawal function accessible only to the contract owner. The contract also includes receive and fallback functions to receive ETH transactions. It uses Chainlink's AggregatorV3Interface for price conversion and employs the PriceConverter library for conversion calculations.   
