const path = require('path');
const fs = require('fs');
const solc = require('solc');

const inboxPath = path.resolve(__dirname, 'contracts', 'Contact.sol');
const source = fs.readFileSync(inboxPath, 'utf8');

const input = {
    language: 'Solidity',
    sources: {
        'Contact.sol': {
            content: source,
        },
    },
    settings: {
        outputSelection: {
            '*': {
                '*': ['*'],
            },
        },
    },
};

module.exports = JSON.parse(solc.compile(JSON.stringify(input))).contracts[
    'Contact.sol'
    ].Contact;

// For debugging compiler errors
// console.log(JSON.parse(solc.compile(JSON.stringify(input))));