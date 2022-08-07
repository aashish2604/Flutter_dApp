import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

///Here we not using the port for the localhost to connect ganache because it causes connection error
///The LocalHost port(127.0.0.1) is already being used by the android emulator
///The privateKey changes everytime ganache restarts. So update it whenever u refresh ganache.

class ContractLinking extends ChangeNotifier {
  final String _rpcUrl = "http://10.10.120.156:7545";
  final String _wsUrl = "ws://10.10.120.156:7545";
  final String _privateKey =
      "9aefd412adb70c6ca4ae0a9aa5ea31c9c7acff34c3140846aae0ef763c614169";

  Web3Client? _web3Client;

  bool isLoading = false;
  String? _abiCode;

  EthereumAddress? _contractAddress;
  Credentials? _credentials;

  DeployedContract? _helloWorldContract;
  ContractFunction? _message;
  ContractFunction? _setMessage;

  DeployedContract? _NFTContract;
  ContractFunction? _createTokenUri;
  ContractFunction? _getTokenUri;
  ContractFunction? _getAllUri;

  String? deployedName;

  List? NFTList;

  ContractLinking() {
    setup();
  }

  void setup() async {
    _web3Client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getCredentials();
    await getNFTContract();
  }

  Future<void> getAbi() async {
    isLoading = true;
    notifyListeners();
    String abiStringFile =
        await rootBundle.loadString('build/contracts/CreateNFT.json');
    final jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi['abi']);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi['networks']['5777']['address']);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getHelloWorldContract() async {
    final contractAbi = ContractAbi.fromJson(_abiCode!, "HelloWorld");
    _helloWorldContract = DeployedContract(contractAbi, _contractAddress!);
    _message = _helloWorldContract!.function("message");
    _setMessage = _helloWorldContract!.function("setMessage");
    getMessage();
  }

  getMessage() async {
    final _myMessage = await _web3Client!
        .call(contract: _helloWorldContract!, function: _message!, params: []);
    deployedName = _myMessage[0];
    isLoading = false;
    notifyListeners();
  }

  setMessage(String message) async {
    isLoading = true;
    notifyListeners();
    await _web3Client!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _helloWorldContract!,
            function: _setMessage!,
            parameters: [message]));
    getMessage();
  }

  Future<void> getNFTContract() async {
    final contractAbi = ContractAbi.fromJson(_abiCode!, "CreateNFT");
    _NFTContract = DeployedContract(contractAbi, _contractAddress!);
    _createTokenUri = _NFTContract!.function("createTokenUri");
    _getTokenUri = _NFTContract!.function("getTokenUri");
    _getAllUri = _NFTContract!.function("getAllUri");
    getAllNfts();
  }

  getAllNfts() async {
    final response = await _web3Client!
        .call(contract: _NFTContract!, function: _getAllUri!, params: []);
    NFTList = response;
    isLoading = false;
    notifyListeners();
  }

  createNewToken([String tokenId = 'Something_']) async {
    isLoading = true;
    notifyListeners();
    await _web3Client!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _NFTContract!,
            function: _createTokenUri!,
            parameters: [tokenId]));
    getAllNfts();
  }
}
