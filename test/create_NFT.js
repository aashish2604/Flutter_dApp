const CreateNFT=artifacts.require('CreateNFT');

contract('CreateNFT',()=>{
    it("Testing",async()=>{
        const instance=await CreateNFT.deployed();
        await instance.createTokenUri("Created sample token");
        const response=instance.getAllUri();
        assert(response.length!==0);

    })
});