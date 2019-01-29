// var Owned = artifacts.require("./Owned.sol");
// var SnapShot = artifacts.require("./SnapShot.sol");
// var AirDrop = artifacts.require("./AirDrop.sol");
// var FeePool = artifacts.require("./FeePool.sol");
var Arcade = artifacts.require("./Arcade.sol");

module.exports = function(deployer) {
    // deployer.deploy(Owned);
    // deployer.link(Owned, SnapShot);
    // deployer.deploy(SnapShot);

    // deployer.link(Owned, SnapShot);
    // deployer.deploy(AirDrop);

    // deployer.link(SnapShot, AirDrop, FeePool);
    // deployer.deploy(FeePool);

    // deployer.link(FeePool, Arcade);
    deployer.deploy(Arcade);
};

