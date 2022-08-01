const HelloWorld=artifacts.require('HelloWorld');

contract('HelloWorld',()=>{
    it("Testing",async()=>{
        const instance=await HelloWorld.deployed();
        await instance.setMessage("How are you?");
        const response=await instance.message();
        assert(response==="How are you?");
    })
})