import 'package:flutter/material.dart';
import 'package:flutter_dapp/contract_linking.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class NftPage extends StatelessWidget {
  const NftPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final newNftTextController = TextEditingController();
    final nftProvider = Provider.of<ContractLinking>(context);
    return Scaffold(
        appBar: AppBar(title: const Text('Your NFTs')),
        body: nftProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: newNftTextController,
                          decoration: InputDecoration(
                            labelText: "Enter text",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextButton(
                            onPressed: () {
                              nftProvider
                                  .createNewToken(newNftTextController.text);
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.blue),
                            child: const Text(
                              "Upload",
                              style: TextStyle(color: Colors.white),
                            )),
                        const SizedBox(
                          height: 20.0,
                        ),
                        const Divider(
                          thickness: 2.0,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Text NFTs',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 20.0),
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        nftProvider.NFTList![0].isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: nftProvider.NFTList![0].length,
                                itemBuilder: (context, index) {
                                  final chainResponse =
                                      (nftProvider.NFTList![0][index]);
                                  final textContent = chainResponse.toString();
                                  return Card(
                                    color: Color((math.Random().nextDouble() *
                                                0xFFFFFF)
                                            .toInt())
                                        .withOpacity(0.5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(textContent),
                                    ),
                                  );
                                })
                            : const Center(
                                child: Text('No NFTs uploaded yet!')),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
