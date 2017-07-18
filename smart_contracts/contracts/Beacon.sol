pragma solidity ^0.4.8; 

contract Beacon{
    string beaconID = 'a3141'; 
    bool beaconOn = false; 
    event beaconSwitched(bool beaconState); 
    
    function switchBeacon(){
        beaconOn = !beaconOn;

        beaconSwitched(!beaconOn); 
    }

}