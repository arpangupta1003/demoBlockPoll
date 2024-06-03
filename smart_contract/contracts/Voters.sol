// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Voters {
  event getWinnerArr(Candidate[] res);
  
  struct User{
    uint id;
    string aadhar;
    string name;
    string email;
    bytes32 pass;
    string cid;
    string key;
    bool isValidated;
  }

  struct Candidate{
    uint id;
    string name;
    uint256 regNo;
    uint voteCount;
  }

  struct Election{
    uint id;
    string name;
    uint256 totalVote;
    uint candidateCount;
    bool isActive;
    bool deleted;
    uint createdBy;
  }

  struct History{
    string poll;
    string candidate;
    uint256 time;
  }

  User[] private userlist;
  User[] private voterList;
  Candidate[] private candidateList;
  Election[] private electionList;

  mapping (uint=>Candidate) electionWinner;
  mapping (uint=>bool) winnerMapped;
  mapping (uint=>History[]) userHistory;
  mapping (address=>uint) UserToId;
  mapping (address=>bool) userExists;
  mapping (uint=>bool) public UserRole;
  mapping (uint=>mapping(uint=>bool)) candidateMap;
  mapping (uint=>mapping(uint=>bool)) electionToCandidate;
  mapping (uint=>mapping(uint=>bool)) userToElection;
  mapping (uint=>mapping(uint=>bool)) public userVote;
  mapping (uint=>mapping(uint=>uint)) userElectionCandidateMap;

  constructor(){
    string memory hsh="d%4c50e2dbA5&ed&dd90U&2d-R]73d1]Wc73+54u9bKx45672ib26f0p1Nmk_+20cpdC(b5712";
    address addr=0x76C88457A491848E66673E603725eBde8119d59A;
    userlist.push(User(0,"000000000000","Admin","admin@admin.admin",collisionHash(hsh),'0','MRSDSMCVGJSFENZT',true));
    voterList.push(userlist[0]);
    UserRole[0]=true;
    UserToId[addr]=0;
    userExists[addr]=true;
  }

  function mapUserToElection(uint electionID,uint userID) external{
    userToElection[electionID][userID]=true;
  }

  function removeUserElectionMap(uint electionID,uint userID) external{
    userToElection[electionID][userID]=false;
  }

  function getUnaddedUserToElection(uint electionID) external view returns(User[] memory){
    User[] memory temp=new User[](userlist.length);
    uint counter=0;
    for(uint i=0;i<userlist.length;i++){
      if(userlist[i].isValidated==true && userToElection[electionID][i]!=true){
        temp[counter]=userlist[i];
        counter++;
      }
    }
    User[] memory result=new User[](counter);
    for(uint i=0;i<counter;i++){
      result[i]=temp[i];
    }
    return result;
  }

  function getAddedUserToElection(uint electionID) external view returns(User[] memory){
    User[] memory temp=new User[](userlist.length);
    uint counter=0;
    for(uint i=0;i<userlist.length;i++){
      if(userlist[i].isValidated==true && userToElection[electionID][i]==true){
        temp[counter]=userlist[i];
        counter++;
      }
    }
    User[] memory result=new User[](counter);
    for(uint i=0;i<counter;i++){
      result[i]=temp[i];
    }
    return result;
  }

  function getCandidates(uint id) external view returns(Candidate[] memory){
    Candidate[] memory temp=new Candidate[](candidateList.length);
    uint counter=0;
    for(uint i=0;i<candidateList.length;i++){
      if(electionToCandidate[id][i]==true){
        temp[counter]=candidateList[i];
        counter++;
      }
    }
    Candidate[] memory result=new Candidate[](counter);
    for(uint i=0;i<counter;i++){
      result[i]=temp[i];
    }
    return result;
  }

  function mapCandidate(uint256 regNo,uint electionID,uint candidateID) external{
    candidateMap[regNo][electionID]=!candidateMap[regNo][electionID];
    electionToCandidate[electionID][candidateID]=!electionToCandidate[electionID][candidateID];
    if(candidateMap[regNo][electionID]==false){
      electionList[electionID].candidateCount--;
    }
  }

  function addCandidate(string memory name,uint256 regNo,uint electionID) public{
    require(!candidateMap[regNo][electionID],"Already Added!");
    uint candidateID=candidateList.length;
    candidateList.push(Candidate(candidateID,name,regNo,0));
    candidateMap[regNo][electionID]=true;
    electionToCandidate[electionID][candidateID]=true;
    electionList[electionID].candidateCount++;
  }

  function removeElection(uint id) external{
    electionList[id].deleted=true;
  }

  function addElection(string memory name) external {
    uint ID=electionList.length;
    electionList.push(Election(ID,name,0,0,false,false,UserToId[msg.sender]));
    addCandidate("None of the Above",0,ID);
  }

  function auditElections(uint id)external{
      electionList[id].isActive=!electionList[id].isActive;
  }

  function isAdminMain() private view returns (bool){
    if(UserToId[msg.sender]==0)
      return true;
    else
      return false;
  }

  function getElectionList() external view returns(Election[] memory){
    uint cnt=electionList.length;
    Election[] memory temp=new Election[](cnt);
    uint counter=0;
    bool flag=isAdminMain();
    for(uint i=cnt;i>0;i--){
      if(electionList[i-1].deleted==false){
        if(flag==true){
          temp[counter]=electionList[i-1];
          counter++;
        }
        else if(electionList[i-1].createdBy==UserToId[msg.sender]){
          temp[counter]=electionList[i-1];
          counter++;
        }
      }
    }
    Election[] memory result=new Election[](counter);
    for(uint i=0;i<counter;i++){
      result[i]=temp[i];
    }
    return result;
  }

  function getActiveElections() external view returns(Election[] memory){
    Election[] memory temp=new Election[](electionList.length);
    uint counter=0;
    bool flag=isAdminMain();
    for(uint i=0;i<electionList.length;i++){
      if(electionList[i].isActive==true && electionList[i].deleted==false){
        if(flag==true){
          temp[counter]=electionList[i];
          counter++;
        }
        else if(electionList[i].createdBy==UserToId[msg.sender]){
          temp[counter]=electionList[i];
          counter++;
        }
      }
    }
    Election[] memory result=new Election[](counter);
    for(uint i=0;i<counter;i++){
      result[i]=temp[i];
    }
    return result;
  }

  function isUserRegistered() public view returns (bool){
    if(userExists[msg.sender]==true){
      return true;
    }
    else{
      return false;
    }
  }

  function loginUser(string memory pass,string memory aadhar) external view returns (bool){
    require(isUserRegistered());
    User memory tmp=userlist[UserToId[msg.sender]];
    bytes32 chkHash=keccak256(abi.encode(pass));
    if(tmp.pass==chkHash && (keccak256(abi.encodePacked(tmp.aadhar)) == keccak256(abi.encodePacked(aadhar)))){
      return true;
    }
    else{
      return false;
    }
  }

  function setPass(string memory _pass) public {
    userlist[UserToId[msg.sender]].pass=keccak256(abi.encode(_pass));
  }

  function switchRole(uint id) public{
    require(id!=0);
    require(id!=UserToId[msg.sender]);
    UserRole[id]=!UserRole[id];
  }


  function collisionHash(string memory _string1) public pure returns (bytes32) {
    return keccak256(abi.encode(_string1));
  }
  
  function addUser(string memory aadhar,string memory name,string memory email,string memory pass,string memory cid,string memory key,bool isValidated) external{
    require(!isUserRegistered(),"Already Registered!");
    uint userID=userlist.length;
    bytes32 hsh=collisionHash(pass);
    UserToId[msg.sender]=userID;
    UserRole[userID]=false;
    userlist.push(User(userID,aadhar,name,email,hsh,cid,key,isValidated));
    userExists[msg.sender]=true;
  }

  function ValidateUser(uint userID) public{
    userlist[userID].isValidated=true;
    voterList.push(userlist[userID]);
  }

  function getUserList() external view returns(User[] memory){
    User[] memory temp=new User[](userlist.length);
    uint counter=0;
    for(uint i=0;i<userlist.length;i++){
      if(userlist[i].isValidated==false){
        temp[counter]=userlist[i];
        counter++;
      }
    }
    User[] memory result=new User[](counter);
    for(uint i=0;i<counter;i++){
      result[i]=temp[i];
    }
    return result;
  }

  function getVoterList() external view returns(User[] memory){
    User[] memory result=new User[](voterList.length);
    for(uint i=0;i<voterList.length;i++){
      result[i]=voterList[i];
    }
    return result;
  }

  function getUserDetails() public view returns(User memory){
    require(userExists[msg.sender]==true,"User does not exist");
    return userlist[UserToId[msg.sender]];
  }

  function getMappedElections(uint id) public view returns(Election[] memory){
    Election[] memory temp=new Election[](electionList.length);
    uint counter=0;
    for(uint i=0;i<electionList.length;i++){
      if(electionList[i].isActive==true && electionList[i].deleted==false && userToElection[i][id]==true){
        temp[counter]=electionList[i];
        counter++;
      }
    }
    Election[] memory result=new Election[](counter);
    for(uint i=0;i<counter;i++){
      result[i]=temp[i];
    }
    return result;
  }

  function getAllMappedElections(uint id) public view returns(Election[] memory){
    Election[] memory temp=new Election[](electionList.length);
    uint counter=0;
    for(uint i=0;i<electionList.length;i++){
      if(userToElection[i][id]==true){
        temp[counter]=electionList[i];
        counter++;
      }
    }
    Election[] memory result=new Election[](counter);
    for(uint i=0;i<counter;i++){
      result[i]=temp[i];
    }
    return result;
  }

  function castVote(uint userid,uint electionid,uint candidateid) public {
    require(UserToId[msg.sender]==userid,"Unauthorized access detected!");
    require(!userVote[userid][electionid],"Already Voted!");
    userElectionCandidateMap[userid][electionid]=candidateid;
    userVote[userid][electionid]=true;
    candidateList[candidateid].voteCount++;
    electionList[electionid].totalVote++;
    setHistory(userid, electionid, candidateid, block.timestamp);
  }

  function setHistory(uint userid,uint electionid,uint candidateid,uint256 time) public{
    userHistory[userid].push(History(electionList[electionid].name,candidateList[candidateid].name,time));
  }

  function getHistory(uint userid) public view returns(History[] memory){
    return userHistory[userid];
  }

  function findWinner(uint electionID) external{
    require(electionList[electionID].deleted==false);
    require(electionList[electionID].isActive==false);
    require(electionList[electionID].totalVote>0);
    Candidate[] memory tmp=new Candidate[](candidateList.length);
    uint counter=0;
    uint maxVote=0;
    for(uint i=0;i<candidateList.length;i++){
      if(electionToCandidate[electionID][i]==true && candidateList[i].voteCount>=maxVote && candidateList[i].regNo!=0){
        maxVote=candidateList[i].voteCount;
        tmp[counter]=candidateList[i];
        counter++;
      }
    }
    Candidate[]  memory res=new Candidate[](counter);
    for(uint i=0;i<counter;i++){
      res[i]=tmp[i];
    }
    if(res.length==0){
      electionWinner[electionID]=Candidate(0,"No Winner",0,0);
      winnerMapped[electionID]=true;
    }
    else if(res.length==1){
      electionWinner[electionID]=res[0];
      winnerMapped[electionID]=true;
    }
    emit getWinnerArr(res);
  }

  function setTieWinner(uint electionID,Candidate memory cnd) public{
    cnd.voteCount++;
    electionWinner[electionID]=cnd;
    winnerMapped[electionID]=true;
  }

  function getWinner(uint electionID) public view returns(Candidate memory){
    if(winnerMapped[electionID]){
      return electionWinner[electionID];
    }
    else{
      return Candidate(0,"null",0,0);
    }
  }

}