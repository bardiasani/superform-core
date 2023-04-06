/// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.19;

import "@openzeppelin-contracts/access/AccessControl.sol";
import "@openzeppelin-contracts/token/ERC20/IERC20.sol";
import {IMultiTxProcessor} from "../interfaces/IMultiTxProcessor.sol";
import {ISuperRegistry} from "../interfaces/ISuperRegistry.sol";

/// @title MultiTxProcessor
/// @author Zeropoint Labs.
/// @dev handles all destination chain swaps.
/// @notice all write functions can only be accessed by superform keepers.
contract MultiTxProcessor is IMultiTxProcessor, AccessControl {
    /*///////////////////////////////////////////////////////////////
                    Access Control Role Constants
    //////////////////////////////////////////////////////////////*/
    bytes32 public constant SWAPPER_ROLE = keccak256("SWAPPER_ROLE");

    /*///////////////////////////////////////////////////////////////
                    State Variables
    //////////////////////////////////////////////////////////////*/

    ISuperRegistry public superRegistry;

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    /*///////////////////////////////////////////////////////////////
                            External Functions
    //////////////////////////////////////////////////////////////*/
    /// @notice receive enables processing native token transfers into the smart contract.
    /// @dev socket.tech fails without a native receive function.
    receive() external payable {}

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
    ) external override onlyRole(SWAPPER_ROLE) {
        address to = superRegistry.getBridgeAddress(bridgeId_);
        if (allowanceTarget_ != address(0)) {
            IERC20(approvalToken_).approve(allowanceTarget_, amount_);
            (bool success, ) = payable(to).call(txData_);
            require(success, "Socket Error: Invalid Tx data (1)");
        } else {
            (bool success, ) = payable(to).call{value: amount_}(txData_);
            require(success, "Socket Error: Invalid Tx Data (2)");
        }
    }

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
    ) external override onlyRole(SWAPPER_ROLE) {
        address to = superRegistry.getBridgeAddress(bridgeId_);
        for (uint256 i = 0; i < txDatas_.length; i++) {
            if (allowanceTarget_ != address(0)) {
                IERC20(approvalTokens_[i]).approve(
                    allowanceTarget_,
                    amounts_[i]
                );
                (bool success, ) = payable(to).call(txDatas_[i]);
                require(success, "Socket Error: Invalid Tx data (1)");
            } else {
                (bool success, ) = payable(to).call{value: amounts_[i]}(
                    txDatas_[i]
                );
                require(success, "Socket Error: Invalid Tx Data (2)");
            }
        }
    }

    /// @dev PREVILEGED admin ONLY FUNCTION.
    /// @param superRegistry_    represents the address of the superRegistry
    function setSuperRegistry(
        address superRegistry_
    ) external override onlyRole(DEFAULT_ADMIN_ROLE) {
        superRegistry = ISuperRegistry(superRegistry_);

        emit SuperRegistryUpdated(superRegistry_);
    }

    /*///////////////////////////////////////////////////////////////
                            Developmental Functions
    //////////////////////////////////////////////////////////////*/
    /// @dev PREVILEGED admin ONLY FUNCTION.
    /// @notice should be removed after end-to-end testing.
    /// @dev allows admin to withdraw lost tokens in the smart contract.
    function withdrawToken(
        address _tokenContract,
        uint256 _amount
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        IERC20 tokenContract = IERC20(_tokenContract);

        /// note: transfer the token from address of this contract
        /// note: to address of the user (executing the withdrawToken() function)
        tokenContract.transfer(msg.sender, _amount);
    }

    /// @dev PREVILEGED admin ONLY FUNCTION.
    /// @dev allows admin to withdraw lost native tokens in the smart contract.
    function withdrawNativeToken(
        uint256 _amount
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        payable(msg.sender).transfer(_amount);
    }
}
