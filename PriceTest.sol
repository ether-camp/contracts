import "std.sol";

contract PriceFeedApi {
    
    // block time when the prices were last updated 
    uint public updateTime;

    // returns the price of an asset 
    // the price is represented as uint: (double price) * 1000000
    function getPrice(bytes32 symbol) returns(uint currPrice);  
    
    // returns the timestamp of the latest price for an asset 
    // normally this is the exchange timestamp, but if exchange 
    // doesn't supply such info the latest data retrieval time is returned
    function getTimestamp(bytes32 symbol) returns(uint timestamp);
}

contract PriceTest is nameRegAware {
    PriceFeedApi priceFeed;
    
    uint lastCrossRate;

    function PriceTest() {
        priceFeed = PriceFeedApi(named("ether-camp/price-feed"));
    }
    
    function() {
        // sample call: calculate how much S&P500 costs in Ethers
        getCrossRate("SP500", "USDT_ETH");
    }
    
    function getCrossRate(bytes32 rate1, bytes32 rate2) returns (uint) {
        lastCrossRate = priceFeed.getPrice(rate1) * 1000000 / priceFeed.getPrice(rate2);
        return lastCrossRate;
    }
}
