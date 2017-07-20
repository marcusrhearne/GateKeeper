pragma solidity ^0.4.11; 

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
    
    modifier isAdmin(){
        require(msg.sender == deviceOwner || msg.sender == intermediaryContract); 
        _;
    }

    function CreateKey (address keyHolder) isAdmin
    {
        KeyRing keyring = keyRings[keyHolder];
        if(keyring.keyholder == address(0x0))
        {
            keyring.keyholder = keyHolder;
        }
        var newKey = BaseKey(
            {
                isTimedKey : false,
                startTime : 0,
                endTime : 0,
                isMeteredKey : false,
                usagesRemaining : 0
            }
        );
        keyring.keys.push(newKey);
    }

    function CreateKey (address keyHolder, uint usages) isAdmin
    {
        KeyRing keyring = keyRings[keyHolder];
        if(keyring.keyholder == address(0x0))
        {
            keyring.keyholder = keyHolder;
        }
        var newKey = BaseKey(
            {
                isTimedKey : false,
                startTime : 0,
                endTime : 0,
                isMeteredKey : true,
                usagesRemaining : usages
            }
        );
        keyring.keys.push(newKey);
    }

    function CreateKey (address keyHolder, uint start, uint end) isAdmin
    {
        KeyRing keyring = keyRings[keyHolder];
        if(keyring.keyholder == address(0x0))
        {
            keyring.keyholder = keyHolder;
        }
        var newKey = BaseKey(
            {
                isTimedKey : true,
                startTime : start,
                endTime : end,
                isMeteredKey : false,
                usagesRemaining : 0
            }
        );
        keyring.keys.push(newKey);
    }

    function AddIntermediary (address intermediaryAddr) isAdmin{
        if(intermediaryContract != address(0x0)){
            intermediaryContract = intermediaryAddr; 
        }
    }
    
    function VerifyKeyExists(string message) returns(bool authorized){
        
    }
    
}
