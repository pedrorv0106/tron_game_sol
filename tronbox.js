module.exports = {
    networks: {
        development: {
            privateKey: "410f44b2011ed939ff1f50e7f9e739d9cb01824ff6822f3a14a0a1e44b364821",
            consume_user_resource_percent: 0,
            fee_limit: 100000000,
            fullNode: "http://127.0.0.1:8090",
            solidityNode: "http://127.0.0.1:8091",
            eventServer: "http://127.0.0.1:8092",

            network_id: "*",
        },
        mainnet: {
            privateKey: "eb45ddc5a15b02473a76e93d3f60f277269f7db8eb897b1b7d848eee5376744e",
            consume_user_resource_percent: 0,
            fee_limit: 100000000,
            fullNode: "https://api.trongrid.io",
            solidityNode: "https://api.trongrid.io",
            eventServer: "https://api.trongrid.io",

            network_id: "*",
        },
        shasta: {
            privateKey: "eb45ddc5a15b02473a76e93d3f60f277269f7db8eb897b1b7d848eee5376744e",
            consume_user_resource_percent: 100,
            fee_limit: 100000000,
            fullNode: "https://api.shasta.trongrid.io",
            solidityNode: "https://api.shasta.trongrid.io",
            eventServer: "https://api.shasta.trongrid.io",

            network_id: "*",
        },
    },
};
