let Jugaad = artifacts.require("Jugaad");

contract('Jugaad', function(accounts) {
  it("should assert true", function() {
    Jugaad.deployed().then(function(instance) {
      assert.isTrue(true);
    });
  });
});

contract('Jugaad', function(accounts) {
  it("Initial jugaad settings should match", function() {
    let jugaad;
    return Jugaad.new(accounts[0]).then(function(instance) {
      jugaad = instance;
      return jugaad.quota.call();
    }).then(function(quota) {
      assert.equal(quota, 1, "Quota is not 1!");
      return jugaad.price.call();
    }).then(function(price) {
      assert.equal(price, 10, "Price is not 10!");
      return jugaad.itemsCollected.call();
    }).then(function(num) {
      assert.equal(num, 0, "Number of items collected is not 0!");
      return jugaad.organizer.call();
    }).then(function(organizer) {
      assert.equal(organizer, accounts[0], "Owner is not equal to accounts[0]");
    });
  });
});

contract('Jugaad', function(accounts) {
  it("Should update contract wallet", function() {
    let jugaad;
    Jugaad.new(accounts[0]).then(function(instance) {
      jugaad = instance;
      return jugaad.price.call();
    }).then(function(price) {
      let priceWei = web3.toWei(0, "ether");
      let initialBalance = web3.eth.getBalance(jugaad.address).toNumber();
      jugaad.sellItem('ipfs-hash', {from: accounts[1]})
        .then(
          function(){
            let newBalance = web3.eth.getBalance(jugaad.address).toNumber();
            let difference = newBalance-initialBalance;
            assert.equal(difference, priceWei, 'The difference after tx is not equal to price');
          }
        );
    });
  });
});
