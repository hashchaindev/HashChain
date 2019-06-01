pragma solidity 0.5.9;


/**
@title HashChain
@author HashChainDev
@dev https://github.com/hashchaindev/HashChain/blob/master/HashChain.sol
*/
contract HashChain{
    
    struct hash {
        address signer;
        uint timestamp;
        bytes32 nextHash;
        bytes32 previousHash;
    }

    mapping(bytes32 => hash) private hashes;
    
    /**
    @notice Store a hash with sender's address and timestamp of when message was sent.
    @dev Require that the hashVal has not changed from the default value.
    @param hashVal Value of the hash of the document you would like to sign.
    */
    function sign(bytes32 hashVal) public {
        require(hashes[hashVal].signer == address(0));
        hashes[hashVal].signer = msg.sender;
        hashes[hashVal].timestamp = now;
    }
    
    /**
    @notice Link two hashes simultanesouly. Once two hashes have been linked they cannot be unlinked.
    @dev
      Require that the next hash of the previous has has not been set.
      Require that the previous hash of the next has has not been set.
      Require that the message sender is the signer of both hashes.
    @param prevHashVal The hash which is at the end of the SignatureLink.
    @param nextHashVal The new hash to be appended to the end of the SignatureLink.
    */
    function link(bytes32 prevHashVal,bytes32 nextHashVal) public {
        require(
            hashes[prevHashVal].nextHash == "" && 
            hashes[nextHashVal].previousHash == "" &&
            hashes[prevHashVal].signer == msg.sender && 
            hashes[nextHashVal].signer == msg.sender
        );
        hashes[prevHashVal].nextHash = prevHashVal;
        hashes[nextHashVal].previousHash = nextHashVal;
    }
    
    /**
    @notice Check if hash already exists in hashes
    @param hashVal Value of hash to query.
    @return { "signed": "Hash is stored" }
    */
    function isSigned(bytes32 hashVal) view public returns (bool signed) {
        return hashes[hashVal].signer != address(0);
    }
    
    /**
    @notice Retrieve address of signer for specific hash.
    @param hashVal Value of hash to retrieve signer of.
    @return { "signer": "Address associated to a specific stored hash value" }
    */
    function getSigner(bytes32 hashVal) view public returns (address signer) {
        return hashes[hashVal].signer;
    }
    
    /**
    @notice Retrieve the next hash for specific hash.
    @param hashVal Value of hash to retrieve next hash of.
    @return { "nextHash": "The next hash associated to a specific stored hash value" }
    */
    function getNextHash(bytes32 hashVal) view public returns (bytes32 nextHash) {
        return hashes[hashVal].nextHash;
    }

    /**
    @notice Retrieve the previous hash for specific hash.
    @param hashVal Value of hash to retrieve the previous hash of.
    @return { "previousHash": "The previous hash associated to a specific stored hash value" }
    */
    function getPreviousHash(bytes32 hashVal) view public returns (bytes32 previousHash) {
        return hashes[hashVal].previousHash;
    }

    /**
    @notice Retrieve timestamp of a specific hash.
    @param hashVal Value of the hash to retrieve a timestamp.
    @return { "timestamp": "Timestamp associated to a specific stored hash value" }
    */
    function getTimestamp(bytes32 hashVal) view public returns (uint timestamp) {
        return hashes[hashVal].timestamp;
    }
}
