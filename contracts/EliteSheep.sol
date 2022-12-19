// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract EliteSheep is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    using SafeMath for uint256;

    uint256 public constant mintPrice = 0.1 ether;
    uint public constant MAX_SUPPLY = 1000;
    uint public constant MAX_PER_MINT = 2;

    Counters.Counter private _tokenIds;
    string private baseURI;
	string private baseExt = ".json";

    constructor(string memory _initBaseURI) ERC721("Elite_Sheep", "ELT") {
        _tokenIds.increment();
		setBaseURI(_initBaseURI);
    }
 

    function mint (uint256 _quantity) public payable {
        require(totalSupply() + _quantity <= MAX_SUPPLY, "reached max supply");
        require(_quantity > 0 && _quantity <= MAX_PER_MINT, "Cannot mint specified number of NFTs.");
        require(msg.value >= mintPrice.mul(_quantity), "Not enough ether to purchase NFTs.");
        
         for (uint i = 0; i < _quantity; i++) {
            _mintNFT();
        }
    }

    function _mintNFT() private {
        uint newTokenID = _tokenIds.current();
        _safeMint(msg.sender, newTokenID);
        _tokenIds.increment();
    }

    // Base URI
	function _baseURI() internal view virtual override returns (string memory) {
		return baseURI;
	}

	// Set base URI
	function setBaseURI(string memory _newBaseURI) public {
		baseURI = _newBaseURI;
	}

	// Get metadata URI
	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token.");

		string memory currentBaseURI = _baseURI();
		return
			bytes(currentBaseURI).length > 0
				? string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId), baseExt))
				: "";
	}

    function withdraw() public payable onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0, "No ether left to withdraw");

        (bool success, ) = (msg.sender).call{value: balance}("");
        require(success, "Transfer failed.");
    }
    
    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

}
