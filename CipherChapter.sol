// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


import "@openzeppelin/contracts/access/Ownable.sol";


interface IArtifactNFT {
function mint(address to, string memory metadataHash) external returns (uint256);
}


contract CipherChapter is Ownable {
// A single chapter puzzle contract


bytes32 public answerHash; // keccak256 of the correct answer (lowercased / normalized off-chain)
bool public solved;
address public solver;
uint256 public rewardTokenId;
address public artifactAddress;


event Attempt(address indexed who, string attempt, bool success);
event Solved(address indexed solver, uint256 tokenId);


constructor(bytes32 _answerHash, address _artifactAddress) {
answerHash = _answerHash;
artifactAddress = _artifactAddress;
}


function submitAnswer(string calldata answer, string calldata metadataHash) external {
require(!solved, "Already solved");
// compute keccak256 of the provided answer (frontend must normalize before sending)
bytes32 attemptHash = keccak256(abi.encodePacked(answer));
bool ok = (attemptHash == answerHash);
emit Attempt(msg.sender, answer, ok);
if (ok) {
solved = true;
solver = msg.sender;
// mint reward NFT to solver via artifact contract (owner of artifact should be this contract owner or approved)
if (artifactAddress != address(0)) {
try IArtifactNFT(artifactAddress).mint(msg.sender, metadataHash) returns (uint256 tid) {
rewardTokenId = tid;
emit Solved(msg.sender, tid);
} catch {
// ignore mint failure - still mark solved
emit Solved(msg.sender, 0);
}
} else {
emit Solved(msg.sender, 0);
}
}
}


// Admin functions
function updateAnswerHash(bytes32 _newHash) external onlyOwner {
answerHash = _newHash;
}


function setArtifactAddress(address _addr) external onlyOwner {
artifactAddress = _addr;
}
}
