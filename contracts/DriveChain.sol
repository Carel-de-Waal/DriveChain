pragma solidity ^0.4.17;

contract DriveChain {

    struct Location {
        uint32 latitude;
        uint32 longitude;
    }

    struct Route {
        Location origin;
        Location destination;
        uint256 costInWei;
        address requester;
        address driver;
    }

    Route[] routes;
    uint256 routesSize;
   
   mapping(address => uint) pendingWithdrawals;

    function requestLift(uint32 latOrigin, uint32 lonOrigin, uint32 latDestination, uint32 lonDestination, uint256 proposedCostInWei) public returns (uint index) {
        var origin = Location(latOrigin, lonOrigin);
        var destination = Location(latDestination, lonDestination);
        var route = Route(origin,destination,proposedCostInWei,msg.sender,0);
        route.destination = destination;
        routesSize++;
        routes[routesSize] = route;
        return routesSize;
    }

    // Dont need this. There is a public getter already because of this: "Route[] public routes;"
    // function liftRequests(uint32 lat, uint32 lon) public constant returns (Route[]) {
    //     return routes;
    // }

    function acceptLiftRequest(uint routeId) public {
        var route = routes[routeId];
        route.driver = msg.sender;
        routes[routeId] = route;
    }

    function payDriver(address driverAddress, uint routeId) public payable returns (bool) {
        var amountToPay = routes[routeId].costInWei;
        require(msg.value >= amountToPay);
        if (msg.value >= amountToPay) {
            pendingWithdrawals[driverAddress] += msg.value;
            return true;
        }else {
            return false;
        }       
    }

    function withdraw() public {
       uint amount = pendingWithdrawals[msg.sender];
       pendingWithdrawals[msg.sender] = 0;
        msg.sender.transfer(amount);
    }

}