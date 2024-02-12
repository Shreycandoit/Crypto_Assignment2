// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.20;

contract VickreyAuction {
    /// @param seller The address selling the auctioned asset.
    /// @param startTime The unix timestamp at which bidding can start.
    /// @param endOfBiddingPeriod The unix timestamp after which bids can no
    ///        longer be placed.
    /// @param endOfRevealPeriod The unix timestamp after which commitments can
    ///        no longer be opened.
    /// @param numUnrevealedBids The number of bid commitments that have not
    ///        yet been opened.
    /// @param highestBid The value of the highest bid revealed so far, or
    ///        the reserve price if no bids have exceeded it.
    /// @param secondHighestBid The value of the second-highest bid revealed
    ///        so far, or the reserve price if no two bids have exceeded it.
    /// @param highestBidder The bidder that placed the highest bid.
    /// @param index Auctions selling the same asset (i.e. tokenContract-tokenId
    ///        pair) share the same storage. This value is incremented for
    ///        each new auction of a particular asset.
    struct Auction {
        address seller;
        uint32 startTime;
        uint32 endOfBiddingPeriod;
        uint32 endOfRevealPeriod;
        uint64 numUnrevealedBids;
        uint96 highestBid;
        uint96 secondHighestBid;
        address highestBidder;
        uint64 index;
    }

    /// @dev Representation of a bid in storage. Occupies one slot
    /// @param commitment The hash commitment of a bid value
    /// @param collateral The amount of collateral backing the bid
    struct Bid {
        bytes20 commitment;
        uint96 collateral;
    }

    /// @notice A mapping storing auction itemId and state
    mapping(uint256 => Auction) public auctions;

    /// @notice A mapping storing bid commitments and records of collateral,
    ///         indexed by item ID, auction index,
    ///         and bidder address. If the commitment is `bytes20(0)`, either
    ///         no commitment was made or the commitment was opened.
    mapping(
        uint256 // item ID
            => mapping(
                uint64 // Auction index
                    => mapping(
                        address // Bidder
                            => Bid
                    )
            )
    ) public bids;

    /// @notice Creates an auction for the given physical asset with the given
    ///         auction parameters.
    /// @param itemId The physical asset being auctioned.
    /// @param startTime The unix timestamp at which bidding can start.
    /// @param bidPeriod The duration of the bidding period, in seconds.
    /// @param revealPeriod The duration of the commitment reveal period,
    ///        in seconds.
    /// @param reservePrice The minimum price that the asset will be sold for.
    ///        If no bids exceed this price, the asset is returned to `seller`.
    function createAuction(uint256 itemId, uint32 startTime, uint32 bidPeriod, uint32 revealPeriod, uint96 reservePrice)
        external
    {}

    /// @notice Commits to a bid on an item being auctioned. If a bid was
    ///         previously committed to, overwrites the previous commitment.
    ///         Value attached to this call is used as collateral for the bid.
    /// @param itemId The item ID of the asset being auctioned.
    /// @param commitment The commitment to the bid, computed as
    ///        `bytes20(keccak256(abi.encode(nonce, bidValue, tokenContract, tokenId, auctionIndex)))`.
    function commitBid(uint256 itemId, bytes20 commitment) external payable {}

    /// @notice Reveals the value of a bid that was previously committed to.
    /// @param itemId The item ID of the asset being auctioned.
    /// @param bidValue The value of the bid.
    /// @param nonce The random input used to obfuscate the commitment.
    function revealBid(uint256 itemId, uint96 bidValue, bytes32 nonce) external {}

    /// @notice Ends an active auction. Can only end an auction if the bid reveal
    ///         phase is over, or if all bids have been revealed. Disburses the auction
    ///         proceeds to the seller. Transfers the auctioned asset to the winning
    ///         bidder and returns any excess collateral. If no bidder exceeded the
    ///         auction's reserve price, returns the asset to the seller.
    /// @param itemId The item ID of the asset auctioned.
    function endAuction(uint256 itemId) external {}

    /// @notice Withdraws collateral. Bidder must have opened their bid commitment
    ///         and cannot be in the running to win the auction.
    /// @param itemId The item ID of the asset that was auctioned.
    /// @param auctionIndex The index of the auction that was being bid on.
    function withdrawCollateral(uint256 itemId, uint64 auctionIndex) external {}

    /// @notice Gets the parameters and state of an auction in storage.
    /// @param itemId The item ID of the asset auctioned.
    function getAuction(uint256 itemId) external view returns (Auction memory auction) {}
}
