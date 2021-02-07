// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../structs/Permissions.sol";
import "../structs/Content.sol";

interface IPersonalFeeds {
    event FeedCreated(bytes32 indexed id, string description, Permissions permissions);

    event FeedEnabled(bytes32 indexed id);

    event FeedDisabled(bytes32 indexed id);

    event DescriptionUpdated(bytes32 indexed id, string description);

    event OwnerUpdated(bytes32 indexed id, address owner);

    event ProvidersUpdated(bytes32 indexed id, address[] providers);

    event ContentUpdated(bytes32 indexed id, Content content);

    function isCreated(bytes32 id) external view returns (bool);

    function isEnabled(bytes32 id) external view returns (bool);

    function isEmpty(bytes32 id) external view returns (bool);

    function isPublic(bytes32 id) external view returns (bool);

    function isOwner(bytes32 id, address address_) external view returns (bool);

    function isProvider(bytes32 id, address address_) external view returns (bool);

    function getDescription(bytes32 id) external view returns (string memory);

    function getOwner(bytes32 id) external view returns (address);

    function getProviders(bytes32 id) external view returns (address[] memory);

    function getContent(bytes32 id) external view returns (Content memory content);

    function createFeed(
        bytes32 id,
        string calldata description,
        Permissions calldata permissions
    ) external;

    function updateDescription(bytes32 id, string calldata description) external;

    function updateOwner(bytes32 id, address owner) external;

    function updateProviders(bytes32 id, address[] calldata providers) external;

    function updateContent(bytes32 id, bytes calldata data) external;
}
