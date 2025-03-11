// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

/**
 * @title TweetNFT
 * @dev ERC721 representing tweets with engagement metrics
 */
contract TweetNFT is ERC721URIStorage, Ownable {
    // Tweet structure
    struct Tweet {
        uint256 id;
        uint256 profileId;
        uint256 likes;
        uint256 retweets;
        uint256 comments;
        uint256 timestamp;
    }

    // Mapping from token ID to Tweet
    mapping(uint256 => Tweet) public tweets;

    // Factory contract address
    address public factoryAddress;

    constructor(
        address _factoryAddress
    ) ERC721("SocialTweet", "STWT") Ownable(msg.sender) {
        factoryAddress = _factoryAddress;
    }

    // Modifier to ensure only the factory can call certain functions
    modifier onlyFactory() {
        require(
            msg.sender == factoryAddress,
            "Only factory can call this function"
        );
        _;
    }

    // Set the factory address
    function setFactoryAddress(address _factoryAddress) external onlyOwner {
        factoryAddress = _factoryAddress;
    }

    // Create a new tweet (only callable by factory)
    function mintTweet(
        address to,
        uint256 tweetId,
        uint256 profileId,
        string memory tokenURI
    ) external onlyFactory returns (uint256) {
        _mint(to, tweetId);
        _setTokenURI(tweetId, tokenURI);

        tweets[tweetId] = Tweet({
            id: tweetId,
            profileId: profileId,
            likes: 0,
            retweets: 0,
            comments: 0,
            timestamp: block.timestamp
        });

        return tweetId;
    }

    // Update tweet engagement metrics (only callable by factory)
    function updateEngagement(
        uint256 tweetId,
        uint256 likes,
        uint256 retweets,
        uint256 comments
    ) external onlyFactory {
        require(_ownerOf(tweetId) != address(0), "Tweet does not exist");

        Tweet storage tweet = tweets[tweetId];
        tweet.likes = likes;
        tweet.retweets = retweets;
        tweet.comments = comments;
    }

    // Get tweet engagement metrics
    function getTweetEngagement(
        uint256 tweetId
    )
        external
        view
        returns (uint256 likes, uint256 retweets, uint256 comments)
    {
        require(_ownerOf(tweetId) != address(0), "Tweet does not exist");
        Tweet storage tweet = tweets[tweetId];
        return (tweet.likes, tweet.retweets, tweet.comments);
    }

    // Get profile ID associated with a tweet
    function getTweetProfileId(
        uint256 tweetId
    ) external view returns (uint256) {
        require(_ownerOf(tweetId) != address(0), "Tweet does not exist");
        return tweets[tweetId].profileId;
    }
}
