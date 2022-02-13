pragma solidity >0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./ERC20.sol";

contract Disney {

    // ------------------------------- INITIAL DECLARATIONS -------------------------------

    // Token contract instance
    ERC20Basic private token; 

    // Disney address ( owner )
    address payable public owner;

    // Constructor
    constructor() public {
        token = new ERC20Basic(10000); // Initial supply of tokens.
        owner = msg.sender; // Address of the person who deploy this contract. We'll assign the initial supply to this address.
    }

    // Data structure to save Disney customers
    struct customer {
        uint buyed_tokens;
        string [] attractions_enjoyed;
    }

    // Customers registry mapping
    mapping (address => customer) public Customers;


    // ------------------------------- TOKEN MANAGEMENT -------------------------------

    // Token price converter
    function tokenPrice(uint _tokensNumber) internal pure returns (uint) {
        // Tokens to ethers conversion: 1 token = 1 ether
        return _tokensNumber * (1 ether);
    }

    // Buy tokens function
    function buyTokens(uint _tokensAmount) public payable {
        // Set tokens price:
        uint price = tokenPrice(_tokensAmount);
        // Check how much tokens the customer can buy with his money. 
        require(msg.value >= price, "Buy less tokens or pay with more ethers. You have the power.");
        // Difference betwen price and customer's money
        uint returnValue = msg.value - price;
        // Disney returns ether amount to the customer
        msg.sender.transfer(returnValue);
        // Get tokens amount available
        uint Balance = balanceOf();
        require( _tokensAmount <= Balance, "WOOOW... Take it easy rich kid! There aren't enough tokens to buy. Buy less tokens.");
        // Tokens amount get transferred to the customer
        token.transfer(msg.sender, _tokensAmount);
        // Number of buyed tokens is saved in a registry
        Customers[msg.sender].buyed_tokens += _tokensAmount;
    }

    // Token balance of Disney contract
    function balanceOf() public view returns (uint) {
        return token.balanceOf(address(this));
    }

    // Visualize customer's remaining tokens
    function myTokens() public view returns (uint) {
        return token.balanceOf(msg.sender);
    }

    // Generate more tokens
    function generateTokens(uint _tokensAmount) public OnlyByOwner(msg.sender) {
        token.increaseTotalSupply(_tokensAmount);
    }

    // Modifier to control executable functions only by Disney
    modifier OnlyByOwner(address _address) {
        require(_address == owner, "Nice try, hackerman... But you don't have permissions to execute this function!");
        _;
    }


    // ------------------------------- DISNEY ATRACTIONS MANAGEMENT -------------------------------
    
    // Events
    event enjoy_attraction(string);
    event new_attraction(string, uint);
    event close_attraction(string);

    // Attraction data structure
    struct attraction {
        string attraction_name;
        uint attraction_price;
        bool attraction_state;
    }
    
    // Mapping to match attraction's name with attraction's data structure
    mapping(string => attraction) public AttractionsMapping;

    // Array to save attractions names.
    string [] Attractions;

    // Mapping to match a customer with his attractions record in Disney
    mapping(address => string []) AttractionsRecord;

    // Create new Disney attraction executable only by Disney (owner)
    // Example: Star Wars -> 2 tokens
    function NewAttraction(string memory _attractionName, uint _price) public OnlyByOwner(msg.sender) {
        // New attraction creation
        AttractionsMapping[_attractionName] = attraction(_attractionName, _price, true);
        // Save attraction's name in the array
        Attractions.push(_attractionName);
        // New attraction event emit
        emit new_attraction(_attractionName, _price);
    }

    // Close Disney attraction
    function CloseAttraction(string memory _attractionName) public OnlyByOwner(msg.sender) {
        // attraction_state turns false => attraction unavailable.
        AttractionsMapping[_attractionName].attraction_state = false;
        // Attraction closed event emit
        emit close_attraction(_attractionName);
    }

    // Visualize available Disney attractions
    function visualizeAvailableDisneyAttractions() public view returns(string[] memory) {
        return Attractions;
    }

    // Pay with tokens and take attraction function
    function takeAttraction(string memory _attractionName) public {
        require(Attractions.length > 0, "There is not attractions available at this time. Come back tomorrow! We love your mone.. Umm, we love you <3");
        // Attraction price in tokens
        uint attraction_tokens = AttractionsMapping[_attractionName].attraction_price;
        // Verify attraction state (if it's available)
        require(AttractionsMapping[_attractionName].attraction_state == true, "Attraction isn't avaliable at this time. Please take another one :)");
        // Verify available customer's tokens to take the attraction
        require(attraction_tokens <= myTokens(), "You don't have enough tokens to take this attraction! Buy more tokens or GTFO!");
        /* 
            Transfer customer's tokens to Disney address.
            To archive this, we had to create a special function called transferDisney() in ERC20.sol contract
            because transfer() function take the contract's address as a sender, and we needed to change it for customer's address.
        */
        token.transferDisney(msg.sender, address(this), attraction_tokens);
        // Save attraction in customer's record
        AttractionsRecord[msg.sender].push(_attractionName);
        // Enjoy attraction event emit
        emit enjoy_attraction(_attractionName);
    }

    // Visualize customer's attractions record.
    function visualizeAttractionsRecord() public view returns(string[] memory) {
        return AttractionsRecord[msg.sender];
    }

    // Give Ether to a customer that returns unused Disney tokens
    function returnTokens(uint _tokensAmount) public payable {
        // Verify if _tokensAmount is more than 0
        require(_tokensAmount > 0, "Invalid tokens amount! Please insert the number of tokens you want to return.");
        // Verify if the customer has the _tokensAmount that is trying to return
        require(_tokensAmount <= myTokens(), "Haha, nice try... Crypto police is on this way right now. You better run! ;)");
        // Customer returns his tokens to Disney
        token.transferDisney(msg.sender, address(this), _tokensAmount);
        // Disney returns Ether to the customer
        msg.sender.transfer(tokenPrice(_tokensAmount));
    }


    // ------------------------------- DISNEY FOOD MANAGEMENT -------------------------------
    
    // Events
    event enjoy_dish(string);
    event new_dish(string, uint);
    event retire_dish(string);

    // Dish data structure
    struct dish {
        string dish_name;
        uint dish_price;
        bool dish_state;
    }
    
    // Mapping to match dish's name with dish's data structure
    mapping(string => dish) public DishesMapping;

    // Array to save dishes names.
    string [] Dishes;

    // Mapping to match a customer with his dishes record in Disney
    mapping(address => string []) DishesRecord;

    // Create new dish in the menu executable only by Disney (owner)
    // Example: Hot dog -> 1 tokens
    function NewDish(string memory _dishName, uint _price) public OnlyByOwner(msg.sender) {
        // New dish creation
        DishesMapping[_dishName] = dish(_dishName, _price, true);
        // Save dish's name in the array
        Dishes.push(_dishName);
        // New dish event emit
        emit new_dish(_dishName, _price);
    }

    // Retire dish from the menu
    function RetireDish(string memory _dishName) public OnlyByOwner(msg.sender) {
        // dish_state turns false => dish unavailable.
        DishesMapping[_dishName].dish_state = false;
        // Dish retired from the menu event emit
        emit retire_dish(_dishName);
    }

    // Visualize menu with available dishes
    function visualizeMenu() public view returns(string[] memory) {
        return Dishes;
    }

    // Pay with tokens and buy dish function
    function buyDish(string memory _dishName) public {
        require(Dishes.length > 0, "There is not food available at this time. If you are hungry just eat some leaves from a tree. They are made from chocolate! Just like Willy Wonka's factory :P");
        // Dish price in tokens
        uint dish_tokens = DishesMapping[_dishName].dish_price;
        // Verify dish state (if it's available)
        require(DishesMapping[_dishName].dish_state == true, "Sorry, we run out of that dish right now. Please select another one from the menu :)");
        // Verify available customer's tokens to buy the dish
        require(dish_tokens <= myTokens(), "You don't have enough tokens to buy this dish! Buy more tokens or take some free candies. Some of them are expired... But hey, they are free!");
        /* 
            Transfer customer's tokens to Disney address.
            To archive this, we had to create a special function called transferDisney() in ERC20.sol contract
            because transfer() function take the contract's address as a sender, and we needed to change it for customer's address.
        */
        token.transferDisney(msg.sender, address(this), dish_tokens);
        // Save dish in customer's record
        DishesRecord[msg.sender].push(_dishName);
        // Enjoy dish event emit
        emit enjoy_dish(_dishName);
    }

    // Visualize customer's dishes record.
    function visualizeDishesRecord() public view returns(string[] memory) {
        return DishesRecord[msg.sender];
    }
} 