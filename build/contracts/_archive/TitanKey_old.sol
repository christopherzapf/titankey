pragma solidity ^0.4.15;
import '../node_modules/zeppelin-solidity/contracts/token/StandardToken.sol';

/*contract TtnKey is StandardToken {

  bytes32 public name = 'TtnKey';
  bytes32 public symbol = 'TITAN';
  uint public decimals = 10;
  uint public INITIAL_SUPPLY = 100000000;

struct TtnName {
  bytes32 name; // Ttn Name
  address owner; // Besitzer
  mapping (bytes32 => Currency) curToTtnName; // 1 Name hat viele Währungen
}

struct Currency {
  bytes32 currency; // z.B. ETH, BTC, ...
  mapping (bytes32 => UserPublicKey) userPublicKeyToCur; //CurNamedByUser wird auf PublicKeys gemappt
}

struct UserPublicKey {
  bytes32 pubKeyNamedByUser; //Name des PublicKey (Nutzer) z.B: Exodus, Bittrix
  bytes32 publicKey; //eigentlich publicKey
}

mapping (address => TtnName) public ownerToName; // 1 Adresse hat viele Namen
mapping (bytes32 => TtnName) public ttnLedger; // Ttn hat viele Namen

  function TtnKey() {
    totalSupply = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
  }

  function setUserData(bytes32 _ttnName,bytes32 _pubKey,bytes32 _pubKeyNamedByUser,bytes32 _cur) public {
    if (isNameOwned(_ttnName)) {
      revert();
    } else if (isValidCur(_cur)) {

    ttnLedger[_ttnName].name = _ttnName;
    ttnLedger[_ttnName].owner = msg.sender;
    ownerToName[msg.sender].name = _ttnName;

    ttnLedger[_ttnName].curToTtnName[_cur].userPublicKeyToCur[_pubKeyNamedByUser].pubKeyNamedByUser = _pubKeyNamedByUser;
    ttnLedger[_ttnName].curToTtnName[_cur].userPublicKeyToCur[_pubKeyNamedByUser].publicKey = _pubKey;
    ownerToName[msg.sender].curToTtnName[_cur].userPublicKeyToCur[_pubKeyNamedByUser].pubKeyNamedByUser = _pubKeyNamedByUser;
    ownerToName[msg.sender].curToTtnName[_cur].userPublicKeyToCur[_pubKeyNamedByUser].publicKey = _pubKey;
  } else { revert(); }
}

function getNameByAccount() constant returns (bytes32){
      return ownerToName[msg.sender].name;
}

function getPublicKeysByName(bytes32 _ttnName) constant returns (bytes32[]){
    require(ttnLedger[_ttnName].owner == msg.sender);
  //  return ttnLedger[_ttnName].curToTtnName[_cur].userPublicKeyToCur[_pubKeyNamedByUser].publicKey;
}

  function isNameOwned(bytes32 _ttnName) constant returns (bool){
    if (ttnLedger[_ttnName].name == 0) { return false;}
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
*/

contract TtnKey is StandardToken {

  bytes32 public name = 'TitanKey';
  bytes32 public symbol = 'TITAN';
  uint public decimals = 10;
  uint public INITIAL_SUPPLY = 100000000;

  bytes32 ownersHash;
  struct TitanUser {
    int32 maxId;
    bytes32 highstOwnersHash;
    mapping (int32 => ownersHash) idList;
  }


  mapping (address => TitanUser) public titanUser; //msg.sender


  struct TitanName {
    bytes32 ownersHash;
    bytes32 titanName;
    int32 ttl;
  }
  mapping (bytes32 => TitanName) public titanLedger; //Name

  bytes32 titanName;
  mapping (bytes32 => titanName) public reverseTitanLedger; //OwnersHash



/*
Creates a name hash with msg.sender and an id that represents the
count of names of this user
*/
  function createOwnersHash () {
    int32 _maxId = titanUser[msg.sender].maxId;
    titanUser[msg.sender].ownersHash = keccak256(_maxId,msg.sender);
    titanUser[msg.sender].idList[_maxId].ownersHash = titanUser[msg.sender].ownersHash;
  }

/*

@params
@return
*/
  function setName(bytes32 _titanName) public {
    titanLedger[_titanName].ownersHash = titanUser[msg.sender].ownersHash;
    titanUser[msg.sender].maxId = titanUser[msg.sender].maxId + 1; // ID counts one more
    storeReverseLedger(_titanName);
    createOwnersHash();
  }

/*

@params
@return
*/
  function storeReverseLedger(bytes32 _titanName) internal {
    reverseTitanLedger[titanLedger[_titanName].ownersHash].titanName = _titanName; //Reverse Lookup
  }

/*
msg.sender and get his names
@params
@return
*/
  function getNames() constant returns (bytes32[]) {
    int32 _maxId = titanUser[msg.sender].maxId;
    bytes32[_maxId] _names;

    for (uint i = 0; i < maxId; i++) {
      bytes32 _ownersHash = titanUser[msg.sender].idList[i].ownersHash;
      _names[i] = reverseTitanLedger[_ownersHash].titanName;
    }

    return _names[];
  }

}
