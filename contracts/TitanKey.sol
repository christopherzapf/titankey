pragma solidity ^0.4.4;
import '../node_modules/zeppelin-solidity/contracts/token/StandardToken.sol';

contract TitanKey is StandardToken {

  bytes32 public name = 'TitanKey';
  bytes32 public symbol = 'TITAN';
  uint public decimals = 10;
  uint public INITIAL_SUPPLY = 100000000;

bytes32[3] public validAddress = ["ETH","BTC","IOTA"];

struct TitanName {
  bytes32 name;
  address owner;
  mapping (bytes32 => Currency) curToTitanName; //Übergabe des Namen > Currency
}

struct Currency {
  mapping (bytes32 => UserPublicKey) userPublicKeyToCur;
}

struct UserPublicKey {
  bytes32 name;
  bytes32 publicKey;
}

modifier isNameOwner(bytes32 _titanName) {
  if (titanData[_titanName].owner != msg.sender){throw;}
}


  //stores a userData Struct for each possible address; Jeder Adresse hat einmal UserData;
   mapping (bytes32 => TitanName) public titanData;

  function TitanKey() {
    totalSupply = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
  }

  function buildingNameHash (bytes32 _titanName, bytes32 _cur) {
    //keccak256 returns a bytes32
  }

  function setUserData(bytes32 _titanName, bytes32 _cur, bytes32 _curName, bytes32 _curAddress) public {
    require(titanData[_titanName].name == 0 && isValidCur(_cur));

    titanData[_titanName].name = _titanName; //DomainName
    titanData[_titanName].owner = msg.sender;

    titanData[_titanName].curToTitanName[_titanName].userPublicKeyToCur[_cur].name = _curName;
    titanData[_titanName].curToTitanName[_titanName].userPublicKeyToCur[_cur].publicKey = _curAddress;
  }

  //Damit man ein Mapping readen kann, braucht man den KeyValue, also userPublicKey
  function isNameOwned(bytes32 _titanName) constant returns (bool){
    if (titanData[_titanName].name == 0) { return false;}
    else {return true;}
  }

  function isValidCur(bytes32 _cur) internal returns (bool){
      for (uint i = 0; i < validAddress.length; i++) {
         if(bytes32[i] == _cur) {
           return true;
         }
    }
    revert();
  }
}
