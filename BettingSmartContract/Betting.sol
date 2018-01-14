pragma solidity ^0.4.0;

contract Betting {

    /**New data structure to hold attributes of the bettor. 
     * Team reference to the sports team the bettor predicts will win the game
     **/
    struct Bet {
        address bettor;
        uint team;
        uint amount;
        bool winLoss;
    }
    
    
    //Adds a mapping of the playerBets to their address
    mapping(address=>Bet) public playerBets;
    
    //Adds an index so we can later iterate through all bets made
    mapping(uint => address) public playerBetsIndex;
    uint public numBets;
    
    //Sum of all money that has been bet on the game
    uint public bettingPoolAmount;
    
    
    function bet(uint team) public payable{
        
        playerBets[msg.sender] = Bet({bettor: msg.sender, team: team, amount: msg.value, winLoss: false});
        playerBetsIndex[numBets] = msg.sender;

        bettingPoolAmount += msg.value;
        numBets ++;

    }
    

    function gameEnd(uint winTeam) public{
       
       //Loop through all bets to pay out to the winner
        for(uint i=0;i<numBets; i++) {
            
            //create a temporay bet object to reference easier
            Bet storage b = playerBets[playerBetsIndex[i]];
            
            if(b.team == winTeam) {
                playerBets[playerBetsIndex[i]].winLoss = true;
                b.bettor.transfer(this.balance);
            } else {
                b.winLoss = false;
            }
                
        }
        
    }
    
    
    function getBalance() public constant returns (uint){
        return this.balance;
    }
    
    function getBet() public constant returns (uint, bool){
        Bet storage b = playerBets[msg.sender];
        return (b.team, b.winLoss);
    }

}
