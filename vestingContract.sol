//Start//

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VestingContract is Ownable {
    IERC20 public token;
    
    enum Role { User, Partner, Team }
    
    struct VestingSchedule {
        uint256 cliffDuration;
        uint256 totalDuration;
        uint256 start;
        uint256 totalAmount;
        uint256 amountClaimed;
    }
    
    mapping(address => VestingSchedule) public beneficiaries;
    mapping(Role => uint256) public roleAllocations;
    mapping(address => Role) public beneficiaryRoles;

    event VestingStarted(uint256 timestamp);
    event BeneficiaryAdded(address indexed beneficiary, Role role, uint256 amount);
    event TokensClaimed(address indexed beneficiary, uint256 amount);

    bool public vestingStarted;
    
    constructor(address _token, address _initialOwner) Ownable(_initialOwner) {
        token = IERC20(_token);
        roleAllocations[Role.User] = 50;
        roleAllocations[Role.Partner] = 25;
        roleAllocations[Role.Team] = 25;
    }
    
    modifier onlyWhenVestingStarted() {
        require(vestingStarted, "Vesting has not started yet");
        _;
    }
    
    function startVesting() external onlyOwner {
        vestingStarted = true;
        emit VestingStarted(block.timestamp);
    }
    
    function addBeneficiary(address _beneficiary, Role _role, uint256 _amount) external onlyOwner {
        require(!vestingStarted, "Cannot add beneficiaries after vesting starts");
        require(_amount > 0, "Amount should be greater than 0");

        VestingSchedule storage schedule = beneficiaries[_beneficiary];
        require(schedule.totalAmount == 0, "Beneficiary already added");

        uint256 cliffDuration;
        uint256 totalDuration;
        if (_role == Role.User) {
            cliffDuration = 10 * 30 days; // Approximation of 10 months
            totalDuration = 2 * 365 days; // Approximation of 2 years
        } else {
            cliffDuration = 2 * 30 days; // Approximation of 2 months
            totalDuration = 365 days; // Approximation of 1 year
        }

        beneficiaries[_beneficiary] = VestingSchedule({
            cliffDuration: cliffDuration,
            totalDuration: totalDuration,
            start: block.timestamp,
            totalAmount: _amount,
            amountClaimed: 0
        });

        beneficiaryRoles[_beneficiary] = _role;
        
        emit BeneficiaryAdded(_beneficiary, _role, _amount);
    }
    
    function claimTokens() external onlyWhenVestingStarted {
        VestingSchedule storage schedule = beneficiaries[msg.sender];
        require(schedule.totalAmount > 0, "No tokens to claim");
        
        uint256 vested = calculateVestedAmount(schedule);
        uint256 claimable = vested - schedule.amountClaimed;
        require(claimable > 0, "No tokens available for claim");

        schedule.amountClaimed += claimable;
        token.transfer(msg.sender, claimable);
        
        emit TokensClaimed(msg.sender, claimable);
    }
    
    function calculateVestedAmount(VestingSchedule memory schedule) internal view returns (uint256) {
        if (block.timestamp < schedule.start + schedule.cliffDuration) {
            return 0;
        } else if (block.timestamp >= schedule.start + schedule.totalDuration) {
            return schedule.totalAmount;
        } else {
            uint256 elapsedTime = block.timestamp - schedule.start;
            return (schedule.totalAmount * elapsedTime) / schedule.totalDuration;
        }
    }
}

//END//