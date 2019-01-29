pragma solidity ^0.4.23;

import "./Owned.sol";
import "./SafeMath.sol";
import "./IFeePool.sol";

contract AirDrop is Owned {
    using SafeMath for uint;

    constructor() Owned() public {}

    function runAirDrop(uint last_air_drop, uint total_fee) public onlyOwner {
        uint[] memory blockNumbers;
        uint length;
        uint total_amount;
        uint i;
        (blockNumbers, length) = IFeePool(owner).getSnapShotBlockNumbers (last_air_drop - 201600, last_air_drop);

        for (i = 0; i < length; i++) {
            total_amount += IFeePool(owner).getSnapShotTotalAmount (blockNumbers[i]);
        }

        for (i = 0; i < length; i++) {
            uint addressCount = IFeePool(owner).getSnapShotAddressCount (blockNumbers[i]);

            for (uint j = 0; j < addressCount; j++) {
                address addr;
                uint amount;

                (addr, amount) = IFeePool(owner).getSnapShotAddress (blockNumbers[i], j);
                amount = (amount * 1.0 trx / total_amount) * total_fee;
                addr.transfer(amount);
            }
        }
    }
}
