// contracts/Blog.sol
//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Blog {
    string public name;
    address public owner;

    using Counters for Counters.Counter;
    Counters.Counter private _postIds;

    struct Post {
        uint id;
        string title;
        string content;
        bool published;
    }
    //mapping can be seen as hash tables
    //here we create lookups for posts by id and posts by ipfs hash

    mapping(uint => Post) private idToPost;
    mapping(string => Post) private hashToPost;

    //events facilitate communication between smart contracts and their user interface
    // ex: we can create listeners for events in the client and also use them in GRT

    event PostCreated(uint id, string title, string hash);
    event PostUpdated(uint id, string title, string hash, bool published);

    //wen the blog is deployed give it a name
    //also set the creator as the owner of the contract
    constructor(string memory _name){
        console.log("Deploying Blog with name:", _name);
        name = _name;
        owner = msg.sender;
    }

    //update the blog name
    function updateName(string memory _name) public {
        name = _name;
    }
    //trade ownership of the contracts to another address
    function tradeOwnership(address newOwner) public onlyOwner{
        owner = newOwner;
    }

    //fetched an individual post by the content hash
    function fetchPost(string memory hash) public view returns(Post memory){
        return hashToPost[hash];
    }

    //create a new post
    function createPost(uint postId, string memory hash, bool published) public onlyOwner{
        _postIds.increment();
        uint postId = _postIds.current();
        Post storage post = idToPost[postId];
        post.id = postId;
        post.title = title;
        post.published = true;
        post.content = hash;
        idToPost[postId] = post;
        hashToPost[hash] = post;

        emit PostCreated(postId, title, hash);
    }

    //update an existing post
    function updatePost(uint postId, string memory hash, bool published) public onlyOwner{
        Post storage post = idToPost[postId];
        post.title = title;
        post.published = published;
        post.content = hash;
        idToPost[postId] = post;
        hashToPost[hash] = post;

        emit PostUpdated(post.id, title, hash, published); 
    }

    //fetched all posts
    function fetchPosts()public view returns(Post[] memory){
        uint itemCount = _postIds.current();
        uint currentIndex = 0;

        Post[] memory posts = new Post[](itemCount);
        for (uint i = 0; i < itemCount; i++) {
            uint currentId = i +1;
            Post storage currentItem = idToPost[currentId];
            posts[currentIndex] = currentItem;
            currentIndex += 1;
        }
        return posts;
    }

    //this modifier means only the contract can invoke the function
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
}