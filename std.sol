contract abstract {}

contract owned is abstract {
  address owner;
  function owned() {
    owner = msg.sender;
  }
  modifier onlyowner() {
    if (msg.sender==owner) _
  }
}

contract mortal is abstract, owned {
  function kill() {
    if (msg.sender == owner) suicide(owner);
  }
}

contract NameReg is abstract {
  function register(bytes32 name) {}
  function unregister() {}
  function addressOf(bytes32 name) constant returns (address addr) {}
  function nameOf(address addr) constant returns (bytes32 name) {}
  function kill() {}
}

contract nameRegAware is abstract {
  function nameRegAddress() returns (address) {
    return 0xcd2a3d9f938e13cd947ec05abc7fe734df8dd825;
  }
}

contract named is abstract, nameRegAware {
  function named(bytes32 name) {
    NameReg(nameRegAddress()).register(name);
  }
}
