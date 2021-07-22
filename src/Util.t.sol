pragma solidity ^0.6.7;

import "ds-test/test.sol";

import "./Util.sol";

contract UtilTest is DSTest {
    Util util;

    function setUp() public {
        util = new Util();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
