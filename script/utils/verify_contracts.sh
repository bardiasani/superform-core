#!/usr/bin/env bash

# Read the RPC URL
source .env

networks=(
    1
    56
    43114
    137
    42161
    10
    8453
    # add more networks here if needed
)

api_keys=(
    $ETHEREUM_API
    $BSCSCAN_API
    $SNOWTRACE_API
    $POLYGONSCAN_API
    $ARBISCAN_API
    $OPSCAN_API
    $BASESCAN_API
    # add more API keys here if needed
)

## CONTRACTS VERIFICATION
empty_constructor_arg="$(cast abi-encode "constructor()")"
super_constructor_arg="$(cast abi-encode "constructor(address)" 0x17A332dC7B40aE701485023b219E9D6f493a2514)"
superposition_constructor_arg="$(cast abi-encode "constructor(string, address, string, string)" https://ipfs-gateway.superform.xyz/ipns/k51qzi5uqu5dg90fqdo9j63m556wlddeux4mlgyythp30zousgh3huhyzouyq8/JSON/ 0x17A332dC7B40aE701485023b219E9D6f493a2514 SuperPositions SP)"
superregistry_constructor_arg="$(cast abi-encode "constructor(address)" 0x480bec236e3d3AE33789908BF024850B2Fe71258)"
super_rbac_arg="$(cast abi-encode 'constructor((address,address,address,address,address,address,address,address,address,address,address))' '(0x48aB8AdF869Ba9902Ad483FB1Ca2eFDAb6eabe92,0x48aB8AdF869Ba9902Ad483FB1Ca2eFDAb6eabe92,0xD911673eAF0D3e15fe662D58De15511c5509bAbB,0x23c658FE050B4eAeB9401768bF5911D11621629c,0x73009CE7cFFc6C4c5363734d1b429f0b848e0490,0x73009CE7cFFc6C4c5363734d1b429f0b848e0490,0xaEbb4b9f7e16BEE2a0963569a5E33eE10E478a5f,0x73009CE7cFFc6C4c5363734d1b429f0b848e0490,0x1666660D2F506e754CB5c8E21BDedC7DdEc6Be1C,0x90ed07A867bDb6a73565D7abBc7434Dd810Fafc5,0x7c9c8C0A9aA5D8a2c2e6C746641117Cc9591296a)')"
wormhole_sr_arg="$(cast abi-encode "constructor(address, uint8)" 0x17A332dC7B40aE701485023b219E9D6f493a2514 2)"

file_names=(
    "src/crosschain-data/extensions/CoreStateRegistry.sol"
    "src/crosschain-liquidity/DstSwapper.sol"
    "src/forms/ERC4626Form.sol"
    "src/EmergencyQueue.sol"
    "src/crosschain-data/adapters/hyperlane/HyperlaneImplementation.sol"
    "src/crosschain-data/adapters/layerzero/LayerzeroImplementation.sol"
    "src/crosschain-liquidity/lifi/LiFiValidator.sol"
    "src/payments/PayMaster.sol"
    "src/crosschain-data/utils/PayloadHelper.sol"
    "src/payments/PaymentHelper.sol"
    "src/crosschain-liquidity/socket/SocketValidator.sol"
    "src/SuperformFactory.sol"
    "src/SuperformRouter.sol"
    "src/crosschain-data/adapters/wormhole/automatic-relayer/WormholeARImplementation.sol"
    "src/SuperPositions.sol"
    "src/settings/SuperRegistry.sol"
    "src/settings/SuperRBAC.sol"
    "src/VaultClaimer.sol"
    "src/crosschain-data/BroadcastRegistry.sol"
    "src/crosschain-data/adapters/wormhole/specialized-relayer/WormholeSRImplementation.sol"
    # Add more file names here if needed
)

