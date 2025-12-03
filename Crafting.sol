// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


import "@openzeppelin/contracts/access/Ownable.sol";


interface IArtifactNFT {
function ownerOf(uint256 tokenId) external view returns (address);
function burn(uint256 tokenId) external;
function mint(address to, string memory metadataHash) external returns (uint256);
}


contract Crafting is Ownable {
address public artifactContract;


event Crafted(address indexed who, uint256[] burnedIds, uint256 newId);


constructor(address _artifact) {
artifactContract = _artifact;
}


// Craft by burning two tokens (the artifact contract must expose a burn function callable by this contract)
function craft(uint256 a, uint256 b, string calldata resultMetadataHash) external {
IArtifactNFT art = IArtifactNFT(artifactContract);
require(art.ownerOf(a) == msg.sender && art.ownerOf(b) == msg.sender, "Must own both tokens");
art.burn(a);
art.burn(b);
uint256 newId = art.mint(msg.sender, resultMetadataHash);
emit Crafted(msg.sender, _asArray(a, b), newId);
}


function _asArray(uint256 x, uint256 y) private pure returns (uint256[] memory arr) {
arr = new uint256[](2);
arr[0] = x;
arr[1] = y;
}


function setArtifactContract(address _addr) external onlyOwner {
artifactContract = _addr;
}
}
