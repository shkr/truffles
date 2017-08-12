pragma solidity ^0.4.0;


contract Jugaad {
 
  // Parameter
  address public organizer;
  uint public quota;
  uint public price;
  uint public fund;
  
  // State variable
  uint public totalSellers;
  uint public totalItems;
  mapping (uint => address) private sellerAddress;
  mapping (address => uint) private sellerSold;
  mapping (address => mapping (uint => string)) private sellersItem;
  bool public done;

  // Event log
  event Deposit(address _to); 
  event Refund(address _from);
  
  // Constructor
  function Jugaad() payable {
    organizer = msg.sender;
    fund = msg.value;
    // 1-seller jugaad
    quota = 1;
    price = 1e18;
    // init state variable
    totalSellers = 0;
    totalItems = 0;
    done = false;
  }
  function sellItem(string item) returns (bool success) { 
    if (totalItems >= quota) { return false; } // buy upto quota
    if (sellerSold[msg.sender]==0) {
      sellerAddress[totalSellers++] = msg.sender;
    }
    sellersItem[msg.sender][++sellerSold[msg.sender]] = item;
    totalItems++;
    Deposit(msg.sender);
    return true;
  }
  function finish() {
    // do not transfer if jugaad is done
    if (done) { return; }
    // do not finish jugaad if quota is incomplete
    if (totalItems != quota) { return; }
    // do not finish jugaad if fund is insufficient
    if (totalItems*price > fund) { return; }
    for(uint i=0;i<totalSellers;i++)
      {
        address seller = sellerAddress[i];
        uint itemsSold = sellerSold[seller];
        uint amt = price*itemsSold;
        seller.transfer(amt);
      }
    done = true;
    return;
  }
  function destroy() { // so funds not locked in contract forever
    if (msg.sender == organizer) {
      suicide(organizer); // send funds to organizer
    }
  }
}
