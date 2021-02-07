// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Permissions.sol";
import "./Status.sol";
import "./Content.sol";

struct Definition {
    bytes32 id;
    string description;
    Permissions permissions;
    Status status;
    Content content;
}
