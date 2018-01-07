pragma solidity ^0.4.18;
import 'zeppelin-solidity/contracts/token/StandardToken.sol';

contract TitanKey is StandardToken {
  event UserSignedUp(address indexed _userAddress, bytes32 _firstName, bytes32 _lastName, bytes32 indexed _email);
  event UserUpdatedProfile(address indexed _userAddress, bytes32 _firstName, bytes32 _lastName, bytes32 indexed _email);

  bytes32 public name = 'TitanKey';
  bytes32 public symbol = 'TITAN';
  uint public decimals = 10;
  uint public INITIAL_SUPPLY = 100000000;
  bytes32[] public validCurrencies;

// DATA MODEL

struct TitanUser {
  bytes32 firstName;
  bytes32 lastName;
  bytes32 email;
  bool userActive;
  bytes32[] curList;
  uint256[] nameList;  //IDs der globalen NameList, die dem Nutzer gehören.
  mapping (bytes32 => Currency) currencies; //Jede Curreny bekommt eine eigene PublicKey Ledger; Bytes32 = curreny
  mapping (uint256 => PublicKey) userPublicKeys; //int32= ID des Keys; PublicKey hat weitere Infos;
}
mapping (address => TitanUser) titanUsers; //Alle Nutzer

struct Currency {
  uint256[] keyIdGlobal;//IDs der globalen KeyList, die dem Nutzer gehören.
  bool isActive;
}

struct PublicKey {
  bool isDefault;
  bool keyStatus; // 1 = Existiert; 2 = Standard
  bytes32 keyName;
  uint256 lastChange;
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


// MODIFIER
/* Check if user exists or terminate */
modifier onlyExistingUser {
  require(!(titanUsers[msg.sender].firstName == 0x0) && !(titanUsers[msg.sender].lastName == 0x0) && !(titanUsers[msg.sender].email == 0x0));
  _;
}

// FUNCTIONS

/*

@params _titanName: TitanName
@return false, if Name is active; true, if Name is not active
*/
  function insertNewName(bytes32 _titanName) onlyExistingUser public {
    //wenn der Name aktiv ist, dann darf die funktion nicht funktionieren
    if (titanNames[_titanName].nameActive == true) revert();

    titanNames[_titanName].owner = msg.sender;
    titanNames[_titanName].nameActive = true;
    //Ich muss den TitanName in die NamesList; Dann bekomme ich einen Index zurück. Diesen Index speicher ich bei einem Nutzer ab
    allNames.push(_titanName); //erster Name = stelle 0; länge 1
    titanUsers[msg.sender].nameList.push(allNames.length-1);

  }
  /*

  @params
  @return
  */
  function isNameAvailable(bytes32 _titanName) public constant returns (bool) {
    return titanNames[_titanName].nameActive;
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
  function getPublicKeys() public constant returns (bytes32[] memory _publicKeys ,bytes32[] memory _keyNames,bytes32[] memory _currency ,bool[] memory _isDefault, uint[] _lastChange) {
    if (titanUsers[msg.sender].curList.length == 0) revert();

    bytes32[] memory _userCurrencies = titanUsers[msg.sender].curList;

    // get count of all keys of all user currencies for fixed length memory arrays
    uint256 _countofKeys = 0;
    for (uint k = 0; k < _userCurrencies.length; k++) {
      _countofKeys += titanUsers[msg.sender].currencies[_userCurrencies[k]].keyIdGlobal.length;
    }

    _publicKeys = new bytes32[](_countofKeys);
    _keyNames = new bytes32[](_countofKeys);
    _currency = new bytes32[](_countofKeys);
    _isDefault = new bool[](_countofKeys);
    _lastChange = new uint256[](_countofKeys);

    for (uint i = 0; i < _userCurrencies.length; i++) {
      uint256[] memory _currencyGlobalKeys = titanUsers[msg.sender].currencies[_userCurrencies[i]].keyIdGlobal;

      for(uint j = 0; j < _currencyGlobalKeys.length; j++){

        _publicKeys[_countofKeys-1] = titanUsers[msg.sender].userPublicKeys[_currencyGlobalKeys[j]].key;
        _keyNames[_countofKeys-1] = titanUsers[msg.sender].userPublicKeys[_currencyGlobalKeys[j]].keyName;
        _currency[_countofKeys-1] = _userCurrencies[i];
        _isDefault[_countofKeys-1] = titanUsers[msg.sender].userPublicKeys[_currencyGlobalKeys[j]].isDefault;
        _lastChange[_countofKeys-1] = titanUsers[msg.sender].userPublicKeys[_currencyGlobalKeys[j]].lastChange;
        _countofKeys--;
      }

    }
    return (_publicKeys,_keyNames,_currency,_isDefault,_lastChange);
  }

  function addPublicKeyToUser(bytes32 _publicKey, bytes32 _cur, bytes32 _keyName, bool _isDefault) public {
    // Activate Currency for User and push it to the currency arrray
    if (!titanUsers[msg.sender].currencies[_cur].isActive) {
      titanUsers[msg.sender].curList.push(_cur);
      titanUsers[msg.sender].currencies[_cur].isActive = true;
    }
      //Ich muss den TitanName in die NamesList; Dann bekomme ich einen Index zurück. Diesen Index speicher ich bei einem Nutzer ab
      //Hinzufügen des Keys in globale Ledger
    uint256 _keyGlobalIndex = allKeyHashs.push(_publicKey)-1;

    titanUsers[msg.sender].currencies[_cur].keyIdGlobal.push(_keyGlobalIndex); //erster Key = _keyIndex 0

    titanUsers[msg.sender].userPublicKeys[_keyGlobalIndex].key =_publicKey;
    titanUsers[msg.sender].userPublicKeys[_keyGlobalIndex].keyName =_keyName;
    titanUsers[msg.sender].userPublicKeys[_keyGlobalIndex].keyStatus =_isDefault;
    titanUsers[msg.sender].userPublicKeys[_keyGlobalIndex].lastChange = now;

  }

  function getPublicKeyByName (bytes32 _titanName, bytes32 _cur) public constant returns (bytes32 _publicKey ) {
    address _owner = titanNames[_titanName].owner;
    uint256 _len = titanUsers[_owner].currencies[_cur].keyIdGlobal.length; //Beispiel: 1 Key, lenght = 1; index 0

    uint256 j;
    for(uint i = 0; i < _len; i++){

      j = titanUsers[_owner].currencies[_cur].keyIdGlobal[i]; //1. durchlauf i = 0; j = 1 //_keyIndex; Need = 0;

      if(titanUsers[_owner].userPublicKeys[j].keyStatus) {
        // j = Die Id des zu untersuchenden Keys im Globalen Verzeichnis
        return _publicKey = titanUsers[_owner].userPublicKeys[j].key;
      }
    }
    return _publicKey = "Kein Standard Key hinterlegt";
      /*Nutzer hat genau einen Key. Es wird in der Tabelle des Nutzers nach der ID seines Keys in der globalen
      Keyliste gesucht und dieser wird zurückgegeben*/
  }

  // USER - Functions

    function userSignUp(bytes32 _firstName, bytes32 _lastName, bytes32 _email, bool nameIsEmail) public {
      if (titanUsers[msg.sender].firstName == 0x0) titanUsers[msg.sender].firstName = _firstName;
      if (titanUsers[msg.sender].lastName == 0x0) titanUsers[msg.sender].lastName = _lastName;
      if (titanUsers[msg.sender].email == 0x0) titanUsers[msg.sender].email = _email;

      if (nameIsEmail) {
        insertNewName(_email);
      }
    }

    function userUpdate(bytes32 _firstName, bytes32 _lastName, bytes32 _email) onlyExistingUser public {
      titanUsers[msg.sender].firstName = _firstName;
      titanUsers[msg.sender].lastName = _lastName;
      titanUsers[msg.sender].email = _email;
    }

    function userLogin() external view onlyExistingUser returns (bytes32, bytes32, bytes32)
    {
      return (titanUsers[msg.sender].firstName, titanUsers[msg.sender].lastName, titanUsers[msg.sender].email);
    }
  // UTITLITY

  function getCurFromUser() public constant returns(bytes32[]) {
    return titanUsers[msg.sender].curList;
  }
}
