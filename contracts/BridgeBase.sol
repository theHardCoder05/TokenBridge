// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import './IToken.sol';

/**
 * @title 
 * @author 
 * @notice 
 */
contract BridgeBase {
    address public owner;
    IToken public token; // This can be IERC20 interface for production
    mapping(address => mapping(uint256 => bool)) public processNounces;
    mapping(address => uint256) public maxProcessNonce;

    enum Step{
        Burn,
        Mint
    }

    // Events
    event Transfer(address from, address to, uint256 amount, uint256 date, uint256 nonce, bytes signature, Step indexed step);


    constructor(address _token) {
        token = IToken(_token);
        owner = msg.sender;
    }

    function burn(address to, uint256 amount, uint256 nonce, bytes calldata signature) external {
        require(processNounces[msg.sender][nonce] == false, "TRANSFER_ALREADY_PROCESSED");
        processNounces[msg.sender][nonce] == true;
        if(nonce > maxProcessNonce[msg.sender]) {
            maxProcessNonce[msg.sender] = nonce;
        }

        token.burn(msg.sender, amount);

        emit Transfer(msg.sender, to, amount, block.timestamp, nonce, signature, Step.Burn);
    }


    function mint(address from, address to, uint256 amount, uint256 nonce, bytes calldata signature) external {
        bytes32 message = prefixed(keccak256(abi.encodePacked(from, to, amount, nonce)));
        require(recoverSigner(message , signature) == from, "WRONG_SIGNATURE");
        require(processNounces[from][nonce] == false, "TRANSFER_ALREADY_PROCESSED");

        processNounces[from][nonce] == true;
        if(nonce > maxProcessNonce[from]) {
            maxProcessNonce[from] = nonce;
        }

        token.mint(to, amount);

        emit Transfer(from, to, amount, block.timestamp, nonce, signature, Step.Mint);
    }

    function prefixed(bytes32  hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }

    // Recover the signer from the signed message in bytes
    function recoverSigner(bytes32 message, bytes memory sig) internal pure returns(address) {

        uint8 v;
        bytes32 r;
        bytes32 s;

        (v,r,s) = splitSignature(sig);
        return ecrecover(message, v, r, s);

    }


    function splitSignature(bytes memory sig) internal pure returns(uint8,bytes32,bytes32){
        require(sig.length == 65);
        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }

}