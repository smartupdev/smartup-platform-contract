var smartideltokenerc20 = artifacts.require("./SmartIdeaTokenERC20.sol");
var ntt = artifacts.require("./NTT.sol");
//var smartup = artifacts.require("./SmartUp.sol");


module.exports = function (deployer, network, accounts) {
    console.log("accounts,", accounts);
    console.log("network", network);
    var owner = accounts[0];
    var sutTotalSupply = 100000000;
    deployer.deploy(smartideltokenerc20, sutTotalSupply, "smartuptoken", "SUT",).then(function () {
        return deployer.deploy(ntt, owner);
    })
}