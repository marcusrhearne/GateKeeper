pragma solidity ^ 0.4 .11;
import "../../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol";

contract SmartDevice is Ownable
{
    struct BaseKey
    {
        // Keys which are neither timed keys or metered keys are permanent.
        bool isTimedKey;
        uint startTime;
        uint endTime;
        bool isMeteredKey;
        uint usagesRemaining;
        address keyHolder;
    }
    
    // Storage for contract which is allowed to govern this device's keys
    address intermediaryContract;

    // Raised when the key list is modified, notifying the lock that it needs to update its internal list.
    event OnKeysChanged(address[] addresses, bool[] isTimed, bool[] isMetered, uint[] usages, uint[] start, uint[] end);

    //Array for bulk-access, mapping for random-access.
    BaseKey[] keyRing;
    mapping(address => BaseKey) keyMap;

    //Allows owner or intermediary contract to call the function.
    modifier isAdmin()
    {
        require(msg.sender == owner || msg.sender == intermediaryContract);
        _;
    }

    //Creates a Perm. Key
    function CreateKey(address newKeyHolder) isAdmin returns(bool successful) 
    {
        successful = false;
        BaseKey memory key = keyMap[newKeyHolder];
        if (key.keyHolder == address(0x0))
        {
            var newKey = BaseKey(
            {
                keyHolder: newKeyHolder,
                isTimedKey: false,
                startTime: 0,
                endTime: 0,
                isMeteredKey: false,
                usagesRemaining: 0
            });
            keyRing.push(newKey);
            keyMap[newKeyHolder] = newKey;
            successful = true;
        }
        SendUpdatedKeyRing();
        return successful;
    }

    //Creates a Metered Key
    function CreateKey(address newKeyHolder, uint usages) isAdmin returns(bool successful)
    {
        successful = false;
        BaseKey memory key = keyMap[newKeyHolder];
        if (key.keyHolder == address(0x0))
        {
            var newKey = BaseKey(
            {
                keyHolder: newKeyHolder,
                isTimedKey: false,
                startTime: 0,
                endTime: 0,
                isMeteredKey: true,
                usagesRemaining: usages
            });
            keyRing.push(newKey);
            keyMap[newKeyHolder] = newKey;
            successful = true;
        }
        SendUpdatedKeyRing();
        return successful;
    }

    //Creates a Timed Key
    function CreateKey(address newKeyHolder, uint start, uint end) isAdmin returns(bool successful)
    {
        successful = false;
        BaseKey memory key = keyMap[newKeyHolder];
        if (key.keyHolder == address(0x0))
        {
            var newKey = BaseKey(
            {
                keyHolder: newKeyHolder,
                isTimedKey: true,
                startTime: start,
                endTime: end,
                isMeteredKey: false,
                usagesRemaining: 0
            });
            keyRing.push(newKey);
            keyMap[newKeyHolder] = newKey;
            successful = true;
        }
        SendUpdatedKeyRing();
        return successful;
    }

    //Finds and removes the key in the array, by overwriting it with the last key in the array and truncating the array,
    //Also pushes a null key into the mapping.
    function RemoveKey(address removedKeyHolder) isAdmin returns(bool successful)
    {
        BaseKey memory key = keyMap[removedKeyHolder];
        if (key.keyHolder != address(0x0))
        {
            BaseKey memory lastKey = keyRing[keyRing.length - 1];
            if (lastKey.keyHolder == removedKeyHolder)
            {
                keyRing.length = keyRing.length - 1;
                keyMap[removedKeyHolder] = BaseKey(
                {
                    keyHolder: address(0x0),
                    isTimedKey: false,
                    startTime: 0,
                    endTime: 0,
                    isMeteredKey: false,
                    usagesRemaining: 0
                });
                SendUpdatedKeyRing();
                return true;
            }
            if (keyRing.length < 2) // guard against array out of bounds in loop below
            {
                return false;
            }
            for (uint i = keyRing.length - 2; i >= 0; i--) // we already checked the last key, so start at the 2nd to last.
            {
                var keyAtIndex = keyRing[i];
                if (keyAtIndex.keyHolder == removedKeyHolder)
                {
                    keyRing[i] = lastKey;
                    keyRing.length = keyRing.length - 1;
                    keyMap[removedKeyHolder] = BaseKey(
                    {
                        keyHolder: address(0x0),
                        isTimedKey: false,
                        startTime: 0,
                        endTime: 0,
                        isMeteredKey: false,
                        usagesRemaining: 0
                    });
                    SendUpdatedKeyRing();
                    return true;
                }
            }
            return false;
        }
    }

    //Adds or replaces the intermediary contract
    function AddIntermediary(address intermediaryAddr) onlyOwner
    {
        if (intermediaryContract != address(0x0))
        {
            intermediaryContract = intermediaryAddr;
        }
    }

    //Pushes a split keyring to the lock for reconstruction.
    function SendUpdatedKeyRing(){
        address[] memory addresses = new address[](keyRing.length);
        bool[]    memory isTimed   = new bool[]   (keyRing.length);
        bool[]    memory isMetered = new bool[]   (keyRing.length);
        uint[]    memory usages    = new uint[]   (keyRing.length);
        uint[]    memory start     = new uint[]   (keyRing.length);
        uint[]    memory end       = new uint[]   (keyRing.length);

        for(uint i = 0; i < keyRing.length; i++){
            BaseKey memory keyAtIndex = keyRing[i];
            addresses[i] = keyAtIndex.keyHolder;
            isTimed[i] = keyAtIndex.isTimedKey;
            isMetered[i] = keyAtIndex.isMeteredKey;
            usages[i] = keyAtIndex.usagesRemaining;
            start[i] = keyAtIndex.startTime;
            end[i] = keyAtIndex.endTime;
        }
        OnKeysChanged(addresses, isTimed, isMetered, usages, start, end);
    }
}
