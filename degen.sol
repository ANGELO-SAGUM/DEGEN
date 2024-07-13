// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    struct StoreItem {
        string name;
        uint256 price;
    }

    mapping(uint8 => StoreItem) public store;

    constructor() ERC20("Degen", "DGN") {
        // Initialize store items
        store[1] = StoreItem("Jordan 1", 500);
        store[2] = StoreItem("Jordan 2", 250);
        store[3] = StoreItem("Jordan 3", 150);
    }

    // Function to mint new tokens, only accessible by the contract owner
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Function for players to transfer tokens to others
    function transferTokens(address to, uint256 amount) public returns (bool) {
        _transfer(_msgSender(), to, amount);
        return true;
    }

    // Function for players to redeem tokens for in-game items
    function redeemTokens(uint8 itemId) public {
        StoreItem memory item = store[itemId];
        require(item.price > 0, "Item does not exist");
        require(balanceOf(_msgSender()) >= item.price, "Insufficient balance to redeem this item");

        _burn(_msgSender(), item.price);
        // Logic to deliver the in-game item goes here
    }

    // Function for anyone to burn their own tokens
    function burnTokens(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

    // Function to check token balance of any player
    function checkBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }

    // Function to get store item details
    function getStoreItem(uint8 itemId) public view returns (string memory name, uint256 price) {
        StoreItem memory item = store[itemId];
        return (item.name, item.price);
    }

    // Function to get all store items as a single string
    function getAllStoreItems() public view returns (string memory) {
        string memory items = "";
        for (uint8 i = 1; i <= 3; i++) {
            items = string(abi.encodePacked(items, uint2str(i), ": ", store[i].name, " - ", uint2str(store[i].price), " DGN\n"));
        }
        return items;
    }

    // Helper function to convert uint to string
    function uint2str(uint _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    // Function for users to store a store item and deduct the equivalent token balance
    function storeItem(uint8 itemId) public {
        StoreItem memory item = store[itemId];
        require(item.price > 0, "Item does not exist");

        uint256 userBalance = balanceOf(_msgSender());
        require(userBalance >= item.price, "Insufficient balance to store this item");

        _burn(_msgSender(), item.price);
        // Logic to store the item goes here
    }
}
