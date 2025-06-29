// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

interface IMockResponse {
    function isActive() external view returns (bool);
    function discordNameAdded(string memory _name) external view returns (bool);
}

contract Trap is ITrap {
    address public constant RESPONSE_CONTRACT = 0x25E2CeF36020A736CF8a4D2cAdD2EBE3940F4608;
    string constant discordName = ""; // add your discord name here

    function collect() external view returns (bytes memory) {
        bool active = IMockResponse(RESPONSE_CONTRACT).isActive();
        bool discordNameAdded = IMockResponse(RESPONSE_CONTRACT).discordNameAdded(discordName);
        return abi.encode(active, discordName, discordNameAdded);
    }

    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory) {
        // take the latest block data from collect
        (bool active, string memory name, bool discordNameAdded) = abi.decode(data[0], (bool, string, bool));
        // will not run if the contract is not active or the discord name is not set or the discord name is already added
        if (!active || bytes(name).length == 0 || discordNameAdded) {
            return (false, bytes(""));
        }

        return (true, abi.encode(name));
    }
}
