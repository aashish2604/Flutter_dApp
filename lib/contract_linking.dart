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
  final String _rpcUrl = "http://192.168.1.4:7545";
  final String _wsUrl = "ws://192.168.1.4:7545";
  final String _privateKey =
      "7fd5b62cdd5b895a7a970673646118c4dc35a722c2ff3411e5e4f5def997ce56";

  Web3Client? _web3Client;

  bool isLoading = false;
  String? _abiCode;

  EthereumAddress? _contractAddress;
  Credentials? _credentials;

  DeployedContract? _contract;
  ContractFunction? _message;
  ContractFunction? _setMessage;

  String? deployedName;

  ContractLinking() {
    setup();
  }

  void setup() async {
    _web3Client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString('build/contracts/HelloWorld.json');
    final jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi['abi']);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi['networks']['5777']['address']);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getDeployedContract() async {
    final contractAbi = ContractAbi.fromJson(_abiCode!, "HelloWorld");
    _contract = DeployedContract(contractAbi, _contractAddress!);
    _message = _contract!.function("message");
    _setMessage = _contract!.function("setMessage");
    getMessage();
  }

  getMessage() async {
    final _myMessage = await _web3Client!
        .call(contract: _contract!, function: _message!, params: []);
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
            contract: _contract!,
            function: _setMessage!,
            parameters: [message]));
    getMessage();
  }
}
