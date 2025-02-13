// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "forge-std/console2.sol";

import {ZoraDeployerBase} from "../src/ZoraDeployerBase.sol";
import {Deployment} from "../src/DeploymentConfig.sol";
import {ZoraDeployerUtils} from "../src/ZoraDeployerUtils.sol";
import {IZoraCreator1155PremintExecutor} from "@zoralabs/zora-1155-contracts/src/interfaces/IZoraCreator1155PremintExecutor.sol";

contract DeployTestContracts is ZoraDeployerBase {
    function run() public returns (string memory) {
        Deployment memory deployment = getDeployment();

        vm.startBroadcast();

        ZoraDeployerUtils.deployTestContractForVerification(deployment.factoryProxy, makeAddr("admin"));

        address fundsRecipient = vm.envAddress("DEPLOYER");
        IZoraCreator1155PremintExecutor.MintArguments memory mintArguments = IZoraCreator1155PremintExecutor.MintArguments({
            mintRecipient: fundsRecipient,
            mintComment: "",
            mintReferral: fundsRecipient
        });

        signAndExecutePremintV2(deployment.preminterProxy, fundsRecipient, mintArguments);

        vm.stopBroadcast();

        // now test signing and executing premint

        return getDeploymentJSON(deployment);
    }
}
