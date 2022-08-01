import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dapp/contract_linking.dart';
import 'package:provider/provider.dart';

class HelloPage extends StatelessWidget {
  const HelloPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageController = TextEditingController();
    final contractProvider = Provider.of<ContractLinking>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter dApp")),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: contractProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Form(
                    child: Column(
                  children: [
                    Text(
                      'Welcome to dApp "${contractProvider.deployedName}"',
                      style:
                          const TextStyle(fontSize: 20.0, color: Colors.orange),
                    ),
                    TextFormField(
                      controller: messageController,
                      decoration:
                          const InputDecoration(labelText: "Enter Message"),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          contractProvider.setMessage(messageController.text);
                          messageController.clear();
                        },
                        child: const Text("Set Message"))
                  ],
                )),
              ),
      ),
    );
  }
}
