pragma solidity ^0.4.23;

import "./SnapShot.sol";
import "./AirDrop.sol";

contract IArcade {
    function emitGetSnapShotData(uint blockNumber) public;
    function emitReceiveSnapShotData(address tokenHolder, uint tokenAmount, uint blockNumber) public;
}

contract FeePool is Owned {
    using SafeMath for uint;

    struct FeeData {
        uint game_id;
        uint arcade_fee;
    }

    mapping(uint => FeeData) fees;
    uint total_fee;
    SnapShot snapShot;
    AirDrop airDrop;
    uint last_snapshot_block;
    uint last_airdrop_block;

    constructor(uint blockNumber) Owned() public {

        snapShot = new SnapShot();
        airDrop = new AirDrop();
        last_snapshot_block = blockNumber;
        last_airdrop_block = blockNumber;
    }

    // snapshot test method
    function startSnapShot(uint blockNumber) public onlyOwner {
        snapShot.runSnapShot(blockNumber);
    }

    function updateSnapShotData(address tokenHolder, uint tokenAmount, uint blockNumber) public onlyOwner {
        snapShot.updateSnapShotData(tokenHolder, tokenAmount, blockNumber);
    }

    function emitGetSnapShotData(uint blockNumber) public {
        require(address(snapShot) == msg.sender, "Wrong owner. Can not emit event of getSnapShotData.");

        IArcade(owner).emitGetSnapShotData(blockNumber);
    }

    function emitReceiveSnapShotData(address tokenHolder, uint tokenAmount, uint blockNumber) public {
        require(address(snapShot) == msg.sender, "Wrong owner. Can not emit event of receiveSnapShotData.");

        IArcade(owner).emitReceiveSnapShotData(tokenHolder, tokenAmount, blockNumber);
    }

    function setFee(uint game_id, uint fee) public onlyOwner {
        fees[block.number] = FeeData(game_id, fee);
        total_fee += fee;

        if (block.number - last_snapshot_block > 14400) {
            last_snapshot_block += 14400;
            snapShot.runSnapShot(last_snapshot_block);
        }

        if (block.number - last_airdrop_block > 201600) {
            last_airdrop_block += 201600;
            uint _total_fee = total_fee;
            total_fee = 0;

            airDrop.runAirDrop(last_airdrop_block, _total_fee);
        }
    }

    function getSnapShotBlockNumbers(uint start, uint end) public returns (uint[] memory blockNumbers, uint length) {
        require(address(airDrop) == msg.sender, "Wrong owner. Can not get snap shot block numbers.");

        return snapShot.getSnapShotBlockNumbers(start, end);
    }

    function getSnapShotAddressCount(uint snapShot_blockNumber) public view returns (uint count) {
        require(address(airDrop) == msg.sender, "Wrong owner. Can not get snap shot address count.");

        return snapShot.getSnapShotAddressCount(snapShot_blockNumber);
    }

    function getSnapShotAddress(uint snapShot_blockNumber, uint addr_index) public view returns (address addr, uint amount) {
        require(address(airDrop) == msg.sender, "Wrong owner. Can not get snap shot address and amount.");

        return snapShot.getSnapShotAddress(snapShot_blockNumber, addr_index);
    }

    function getSnapShotTotalAmount(uint snapShot_blockNumber) public view returns (uint total_amount) {
        require(address(airDrop) == msg.sender, "Wrong owner. Can not get amount of address.");

        return snapShot.getSnapShotTotalAmount(snapShot_blockNumber);
    }
}
