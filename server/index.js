import Web3 from 'web3'; 
import BeaconABI from '../smart_contracts/build/contracts/Beacon.json'; 
import contract from 'truffle-contract'; 

   
    
    const a = new Web3.providers.HttpProvider('http://localhost:8545');
   
    const Web3A = new Web3(a); 

    let Beacon = contract(BeaconABI); 
    Beacon.setProvider(a); 
    let account = Web3A.eth.accounts[0]; 
    

   Beacon.deployed().then((instance)=>{
      

       var BeaconEvent = instance.beaconSwitched(); 
       BeaconEvent.watch( function(error, result) {
                if (!error) {
                        console.log(result.args);
                } else {
                        console.log( error);
                }
        });
   })



