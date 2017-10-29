
App = {
  web3Provider: null,
  contracts: {},
  init: function() {
    return App.initWeb3();
  },

//Start des Web3 API zu ETH Blockchain
  initWeb3: function() {
    // Initialize web3 and set the provider to the testRPC.
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // set the provider you want from Web3.providers
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
      web3 = new Web3(App.web3Provider);
    }

    return App.initContract();
  },


// Start des Contracts
  initContract: function() {

    //Infos, wie Payable etc werden im Artifact geladen
    $.getJSON('TitanKey.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract.
      var TitanKeyArtifact = data;
      App.contracts.TitanKey = TruffleContract(TitanKeyArtifact);

      // Set the provider for our contract.
      App.contracts.TitanKey.setProvider(App.web3Provider);

      // TODO: Return Name statt App.balances  return App.getBalances();
      return App.setUserName("Chris");
    });

  //  return App.bindEvents();
  },

/*  bindEvents: function() {
    $(document).on('click', '#transferButton', App.handleTransfer);
//    $(document).on('click', '#PublicId', App.handleTransfer);
*/
  },

  handleTransfer: function() {
    event.preventDefault();

    var amount = parseInt($('#TTTransferAmount').val());
    var toAddress = $('#TTTransferAddress').val();

    console.log('Transfer ' + amount + ' TT to ' + toAddress);

    var TitanKeyInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.TitanKey.deployed().then(function(instance) {
        TitanKeyInstance = instance;

        return TitanKeyInstance.transfer(toAddress, amount, {from: account});
      }).then(function(result) {
        alert('Transfer Successful!');
        return App.getBalances();
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },

  getBalances: function(adopters, account) {
    console.log('Getting balances...');

    var TitanKeyInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }


      var account = accounts[0];

      App.contracts.TitanKey.deployed().then(function(instance) {
        TitanKeyInstance = instance;
        TitanKeyInstance.setUserName("dfgdfgd");

        TitanKeyInstance.getUserName.data().then(function(name) {
          // If this callback is called, the call was successfully executed.
          // Note that this returns immediately without any waiting.
          // Let's print the return value.
          console.log(name);
        }).catch(function(e) {
          // There was an error! Handle it.
        })



        return TitanKeyInstance.balanceOf(account);
      }).then(function(result) {
        balance = result.c[0];

        $('#TTBalance').text(test);
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },

  getName: function() {
    console.log('Funktionsaufruf GetName');
    var TitanKeyInstance;

    var contract = web3.eth.contract().at(contractAddress);
    console.log(contract)
    var callData = contract.getUserName.getData();
    var result = web3.eth.call({
        to: contract,
        data: callData
    });

    $('#Name').text(result);
  }
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
