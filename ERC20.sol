// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 < 0.7.0;
pragma experimental ABIEncoderV2;
import "./SafeMath.sol";

// Users for testing purposes (replace with your own addresses):

// Andres: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 
// John: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// Julia: 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
// Smart Contract: 0x993E3cdfC4a066283E1c69276F4b4425F1263Aa2

// ERC20 token interface
interface IERC20 {
    
    // Returns the number of existing tokens
    function totalSupply() external view returns(uint256);
    
    // Returns the number of tokens for an address taken by parameter
    function balanceOf(address account) external view returns(uint256);
    
    // Returns the number of tokens that the spender could spent in name of the owner
    function allowance(address owner, address spender) external view returns (uint256);
    
    // Returns a boolean value as a result of a given operation
    function transfer(address recipient, uint256 amount) external returns (bool);

    // Returns a boolean value as a result of a Disney transaction
    function transferDisney(address _customer, address recipient, uint256 amount) external returns (bool);
    
    // Returns the approval of a given operation as boolean
    function approve(address spender, uint256 amount) external returns (bool);
    
    // Returns a boolean value as a result of a given token quantity transfer operation using the allowance method
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    
    
    // This event must be emitted when a number of tokens go from an origin to a destiny
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    // This event must be emitted when an assignment is made with the allowance method
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// ERC20 token functions implementation
contract ERC20Basic is IERC20 {
    
    string public constant name = "ERC20BlockchainAZ";
    string public constant symbol = "BAZ"; // the symbol comes from "Blockchain from A to Z" that is the name of the course.
    uint8 public constant decimals = 2;
    
    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed owner, address indexed spender, uint256 tokens);
    
    using SafeMath for uint256;
    
    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;
    uint256 totalSupply_;   

    constructor (uint256 initialSupply) public {
        totalSupply_ = initialSupply;
        balances[msg.sender] = totalSupply_;
    }
        
    function totalSupply() public override view returns (uint256) {
        return totalSupply_; 
    }

    function increaseTotalSupply(uint newTokensAmount) public {
        totalSupply_ += newTokensAmount;
        balances[msg.sender] += newTokensAmount;
    }
    
    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }
    
    function allowance(address owner, address delegate) public override view returns (uint256) {
        return allowed[owner][delegate];
    }
    
    function transfer(address recipient, uint256 tokensAmount) public override returns (bool) {
        require(tokensAmount <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(tokensAmount);
        balances[recipient] = balances[recipient].add(tokensAmount);
        emit Transfer(msg.sender, recipient, tokensAmount);
        return true;
    }

    function transferDisney(address _customer, address recipient, uint256 tokensAmount) public override returns (bool) {
        require(tokensAmount <= balances[_customer]);
        balances[_customer] = balances[_customer].sub(tokensAmount);
        balances[recipient] = balances[recipient].add(tokensAmount);
        emit Transfer(_customer, recipient, tokensAmount);
        return true;
    }
    
    function approve(address delegate, uint256 tokensAmount) public override returns (bool) {
        allowed[msg.sender][delegate] = tokensAmount;
        emit Approval(msg.sender, delegate, tokensAmount);
        return true;
    }
    
    function transferFrom(address owner, address buyer, uint256 tokensAmount) public override returns (bool) {
        require(tokensAmount <= balances[owner]);
        require(tokensAmount <= allowed[owner][msg.sender]);
        balances[owner] = balances[owner].sub(tokensAmount);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(tokensAmount);
        balances[buyer] = balances[buyer].add(tokensAmount);
        emit Transfer(owner, buyer, tokensAmount);
        return true;
    }
    
}