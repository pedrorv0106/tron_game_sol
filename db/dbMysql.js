"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const Sequelize = require("sequelize");
const sequelize = new Sequelize('tron_tk', 'root', 'root', {
    dialect: 'mysql',
    define: {
        charset: 'utf8',
        dialectOptions: {
            collate: 'utf8_general_ci'
        }
    },
});
/* Account model define */
const Account = sequelize.define('accounts', {
    address: Sequelize.STRING,
    amount: Sequelize.INTEGER,
    block: Sequelize.INTEGER,
}, {
    createdAt: 'created_at',
    updatedAt: 'updated_at',
});
Account.sync();
function insert_account(address, amount, block) {
    return Account.create({
        address: address,
        amount: amount,
        block: block,
    });
}
exports.insert_account = insert_account;
function find_account(address, block) {
    return Account.findOne({
        where: {
            address: address,
            block: block,
        },
    });
}
exports.find_account = find_account;

