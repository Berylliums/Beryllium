
const MERKLE_TREE_HEIGHT = 23;

// 需要部署到什么链，就将参数改成什么链，
const govAddress = "0xeE5eb4429EeC511B45F38EE61b86CB27192ccC8e"; // 个人地址，EVM兼容的地址
const omniBridge = "0x59447362798334d3485c64D1e4870Fde2DDC0d75"; // omnibridge合约 in gn链
const amb = "0x162e898bd0aacb578c8d5f8d6ca588c13d2a383f"; // amb合约 in gn链
const token = "0xCa8d20f3e0144a72C6B5d576e9Bd3Fd8557E2B04"; // WBNB合约 in gn链
const l1Unwrapper = "0x310E4828Eff79522930381A7EF142Dc49DCf2786"; // WBNB -> BNB L1unwrapper合约(自己需要部署的链的合约地址)
const l1ChainId = 5777; // 部署在链的ID，ex:ETH、BNB.etc
const multisig = "0xeE5eb4429EeC511B45F38EE61b86CB27192ccC8e"; // 个人地址，EVM兼容的地址


const Verifier2 = artifacts.require("Verifier2");
const Verifier16 = artifacts.require("Verifier16");
const Hasher = artifacts.require("Hasher");
const Hasher3 = artifacts.require("Hasher3");
const L1UnWrapper = artifacts.require("L1UnWrapper");
const TornadoPool = artifacts.require("TornadoPool");

module.exports = async function(deployer) {

    // Deploy
    await deployer.deploy(Verifier2);
    const verifier2 = await Verifier2.deployed();
    console.log(`Verifier2 deployed to ${verifier2.address}`);

    await deployer.deploy(Verifier16);
    const verifier16 = await Verifier16.deployed();
    console.log(`Verifier16 deployed to ${verifier16.address}`);

    await deployer.deploy(Hasher);
    const hasher = await Hasher.deployed();
    console.log(`Hasher deployed to ${hasher.address}`);

    await deployer.deploy(Hasher3);
    const hasher3 = await Hasher3.deployed();
    console.log(`Hasher deployed to ${hasher3.address}`);

    // L1Unwrapper需要用singleFactory代理合约手动部署，然后将l1Unwrapper改为自己的地址

    await deployer.deploy(
        TornadoPool,
        verifier2.address,
        verifier16.address,
        MERKLE_TREE_HEIGHT,
        hasher.address,
        hasher3.address,
        token,
        omniBridge,
        l1Unwrapper,
        govAddress,
        l1ChainId,
        multisig,
        {overwrite: true}
    );
    const tornadoPool = await TornadoPool.deployed();
    console.log(`TornadoPool deployed to ${tornadoPool.address}`);

}
