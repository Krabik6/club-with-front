// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract club {
    NFT nft;
    TOKEN token;

    struct member {
        address _address;
        bool adult;
    }

    mapping(address => member) public members;

    member[] arrayMembers;

    uint index;

    constructor() {
        nft = new NFT();
        token = new TOKEN();
        members[msg.sender] = member({_address: msg.sender, adult: true});

        arrayMembers.push(members[msg.sender]);

        nft.safeMint(msg.sender);
        token.mint(msg.sender, 100);
    }

    function nft_address() public view returns (address) {
        return address(nft);
    }

    modifier isAdult() {
        require(members[msg.sender].adult == true);
        _;
    }

    function addMember(
        address _address,
        bool _adult,
        string memory
    ) public isAdult {
        require(
            members[_address]._address == address(0),
            "already existing user"
        );
        members[_address] = member({_address: _address, adult: _adult});
        arrayMembers.push(members[_address]);

        nft.safeMint(_address);
        token.mint(_address, 100);
    }

    function deleteMember(address _address) public isAdult {
        members[_address] = member({_address: address(0), adult: false});
        //из массива не удаляется
        nft.safeMint(_address);
    }

    function returnMemberByAddress(address _address)
        public
        view
        returns (member memory)
    {
        return members[_address];
    }

    function returnArray() public view returns (member[] memory) {
        return arrayMembers;
    }
}

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("MyTokenasdasd", "MTK") {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://api.otherside.xyz/lands/";
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }
}

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TOKEN is ERC20, Ownable {
    constructor() ERC20("MyToken", "MTK") {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
