pragma solidity ^0.4.4;
import '../node_modules/zeppelin-solidity/contracts/token/StandardToken.sol';

contract TitanKey is StandardToken {

  bytes32 public name = 'TitanKey';
  bytes32 public symbol = 'TITAN';
  uint public decimals = 10;
  uint public INITIAL_SUPPLY = 100000000;

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

  //stores a userData Struct for each possible address; Jeder Adresse hat einmal UserData;
   mapping (bytes32 => TitanName) public titanData;

  function TitanKey() {
    totalSupply = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
  }

  function buildingNameHash (bytes32 _titanName, bytes32 _cur) {
    //keccak256 returns a bytes32
  }

  function setUserData(bytes32 _titanName,bytes32 _pubKey,bytes32 _pubKeyNamedByUser,bytes32 _cur) public {
    if (isNameOwned(_titanName)) {
      revert();
    } else if (isValidCur(_cur)) {

    titanData[_titanName].name = _titanName;
    titanData[_titanName].owner = msg.sender;

    titanData[_titanName].curToTitanName[_titanName].userPublicKeyToCur[_cur].name = _pubKeyNamedByUser;
    titanData[_titanName].curToTitanName[_titanName].userPublicKeyToCur[_cur].publicKey = _pubKey;
  } else { revert(); }
}

  //Damit man ein Mapping readen kann, braucht man den KeyValue, also userPublicKey
  function isNameOwned(bytes32 _titanName) constant returns (bool){
    if (titanData[_titanName].name == 0) { return false;}
    else {return true;}
  }

  function isValidCur(bytes32 _cur) constant returns (bool){
      bytes32[2] memory validCur;
      validCur[1] = 'eth'; validCur[0] = 'btc';
      for (uint i = 0; i < validCur.length; i++) {
         if(keccak256(validCur[i]) == keccak256(_cur) ) {
           return true;
         }
    }
    return false;
  }
}
