# Momo Smart Contract

This project demonstrates a smart contract for tracking Twitter engagement and rewarding creators with NFTs. The contract is deployed on the Monad testnet.

## Factory Address

Monad testnet: `0x5FbDB2315678afecb367f032d93F642f64180aa3`

## Prerequisites

- [Node.js](https://nodejs.org/)
- [Hardhat](https://hardhat.org/)

## Installation

1. Install dependencies:

    ```shell
    pnpm install
    ```

2. Compile the contracts:

    ```shell
    pnpm hardhat compile
    ```

## Deployment

1. Deploy the contracts to the Monad testnet:

    ```shell
    pnpm hardhat run scripts/deploy.js --network monadTestnet
    ```

2. Verify the deployment:

    ```shell
    pnpm hardhat verify --network monadTestnet <DEPLOYED_CONTRACT_ADDRESS>
    ```

## Usage

### Interacting with the Contract

1. Start a local node:

    ```shell
    pnpm hardhat node
    ```

2. Deploy the contract locally:

    ```shell
    pnpm hardhat run scripts/deploy.js --network localhost
    ```

3. Interact with the contract using the Hardhat console:

    ```shell
    pnpm hardhat console --network localhost
    ```

    Example commands:

    ```javascript
    const Momo = await ethers.getContractFactory("Momo");
    const momo = await Momo.attach("<DEPLOYED_CONTRACT_ADDRESS>");

    // Take a tweet snapshot
    await momo.takeTweetSnapshot(
        "0xCreatorAddress",
        "tweetId123",
        1000, // views
        100,  // retweets
        50,   // comments
        200,  // likes
        "https://metadata.url"
    );

    // Get creator's score
    const score = await momo.getCreatorScore("0xCreatorAddress");
    console.log("Creator's score:", score.toString());
    ```

### Admin Functions

- **Pause the contract:**

    ```javascript
    await momo.pauseEvent();
    ```

- **Restart the contract:**

    ```javascript
    await momo.restartEvent();
    ```

- **Update multipliers:**

    ```javascript
    await momo.updateMultipliers(2, 3, 1);
    ```

- **Update NFT metadata:**

    ```javascript
    await momo.updateNFTMetadata(
        1,     // tokenId
        1500,  // views
        200,   // retweets
        100,   // comments
        300,   // likes
        "https://new.metadata.url"
    );
    ```

## Testing

Run the tests:

```shell
pnpm hardhat test
```

## License

This project is licensed under the MIT License.