// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract Lottery{
    //state variables lotteryOwner is the owner of the lottery(who deploys the contract)
    address public lotteryOwner;

    //players is the array of the players who participated
    address payable[] public players;

    //for winners History
    uint public id;
    mapping (uint => address payable) private winnersHistory;

    constructor(){ 
        //setting the address of deploayer to lotteryOwner
        lotteryOwner = msg.sender;

    }
    // custom modifier for only owner restriction
    modifier onlyOwner(){
        require(msg.sender == lotteryOwner);
        _;
    }

    //players apply for the Lottery.
    function Apply() public payable {
        // players should have atleast 0.01 ethers to apply for the lottery.
        require(msg.value >= 0.01 ether, "you don't have enough ether to apply for Lottery");

        //setting up the address of applier to players[].
        players.push(payable(msg.sender));
    }

    // get the (contract) Account balance
    function getContractBalance () public view returns(uint){
        return address(this).balance;
    }

    //get all the (addresses) players that apply for the lottery;
    function getAppliedPlayers() public view returns(address payable[] memory){
        return players;
    }

    //Get the random numbers for selecting the winner.
    function getRandomNumber() public view returns(uint){
        //temporary  way to get random number.
        return uint(keccak256(abi.encodePacked(lotteryOwner,block.timestamp)));
    }


   
   

    //pick the winner from players[].
    function pickWinner() public onlyOwner{
        require(players.length != 0, "No player is applied for the lottery");

        // get Random number from 0 to players[] length - 1;
        uint randomNumber = getRandomNumber() % players.length;

        //transfer the money to winners account
        players[randomNumber].transfer(address(this).balance);

        //update the history
        winnersHistory[id] = players[randomNumber];
        id++;

        //after payment reset the players[].
        // players = new address payable[](0);

        delete players;  // this means players.length = 0; 
    }


    // for getting winner
    function showWinner(uint lotteryId) public view returns (address payable){
        return winnersHistory[lotteryId];
    }
}