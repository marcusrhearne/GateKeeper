pragma solidity ^0.4.13; 

contract SmartDevice{
    address deviceOwner;
    address intermediaryContract;
    
    struct KeyRing{
        address keyholder;
        BaseKey[] keys;
    }

    struct BaseKey{
        // Keys which are neither timed keys or metered keys are permanent.
        bool isTimedKey;
        uint startTime;
        uint endTime;

        bool isMeteredKey;
        uint usagesRemaining;
    }
    
    event OnLockOpened(address opener); 
    
    mapping (address => KeyRing) keyRings;
    
    modifier isAdmin{
        require((msg.sender == deviceOwner) || (msg.sender == intermediaryContract)); 
        _;
    }

    function InitializeKeyRing(address keyHolder, KeyRing keyring){
        if(keyring.keyholder == address(0x0))
        {
            keyring.keyholder = keyHolder;
        }
    }

    function CreateKey (address keyHolder) isAdmin
    {
        KeyRing keyring = keyRings[address];
        InitializeKeyRing(keyHolder, keyring);
        BaseKey newKey = BaseKey(
            {
                isTimedKey : false,
                isMeteredKey : false
            }
        )
        keyring.keys.push(newKey);
    }

    function CreateKey (address keyHolder, uint usages) isAdmin
    {
        KeyRing keyring = keyRings[address];
        InitializeKeyRing(keyHolder, keyring);
        BaseKey newKey = BaseKey(
            {
                isTimedKey : false,
                isMeteredKey : true,
                usagesRemaining : usages
            }
        )
        keyring.keys.push(newKey);
    }

    function CreateKey (address keyHolder, uint start, uint end) isAdmin
    {
        KeyRing keyring = keyRings[address];
        InitializeKeyRing(keyHolder, keyring);
        BaseKey newKey = BaseKey(
            {
                isTimedKey : true,
                startTime : start,
                endTime : end,
                isMeteredKey : false
            }
        )
        keyring.keys.push(newKey);
    }

    function AddIntermediary (address intermediaryAddr) isAdmin{
        if(allowIntermediary == true){
            intermediaryContract = intermediaryAddr; 
        }
    }
    
    function OpenLock() returns(bool successful){
        KeyRing keyRing = keyRings[msg.sender];
        if(keyring.keyholder == address(0x0))){
            return false;
        }
        // implement iterable mapping for keyring
    }
    
}
