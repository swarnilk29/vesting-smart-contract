# Vesting-Smart-Contract

## Description

This project involves the creation of a blockchain token vesting contract designed to manage the vesting process for Users, Partners, and Team members. The smart contract adheres to specific vesting schedules for each role. The following document includes the complete Solidity code, instructions for deployment, and a detailed usage guide.

## Overview

- Roles and Vesting Schedules

  1.  User

      - Allocation: 50% of total allocated tokens

      - Cliff Period: 10 months

      - Vesting Duration: 2 years

  2.  Partners

      - Allocation: 25% of total allocated tokens

      - Cliff Period: 2 months

      - Vesting Duration: 1 year

  3.  Team

      - Allocation: 25% of total allocated tokens

      - Cliff Period: 2 months

      - Vesting Duration: 1 year

## Features

- Owner can start vesting.

- Beneficiaries can be added for each role before vesting starts.

- Beneficiaries can claim their vested tokens according to the schedule.

- Events are emitted for vesting start, beneficiary addition, and token withdrawal.

## Deployment and Usage

- Install Dependencies: Ensure you have Node.js and npm installed. Install the necessary dependencies (if using vs code):

## bash (if using vs code)

    npm install @openzeppelin/contracts

Compile the Contract: Use a Solidity compiler (like Remix) to compile the contract.

## Deploy the Contract:

- Deploy the compiled contract on your preferred Ethereum network (testnet or mainnet).

- Ensure you provide the correct token address and total allocated tokens during deployment.

## Usage

     addBeneficiary(address beneficiary, uint256 cliff, uint256 duration, uint256 allocation)

- Adding Beneficiaries: The contract owner can add beneficiaries before starting the vesting. Each beneficiary is assigned a cliff period, vesting duration, and token allocation.

- Starting Vesting : Once all beneficiaries are added, the owner can start the vesting period.

- Claiming Tokens : Beneficiaries can claim their vested tokens once the cliff period is over and tokens have vested.

## Events

- VestingStarted : Emitted when the vesting starts.

- BeneficiaryAdded : Emitted when a beneficiary is added.

- TokensClaimed : Emitted when a beneficiary claims tokens.
