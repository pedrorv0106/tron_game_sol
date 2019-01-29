pragma solidity ^0.4.23;

import "./Owned.sol";
import "./SafeMath.sol";
import "./IFeePool.sol";

contract SnapShot is Owned {
    using SafeMath for uint;

    struct SnapShotData {
        address[] snapShotAddress;
        mapping(address => uint) amountOfAddress;
        uint totalAmount;
    }

    mapping(uint => SnapShotData) data;
    uint[] snapShotBlockNumbers;
    uint lastIndexOfBlockNumbers;

    constructor() Owned() public {}

    function runSnapShot(uint blockNumber) public onlyOwner {
        snapShotBlockNumbers.push(blockNumber);

        // run the contract of oraclize
        IFeePool(owner).emitGetSnapShotData(blockNumber);
    }

    function updateSnapShotData(address tokenHolder, uint tokenAmount, uint blockNumber) public onlyOwner {
        data[blockNumber].snapShotAddress.push(tokenHolder);
        data[blockNumber].amountOfAddress[tokenHolder] = tokenAmount;
        data[blockNumber].totalAmount += tokenAmount;

        IFeePool(owner).emitReceiveSnapShotData(tokenHolder, tokenAmount, blockNumber);
    }

    function getSnapShotBlockNumbers(uint start, uint end) public onlyOwner returns (uint[] memory blockNumbers, uint length) {
        uint[] memory tempBlockNumbers = new uint[](15);
        uint i;
        length = 0;

        for (i = lastIndexOfBlockNumbers; i < snapShotBlockNumbers.length; i++) {
            if ((snapShotBlockNumbers[i] >= start) &&
                (snapShotBlockNumbers[i] < end)) {
                tempBlockNumbers[length] = snapShotBlockNumbers[i];
                length++;
            }

            if (snapShotBlockNumbers[i] >= end)
                break;
        }

        lastIndexOfBlockNumbers = i;
        blockNumbers = tempBlockNumbers;
    }

    function getSnapShotAddressCount(uint snapShot_blockNumber) public view onlyOwner returns (uint count) {
        count = data[snapShot_blockNumber].snapShotAddress.length;
    }

    function getSnapShotAddress(uint snapShot_blockNumber, uint addr_index) public view onlyOwner returns (address addr, uint amount) {
        addr = data[snapShot_blockNumber].snapShotAddress[addr_index];
        amount = data[snapShot_blockNumber].amountOfAddress[addr];
    }

    function getSnapShotTotalAmount(uint snapShot_blockNumber) public view onlyOwner returns (uint total_amount) {
        total_amount = data[snapShot_blockNumber].totalAmount;
    }

}