import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/client_item.dart';
// import 'package:shop/data/dummy_users.dart';
import 'package:shop/models/client_list.dart';
import 'package:shop/utils/app_routes.dart';

class ClientOverviewPage extends StatefulWidget {
  const ClientOverviewPage({Key? key}) : super(key: key);

  @override
  _ClientOverviewPageState createState() => _ClientOverviewPageState();
}

class _ClientOverviewPageState extends State<ClientOverviewPage> {
  @override
  Widget build(BuildContext context) {
    final ClientList clients = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de clientes'),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.CLIENT_FORM,
            );
          }, 
          icon: Icon(Icons.add)),
        ],
      ),
      body: ListView.builder(
        itemCount: clients.itemsCount,
        itemBuilder: (ctx, i) => ClientItem(clients.byIndex(i)),
      ),
    );
  }
}
