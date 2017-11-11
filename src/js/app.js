
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

    //Infos, wie Payable etc werden im Artifact geladen (truffle-compile)
    $.getJSON('TitanKey.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract.
      var TitanKeyArtifact = data;
      App.contracts.TitanKey = TruffleContract(TitanKeyArtifact);
      // Set the provider for our contract.
      App.contracts.TitanKey.setProvider(App.web3Provider);
    });
    return App.bindEvents();
  },

bindEvents: function() {
    $(document).on('click', '#transferButton', App.insertNewName);
    $(document).on('click', '#getNames', App.getNamesOfUser);
    $(document).on('click', '#nameAvailableBtn', App.isNameAvailable);
    $(document).on('click', '#insertPublicKeys', App.insertPublicKeys);
    $(document).on('click', '#getPublicKeys', App.getPublicKeyOfUser);

},


getNamesOfUser: function(){
    var TitanKeyInstance;

    web3.eth.getAccounts(function(error, accounts) {if (error) {console.log(error);}
      var account = accounts[0];

            App.contracts.TitanKey.deployed().then(function (instance) {
                TitanKeyInstance = instance;

                return TitanKeyInstance.getNamesOfUser();

              }).then(function(result) {

                var a = "";
                result.forEach(function(element) {
                      a = web3.toUtf8(element) +" "+ a;
                      console.log(web3.toUtf8(element));
                })
                  $('#namesOfUser').text(a);


                }).catch(function(err) {console.log(err.message);});
          });
  },

  isNameAvailable: function(){
      var TitanKeyInstance;
      var _name = $('#nameAvailable').val().toLowerCase();

      web3.eth.getAccounts(function(error, accounts) {if (error) {console.log(error);}
        var account = accounts[0];

              App.contracts.TitanKey.deployed().then(function (instance) {
                  TitanKeyInstance = instance;

                  return TitanKeyInstance.isNameAvailable(_name, {from: account});

                }).then(function(result) {

                  alert("Name ist verfügbar:"+result);

                }).catch(function(err) {console.log(err.message);});
        });
    },

  insertNewName: function() {
    var TitanKeyInstance;
    var _titanName = $('#inputTitanName').val().toLowerCase();

    web3.eth.getAccounts(function(error, accounts) {if (error) {console.log(error);}
      var account = accounts[0];

          App.contracts.TitanKey.deployed().then(function (instance) {
              TitanKeyInstance = instance;

              return TitanKeyInstance.insertNewName(_titanName, {from: account});
            }).then(
              function(result) {
                console.log(result);
              }).catch(function(err) {console.log(err.message);});
    });
  },

  insertPublicKeys: function() {
    var TitanKeyInstance;
    var _publicKey = $('#publicKey').val().toLowerCase();
    var _currency = $('#curreny').val().toLowerCase();
    var _namedByUser = $('#namedByUser').val().toLowerCase();
    var _publicKeyInformation = _publicKey + "|" + _currency + "|" + _namedByUser;


    web3.eth.getAccounts(function(error, accounts) {if (error) {console.log(error);}
      var account = accounts[0];

          App.contracts.TitanKey.deployed().then(function (instance) {
              TitanKeyInstance = instance;

              return TitanKeyInstance.addPublicKeyToUser(_publicKeyInformation, {from: account});
            }).then(
              function(result) {
                console.log(result);
              }).catch(function(err) {console.log(err.message);});
    });
  },


  getPublicKeyOfUser: function(){
      var TitanKeyInstance;

      web3.eth.getAccounts(function(error, accounts) {if (error) {console.log(error);}
        var account = accounts[0];

              App.contracts.TitanKey.deployed().then(function (instance) {
                  TitanKeyInstance = instance;

                  return TitanKeyInstance.getPublicKeysOfUser();

                }).then(function(result) {
                  var a ="";
                  result.forEach(function(element) {
                        a = web3.toUtf8(element).split("|") +" "+ a;
                        console.log(web3.toUtf8(element));
                  })
                    $('#publicKeysOfUser').text(a);


                  }).catch(function(err) {console.log(err.message);});
            });
    }
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
