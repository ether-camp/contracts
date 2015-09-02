import "std.sol";

contract PriceFeedApi {
    
    // block time when the prices were last updated 
    uint public updateTime;

    // returns the price of an asset 
    // the price is represented as uint: (double price) * 1000000
    function getPrice(bytes32 symbol) constant returns(uint currPrice);  
    
    // returns the timestamp of the latest price for an asset 
    // normally this is the exchange timestamp, but if exchange 
    // doesn't supply such info the latest data retrieval time is returned
    function getTimestamp(bytes32 symbol) constant returns(uint timestamp);
}

contract PriceFeed is PriceFeedApi, owned, mortal, named("ether-camp/price-feed")  {
    
    mapping (bytes32 => uint) priceMap;     // symbol => price
    mapping (bytes32 => uint) timestampMap; // symbol => time
    
    mapping (address => uint) updaters; // who can update the price
    
    function PriceFeed() {
        addUpdater(msg.sender);
    }

    function update(bytes32[] symbols, uint[] newPrices, uint[] timestamps) {
        if (updaters[msg.sender] == 1) {
            updateTime = now;
            for (uint i = 0; i < symbols.length; i++) {
                priceMap[symbols[i]] = newPrices[i];
                timestampMap[symbols[i]] = timestamps[i];
            }
        }
    }
    
    function getPrice(bytes32 symbol) constant returns(uint currPrice) {
        return priceMap[symbol];
    }    
    
    function getTimestamp(bytes32 symbol) constant returns(uint timestamp) {
        return timestampMap[symbol];
    }
    
    function addUpdater(address updater) onlyowner {
        updaters[updater] = 1;
    }

    function removeUpdater(address updater) onlyowner {
        updaters[updater] = 0;
    }
}