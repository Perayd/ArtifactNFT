const { ethers } = require('hardhat');


async function main() {
const [deployer] = await ethers.getSigners();
console.log('Deploying from', deployer.address);


const Artifact = await ethers.getContractFactory('ArtifactNFTWithBurn');
const artifact = await Artifact.deploy('CipherArtifacts', 'CART', 'https://example.com/metadata/');
await artifact.deployed();
console.log('Artifact at', artifact.address);


// Example answer: "the final key"
const answer = ethers.utils.keccak256(ethers.utils.toUtf8Bytes('the final key'));
const Chapter = await ethers.getContractFactory('CipherChapter');
const chapter = await Chapter.deploy(answer, artifact.address);
await chapter.deployed();
console.log('Chapter at', chapter.address);


const Crafting = await ethers.getContractFactory('Crafting');
const crafting = await Crafting.deploy(artifact.address);
await crafting.deployed();
console.log('Crafting at', crafting.address);


// Transfer ownership of artifact to deployer (already owner) or set up minter roles as needed
}


main().catch((e) => {
console.error(e);
process.exit(1);
});
