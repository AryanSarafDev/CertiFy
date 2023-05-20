import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/io.dart';

class CertificateVerificationController {
  BigInt cid = BigInt.one;
  final String _rpcUrl = "http://10.0.2.2:7545";
  final String _wsUrl = "http://10.2.2.2:7545";
  late final Web3Client _web3client;
  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  late EthPrivateKey _creds;
  late DeployedContract _deployedContract;
  late ContractFunction _addCertificate;
  late ContractFunction _revokeCertificate;
  late ContractFunction _verifyCertificate;
  late ContractFunction _getCertificates;
  late ContractFunction _owner;

  CertificateVerificationController() {}

  init() async {
    _web3client = Web3Client(
      _rpcUrl,
      Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );
    await getABI();
    await getCredentials();
    await getDeployedContract();
    cid = await _web3client.getChainId();

    print("ls: ${await owner()}");
  }

  final String _privatekey =
      '0x2706143bea7f0439b66e99eadbd884569b7352b8adc3b10ee2c1ad4dcde8000f';

  Future<void> getABI() async {
    String abiFile = await rootBundle.loadString(
        'lib/contracts/build/contracts/CertificateVerification.json');
    var jsonABI = jsonDecode(abiFile);
    _abiCode = ContractAbi.fromJson(
        jsonEncode(jsonABI['abi']), 'CertificateVerification');
    _contractAddress =
        EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _creds = EthPrivateKey.fromHex(_privatekey);
  }

  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    _addCertificate = _deployedContract.function('addCertificate');
    _getCertificates = _deployedContract.function('getCertificates');
    _revokeCertificate = _deployedContract.function('revokeCertificate');
    _verifyCertificate = _deployedContract.function('verifyCertificate');
    _owner = _deployedContract.function('owner');
  }

  addCertificate(String studentHash, String orgHash, String certHash) async {
    await _web3client.sendTransaction(
        _creds,
        Transaction.callContract(
          contract: _deployedContract,
          function: _addCertificate,
          parameters: [studentHash, orgHash, certHash],
        ),
        chainId: cid.toInt());
  }

  revokeCertificate(String studentHash, String orgHash, String certHash) async {
    await _web3client.sendTransaction(
        _creds,
        Transaction.callContract(
          contract: _deployedContract,
          function: _revokeCertificate,
          parameters: [studentHash, orgHash, certHash],
        ),
        chainId: cid.toInt());
  }

  verifyCertificate(String studentHash, String orgHash, String certHash) async {
    List cert = await _web3client.call(
        contract: _deployedContract,
        function: _verifyCertificate,
        params: [studentHash, orgHash, certHash]);
    return cert[0];
  }

  getCertificates(String studentHash, String orgHash, String certHash) async {
    await _web3client.sendTransaction(
        _creds,
        Transaction.callContract(
          contract: _deployedContract,
          function: _getCertificates,
          parameters: [studentHash, orgHash, certHash],
        ),
        chainId: cid.toInt());
  }

  owner() async {
    List owner = await _web3client
        .call(contract: _deployedContract, function: _owner, params: []);
    return owner[0];
  }
}
