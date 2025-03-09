// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

/**
 * @title ProfileNFT
 * @dev ERC721 representing user profiles with score tracking
 */
contract ProfileNFT is ERC721URIStorage, Ownable {
    // Profile structure
    struct Profile {
        uint256 id;
        uint256 score;
    }

    // Mapping from token ID to Profile
    mapping(uint256 => Profile) public profiles;

    // Factory contract address
    address public factoryAddress;

    // Event emitted when a profile score is updated
    event ScoreUpdated(uint256 indexed profileId, uint256 newScore);

    constructor(
        address initialOwner
    ) ERC721("SocialProfile", "SPROF") Ownable(initialOwner) {}

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

    // Create a new profile (only callable by factory)
    function mintProfile(
        address to,
        uint256 profileId,
        string memory tokenURI
    ) external onlyFactory returns (uint256) {
        _mint(to, profileId);
        _setTokenURI(profileId, tokenURI);

        profiles[profileId] = Profile({id: profileId, score: 0});

        return profileId;
    }

    // Update profile score (only callable by factory)
    function updateScore(
        uint256 profileId,
        uint256 newScore
    ) external onlyFactory {
        require(_ownerOf(profileId) != address(0), "Profile does not exist");
        profiles[profileId].score = newScore;
        emit ScoreUpdated(profileId, newScore);
    }

    // Get a profile's score
    function getProfileScore(
        uint256 profileId
    ) external view returns (uint256) {
        require(_ownerOf(profileId) != address(0), "Profile does not exist");
        return profiles[profileId].score;
    }
}
