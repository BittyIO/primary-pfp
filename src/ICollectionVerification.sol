// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

/**
 * @title Same image url will confuse people, so verify a collection list of unique PFPs is important for public social networking.
 *
 */
interface ICollectionVerification {
    // @notice Emitted when a PFP collection is verified.
    event CollectionVerified(address indexed contract_);

    // @notice Emitted when a PFP collection verification is removed.
    event CollectionVerificationRemoved(address indexed contract_);

    /**
     * @notice Owner only
     *
     * @param contracts The collection addresses of the PFPs
     */
    function addVerification(address[] calldata contracts) external;

    /**
     * @notice Owner only
     *
     * @param contracts The collection addresses of the PFPs
     */
    function removeVerification(address[] calldata contracts) external;

    /**
     * @notice Returns whether a PFP collection is verified.
     *
     * @param contract_ The collection address of the PFP
     */
    function isCollectionVerified(address contract_) external view returns (bool);
}
