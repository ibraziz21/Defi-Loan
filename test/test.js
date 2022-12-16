const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Bank", function () {
  beforeEach(async function(){
    const aggAddress = '0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e'
    const Inst = await ethers.getContractFactory("Bank");
    const Instance = await Inst.deploy(aggAddress);
  })

});