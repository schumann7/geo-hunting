import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List> createRoom() async {
  final url = Uri.parse(
    'http://ec2-54-233-31-163.sa-east-1.compute.amazonaws.com:5000/create_room',
  );

  // JSON que será enviado
  final Map<String, dynamic> dados = {
    "nomedasala": "Rômulo",
    "latitude": "12213123",
    "longitude": "12213123",
    "privada": false,
  };

  final resposta = await http.post(
    url,
    headers: {"Content-Type": "application/json", "Accept": "application/json"},
    body: jsonEncode(dados),
  );

  print(resposta);

  if (resposta.statusCode == 200 || resposta.statusCode == 201) {
    print("Dados enviados com sucesso!");
    print("Resposta: ${resposta.body}");
  } else {
    print("Erro ao enviar dados: ${resposta.statusCode}");
    print("Mensagem: ${resposta.body}");
  }

  return [];
}









/*

{
  "nomedasala" : "<nome>",
  "latitude" : "12213123",
  "longitude" : "12213123",
  "privada" : boolean,
  "senha" : "ABCD"
}

*/