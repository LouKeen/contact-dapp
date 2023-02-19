// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.16 <0.9.0;
pragma experimental ABIEncoderV2;

contract Contact {
    struct User {
        uint8 accessLevel; // 1 - Admin, 2 - Supervisor, 3 - User
        address[] friends;
        address[] requests;
        uint index;
    }

    mapping(address => User) public users;
    address[] private userIndex;

    constructor() {
        User storage admin = users[msg.sender];
        admin.accessLevel = 3;
        admin.index = 0;
        userIndex.push(msg.sender);
    }

    function signUp() public {
        require(!(userIndex[users[msg.sender].index] == msg.sender)); // Check if already registered
        User storage user = users[msg.sender];
        user.accessLevel = 1;
        user.index = userIndex.length;
        userIndex.push(msg.sender);
    }

    function promote(address userToPromote) public adminOnly {
        require(isUser(userToPromote));
        User storage user = users[userToPromote];
        require(user.accessLevel < 2);
        user.accessLevel = user.accessLevel + 1;
    }

    function demote(address userToDemote) public adminOnly {
        require(isUser(userToDemote));
        User storage user = users[userToDemote];
        require(user.accessLevel > 1);
        user.accessLevel = user.accessLevel - 1;
    }

    function invite(address userToInvite) public userOnly {
        require(isUser(userToInvite));
        User storage userToAdd = users[userToInvite];
        userToAdd.requests.push(msg.sender);
    }

    function approve(uint requestToAccept) public userOnly {
        User storage user = users[msg.sender];
        address userToAccept = user.requests[requestToAccept];
        user.friends.push(userToAccept);
        requestCleanUp(user.requests, requestToAccept);
    }

    function decline(uint requestToDecline) public userOnly {
        User storage user = users[msg.sender];
        requestCleanUp(user.requests, requestToDecline);
    }

    // Query functions
    function getRequests() public view returns (address[] memory) {
        return users[msg.sender].requests;
    }

    function getUser(address user) public view returns (User memory) {
        require(isUser(user));
        return users[user];
    }

    function getFriends() public view returns (address[] memory) {
        return users[msg.sender].friends;
    }

    function isUser(address user) private view returns (bool) {
        return userIndex[users[user].index] == user;
    }

    function requestCleanUp(address[] storage requests, uint removedIndex) private {
        if(requests.length > 0) {
            requests[removedIndex] = requests[requests.length - 1];
        }
        requests.pop();
    }

    // Modifiers
    modifier adminOnly() {
        require(users[msg.sender].accessLevel == 3);
        _;
    }

    modifier userOnly() {
        require(userIndex[users[msg.sender].index] == msg.sender);
        _;
    }
}