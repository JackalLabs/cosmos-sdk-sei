make build install
cp build/simd ~/go/bin/simd
echo $(which simd)
rm -rf ~/.simapp/

simd init mynode --chain-id=simnet
simd config chain-id simnet
simd config keyring-backend test

simd keys add validator --keyring-backend="test"
simd add-genesis-account $(simd keys show validator -a --keyring-backend="test") 2100000stake
simd gentx validator 2000000stake --keyring-backend="test" --chain-id=simnet
simd collect-gentxs

sed -i 's#"tcp://127.0.0.1:26657"#"tcp://0.0.0.0:26657"#g' ~/.simapp/config/config.toml
sed -i 's/timeout_commit = "5s"/timeout_commit = "1s"/g' ~/.simapp/config/config.toml
sed -i 's/timeout_propose = "3s"/timeout_propose = "1s"/g' ~/.simapp/config/config.toml
sed -i 's/minimum-gas-prices = "0stake"/minimum-gas-prices = "0.0125stake"/g' ~/.simapp/config/app.toml
sed -i 's#"free_messages": \[\]#"free_messages": \["/cosmos.bank.v1beta1.MsgSend"]#g' ~/.simapp/config/genesis.json

simd start --pruning=nothing --log_level=info --chain-id=simnet