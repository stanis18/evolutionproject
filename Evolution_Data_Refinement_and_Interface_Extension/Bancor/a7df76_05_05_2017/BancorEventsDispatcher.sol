pragma solidity >=0.5.0 <0.9.0;
import './Owned.sol';
import './BancorEventsInterface.sol';

/*
    Provides access and utilities to BancorEvents contract
*/
contract BancorEventsDispatcher is Owned {
    BancorEventsInterface public events;    // bancor events contract

    /*
        _events     optional, address of a bancor events contract
    */
     constructor(address _events) public {
        events = BancorEventsInterface(_events);
    }

    /*
        replaces the events contract with a new one
        can only be called by the owner
    */
    function setEvents(address _events) public ownerOnly returns (bool success) {
        require(_events != address(events));
        events = BancorEventsInterface(_events);
        return true;
    }
}
