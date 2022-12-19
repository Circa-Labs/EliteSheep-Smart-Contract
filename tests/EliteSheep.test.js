const { expect } = require('chai');
const { ethers } = require("hardhat")

describe("EliteSheep Smart Contract Tests", function() {

    let elitesheep;

    this.beforeEach(async function() {
        // This is executed before each test
        // Deploying the smart contract
        const EliteSheep = await ethers.getContractFactory("EliteSheep");
        artwork = await EliteSheep.deploy("Elite_Sheep", "ELT");
    })

    it("NFT is minted successfully", async function() {
        [account1] = await ethers.getSigners();

        expect(await elitesheep.balanceOf(account1.address)).to.equal(0);
        
        const tokenURI = "https://ipfs.io/ipfs/QmTcDie6fatghUpQkTcBoEYZZHPQ6ebiRjwJEPGGEnokMz/1"
        const tx = await elitesheep.connect(account1).mint(tokenURI);

        expect(await elitesheep.balanceOf(account1.address)).to.equal(1);
    })

    it("tokenURI is set sucessfully", async function() {
        [account1, account2] = await ethers.getSigners();

        const tokenURI_1 = "https://ipfs.io/ipfs/QmTcDie6fatghUpQkTcBoEYZZHPQ6ebiRjwJEPGGEnokMz/1"
        const tokenURI_2 = "https://ipfs.io/ipfs/QmTcDie6fatghUpQkTcBoEYZZHPQ6ebiRjwJEPGGEnokMz/2"

        const tx1 = await elitesheep.connect(account1).mint(tokenURI_1);
        const tx2 = await elitesheep.connect(account2).mint(tokenURI_2);

        expect(await elitesheep.tokenURI(0)).to.equal(tokenURI_1);
        expect(await elitesheep.tokenURI(1)).to.equal(tokenURI_2);

    })

})
