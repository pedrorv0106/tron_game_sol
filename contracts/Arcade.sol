pragma solidity ^0.4.23;

import "./FeePool.sol";

contract Arcade is Owned {
    using SafeMath for uint;

    event Register(address indexed _player);
    event receiveSnapShotData(address tokenHolder, uint tokenAmount, uint blockNumber);
    event getSnapShotData(uint blockNumber);

    struct GameInfo {
        mapping(address => uint) fee;
        uint total_fee;
        uint registration_fee;
        uint player_limit;
    }

    FeePool feePool;
    mapping(uint => GameInfo) gameData;
    uint fee_percentage;

    constructor() Owned() public {
        fee_percentage = 10.0;
        feePool = new FeePool(block.number);
    }

    function updateSnapShotData(address tokenHolder, uint tokenAmount, uint blockNumber) public onlyOwner {
        feePool.updateSnapShotData(tokenHolder, tokenAmount, blockNumber);
    }

    // snapshot test method
    function startSnapShot(uint blockNumber) public onlyOwner {
        feePool.startSnapShot(blockNumber);
    }

    function emitGetSnapShotData(uint blockNumber) public {
        require(address(feePool) == msg.sender, "Wrong owner. Can not emit event of getSnapShotData.");

        emit getSnapShotData(blockNumber);
    }

    function emitReceiveSnapShotData(address tokenHolder, uint tokenAmount, uint blockNumber) public {
        require(address(feePool) == msg.sender, "Wrong owner. Can not emit event of receiveSnapShotData.");
        
        emit receiveSnapShotData(tokenHolder, tokenAmount, blockNumber);
    }

    function createGame(uint game_id, uint registration_fee, uint player_limit) public onlyOwner {
        gameData[game_id].total_fee = 0;
        gameData[game_id].registration_fee = registration_fee * 1.0 trx;
        gameData[game_id].player_limit = player_limit;
    }

    function setArcadeFeePercentage(uint percentage) public onlyOwner {
        fee_percentage = percentage;
    }

    function refund() public onlyOwner {
        uint balance = address(this).balance;

        if (balance > 0) {
            owner.transfer(balance);
        }
    }

    function register(uint game_id) public payable {
        require(gameData[game_id].fee[msg.sender] <= 0, "Already registered");
        require(gameData[game_id].player_limit > 0, "Game not found");
        require(msg.value >= gameData[game_id].registration_fee, "Not enough registration fee");

        gameData[game_id].fee[msg.sender] = msg.value;
        gameData[game_id].total_fee += msg.value;

        emit Register(msg.sender);
    }

    function setWinner(uint game_id, address winner) public onlyOwner {

        require(gameData[game_id].fee[winner] > 0, "Not registered winner for this game");

        uint arcade_fee = gameData[game_id].total_fee * fee_percentage / 100.0;
        uint winner_amount = gameData[game_id].total_fee - arcade_fee;
        uint balance = address(this).balance;

        if (balance < winner_amount) {
            winner_amount = balance;
        }

        delete gameData[game_id];

        feePool.setFee(game_id, arcade_fee);
        winner.transfer(winner_amount);
    }

}
