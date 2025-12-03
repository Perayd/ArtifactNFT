// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract ArtifactNFT is ERC721Enumerable, Ownable {
using Strings for uint256;


string public baseURI;
uint256 public nextTokenId = 1;


mapping(uint256 => string) private _tokenHashes;


constructor(string memory _name, string memory _symbol, string memory _baseURI) ERC721(_name, _symbol) {
baseURI = _baseURI;
}


function mint(address to, string memory metadataHash) external onlyOwner returns (uint256) {
uint256 id = nextTokenId++;
_safeMint(to, id);
_tokenHashes[id] = metadataHash;
return id;
}


function tokenURI(uint256 tokenId) public view override returns (string memory) {
require(_exists(tokenId), "Token does not exist");
string memory hash = _tokenHashes[tokenId];
if (bytes(hash).length == 0) {
return string(abi.encodePacked(baseURI, tokenId.toString()));
}
return string(abi.encodePacked(baseURI, "ipfs/", hash));
}


function setBaseURI(string memory _baseURI) external onlyOwner {
baseURI = _baseURI;
}
