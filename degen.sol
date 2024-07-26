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
    mapping(address => mapping(uint8 => uint256)) public redeemedItems;

    constructor() ERC20("Degen", "DGN") {
        store[1] = StoreItem("Jordan 1", 500);
        store[2] = StoreItem("Jordan 2", 250);
        store[3] = StoreItem("Jordan 3", 150);
    }

    function mint(address recipient, uint256 amount) public onlyOwner {
        _mint(recipient, amount);
    }

    function transferTokens(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function redeemTokens(uint8 itemId) public {
        StoreItem memory item = store[itemId];
        require(item.price > 0, "Item does not exist");
        require(balanceOf(msg.sender) >= item.price, "Insufficient balance");

        _burn(msg.sender, item.price);
        redeemedItems[msg.sender][itemId] += 1;
    }

    function burnTokens(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function checkBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }

    function getStoreItem(uint8 itemId) public view returns (string memory, uint256) {
        StoreItem memory item = store[itemId];
        return (item.name, item.price);
    }

    function getAllStoreItems() public view returns (string memory) {
        string memory items = "";
        for (uint8 i = 1; i <= 3; i++) {
            items = string(abi.encodePacked(items, uint2str(i), ": ", store[i].name, " - ", uint2str(store[i].price), " DGN\n"));
        }
        return items;
    }

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
            k--;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bstr[k] = bytes1(temp);
            _i /= 10;
        }
        return string(bstr);
    }

    function storeItem(uint8 itemId) public {
        StoreItem memory item = store[itemId];
        require(item.price > 0, "Item does not exist");

        uint256 userBalance = balanceOf(msg.sender);
        require(userBalance >= item.price, "Insufficient balance");

        _burn(msg.sender, item.price);
        
    }

    function checkRedeemedItems(address player, uint8 itemId) public view returns (uint256) {
        return redeemedItems[player][itemId];
    }
}
