import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/client_item.dart';
import 'package:shop/models/client_list.dart';
import 'package:shop/utils/app_routes.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ClientList>(
      context,
      listen: false,
    ).loadClients();
  }

  @override
  Widget build(BuildContext context) {
    final ClientList clients = Provider.of(context);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Gerenciar Clientes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.CLIENT_FORM,
              );
            }, 
            icon: Icon(Icons.add)
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: clients.itemsCount,
            itemBuilder: (ctx, i) => Column(
              children: [
                ClientItem(clients.items[i]),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
