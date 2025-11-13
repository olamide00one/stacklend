# StackLend v2 - Smart Lending & Borrowing Contract

## Overview

StackLend v2 is an enhanced smart contract built on the Stacks blockchain that enables users to participate in a decentralized lending and borrowing protocol. Users can deposit STX to earn interest, borrow against collateral, and participate in a risk management system through liquidation mechanisms.

## Features

### Core Functionality

- **Lending Pool**: Users can deposit STX tokens to earn interest on their holdings
- **Borrowing**: Users can borrow STX by providing collateral, with a maximum loan-to-value (LTV) ratio
- **Interest Calculation**: Automatic interest accrual based on deposit duration and configured interest rates
- **Collateralization Tracking**: Real-time monitoring of loan health through collateral ratios
- **Liquidation Mechanism**: Automatic liquidation of undercollateralized loans to protect the protocol
- **Emergency Controls**: Admin functions for emergency withdrawals and protocol management

### Key Contracts

#### Data Structures

| Structure | Purpose |
|-----------|---------|
| `loans` | Tracks borrowed amounts and collateral per user |
| `deposits` | Records deposit amounts and timestamps for interest calculation |
| `owner` | Contract administrator address |
| `deposit-interest-rate` | Configurable interest rate (5% by default) |

#### Functions

**Read-Only Functions:**
- `calculate-interest`: Computes accrued interest based on principal, rate, and elapsed blocks
- `get-collateral-ratio`: Returns the current loan-to-collateral ratio for a user

**Public Functions:**
- `liquidate`: Liquidates undercollateralized loans (ratio > 50%)
- `apply-deposit-bonus`: Applies bonus interest for long-term deposits
- `withdraw-interest`: Allows users to withdraw only interest earnings
- `emergency-withdraw`: Admin function for emergency fund withdrawal

## Error Codes

| Code | Constant | Description |
|------|----------|-------------|
| u110 | ERR_UNDER_COLLATERAL | Insufficient collateral for operation |
| u111 | ERR_NOT_ENOUGH | Insufficient funds available |
| u112 | ERR_NO_FUNDS | No funds in account |
| u113 | ERR_EMERGENCY | Emergency operation failed |
| u114 | ERR_NOT_BORROWER | User has no active loan |
| u115 | ERR_NO_DEPOSIT | User has no active deposit |

## Technical Details

### Language & Chain
- **Language**: Clarity 3
- **Blockchain**: Stacks (STX)
- **Version**: v2.0

### Interest Calculation

Interest is calculated using the formula:
