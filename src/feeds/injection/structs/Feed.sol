// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Permissions.sol";
import "./Status.sol";
import "./Content.sol";

struct Feed {
    Status status;
    string description;
    Permissions permissions;
    Content content;
}
