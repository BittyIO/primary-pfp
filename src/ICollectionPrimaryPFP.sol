// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.21;

/**
 * @title Set collection primary PFP for an address like primary ENS.
 * @dev owner or delegated/warmed address can set collection primary PFP, only owner can remove the collection primary PFP.
 */
interface ICollectionPrimaryPFP {
    // @notice Emitted when a primary collection PFP set for the owner.
    event CollectionPrimarySet(address indexed to, address indexed contract_, uint256 tokenId);

    // @notice Emitted when a primary collection PFP set from delegate.cash.
    event CollectionPrimarySetByDelegateCash(address indexed to, address indexed contract_, uint256 tokenId);

    // @notice Emitted when a primary collection PFP removed.
    event CollectionPrimaryRemoved(address indexed from, address indexed contract_, uint256 tokenId);

    /**
     * @notice Set collection primary PFP for an address.
     * Only the PFP owner can set it.
     *
     * @param contract_ The collection address of the PFP
     * @param tokenId The tokenId of the collection PFP
     */
    function setCollectionPrimary(address contract_, uint256 tokenId) external;

    /**
     * @notice Set collection primary PFP for an address from a delegated address from delegate.cash.
     * Only the delegated address from delegate cash can set it.
     *
     * @param contract_ The collection address of the PFP
     * @param tokenId The tokenId of the PFP
     */
    function setCollectionPrimaryByDelegateCash(address contract_, uint256 tokenId) external;

    /**
     * @notice Remove the collection primary PFP setting.
     * Only the PFP owner can remove it.
     *
     * @param contract_ The collection address of the PFP
     * @param tokenId The tokenId of the PFP
     */
    function removeCollectionPrimary(address contract_, uint256 tokenId) external;

    /**
     * @notice whether one has a collection primary PFP
     * Returns false if they don't have
     *
     * @param addr The address for querying collection primary PFP
     * @param contract_ The collection address of the PFP
     */
    function hasCollectionPrimary(address addr, address contract_) external view returns (bool);

    /**
     * @notice Get collection primary PFP id for an address.
     * Returns 0 if this addr has no primary PFP.
     *
     * @param addr The address for querying primary PFP
     * @param contract_ The collection address of the PFP
     */
    function getCollectionPrimary(address addr, address contract_) external view returns (uint256);
}
