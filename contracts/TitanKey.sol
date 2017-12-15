pragma solidity ^0.4.14;
import '../node_modules/zeppelin-solidity/contracts/token/StandardToken.sol';

contract TitanKey is StandardToken {
  event debugEventInsertName(address owner, bool nameActive, bytes32[] allNames, uint256 namesListId);
  event debugEventInsertPublicKey(bytes32[] allKeyHash, uint256[] _curKeys, bytes32 expectedKey, uint256 lengthOfAllKeyHash,uint256 _idOfCurKeyHashList);
  event debug (bool wirklichTrue);

  bytes32 public name = 'TitanKey';
  bytes32 public symbol = 'TITAN';
  uint public decimals = 10;
  uint public INITIAL_SUPPLY = 100000000;
  bytes32[] public validCurrencies;


struct TitanUser {
  bytes32 emailHash;
  bool userActive;
  uint256[] nameList;  //IDs der globalen NameList, die dem Nutzer gehören.
  mapping (bytes32 => Currency) currencies; //Jede Curreny bekommt eine eigene PublicKey Ledger; Bytes32 = curreny
  mapping (uint256 => PublicKey) userPublicKeys; //int32= ID des Keys; PublicKey hat weitere Infos;
}
mapping (address => TitanUser) titanUsers; //Alle Nutzer

struct Currency {
  uint256[] keyHashList;//IDs der globalen KeyList, die dem Nutzer gehören.
}

struct PublicKey {
  bool isStandard;
  uint256 keyStatus; // 1 = Existiert; 2 = Standard
  bytes32 keyName;
  bytes32 key;
}

struct TitanName {
  //bytes32 titanName; wird nicht gebraucht, da in Mapping vorhanden
  address owner;
  bool nameActive;
}
mapping (bytes32 => TitanName) titanNames; //Namesverzeichnis: Jeder Name hat ein TitanName Object

/*
GLOBAL LEDGERs
Every KeyHash, Name gets an Id (index of Array).
Use Case: This Id is also saved in the TitanUser-Object so that one user could
          have more then one Name;
*/
bytes32[] allKeyHashs;
bytes32[] allNames;


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

    debugEventInsertName(titanNames[_titanName].owner,
      titanNames[_titanName].nameActive,allNames,
      titanUsers[msg.sender].nameList.length
    );
  }
  /*

  @params
  @return
  */
  function getNamesOfUser() public constant returns (bytes32[] memory _names) {
    uint256 _len = titanUsers[msg.sender].nameList.length;
    if (_len == 0) revert();

    _names = new bytes32[](_len);
    for(uint i = 0; i < _len; i++){

      _names[i] = allNames[titanUsers[msg.sender].nameList[i]];
    }

    return _names;
  }
  /*
  Gets all keys from msg.sender and his keys per currencies
  @params
  @return
  */
  function getPublicKeysByCur(bytes32 _cur) public constant returns (bytes32[] memory _publicKeys /*,bytes32[] memory _keyName*/) {

    uint256 _len = titanUsers[msg.sender].currencies[_cur].keyHashList.length;
    _publicKeys = new bytes32[](_len);

    if (_len == 0) revert();

    for(uint i = 0; i < _len; i++){
      _publicKeys[i] = allKeyHashs[titanUsers[msg.sender].currencies[_cur].keyHashList[i]];
      //_keyName[i] = titanUsers[msg.sender].userPublicKeys[i].keyName;
    }
    return (_publicKeys/*,_keyNames*/);
  }
  /*

  @params
  @return
  */
  function isNameAvailable(bytes32 _titanName) public constant returns (bool) {
    return titanNames[_titanName].nameActive;
  }

  function addPublicKeyToUser(bytes32 _publicKey, bytes32 _cur, bytes32 _keyName, uint256 _isStandard) public {
      //Ich muss den TitanName in die NamesList; Dann bekomme ich einen Index zurück. Diesen Index speicher ich bei einem Nutzer ab
      //Hinzufügen des Keys in globale Ledger
    uint256 _keyIndex = allKeyHashs.push(_publicKey)-1;
    uint256 _idOfCurKeyHashList = titanUsers[msg.sender].currencies[_cur].keyHashList.push(_keyIndex); //erster Key = _keyIndex 0
    titanUsers[msg.sender].userPublicKeys[_keyIndex].key =_publicKey;
    titanUsers[msg.sender].userPublicKeys[_keyIndex].keyName =_keyName;
    titanUsers[msg.sender].userPublicKeys[_keyIndex].keyStatus =_isStandard;

    debugEventInsertPublicKey(
      allKeyHashs,
      titanUsers[msg.sender].currencies[_cur].keyHashList,
      titanUsers[msg.sender].userPublicKeys[allKeyHashs.length-1].key,
      _keyIndex,
      _idOfCurKeyHashList
      );

  }


  /*
  Mögliche Probleme:
  Aktuelles Verhalten: Egal, wie viele Key ich eingebe, es wird immer nur der erste ausgeben. Unabhängig der Währung

  1. Es gibt keine Namenszuordnung beim Public Key; Ist irgendwo egal, da ich über den Namen, auf den Besitzer komme
  2. Gibt es wirklich bei


  Next Step: Events lernen und debuggen mit Events;

  */

  /* the name resolver

  @params: _titanName: Name that should be resolved; _cur: Currency where the public key is
  @return
  */

  function getPublicKeyByName (bytes32 _titanName, bytes32 _cur) public constant returns (bytes32 _publicKey ) {
    address _owner = titanNames[_titanName].owner;
    uint256 _len = titanUsers[_owner].currencies[_cur].keyHashList.length; //Beispiel: 1 Key, lenght = 1; index 0

    uint256 j;
    for(uint i = 0; i < _len; i++){

      j = titanUsers[_owner].currencies[_cur].keyHashList[i]; //1. durchlauf i = 0; j = 1 //_keyIndex; Need = 0;

      if(titanUsers[_owner].userPublicKeys[j].keyStatus == 2) {
        // j = Die Id des zu untersuchenden Keys im Globalen Verzeichnis
        return _publicKey = titanUsers[_owner].userPublicKeys[j].key;
      }
    }
    return _publicKey = "Kein Standard Key hinterlegt";
      /*Nutzer hat genau einen Key. Es wird in der Tabelle des Nutzers nach der ID seines Keys in der globalen
      Keyliste gesucht und dieser wird zurückgegeben*/
  }

  function isValidCurreny(bytes32 _cur) internal constant returns (bool) {
    validCurrencies[0] = 'btc';
    validCurrencies[1] = 'etc';
    validCurrencies[2] = 'iota';
    validCurrencies[3] = 'eos';
    for(uint i = 0; i < validCurrencies.length;i++) {
      if(validCurrencies[i] == _cur) return true;
    }
    return false;
  }

}
