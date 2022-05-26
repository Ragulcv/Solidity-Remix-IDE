//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Team {
address[16] team;
function getTeamPlayers() public view returns(address[16] memory){
return team;
}
function selectJerseyNumber(uint256 playerID) public view returns(uint256){
require(playerID >= 0 && playerID <= 15);
team[playerID] == msg.sender;
return playerID;
}
}
