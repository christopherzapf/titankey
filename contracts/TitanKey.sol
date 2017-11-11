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
}
mapping (address => TitanUser) titanUsers;

struct TitanName {
  //bytes32 titanName; wird nicht gebraucht, da in Mapping vorhanden
  address owner;
  bool nameActive;
}

bytes32[] allNames; //Every Name gets an Index via titanUser.index: Diesen Index speicher ich in einem Array bei dem jeweiligen User ab.
mapping (bytes32 => TitanName) titanNames; // All names and their owner;

/*

@params _titanName: TitanName
@return false, if Name is active; true, if Name is not active
*/
  function insertNewName(bytes32 _titanName) public returns (bytes32) {
    //wenn der Name aktiv ist, dann darf die funktion nicht funktionieren
    if (titanNames[_titanName].nameActive == true) return "false";

    titanNames[_titanName].owner = msg.sender;
    titanNames[_titanName].nameActive = true;

    //Ich muss den TitanName in die NamesList; Dann bekomme ich einen Index zurück. Diesen Index speicher ich bei einem Nutzer ab
    allNames.push(_titanName); //erster Name = stelle 0; länge 1
    titanUsers[msg.sender].nameList.push(allNames.length-1);
    return "true";

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
  function isNameAvailable(bytes32 _titanName) public constant returns (bool a) {
    if(titanNames[_titanName].nameActive) return a = true;
    return a = false;
  }

}




//UTILITY FUNCTIONS
