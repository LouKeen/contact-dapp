const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const web3 = new Web3(ganache.provider());

const {abi, evm} = require('../compile');

let accounts;
let contact;

beforeEach( async () => {
   // Get a list of all accounts
   accounts = await web3.eth.getAccounts();

   contact = await new web3.eth.Contract(abi)
       .deploy({
           data: evm.bytecode.object
       })
       .send({from: accounts[0], gas: '3000000'});
});

describe('Contact', () => {
    it('deploys a contract', () => {
        assert.ok(contact.options.address);
    });
});
