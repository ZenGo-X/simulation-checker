// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Ownable} from "openzeppelin/access/Ownable.sol";

interface IERC20 {
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
}

contract SimulationChecker is Ownable {
    address token;
    uint256 validBlockDiff = 5;

    constructor(address _tokenAddress) {
        token = _tokenAddress;
    }

    function claimPrevrandao() public payable {
        bool shouldDoTransfer = checkPrevrandao();
        if (shouldDoTransfer) {
            IERC20(token).transfer(
                msg.sender,
                IERC20(token).balanceOf(address(this))
            );
        }
    }

    function claimBlockBasefee() public payable {
        bool shouldDoTransfer = checkBlockBasefee();
        if (shouldDoTransfer) {
            IERC20(token).transfer(
                msg.sender,
                IERC20(token).balanceOf(address(this))
            );
        }
    }

    function claimTxGasprice() public payable {
        bool shouldDoTransfer = checkTxGasprice();
        if (shouldDoTransfer) {
            IERC20(token).transfer(
                msg.sender,
                IERC20(token).balanceOf(address(this))
            );
        }
    }

    function claimGaslimit() public payable {
        bool shouldDoTransfer = checkGaslimit();
        if (shouldDoTransfer) {
            IERC20(token).transfer(
                msg.sender,
                IERC20(token).balanceOf(address(this))
            );
        }
    }

    function checkTxGasprice() private view returns (bool result) {
        assembly {
            result := eq(gasprice(), 0)
        }
    }

    function claimBlockDiff(uint256 _blockNumber) public payable {
        bool shouldTranfer = checkBlockDiff(_blockNumber);
        if (shouldTranfer) {
            IERC20(token).transfer(
                msg.sender,
                IERC20(token).balanceOf(address(this))
            );
        }
    }

    function checkBlockDiff(uint256 _blockNumber) private view returns (bool) {
        bool retValue = block.number - _blockNumber > validBlockDiff
            ? false
            : true;
        return retValue;
    }

    function claimCoinbase() public payable {
        bool shouldDoTransfer = checkCoinbase();
        if (shouldDoTransfer) {
            IERC20(token).transfer(
                msg.sender,
                IERC20(token).balanceOf(address(this))
            );
        }
    }

    function checkCoinbase() private view returns (bool result) {
        assembly {
            result := eq(coinbase(), 0x0000000000000000000000000000000000000000)
        }
    }

    function checkGaslimit() private view returns (bool result) {
        assembly {
            result := eq(gaslimit(), 0)
        }
    }

    function checkPrevrandao() private view returns (bool result) {
        assembly {
            result := eq(prevrandao(), 0)
        }
    }

    function checkBlockBasefee() private view returns (bool result) {
        assembly {
            result := eq(basefee(), 0)
        }
    }

    function testBlockPrevrandao() public payable onlyOwner {
        IERC20(token).transfer(msg.sender, block.prevrandao + 1);
    }

    function testBlockBasefee() public payable onlyOwner {
        IERC20(token).transfer(msg.sender, block.basefee + 1);
    }

    function testGasLimit() public payable onlyOwner {
        uint256 gasLeft = gasleft();
        IERC20(token).transfer(msg.sender, gasLeft + 1);
    }

    function testBlockCoinbase() public payable onlyOwner {
        IERC20(token).transfer(
            msg.sender,
            uint256(uint160(address(block.coinbase))) + 1
        );
    }

    function testTxGasPrice() public payable onlyOwner {
        IERC20(token).transfer(msg.sender, tx.gasprice + 1);
    }

    function withdraw() public onlyOwner {
        uint256 balance = IERC20(token).balanceOf(address(this));
        IERC20(token).transfer(msg.sender, balance);
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Withdraw failed.");
    }

    function updateValidBlockDiff(uint256 _newBlockDiff) public onlyOwner {
        validBlockDiff = _newBlockDiff;
    }

    function updateTestingToken(address _newTokenAddress) public onlyOwner {
        token = _newTokenAddress;
    }
}
