import * as Sequelize from 'sequelize';
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

function find_account(address, block) {
  return Account.findOne({
    where: {
      address: address,
      block: block,
    },
  });
}

export {
  insert_account,
  find_account,
};
