pragma solidity ^0.5.0;

import "./../../ModuleFactory.sol";
import "./SingleTradeVolumeRestrictionTM.sol";
import "../../../libraries/Util.sol";

/**
 * @title Factory for deploying SingleTradeVolumeRestrictionManager
 */
contract SingleTradeVolumeRestrictionTMFactory is ModuleFactory {
    /**
    * @notice Constructor
    * @param _setupCost Setup cost of the module
    * @param _usageCost Usage cost of the module
    * @param _subscriptionCost Subscription cost of the module
    */
    constructor(
        uint256 _setupCost,
        uint256 _usageCost,
        uint256 _subscriptionCost
    ) public ModuleFactory(_setupCost, _usageCost, _subscriptionCost) {
        version = "1.0.0";
        name = "SingleTradeVolumeRestrictionTM";
        title = "Single Trade Volume Restriction Manager";
        description = "Imposes volume restriction on a single trade";
        compatibleSTVersionRange["lowerBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
        compatibleSTVersionRange["upperBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
    }

    /**
    * @notice Used to launch the Module with the help of factory
    * @return address Contract address of the Module
    */
    function deploy(bytes calldata _data) external returns(address) {
        address polyToken = _takeFee();
        SingleTradeVolumeRestrictionTM singleTradeVolumeRestrictionManager = new SingleTradeVolumeRestrictionTM(msg.sender, polyToken);
        require(Util.getSig(_data) == singleTradeVolumeRestrictionManager.getInitFunction(), "Provided data is not valid");
        bool success;
        /*solium-disable-next-line security/no-low-level-calls*/
        (success, ) = address(singleTradeVolumeRestrictionManager).call(_data);
        require(success, "Unsuccessful call");
        /*solium-disable-next-line security/no-block-members*/
        emit GenerateModuleFromFactory(address(singleTradeVolumeRestrictionManager), getName(), address(this), msg.sender, setupCost, now);
        return address(singleTradeVolumeRestrictionManager);
    }

    /**
    * @notice Get the types of the Module factory
    * @return uint8[]
    */
    function getTypes() external view returns(uint8[] memory) {
        uint8[] memory res = new uint8[](1);
        res[0] = 2;
        return res;
    }

    /**
    * @notice Get the Instructions that help to use the module
    * @return string
    */
    function getInstructions() external view returns(string memory) {
        /*solium-disable-next-line max-len*/
        return "Allows an issuer to impose volume restriction on a single trade. Init function takes two parameters. First parameter is a bool indicating if restriction is in percentage. The second parameter is the value in percentage or amount of tokens";
    }

    /**
    * @notice Get the tags related to the module factory
    * @return bytes32[]
    */
    function getTags() external view returns(bytes32[] memory) {
        bytes32[] memory availableTags = new bytes32[](3);
        availableTags[0] = "Single Trade";
        availableTags[1] = "Transfer";
        availableTags[2] = "Volume";
        return availableTags;
    }

}