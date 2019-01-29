var Arcade = artifacts.require("./Arcade.sol");
contract('Arcade', function(accounts) {
	it("emit getSnapShotData", function() {
	    return Arcade.deployed().then(function(instance) {
		  return instance.emitGetSnapShotData(1000);
		}).then(function(result) {
			console.log('RESULT = ' + result);
		  // assert.equal("method emitGetSnapShotData", result[0], "is not call method g");
	    });
	});
});
