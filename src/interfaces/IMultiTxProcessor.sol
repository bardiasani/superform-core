/// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.19;

/// @title IMultiTxProcessor
/// @author Zeropoint Labs
/// @dev handles all destination chain swaps.
/// @notice all write functions can only be accessed by superform keepers.
interface IMultiTxProcessor {
    /*///////////////////////////////////////////////////////////////
                                Errors
    //////////////////////////////////////////////////////////////*/

    /// @dev is emitted when the chain id input is invalid.
    error INVALID_INPUT_CHAIN_ID();

    /*///////////////////////////////////////////////////////////////
                                Events
    //////////////////////////////////////////////////////////////*/

    /// @dev is emitted when the super registry is updated.
    event SuperRegistryUpdated(address indexed superRegistry);

    /// @dev PREVILEGED SWAPPER ONLY FUNCTION
    /// @dev would interact with socket contract to process multi-tx transactions and move the funds into destination contract.
    /// @param bridgeId_          represents the unique propreitory id of the bridge used.
    /// @param txData_            represents the transaction data generated by socket API.
    /// @param approvalToken_     represents the tokens to be swapped.
    /// @param allowanceTarget_   represents the socket registry contract.
    /// @param amount_            represents the amounts to be swapped.
    function processTx(
        uint8 bridgeId_,
        bytes calldata txData_,
        address approvalToken_,
        address allowanceTarget_,
        uint256 amount_
    ) external;

    /// @dev PREVILEGED SWAPPER ONLY FUNCTION
    /// @dev would interact with socket contract to process multi-tx transactions and move the funds into destination contract.
    /// @param bridgeId_          represents the unique propreitory id of the bridge used.
    /// @param txDatas_            represents the array of transaction data generated by socket API.
    /// @param approvalTokens_     represents the array of tokens to be swapped.
    /// @param allowanceTarget_   represents the array of socket registry contract.
    /// @param amounts_            represents the array of amounts to be swapped.
    function batchProcessTx(
        uint8 bridgeId_,
        bytes[] calldata txDatas_,
        address[] calldata approvalTokens_,
        address allowanceTarget_,
        uint256[] calldata amounts_
    ) external;
}
