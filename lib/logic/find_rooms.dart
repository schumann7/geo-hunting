import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List> findRooms() async {
  final response = await http.Client().get(
    Uri.parse(
      'http://ec2-15-228-201-167.sa-east-1.compute.amazonaws.com/find_rooms',
    ),
  );
  debugPrint(response.toString());

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data;
  }
  return ['Erro'];
}
