## Simulation Checker

Following our Research regarding some potential issues with the way the simulation is handled, we created a contract that can be used to check whether the simulation is valid or not, it is highly recommeded for every simulation provider to check whether their simulation is valid or not before deploying it to production

## Background

Simulation can easily exploited if it uses environment variables which are not valid on-chain, that way a malicous contract can detect whether malicous values are being submitted during simulation, detect if it runs under it and flip the behivour when running on-chain ([more info](https://zengo.com/zengo-uncovers-security-vulnerabilities-in-popular-web3-transaction-simulation-solutions-the-red-pill-attack/))

## Verify your Simulation

1. When deploying the contract, pass an ERC20 token address as a constructor argument, that will be the token that we'll use in order to debug the simulation
2. Send some of the ERC20 token to the contract

3. Use the claim functions, if the simulation is valid, you won't get any ERC20 token back in favor, if the simulation is invalid, you'll get the ERC20 token back in favor of the ETH you submitted

4. DO NOT submit any transaction on-chain

## Debug your Simulation

The owners of the SimulationChecker contract is able to debug the environment variables values of the simulation they use by calling the test functions, these functions simply returns the caller the value of the respective environment variable.

For Example:

`testBlockBasefee()` function will return the value of `block.basefee` environment variable of the deposited ERC-20 token

### Improtant note

its important that only the owner of the contract can call these funcitons (As in that repo), becuase if they would run on chain, the caller will actually get the deposited ERC-20 token back

## Example

Gas price of 0 (tx.gasprice = 0) isn't valid on-chain, so if the simulation provider uses tx.gasprice = 0 when submitting simulation, it can be easily exploitable as a malicous contract can detect that and flip the behivour when running on-chain

#### How to check

- call `claimTxGasprice()` function within the simulation
- if the simulation shows that the deposited ERC-20 is going to be returned, then the simulation isn't valid (tx.gasprice = 0)
