pragma solidity ^0.4.23;

contract IFeePool {
    function getSnapShotBlockNumbers(uint start, uint end) public returns (uint[] memory blockNumbers, uint length);
    function getSnapShotAddressCount(uint snapShot_blockNumber) public returns (uint count);
    function getSnapShotAddress(uint snapShot_blockNumber, uint addr_index) public returns (address addr, uint amount);
    function getSnapShotTotalAmount(uint snapShot_blockNumber) public returns (uint total_amount);
    function emitGetSnapShotData(uint blockNumber) public;
    function emitReceiveSnapShotData(address tokenHolder, uint tokenAmount, uint blockNumber) public;
}