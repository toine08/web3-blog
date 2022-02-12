const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Blog", async function () {
  it("Should create a post", async function () {
    const Blog = await ethers.getContractFactory("Blog");
    const blog = await Blog.deploy("my blog 1212 test");
    await blog.deployed();
    await blog.createPost("my first post", "12345")

    const posts = await blog.fetchPosts()
    expect(posts[0].title).to.equal("my first post")
  })
  it("Should edit a post", async function(){
    const Blog = await ethers.getContractFactory("Blog")
    const blog = await Blog.deploy()
    await blog.deployed();
    await blog.createPost("my second post", "23456", true)

    post = await blog.fetchPosts()
    expect(posts[0].title).to.equal("my updated post")
  })

  it("should add update the name", async function (){
    const Blog = await ethers.getContractFactory("Blog")
    const blog = await Blog.deploy()
    await blog.deployed();

    expect(await blog.name()).to.equal("my blog")
    await blog.updateName('my new blog')
    expect(await blog.name()).to.equal("my new blog")
  })
});
