// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import '../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol';
import '../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '../lib/openzeppelin-contracts/contracts/utils/Counters.sol';

contract Counter is ERC721, ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    uint public totalSupply = 100;
    uint256 public constant MAX_SUPPLY = 100;

    uint public price = 0.01 ether;

    uint public maxPerUser = 5;

    address public owner;

    uint public balance;

    string public image = 'ipfs://QmdnjkbWezYMJ8ssjGKGyC8YfXRJWcYGAM5XqWFUPpbWis';

    constructor() ERC721("MyToken", "MTK") {
        owner = msg.sender;
    }

    function safeMint(uint256 numberOfNfts) public payable {
        require(msg.value >= price, 'insufficient funds');
        require(numberOfNfts < maxPerUser, 'cannot mint more than 5 NFTs');
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, image);
    }

    function withdraw() public {
        uint256 ownerBalance = address(this).balance;
        require(ownerBalance > 0, "Owner has not balance to withdraw");
        require(msg.sender == owner, 'You have to be the owner to make this call');
        (bool success, ) = msg.sender.call{value: ownerBalance}("");
        require(success, "function 'withdraw' failed!");
        //emit withdraw(msg.sender, ownerBalance);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}