import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/client.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';

class ClientList with ChangeNotifier {
  List<Client> _items = [];

  List<Client> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  Client byIndex(int i) {
    return _items.elementAt(i);
  }

  Future<void> loadClients() async {
    _items.clear();

    final response = await http.get(
      Uri.parse('${Constants.CLIENT_BASE_URL}.json'),
    );
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((clientId, clientData) {
      _items.add(Client(
        id: clientId,
        name: clientData['name'],
        email: clientData['email'],
        avatarUrl: clientData['imageUrl'],
      ));
    });
    notifyListeners();
  }

  Future<void> saveClients(Map<String, dynamic> data) async {
    bool hasId = data['id'] != null;

    final client = Client(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      email: data['email'] as String,
      avatarUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateClients(client);
    } else {
      return addClients(client);
    } 
  }

  Future<void> addClients(Client client) async {
    final response = await http.post(
      Uri.parse('${Constants.CLIENT_BASE_URL}.json'),
      body: jsonEncode({
        "name": client.name,
        "email": client.email,
        "imageUrl": client.avatarUrl,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(Client(
      id: id,
      name: client.name,
      email: client.email,
      avatarUrl: client.avatarUrl,
    ));
    notifyListeners();
  }

  Future<void> updateClients(Client client) async {
    int index = _items.indexWhere((p) => p.id == client.id);

    if (index >= 0) {
      await http.patch(
          Uri.parse('${Constants.CLIENT_BASE_URL}/${client.id}.json'),
          body: jsonEncode({
            "name": client.name,
            "email": client.email,
            "imageUrl": client.avatarUrl,
          }));
      _items[index] = client;
      notifyListeners();
    }
  }

  Future<void> removeClients(Client client) async {
    int index = _items.indexWhere((p) => p.id == client.id);

    if (index >= 0) {
      final client = _items[index];
      _items.remove(client);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${Constants.CLIENT_BASE_URL}/${client.id}.json'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, client);
        notifyListeners();
        throw HttpException(
            msg: 'Não foi possível excluir o cliente.',
            statusCode: response.statusCode);
      }
    }
  }
}