contract_names=(
    "CoreStateRegistry"
    "DstSwapper"
    "ERC4626Form"
    "EmergencyQueue"
    "HyperlaneImplementation"
    "LayerzeroImplementation"
    "LiFiValidator"
    "PayMaster"
    "PayloadHelper"
    "PaymentHelper"
    "SocketValidator"
    "SuperformFactory"
    "SuperformRouter"
    "WormholeARImplementation"
    "SuperPositions"
    "SuperRegistry"
    "SuperRBAC"
    "VaultClaimer"
    "BroadcastRegistry"
    "WormholeSRImplementation"
    # Add more contract names here if needed
)

contract_addresses=(
    0x3721B0E122768CedDfB3Dec810E64c361177f826
    0x2691638Fa19357773C186BA34924E194B4Ab6cDa
    0x58F8Cef0D825B1a609FaD0576d5F2b7399ab1335
    0xE22DCd9264086DF7B26d97A9A9d35e8dFac819dd
    0x5417Fe6bA77106BCb5Ef1173fd901097BF08F234
    0x8a3E646d9FDAA5ce032743fCe4d81B5Fa8723Be2
    0x8b5dF72D849cC03baf168678FD357B81E00e2ba5
    0xcA665d3e3D48fb3C1A2B743445e367fa4340Eb3F
    0x92f98d698d2c8E0f29D1bb4d75C3A03e05e811bc
    0xaDcA2c82D7A05b9E84F75AeAc466bE74B34066d9
    0x7483486862BDa9BA68Be4923E7E9945c2771Ec28
    0xD85ec15A9F814D6173bF1a89273bFB3964aAdaEC
    0xa195608C2306A26f727d5199D5A382a4508308DA
    0xbD59F0B24d7A668f2c2CEAcfa056518bB3C06A9f
    0x01dF6fb6a28a89d6bFa53b2b3F20644AbF417678
    0x17A332dC7B40aE701485023b219E9D6f493a2514
    0x480bec236e3d3AE33789908BF024850B2Fe71258
    0xC4A234A40aC13b02096Dd4aae1b8221541Dc5d5A
    0x856ddF6348fFF6B774566cD63f2e8db3796a0965
    0x2827eFf89affacf9E80D671bca6DeCf7dbdcCaCa
    # Add more addresses here if needed
)

constructor_args=(
    $super_constructor_arg
    $super_constructor_arg
    $super_constructor_arg
    $super_constructor_arg
    $super_constructor_arg
    $super_constructor_arg
    $super_constructor_arg
    $super_constructor_arg
    $super_constructor_arg
    $super_constructor_arg
    $super_constructor_arg
    $super_constructor_arg
    $super_constructor_arg
    $super_constructor_arg
    $superposition_constructor_arg
    $superregistry_constructor_arg
    $super_rbac_arg
    $empty_constructor_arg
    $super_constructor_arg
    $wormhole_sr_arg
)

# loop through networks
for i in "${!networks[@]}"; do
    network="${networks[$i]}"
    api_key="${api_keys[$i]}"

    # loop through file_names and contract_names
    for j in "${!file_names[@]}"; do
        file_name="${file_names[$j]}"
        contract_name="${contract_names[$j]}"
        contract_address="${contract_addresses[$j]}"
        constructor_arg="${constructor_args[$j]}"

        # verify the contract
        if [[ $network == 43114 ]]; then
            forge verify-contract $contract_address \
                --chain-id $network \
                --num-of-optimizations 200 \
                --watch --compiler-version v0.8.23+commit.f704f362 \
                --constructor-args "$constructor_arg" \
                "$file_name:$contract_name" \
                --etherscan-api-key "$api_key" \
                --verifier-url 'https://api.routescan.io/v2/network/mainnet/evm/43114/etherscan'
        else
            forge verify-contract $contract_address \
                --chain-id $network \
                --num-of-optimizations 200 \
                --watch --compiler-version v0.8.23+commit.f704f362 \
                --constructor-args "$constructor_arg" \
                "$file_name:$contract_name" \
                --etherscan-api-key "$api_key"
        fi
    done
done
