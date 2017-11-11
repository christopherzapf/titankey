pragma solidity ^0.4.4;
import '../node_modules/zeppelin-solidity/contracts/token/StandardToken.sol';

contract TitanKey is StandardToken {

  bytes32 public name = 'TitanKey';
  bytes32 public symbol = 'TITAN';
  uint public decimals = 10;
  uint public INITIAL_SUPPLY = 100000000;

struct TitanUser {
  bytes32 emailHash;
  bool userActive;
  uint256[] nameList;
  uint256[] keyList;
}
mapping (address => TitanUser) titanUsers;


struct TitanName {
  //bytes32 titanName; wird nicht gebraucht, da in Mapping vorhanden
  address owner;
  bool nameActive;
}
bytes32[] allNames; //Every Name gets an Index Diesen Index speicher ich in einem Array bei dem jeweiligen User ab.
mapping (bytes32 => TitanName) titanNames; // All names and their owner;


struct PublicKey {
  uint256[] keyList;
}
bytes32[] allKeys;
mapping (bytes32 => PublicKey) userPublicKeys;// All PublicKeys and their owner;

/*

@params _titanName: TitanName
@return false, if Name is active; true, if Name is not active
*/
  function insertNewName(bytes32 _titanName) public {
    //wenn der Name aktiv ist, dann darf die funktion nicht funktionieren
    if (titanNames[_titanName].nameActive == true) revert();

    titanNames[_titanName].owner = msg.sender;
    titanNames[_titanName].nameActive = true;
    //Ich muss den TitanName in die NamesList; Dann bekomme ich einen Index zurück. Diesen Index speicher ich bei einem Nutzer ab
    allNames.push(_titanName); //erster Name = stelle 0; länge 1
    titanUsers[msg.sender].nameList.push(allNames.length-1);
  }

  function addPublicKeyToUser(bytes32 _publicKey) public {

      //Ich muss den TitanName in die NamesList; Dann bekomme ich einen Index zurück. Diesen Index speicher ich bei einem Nutzer ab
    allKeys.push(_publicKey); //erster Name = stelle 0; länge 1
    titanUsers[msg.sender].keyList.push(allKeys.length-1);
  }
  /*

  @params
  @return
  */
  function getNamesOfUser() public constant returns (bytes32[] memory _names) {
    uint256 _len = titanUsers[msg.sender].nameList.length;
    if (_len == 0) {
      _names = new bytes32[](1);
      _names[0] = "Leer";
      return _names;
    }

    _names = new bytes32[](_len);
    for(uint i = 0; i < _len; i++){

      _names[i] = allNames[titanUsers[msg.sender].nameList[i]];
    }

    return _names;
  }
  /*
  @params
  @return
  */
  function getPublicKeysOfUser() public constant returns (bytes32[] memory _publicKeys) {
    uint256 _len = titanUsers[msg.sender].keyList.length;
    if (_len == 0) {
      _publicKeys = new bytes32[](1);
      _publicKeys[0] = "Leer";
      return _publicKeys;
    }
    _publicKeys = new bytes32[](_len);
    for(uint i = 0; i < _len; i++){
      _publicKeys[i] = allKeys[titanUsers[msg.sender].keyList[i]];
    }
    return _publicKeys;
  }
  /*

  @params
  @return
  */
  function isNameAvailable(bytes32 _titanName) public constant returns (bool a) {
    if(titanNames[_titanName].nameActive) return a = true;
    return a = false;
  }

}




//UTILITY FUNCTIONS
