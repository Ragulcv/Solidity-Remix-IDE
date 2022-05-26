//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Ecommerce{

    struct Product{
        string title;
        string desc;
        uint256 price;
        uint256 productID;
        address payable seller;
        address buyer;
        bool delivered;
    }

    uint256 counter = 0;
    Product[] public products;
    address payable public manager ;

    bool destroyed = false;

    modifier isnotDestroyed{
        require(!destroyed,"smart contract does not exist");
        _;
    }

    constructor(){
        manager=payable(msg.sender);
    }


    
    event checkProduct(string title,uint256 productID, address seller);
    event bought(address buyer,uint256 productID);
    event delivered(uint256 productID);


    function registerProduct(string memory _title, string memory _desc, uint256 _price)public isnotDestroyed{
        require(_price>0 , "price of the product should be greater than zero");
        Product memory tempProduct;
        tempProduct.title=_title;
        tempProduct.desc=_desc;
        tempProduct.price=_price*10**18;
        tempProduct.seller= payable(msg.sender);
        tempProduct.productID=counter;
        products.push(tempProduct);
        counter++;
        emit checkProduct(_title,tempProduct.productID,msg.sender);
    }

    function buy(uint256 _productID) payable public isnotDestroyed{
        require(products[_productID].price==msg.value, "please pay the exact price");
        require(products[_productID].seller!=msg.sender,"seller cannot buy the same product");
        products[_productID].buyer=msg.sender;
        emit bought(msg.sender,_productID);
    }

    function delivery(uint256 _productID) public isnotDestroyed {
        require(products[_productID].buyer==msg.sender,"only the buyer can confirm the order status");
        products[_productID].delivered=true;
        products[_productID].seller.transfer(products[_productID].price);
        emit delivered(_productID);
    }

    function destroy() public isnotDestroyed{
        require(manager==msg.sender);
        manager.transfer(address(this).balance);
        destroyed=true;
    }

    fallback() payable external{
        payable(msg.sender).transfer(msg.value);
    }


}