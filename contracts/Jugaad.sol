pragma solidity ^0.4.0;


contract Jugaad {
 
  // Parameter
  address public organizer;
  uint public quota;
  uint public price;
  
  // State variable
  uint public itemsCollected;
  mapping (address => uint) public collectedFrom;
  mapping (address => mapping (uint => string)) private sellersItem;

  // Event log
  event Deposit(address _to); 
  event Refund(address _from);
  
  // Constructor
  function Jugaad() { 
    organizer = msg.sender;
    // 1-seller jugaad
    quota = 1;
    price = 10;
    // init state variable
    itemsCollected = 0;
  }
  function sellItem(string item) returns (bool success) { 
    if (itemsCollected >= quota) { return false; } // buy upto quota
    sellersItem[msg.sender][++collectedFrom[msg.sender]] = item;
    itemsCollected++;
    Deposit(msg.sender);
    return true;
  }
  function returnItem(address recipient) returns (bool success) {
    if (msg.sender != organizer) { return false; }
    address contractAddress = this;
    if ((contractAddress.balance >= price) && (collectedFrom[recipient] > 0)) {
      recipient.transfer(price);
      collectedFrom[recipient] -= 1;
      itemsCollected--;
      Refund(recipient);
      return true;
    }
  }
  function destroy() { // so funds not locked in contract forever
    if (msg.sender == organizer) {
      suicide(organizer); // send funds to organizer
    }
  }
}
