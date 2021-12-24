
//SPDX-License-Identifier:UNLICENSED

pragma solidity ^0.8.0;

//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/access/Ownable.sol";
/**
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/token/ERC721/IERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/utils/introspection/IERC165.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/token/ERC721/IERC721Receiver.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/utils/introspection/ERC165.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/token/ERC721/ERC721.sol";
*/
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Burnable.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

 
/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */

 
/**
 * @dev Collection of functions related to the address type
 */

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 * and `uint256` (`UintSet`) are supported.
 */



pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */

 
contract MyToken is ERC721Burnable, Ownable {
    using Strings for uint256;
    //----private--
    string private _baseURIextended;
    string private _blindURIextended;

    bool private _timeSaleActiveLock;
    bool private _timeSaleLastingLock;

    address private _payeeAccount;

    mapping(address => uint256) private _whiteList;
    //--
    //----public--
    uint256 public immutable maxToken;
    uint256 public totalSupply;
    uint256 public timeSaleActive;
    uint256 public timeSaleLasting;
    uint256 public tokenPrice;
    uint256 public maxMintPublic;

    bool public revealBox;
    bool public isSaleActive;
    //--

 
    constructor()
        ERC721("TokenName", "TokenSymbal")
    {
        maxToken = 10000;
    }

    function setBaseURI(string memory baseURI_) public onlyOwner {
        _baseURIextended = baseURI_;
    }
    function setBlindURI(string memory blindURI_) public onlyOwner {
        _blindURIextended = blindURI_;
    }

    function _baseURI() internal view virtual override returns (string memory) {
            return _baseURIextended;
    }
    
    function tokenURI(uint256 tokenId) public view virtual override(ERC721) returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        if (revealBox == true) {
            return string(abi.encodePacked(_baseURI(), tokenId.toString()));
        } else {
            return _blindURIextended;
        }
    }
    
    function revealBlindBox() public onlyOwner {
        revealBox = true;
    }

    function setPayeeAccount(address account) external onlyOwner {
        _payeeAccount = account;
    }

    function setWhiteAccounts(address[] calldata accounts, uint32 numAllowedToMint) external onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            _whiteList[accounts[i]] = numAllowedToMint;
        }
    }

    function deleteWhiteAccounts(address[] calldata accounts) external onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++){
            delete _whiteList[accounts[i]];
        }
    }

    function setSaleActiveTime(uint32 hours_) public onlyOwner {
        require(_timeSaleActiveLock == false, "");
        timeSaleActive = block.timestamp + hours_ * 3600;
        _timeSaleActiveLock = true;
    }

    function setSaleLasting(uint32 hours_) public onlyOwner {
        require(_timeSaleLastingLock == false, "");
        timeSaleLasting = hours_ * 3600;
        _timeSaleLastingLock = true;
    }

    function setTokenPrice(uint256 price) external onlyOwner {
        tokenPrice = price;
    }

    function setMaxmintPublic(uint256 number) external onlyOwner {
        maxMintPublic = number;
    }

    function flipSaleState() external onlyOwner {
        isSaleActive = !isSaleActive;
    }

    function accountAuthorityCheck(address account) public view returns (uint256) {
        if (_whiteList[account] != 0) {
            return _whiteList[account];
        } else {
            return 0;
        }
    }

    //--------

    function preSaleMint(uint256 numberOfTokens) public payable {
        require(isSaleActive, "Sale is not active.");
        bool whiteAccount = false;
        uint256 mintLimit;
        if (accountAuthorityCheck(msg.sender) == 0) {
            require(block.timestamp >= timeSaleActive, "Sale is not active yet.");
            mintLimit = maxMintPublic;
        } else {
            whiteAccount = true;
            mintLimit = accountAuthorityCheck(msg.sender);
        }
        require(block.timestamp < timeSaleLasting, "Sale has closed.");
        require(numberOfTokens > 0, "");
        require(numberOfTokens + balanceOf(msg.sender) < mintLimit, "Out of mint limit per address!");
        require(totalSupply + numberOfTokens <= maxToken, "Purchase would exceed max supply of Token");
        require(tokenPrice * numberOfTokens == msg.value, "Ether value is not correct");

        payable(_payeeAccount).transfer(msg.value);
 
        for (uint256 i = 0; i < numberOfTokens; i++) {
            uint256 mintIndex = totalSupply;
            if (totalSupply < maxToken) {
                _safeMint(msg.sender, mintIndex);
                totalSupply += 1;
            }
        }
    }

 
    function mintAdmin(uint256 numberOfTokens) public onlyOwner {
        require(numberOfTokens > 0, "");
        require(totalSupply + numberOfTokens <= maxToken, "Purchase would exceed max supply of Token");

        for (uint256 i = 0; i < numberOfTokens; i++) {
            uint256 mintIndex = totalSupply;
            if (totalSupply < maxToken) {
                _safeMint(msg.sender, mintIndex);
                totalSupply += 1;
            }
        }
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(_payeeAccount).transfer(balance);
    }

    fallback() external {
	}
}
