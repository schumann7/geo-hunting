import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List> findRooms() async {
  final response = await http.Client().get(
    Uri.parse(
      'http://ec2-54-233-31-163.sa-east-1.compute.amazonaws.com:5000/find_rooms',
    ),
  );
  debugPrint(response.toString());

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print(data);
    return data;
  } else {
    print('Erro: ${response.statusCode}');
  }
  return ['Erro'];
}
