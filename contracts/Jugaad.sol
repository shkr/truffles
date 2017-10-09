pragma solidity ^0.4.0;


contract Jugaad {
 
  // Parameter
  address public organizer;
  uint public quota;
  uint public price;
  uint public fund;
  string public fileType;
  string public publicKey;

  // State variable
  uint public totalSellers;
  uint public totalItems;
  mapping (uint => address) private sellerAddress;
  mapping (address => uint) private sellerSold;
  mapping (uint => address) private itemSeller;
  mapping (uint => string) private itemValue;
  bool public done;

  // Event log
  event Deposit(address _to); 
  event Refund(address _from);
  
  // Modifier
  // If this modifier is used, it will
  // prepend a check that only passes
  // if the function is called from
  // a certain address.
  modifier onlyBy(address _account) {
    require(msg.sender == _account);
    // Do not forget the "_;"! It will
    // be replaced by the actual function
    // body when the modifier is used.
    _;
  }

  // If this modifier is used with a payable
  // function call then it requires the 
  // value to be greater than equal to _amount
  // and excess value is returned
  modifier costs(uint _amount) {
    require(msg.value >= _amount);
    _;
    if (msg.value > _amount)
        msg.sender.transfer(msg.value - _amount);
  }

  // Constructor
  function Jugaad(string publicKeyReceived, string fileTypeRequired, 
                  uint priceRequired, uint quotaRequired) costs( priceRequired * quotaRequired ) payable {
    
    organizer = msg.sender;
    fund = msg.value;
    // parameters
    publicKey = publicKeyReceived;
    quota = quotaRequired;
    price = priceRequired;
    fileType = fileTypeRequired;
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
    itemSeller[totalItems] = msg.sender;
    itemValue[totalItems] = item;
    sellerSold[msg.sender]++;
    totalItems++;
    Deposit(msg.sender);
    return true;
  }
  function accessItem(uint itemId) onlyBy(organizer) constant returns (string value) {
    return itemValue[itemId];
  }
  function finish() onlyBy(organizer) {
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
