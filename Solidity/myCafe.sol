  
pragma solidity ^0.5.1;
pragma experimental ABIEncoderV2;

contract myCafe {

    constructor() public {
        itemCounter = 0;
        orderCounter = 0;
        createItem("Espresso",4,"Espresso.jpg");
        createItem("Cappuccino",6,"Cappuccino.jpg");
        createItem("Latte",4,"Latte.jpg");
        createItem("Mocha",5,"Mocha.jpg");
        createItem("Blueberry Bagel",2,"Blueberry_Bagel.jpg");
        createItem("Cheese Danish",1,"Cheese_Danish.jpg");
        createItem("Pumpkin Loaf",3,"Pumpkin_Loaf.jpg");
        createItem("Butter Croissant",2,"Butter_Croissant.jpg");
    }

    event BuyItem(
        address from,
        uint256 idItem,
        string  time
    ); 

    event ErrorNotEnoughMoney(
        address from, 
        uint256 idItem
    );
    
    struct Item {
        uint256 id;
        string  name;
        uint256 price;
        address seller;
        address from;
        string  time;
        string  imgPath;
    }

    uint256[] itemList;
    uint256[] orderList;
    
    mapping (uint256 => Item) private items;
    mapping (uint256 => Item) private orders;

    uint256 public itemCounter;
    uint256 public orderCounter;

    function fieldIsEmpty(string memory _str) pure private returns(bool _fieldIsEmpty){
        bytes memory tempFieldEmptyString = bytes(_str);
        if (tempFieldEmptyString.length == 0) {
            return true;
        } else {
            return false;
        }
    }

    function getItemFirstCounter() private returns(uint){
        return ++itemCounter; 
    }

    function getOrderCounter() private returns(uint){
         return ++orderCounter; 
    }
    
    function createItem (string memory _name,uint256 _price,string memory _imgPath) public returns(bool success) {
        require(!fieldIsEmpty(_name),"Field name init must not empty.");

        uint256 idItemInit = getItemFirstCounter();
        Item memory item = items[idItemInit];
        item.id = idItemInit;
        item.name = _name;
        item.price = _price;
        item.seller = msg.sender;
        item.imgPath = _imgPath;
        items[idItemInit] = item;
        
        itemList.push(idItemInit);

        return true;
    }

    function buyItem (uint256 _idItem, string memory _time) public payable returns(bool success){
        Item memory itemNow = items[_idItem];
        if(msg.value <= itemNow.price){
            emit ErrorNotEnoughMoney(msg.sender, _idItem);
            msg.sender.transfer(msg.value);
            return false;
        }

        uint256 idOrder = getOrderCounter();
        Item memory order = orders[idOrder];
        order.id = itemNow.id;
        order.name = itemNow.name;
        order.from = msg.sender;
        order.time = _time;
        orders[idOrder] = order;

        orderList.push(idOrder);
        emit BuyItem(msg.sender, itemNow.id, _time);

        return true;
    }

    function getAllItemList() public view returns(uint256[] memory _items){
        return itemList;
    }

    function getAllOrderList() public view returns(uint256[] memory _orders){
        return orderList;
    }
    
    function getItemStrByID(uint256 _id) public view returns(uint256 id, string memory name, uint256 price, string memory imgPath){
        Item memory itemNow = items[_id];
        return (itemNow.id, itemNow.name, itemNow.price, itemNow.imgPath);
    }

    function getOrderStrByID(uint256 _id) public view returns(uint256 id, string memory name, address from, string memory time){
        Item memory orderNow = orders[_id];
        return (orderNow.id, orderNow.name, orderNow.from, orderNow.time);
    }
    
}