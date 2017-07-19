pragma solidity ^0.4.8; 

contract SmartDevice{
    address owner; //sets the device owner
    address intermediaryContract; //could be marketplace, oracle etc. 
    
    
    struct Opener{
        //For rental type locks
        uint startTime; //blocktime or epoch ?
        uint endTime; 
        
        uint value;  // value per lock in Wei
        bool exists; //fucking key value bs
    }
    
    bool allowIntermediary; //determined by constructor or change by admin
    event OpenLock(address opener); 
    mapping (address => bool) permOpeners; 
    mapping (address => Opener) openers; 
    uint256 fwUpdate; //points to hash of latest FWUpdate  on IPFS 
    
    
    modifier isAdmin{
        require((msg.sender == owner) || (msg.sender == intermediaryContract)); 
        _;
    }
    
    function createRental (uint start, uint end,  uint avalue, address rentee) isAdmin{
        openers[rentee] = Opener({startTime: start, endTime: end, value: avalue, exists: true}); 
        
    }
    
    function createPerm (address keyholder) isAdmin{
        permOpeners[keyholder] = true; 
    }
    
  
    function addIntermediary (address intermediaryAddr) isAdmin{
        if(allowIntermediary == true){
            intermediaryContract = intermediaryAddr; 
        }
    }
    
      function openLock(){
       if (permOpeners[msg.sender] == true){
            OpenLock(msg.sender); //Lock will wait for event to be fired
       }
       else if (openers[msg.sender].exists != false){
           OpenLock(msg.sender); //possibly leaky logic
           
       }
    }
    
}
