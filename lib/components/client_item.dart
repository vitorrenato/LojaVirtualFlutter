import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/client.dart';
import 'package:shop/models/client_list.dart';
import 'package:shop/utils/app_routes.dart';

class ClientItem extends StatelessWidget {
  final Client client;

  const ClientItem(
    this.client, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    final avatar = client.avatarUrl == 'null' || client.avatarUrl.isEmpty
        ? CircleAvatar(
            child: Icon(Icons.person),
          )
        : CircleAvatar(backgroundImage: NetworkImage(client.avatarUrl));

    return ListTile(
      leading: avatar,
      title: Text(client.name),
      subtitle: Text(client.email),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.edit_outlined),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.CLIENT_FORM,
                    arguments: client,
                  );
                }),
            IconButton(
                icon: Icon(Icons.delete_outlined),
                onPressed: () {
                  showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text('Excluir cliente'),
                            content: Text('Tem certeza?'),
                            actions: [
                              TextButton(
                                  child: Text('Não'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop(false);
                                  }),
                              TextButton(
                                  child: Text('Sim'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop(true);
                                  }),
                            ],
                          )).then((value) async {
                    if (value ?? false) {
                      try {
                        await Provider.of<ClientList>(
                          context,
                          listen: false,
                        ).removeClients(client);
                      } on HttpException catch (error) {
                        msg.showSnackBar(
                          SnackBar(
                            content: Text(error.toString()),
                          ),
                        );
                      }
                    }
                  });
                }),
          ],
        ),
      ),
    );
  }
}
