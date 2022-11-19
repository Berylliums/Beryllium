// 使用外部编译器机制在编译时生成 Hasher 工件

require("ts-node/register");

export async function run(contractName:string, nInputs:number) {
    const { poseidonContract: { createCode, generateABI } } = require("circomlibjs");
    const path = require("path");
    const fs = require("fs");
    const outputPath = path.join(__dirname, "..", "build", "contracts");
    const outputFile = path.join(outputPath, contractName + ".json");

    if (!fs.existsSync(outputPath)) {
        fs.mkdirSync(outputPath, { recursive: true });
    }

    const contract = {
        _format: "hh-sol-artifact-1",
        sourceName: "contracts/Hasher.sol",
        linkReferences: {},
        deployedLinkReferences: {},
        contractName: contractName,
        abi: generateABI(nInputs),
        bytecode: createCode(nInputs)
    };
    fs.writeFileSync(outputFile, JSON.stringify(contract, null, 2));
    console.log("compiled Hasher.json in " + outputFile)
}

module.exports = {
    run
};