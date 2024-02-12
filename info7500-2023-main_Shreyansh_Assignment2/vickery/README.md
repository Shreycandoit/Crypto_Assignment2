# Vickery Auction

Reading:
* https://a16zcrypto.com/posts/article/how-auction-theory-informs-implementations/


1. Initialize a foundry project.

2. Copy the skeleton contract `BasicVickreyAuction.sol` in this directory into your foundry project.

3. Develop comprehensive test cases to thoroughly evaluate your contract's functionalities.

4. Generate a Solidity coverage report to ensure 100% line and branch coverage of your contract code. 

5. Half of your score of the assignment will be based on the quality of your test cases. We will make random mutations to your code, and your test cases should catch these changes. For example, we may remove a modifier on a function or swap the order of arguments in a call. Of course, you may assume that these changes won't introduce any compilation errors.

6. Your submission should be a zip file that contains only your smart contract files and your test files. 

## Specification

* **Seller Setup:**
   - Implement the `createAuction` function, allowing a seller to list a physical item for auction. This function should permit the seller to set parameters like `startTime`, `bidPeriod`, `revealPeriod`, and `reservePrice`.
   - The auction begins at the block in which the contract is created.

* **Bidding:**
   - Implement the `commitBid` function, which permits interested bidders to commit their bids for an item with the price of their choice. Bidders should send Ether as collateral. Ensure that bidders can only commit bids after the `startTime` set by the seller has passed and until the start of the `revealPeriod`.
  
* **Bid Reveal:**
   - Implement the `revealBid` function. Bidders should be able to reveal their bids during the `revealPeriod` using the `bidValue` and a `nonce`. Prevent bids from being submitted after this period.
  
* **Auction Completion:**
   - Implement the `endAuction` function, allowing the auction to be completed after all bidders have revealed their bids. Ensure that the winning bidder is determined, the asset is transferred, collateral is managed, and cases where the reserve price is not exceeded are handled.
  
* **Withdraw Collateral:**
   - Implement the `withdrawCollateral` function, enabling non-winning bidders to withdraw their bid collateral after the auction ends.
