const abi = [{"constant":true,"inputs":[{"name":"ctAddress","type":"address"}],"name":"votingPeriod","outputs":[{"name":"start","type":"uint256"},{"name":"end","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"ctAddress","type":"address"}],"name":"appealingPeriod","outputs":[{"name":"start","type":"uint256"},{"name":"end","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"ctAddress","type":"address"}],"name":"conclude","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"ctAddress","type":"address"}],"name":"appealRound","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"cancelOwnershipTransfer","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"ctAddress","type":"address"}],"name":"ballots","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"ctAddress","type":"address"}],"name":"state","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"ctAddress","type":"address"}],"name":"closeFlagging","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"ctAddress","type":"address"}],"name":"flaggerList","outputs":[{"name":"","type":"address[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"ctAddress","type":"address"}],"name":"totalCreatorDeposit","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"ctAddress","type":"address"}],"name":"totalFlaggerDeposit","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"ctAddress","type":"address"}],"name":"flaggerDeposits","outputs":[{"name":"","type":"uint256[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"ctAddress","type":"address"}],"name":"flaggingPeriod","outputs":[{"name":"start","type":"uint256"},{"name":"end","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"renounceOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"confirmOwnershipTransfer","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"ctAddress","type":"address"}],"name":"jurorSize","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"ctAddress","type":"address"}],"name":"flaggerSize","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"sutOwner","type":"address"},{"name":"approvedSutAmount","type":"uint256"},{"name":"token","type":"address"},{"name":"extraData","type":"bytes"}],"name":"receiveApproval","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"ctAddress","type":"address"}],"name":"jurorVotes","outputs":[{"name":"","type":"uint8[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"markets","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"_owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"ctAddress","type":"address"},{"name":"dissolve","type":"bool"}],"name":"vote","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"initiateOwnershipTransfer","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"member","type":"address"}],"name":"addMember","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"ctAddress","type":"address"}],"name":"nextFlaggableDate","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"ctAddress","type":"address"}],"name":"jurorList","outputs":[{"name":"","type":"address[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"marketSize","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"ctAddress","type":"address"}],"name":"dissolve","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"ctAddress","type":"address"}],"name":"creator","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"payable":true,"stateMutability":"payable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_projectAddress","type":"address"},{"indexed":false,"name":"_flagger","type":"address"},{"indexed":false,"name":"_deposit","type":"uint256"},{"indexed":false,"name":"_totalDeposit","type":"uint256"}],"name":"Flagging","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"marketAddress","type":"address"},{"indexed":false,"name":"marketCreator","type":"address"},{"indexed":false,"name":"initialDeposit","type":"uint256"}],"name":"MarketCreated","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_ctAddress","type":"address"},{"indexed":false,"name":"_appealer","type":"address"},{"indexed":false,"name":"_depositAmount","type":"uint256"}],"name":"AppealMarket","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_ctAddress","type":"address"},{"indexed":false,"name":"_closer","type":"address"}],"name":"CloseFlagging","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_ctAddress","type":"address"},{"indexed":false,"name":"_voter","type":"address"},{"indexed":false,"name":"_appealRount","type":"uint8"},{"indexed":false,"name":"_details","type":"bool"}],"name":"MakeVote","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"previousOwner","type":"address"},{"indexed":true,"name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"}]

var contract_address = "xxx";

if (process.argv.length < 3) {
  console.log("Usage node test.js contractAddress")
  process.exit();
}

contract_address = process.argv[2];

//web3引入
const Web3 = require('web3');
//new Web3.providers.WebsocketProvider('ws://localhost:7545')
//连接节点
// WebsocketProvider("wss://mainnet.infura.io/ws/v3/YOUR-PROJECT-ID")
// ropsten.infura.io/ws/v3/30a8695fb6fb4a078b4ee86a49b1cd7c
var web3 = new Web3(new Web3.providers.WebsocketProvider('wss://ropsten.infura.io/ws/v3/30a8695fb6fb4a078b4ee86a49b1cd7c'));
//var web3 = new Web3(new Web3.providers.HttpProvider('https://ropsten.infura.io/v3/30a8695fb6fb4a078b4ee86a49b1cd7c'));

const SmartUp = new web3.eth.Contract(abi, contract_address);

var version = web3.version;
//var count = 0;

console.log("version: ",version);

//var NewWeight = new web3.eth.Contract(abi, contract_address);

console.log("monitor log start...");

web3.eth.getBalance("0xaD5703d6e3b66276af1C70656a5d7f9618ED178d").then(console.log);

//myContract.methods.myMethod(123).encodeABI()

var data = SmartUp.methods.sell(1000000000000000000000).encodeABI()

console.log("data: ", data);

SmartUp.events.MarketCreated({
    filter: {}, // Using an array means OR: e.g. 20 or 23
    fromBlock: 5368707 ,
    toBlock: 'latest'
}, (error, event) => {})
.on('data', (event) => {
    console.log(JSON.stringify(event)); // same results as the optional callback above
})
.on('changed', (event) => {
    // remove event from local database
})
.on('error', console.error);

// SmartUp.getPastEvents('MarketCreated', {
//     filter: {}, // Using an array means OR: e.g. 20 or 23
//     fromBlock: 5368707 ,
//     toBlock: 'latest'
// }, (error, events) => { console.log(events); })
// .then((events) => {
//     console.log(JSON.stringify(events)) // same results as the optional callback above
// });
 