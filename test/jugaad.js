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
      assert.equal(price, 1e18, "Price is not 1 ether!");
      return jugaad.totalItems.call();
    }).then(function(num) {
      assert.equal(num, 0, "Number of items collected is not 0!");
      return jugaad.organizer.call();
    }).then(function(organizer) {
      assert.equal(organizer, accounts[0], "Owner is not equal to accounts[0]");
    });
  });
});

contract('Jugaad', function(accounts) {
  it("Should transfer money after finish", function() {
    let jugaad;
    Jugaad.new({from: accounts[0], value: 1e18}).then(function(instance) {
      jugaad = instance;
      return jugaad.price.call();
    }).then(function(price) {
      jugaad.sellItem('ipfs-hash', {from: accounts[1]})
        .then(
          function(){
            let initialBalance = web3.eth.getBalance(accounts[1]).toNumber();
            jugaad.finish().then(
              function() {
                let newBalance = web3.eth.getBalance(accounts[1]).toNumber();
                let difference = newBalance-initialBalance;
                assert.equal(difference, price, 'The difference after tx is not equal to price');
              }
            );
          }
        );
      });
    });
  });

contract('Jugaad', function(accounts) {
  it("Should not finish if funds are insufficient for transfer", function() {
    let jugaad;
    Jugaad.new({from: accounts[0], value: 1e14}).then(function(instance) {
      jugaad = instance;
      return jugaad.price.call();
    }).then(function(price) {
      jugaad.sellItem('ipfs-hash', {from: accounts[1]})
        .then(
          function(){
            let initialBalance = web3.eth
            jugaad.finish().then(
              function() {
                return jugaad.done.call();
             }
           ).then(function(done) {
              assert.isTrue(!done, 'The jugaad will not finish due to insufficient fund');
           }
          );
         }
       );
      });
    });
  });
