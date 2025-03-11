// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "./ProfileNFT.sol";
import "./TweetNFT.sol";

/**
 * @title Factory
 * @dev Factory contract to create and manage profiles and tweets
 */
contract Factory is Ownable, Pausable {
    uint256 private _profileCounter;
    uint256 private _tweetCounter;

    // Contract instances
    ProfileNFT public profileNFT;
    TweetNFT public tweetNFT;

    // Score calculation parameters
    uint256 public likeWeight = 1;
    uint256 public retweetWeight = 1;
    uint256 public commentWeight = 1;

    // Events
    event ProfileCreated(address indexed owner, uint256 indexed profileId);
    event TweetCreated(
        address indexed owner,
        uint256 indexed tweetId,
        uint256 indexed profileId
    );
    event EngagementUpdated(
        uint256 indexed tweetId,
        uint256 likes,
        uint256 retweets,
        uint256 comments
    );

    constructor() Ownable(msg.sender) {
        // // Deploy child contracts
        // profileNFT = new ProfileNFT(address(this));
        // tweetNFT = new TweetNFT(address(this));
        // // Set factory address in child contracts
        // profileNFT.setFactoryAddress(address(this));
        // tweetNFT.setFactoryAddress(address(this));
        // // Transfer ownership of child contracts to the deployer
        // profileNFT.transferOwnership(msg.sender);
        // tweetNFT.transferOwnership(msg.sender);
    }

    /**
     * @dev Initialize the ProfileNFT and TweetNFT contract addresses
     * @param _profileNFTAddress The address of the ProfileNFT contract
     * @param _tweetNFTAddress The address of the TweetNFT contract
     */
    function initializeNFTContracts(
        address _profileNFTAddress,
        address _tweetNFTAddress
    ) external onlyOwner {
        profileNFT = ProfileNFT(_profileNFTAddress);
        tweetNFT = TweetNFT(_tweetNFTAddress);
    }

    /**
     * @dev Create a new profile
     * @param tokenURI The metadata URI for the profile NFT
     * @return profileId The ID of the created profile
     */
    function createProfile(
        string memory tokenURI
    ) external whenNotPaused returns (uint256) {
        _profileCounter += 1;
        uint256 profileId = _profileCounter;

        profileNFT.mintProfile(msg.sender, profileId, tokenURI);

        emit ProfileCreated(msg.sender, profileId);
        return profileId;
    }

    /**
     * @dev Create a new tweet
     * @param profileId The profile ID of the tweet creator
     * @param tokenURI The metadata URI for the tweet NFT
     * @return tweetId The ID of the created tweet
     */
    function createTweet(
        uint256 profileId,
        string memory tokenURI
    ) external whenNotPaused returns (uint256) {
        // Ensure the sender owns the profile
        require(
            profileNFT.ownerOf(profileId) == msg.sender,
            "You don't own this profile"
        );

        _tweetCounter += 1;
        uint256 tweetId = _tweetCounter;

        tweetNFT.mintTweet(msg.sender, tweetId, profileId, tokenURI);

        emit TweetCreated(msg.sender, tweetId, profileId);
        return tweetId;
    }

    /**
     * @dev Update engagement metrics for a tweet and recalculate profile score
     * @param tweetId The ID of the tweet to update
     * @param likes New likes count
     * @param retweets New retweets count
     * @param comments New comments count
     */
    function updateEngagement(
        uint256 tweetId,
        uint256 likes,
        uint256 retweets,
        uint256 comments
    ) external onlyOwner whenNotPaused {
        // Update tweet engagement metrics
        tweetNFT.updateEngagement(tweetId, likes, retweets, comments);

        // Get the profile ID associated with the tweet
        uint256 profileId = tweetNFT.getTweetProfileId(tweetId);

        // Recalculate the profile score
        calculateAndUpdateScore(profileId, tweetId);

        emit EngagementUpdated(tweetId, likes, retweets, comments);
    }

    /**
     * @dev Calculate and update the score for a profile based on all its tweets
     * @param profileId The profile ID to update
     */
    function calculateAndUpdateScore(
        uint256 profileId,
        uint256 tweetId
    ) public whenNotPaused {
        uint256 totalScore = 0;

        // In a real implementation, you would iterate through all tweets owned by the profile
        // For simplicity, we're assuming we have a way to get all tweet IDs for a profile
        // This would typically be implemented with additional mappings or arrays

        // For each tweet, calculate engagement score
        // Note: This is a simplified example. In a real contract, you would need to track
        // tweet ownership and iterate through all tweets belonging to a profile

        // Example calculation for a single tweet (in reality would sum all tweets):
        // uint256 tweetId = someTweetIdForProfile;
        (uint256 likes, uint256 retweets, uint256 comments) = tweetNFT
            .getTweetEngagement(tweetId);
        totalScore +=
            (likes * likeWeight) +
            (retweets * retweetWeight) +
            (comments * commentWeight);

        // For demonstration, we'll just use a placeholder calculation
        // In a real implementation, you would sum scores from all tweets

        // Update the profile score
        profileNFT.updateScore(profileId, totalScore);
    }

    /**
     * @dev Update the weights used for score calculation
     * @param _likeWeight New weight for likes
     * @param _retweetWeight New weight for retweets
     * @param _commentWeight New weight for comments
     */
    function updateWeights(
        uint256 _likeWeight,
        uint256 _retweetWeight,
        uint256 _commentWeight
    ) external onlyOwner {
        likeWeight = _likeWeight;
        retweetWeight = _retweetWeight;
        commentWeight = _commentWeight;
    }

    /**
     * @dev Pause the contract
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @dev Unpause the contract
     */
    function unpause() external onlyOwner {
        _unpause();
    }
}
