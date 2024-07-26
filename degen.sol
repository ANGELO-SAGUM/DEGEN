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
    
        store[1] = StoreItem("Jordan 1", 500);
        store[2] = StoreItem("Jordan 2", 250);
        store[3] = StoreItem("Jordan 3", 150);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function transferTokens(address to, uint256 amount) public returns (bool) {
        _transfer(_msgSender(), to, amount);
        return true;
    }


    function redeemTokens(uint8 itemId) public {
        StoreItem memory item = store[itemId];
        require(item.price > 0, "Item does not exist");
        require(balanceOf(_msgSender()) >= item.price, "Insufficient balance to redeem this item");

        _burn(_msgSender(), item.price);

    }


    function burnTokens(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

    function checkBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }

    function getStoreItem(uint8 itemId) public view returns (string memory name, uint256 price) {
        StoreItem memory item = store[itemId];
        return (item.name, item.price);
    }
}
