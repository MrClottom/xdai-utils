// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface Weth is IERC20 {
    function deposit() external payable;
}

interface TokenBridge {
    function relayTokens(address token, address receiver, uint256 value) external;
}

contract InstaXDAIWrap {
    Weth public constant WETH = Weth(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    TokenBridge public constant BRIDGE = TokenBridge(0x88ad09518695c6c3712AC10a214bE5109a655671);

    constructor() {
        WETH.approve(address(BRIDGE), type(uint256).max);
    }

    function wrapAndSend() external payable {
        _wrapAndSendTo(msg.sender);
    }

    function wrapAndSendTo(address recipient) public payable {
        _wrapAndSendTo(recipient);
    }

    function _wrapAndSendTo(address recipient) internal {
        WETH.deposit{ value: msg.value }();
        BRIDGE.relayTokens(address(WETH), recipient, msg.value);
    }
}
