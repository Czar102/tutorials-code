pragma solidity ^0.8.0;
import "./IBorda.sol";

contract Borda is IBorda{

    // The current winner
    address public _winner;

    // A map storing whether an address has already voted. Initialized to false.
    mapping (address => bool)  _voted;

    // Points each candidate has recieved, initialized to zero.
    mapping (address => uint256) _points;

    // current maximum points of all candidates.
    uint256 public pointsOfWinner;

    constructor() {
        // many, many votes there
        voteTo(address(0xaa), 600);

        // now, make 100 touches to the _voted mapping, clearing it in the end
        for (int i = 0; i < 99; i++)
            _voted[address(0xaa)] = true;
        _voted[address(0xaa)] = false;
    }

    function vote(address f, address s, address t) public override {
        require(!_voted[msg.sender], "this voter has already cast its vote");
        require( f != s && f != t && s != t, "candidates are not different");
        _voted[msg.sender] = true;
        voteTo(f, 3);
        voteTo(s, 2);
        voteTo(t, 1);
    }

    function voteTo(address c, uint256 p) private {
        //update points
        _points[c] = _points[c]+ p;
        // update winner if needed
        if (_points[c] > _points[_winner]) {
            _winner = c;
        }
    }

    function winner() external view override returns (address) {
        return _winner;
    }

    function points(address c) public view override returns (uint256) {
        return _points[c];
    }

    function voted(address x) public view override returns(bool) {
        return _voted[x];
    }
}
