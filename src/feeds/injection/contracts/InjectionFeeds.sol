// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IInjectionFeeds.sol";

contract InjectionFeeds is IInjectionFeeds {
    mapping(bytes32 => Feed) private feeds;

    modifier onlyExisting(bytes32 id) {
        require(isCreated(id), "Feed doesn't exist.");
        _;
    }

    modifier onlyNonExisting(bytes32 id) {
        require(!isCreated(id), "Feed already exists.");
        _;
    }

    modifier onlyEnabled(bytes32 id) {
        require(isEnabled(id), "Feed is not enabled.");
        _;
    }

    modifier onlyDisabled(bytes32 id) {
        require(!isEnabled(id), "Feed is not disabled.");
        _;
    }

    modifier onlyOwner(bytes32 id) {
        require(isOwner(id, msg.sender), "Owner only.");
        _;
    }

    modifier onlyProviders(bytes32 id) {
        require(isPublic(id) || isProvider(id, msg.sender), "Providers only.");
        _;
    }

    modifier onlyNonEmpty(bytes32 id) {
        require(!isEmpty(id), "Feed is empty.");
        _;
    }

    function isCreated(bytes32 id) public view override returns (bool) {
        return feeds[id].status.created;
    }

    function isEnabled(bytes32 id) public view override onlyExisting(id) returns (bool) {
        return feeds[id].status.enabled;
    }

    function isEmpty(bytes32 id) public view override onlyExisting(id) returns (bool) {
        return feeds[id].content.metadata.index == -1;
    }

    function isPublic(bytes32 id) public view override onlyExisting(id) returns (bool) {
        return feeds[id].permissions.providers.length == 0;
    }

    function isOwner(bytes32 id, address address_) public view override onlyExisting(id) returns (bool) {
        return feeds[id].permissions.owner == address_;
    }

    function isProvider(bytes32 id, address address_) public view override onlyExisting(id) returns (bool) {
        address[] storage providers = feeds[id].permissions.providers;
        for (uint256 i = 0; i < providers.length; i++) if (providers[i] == address_) return true;
        return false;
    }

    function getFeed(bytes32 id) public view override onlyExisting(id) returns (Feed memory) {
        return feeds[id];
    }

    function getStatus(bytes32 id) public view override onlyExisting(id) returns (Status memory) {
        return feeds[id].status;
    }

    function getDescription(bytes32 id) public view override onlyExisting(id) returns (string memory) {
        return feeds[id].description;
    }

    function getPermissions(bytes32 id) public view override onlyExisting(id) returns (Permissions memory) {
        return feeds[id].permissions;
    }

    function getContent(bytes32 id) public view override onlyNonEmpty(id) returns (Content memory) {
        return feeds[id].content;
    }

    function createFeed(
        bytes32 id,
        string calldata description,
        Permissions calldata permissions
    ) external override onlyNonExisting(id) {
        feeds[id].status.created = true;
        feeds[id].status.enabled = true;
        feeds[id].description = description;
        feeds[id].permissions = permissions;
        feeds[id].content.metadata.index = -1;
        emit FeedCreated(id, description, permissions);
    }

    function enableFeed(bytes32 id) external override onlyOwner(id) onlyDisabled(id) {
        feeds[id].status.enabled = true;
        emit FeedEnabled(id);
    }

    function disableFeed(bytes32 id) external override onlyOwner(id) onlyEnabled(id) {
        feeds[id].status.enabled = false;
        emit FeedDisabled(id);
    }

    function updateDescription(bytes32 id, string calldata description) external override onlyOwner(id) {
        feeds[id].description = description;
        emit DescriptionUpdated(id, description);
    }

    function updateOwner(bytes32 id, address owner) external override onlyOwner(id) {
        feeds[id].permissions.owner = owner;
        emit OwnerUpdated(id, owner);
    }

    function updateProviders(bytes32 id, address[] calldata providers) external override onlyOwner(id) {
        feeds[id].permissions.providers = providers;
        emit ProvidersUpdated(id, providers);
    }

    function updateContent(bytes32 id, bytes calldata data) external override onlyProviders(id) {
        feeds[id].content.data = data;
        feeds[id].content.metadata.index += 1;
        feeds[id].content.metadata.size = data.length;
        feeds[id].content.metadata.block_ = block.number;
        feeds[id].content.metadata.provider = msg.sender;
        emit ContentUpdated(id, feeds[id].content);
    }
}
