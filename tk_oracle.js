"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const TronWeb = require("tronweb");
const dbMysql = require("./db/dbMysql");
const HttpProvider = TronWeb.providers.HttpProvider;
const fullNode = new HttpProvider('https://api.shasta.trongrid.io');
const solidityNode = new HttpProvider('https://api.shasta.trongrid.io');
const eventServer = 'https://api.shasta.trongrid.io/';
const privateKey = '9E503D5C8C3ADD64D539733B15104AFA6C25BA1CF8C6E32E6E409633CB040BD6';
const tokenAddress = 'THvZvKPLHKLJhEFYKiyqj6j8G8nGgfg7ur';
const arcadeAddress = 'xxx';
var tokenContract;
var arcadeContract;
const tronWeb = new TronWeb(fullNode, solidityNode, eventServer, privateKey);
// tronWeb.trx.getTokenByID('1001761').then(console.log);
// tronWeb.trx.getTransactionsRelated("TUi3q9AGzYiuSHdCp5867HPyqqSecLeVFK", "all", 3, 0).then(transactions => {
//  transactions.forEach(transaction => {
//      console.log("TXID = " + transaction.txID);
//      console.log("Type = " + transaction.raw_data.contract[0].type);
//      console.log("Owner_Address = " + tronWeb.address.fromHex(transaction.raw_data.contract[0].parameter.value.owner_address));
//      console.log("To_Address = " + tronWeb.address.fromHex(transaction.raw_data.contract[0].parameter.value.to_address));
//      console.log("Amount = " + transaction.raw_data.contract[0].parameter.value.amount);
//  });
// });
function getBalance(address) {
    return __awaiter(this, void 0, void 0, function* () {
        var result = yield tokenContract.balanceOf(address).call();
        return tronWeb.fromSun(parseInt(result.balance));
    });
}
function updateAccountDB(address, blockNumber) {
    return __awaiter(this, void 0, void 0, function* () {
        var account = yield dbMysql.find_account(address, blockNumber);
        var amount = 0;
        if (account != null) {
            return;
        }
        else {
            amount = yield getBalance(address);
            dbMysql.insert_account(address, amount, blockNumber);
            arcadeContract.updateSnapShotData(address, amount, blockNumber).send({
                shouldPollResponse: true,
                callValue: 0
            }).catch(function (err) {
                console.log(err);
            });
        }
    });
}
function eventResult(pageNum, timestamp, blockNumber) {
    return __awaiter(this, void 0, void 0, function* () {
        console.log("PAGENUM = " + pageNum);
        tronWeb.getEventResult(tronWeb.address.toHex(tokenAddress), timestamp, 'Transfer', 0, 200, pageNum, (err, events) => __awaiter(this, void 0, void 0, function* () {
            if (err) {
                eventResult(pageNum, timestamp, blockNumber);
                return;
            }
            if (events.length > 0) {
                for (var i = 0; i < events.length; i++) {
                    yield updateAccountDB(events[i].result.from, blockNumber);
                    yield updateAccountDB(events[i].result.to, blockNumber);
                }
                eventResult(pageNum + 1, timestamp, blockNumber);
                return;
            }
            console.log("FINISH");
        }));
    });
}
function startSnapShot(blockNumber) {
    return __awaiter(this, void 0, void 0, function* () {
        tronWeb.trx.getBlockByNumber(blockNumber, (err, block) => {
            if (err) {
                startSnapShot(blockNumber);
                return;
            }
            var timestamp = block.block_header.raw_data.timestamp;
            console.log('Timestamp = ' + timestamp);
            eventResult(1, timestamp, blockNumber);
        });
    });
}
function initContract() {
    return __awaiter(this, void 0, void 0, function* () {
        tokenContract = yield tronWeb.contract().at(tokenAddress);
        arcadeContract = yield tronWeb.contract().at(arcadeAddress);
        arcadeContract.receiveSnapShotData().watch((err, { result }) => {
            if (err)
                return console.log(err);
            console.log(result);
        });
        arcadeContract.getSnapShotData().watch((err, { result }) => {
            if (err)
                return console.log(err);
            startSnapShot(result.blockNumber);
        });
    });
}
// initContract();
// startSnapShot(5626281);
function test() {
    return __awaiter(this, void 0, void 0, function* () {
        arcadeContract = yield tronWeb.contract().at('TKWeF8zjwMQA8TpZQRs5Cj9SXTbargYJFy');
        arcadeContract.receiveSnapShotData().watch((err, { result }) => {
            if (err)
                return console.log('ERROR - Received event of receiveSnapShotData ' + err);
            console.log("SUCCESS - Received event of receiveSnapShotData " + result);
            console.log(result);
        });
        arcadeContract.getSnapShotData().watch((err, { result }) => {
            if (err)
                return console.log("ERROR - Received event of getSnapShotData " + err);
            console.log("SUCCESS - Received event of getSnapShotData " + result);
            arcadeContract.updateSnapShotData('THvZvKPLHKLJhEFYKiyqj6j8G8nGgfg7ur', 200, 5626281).send({
                shouldPollResponse: true,
                callValue: 0
            }).catch(function (err) {
                console.log("ERROR - calling updateSnapShotData() " + tronWeb.toAscii(err.output.resMessage));
            });
        });
        arcadeContract.startSnapShot(5626281).send({
            shouldPollResponse: true,
            callValue: 0
        }).catch(function (err) {
            console.log("ERROR - calling startSnapShot() " + tronWeb.toAscii(err.output.resMessage));
        });
    });
}
test();

