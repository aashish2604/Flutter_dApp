// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract CreateNFT{
    uint private _tokenId=0;
    mapping(uint=>string) private _tokenURIs;

    function createTokenUri(string memory _tokenUri)public returns(uint,string memory){
        _tokenURIs[_tokenId]=_tokenUri;
        _tokenId++;
        return(_tokenId,_tokenUri);
    }

    function getTokenUri(uint tId)public view returns(string memory){
        string memory _currentUri=_tokenURIs[tId];
        return _currentUri;
    }

    function getAllUri()public view returns(string[] memory){
        string[] memory uris= new string[](_tokenId);
        for(uint i=0;i<_tokenId;i++){
            uris[i]=_tokenURIs[i];
        }
        return uris;
    }
}