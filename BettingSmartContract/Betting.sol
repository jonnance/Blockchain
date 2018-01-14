
contract Betting {
    /* This creates an array with all balances */
    //mapping (address => uint256) public balanceOf;
    address public winner;
    address public loser;
    uint public winningTeam;
    
    uint public bettingPoolAmount;
    
    mapping(address=>Bet) public playerBets;
    mapping(uint=>Bet) public playerBets2;

    mapping(uint => address) public playerBetsIndex;
    uint public numBets;
    
    mapping(uint => uint) public mapTest;
    
    
    struct Bet {
        address bettor;
        uint team;
        uint amount;
        bool winLoss;
    }
    
    Bet public firstbet;
    uint public numberTest;
    
    
    function bet(uint team) public payable{
        
        numBets ++;
        playerBets[msg.sender] = Bet({bettor: msg.sender, team: team, amount: msg.value, winLoss: false});
        playerBetsIndex[numBets] = msg.sender;
        firstbet = Bet({bettor: msg.sender, team: team, amount: msg.value, winLoss: false});

        mapTest[1] = 1;

        bettingPoolAmount += msg.value;
    }
    

    function gameEnd(uint winTeam) public{
        winningTeam = winTeam;
        for(uint i=0;i<numBets+1; i++) {
            Bet storage b = playerBets[playerBetsIndex[i]];
            //numberTest = playerBets[playerBetsIndex[i]].team;
            if(b.team == winningTeam) {
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
    
    function getBet() public constant returns (uint, bool, bool){
        Bet storage b = playerBets[msg.sender];
        return (b.team, b.winLoss, b.team == winningTeam);
    }

}
