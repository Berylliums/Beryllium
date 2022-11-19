.PHONY: clean build-circom install-depends download deploy test build-contract yarn-install

POWERS_OF_TAU=16

default: yarn-install download build-circom build-contract deploy

yarn-install:
	@npm install

# 清理编译出来的文件
clean:
	@echo "[clean:) ] Clean..."
	@rm -rf node_modules build contracts/Verifier2.sol contracts/Verifier16.sol

build-contract:
	@echo "[build-contract:) ] Building contract..."
	@truffle compile
	@npx ts-node -e 'require("./scripts/compileHasher").run("Hasher",2)'
	@npx ts-node -e 'require("./scripts/compileHasher").run("Hasher3",3)'

deploy:
	@npx hardhat run scripts/deployL1Unwrapper.ts --network localhost
	@npx hardhat run scripts/deployTornadoUpgrade.ts --network localhost

node:
	@npx hardhat node

test:
	@npx hardhat coverage

lunch-gui:
	@npx hardhat deploy
	@npx hardhat gui

build-circom:
	@echo "[build-circom:) ] Building circom..."
	@cd circuits && circom transaction2.circom --r1cs --wasm --sym -o ../build/circuits/
	@cd circuits && circom transaction16.circom --r1cs --wasm --sym -o ../build/circuits/


	@echo "[build-circom:) ] Circom info"
	@npx snarkjs info -r build/circuits/transaction2.r1cs
	@npx snarkjs info -r build/circuits/transaction16.r1cs

	@echo "[build-circom:) ] Start a new zkey and make a contribution"
	@npx snarkjs groth16 setup build/circuits/transaction2.r1cs build/circuits/ptau${POWERS_OF_TAU} build/circuits/tmp_transaction2.zkey
	@npx snarkjs groth16 setup build/circuits/transaction16.r1cs build/circuits/ptau${POWERS_OF_TAU} build/circuits/tmp_transaction16.zkey

	@npx snarkjs zkey contribute build/circuits/tmp_transaction2.zkey build/circuits/transaction2.zkey --name="1st Contributor Name" -v -e="random text"
	@npx snarkjs zkey contribute build/circuits/tmp_transaction16.zkey build/circuits/transaction16.zkey --name="1st Contributor Name" -v -e="random text"

	@echo "[build-circom:) ] Export verificationkey..."
	@npx snarkjs zkey export verificationkey build/circuits/transaction2.zkey build/circuits/transaction2.json
	@npx snarkjs zkey export verificationkey build/circuits/transaction16.zkey build/circuits/transaction16.json

	@echo "[build-circom:) ] Export solidityverifier..."
	@npx snarkjs zkey export solidityverifier build/circuits/transaction2.zkey contracts/Verifier2.sol
	@npx snarkjs zkey export solidityverifier build/circuits/transaction16.zkey contracts/Verifier16.sol

	@sed -i.bak "s/contract Verifier/contract Verifier2/g" contracts/Verifier2.sol
	@sed -i.bak "s/contract Verifier/contract Verifier16/g" contracts/Verifier16.sol
	@rm -rf *.bak

# 依赖安装
install-depends:
	@echo "[setup:) ] Installing circom..."
	@mkdir build
	@cd build && git clone https://github.com/iden3/circom.git
	@cd build/circom && cargo build --release && cargo install --path circom

download:
	@echo "[Download:) ] Download power tal..."
	@mkdir -p build/circuits
	@curl -L https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_${POWERS_OF_TAU}.ptau --create-dirs -o build/circuits/ptau${POWERS_OF_TAU}
