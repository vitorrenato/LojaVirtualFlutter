import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/models/client_list.dart';

class ClientFormPage extends StatefulWidget {
  const ClientFormPage({Key? key}) : super(key: key);

  @override
  _ClientFormPageState createState() => _ClientFormPageState();
}

class _ClientFormPageState extends State<ClientFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  bool _isLoading = false;

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && endsWithFile;
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<ClientList>(
        context,
        listen: false,
      ).saveClients(_formData);

      Navigator.of(context).pop();
    } catch(error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro!'),
          content: Text('Ocorreu um erro para salvar o cliente.'),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(), 
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Cliente'),
        actions: [
          IconButton(
            onPressed: _submitForm, 
            icon: Icon(Icons.save)
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              TextFormField(
                initialValue: _formData["name"]?.toString(),
                decoration: InputDecoration(labelText: 'Nome'),
                textInputAction: TextInputAction.next,
                onSaved: (name) => _formData['name'] = name ?? '',
                validator: (_name) {
                  final name = _name ?? '';

                  if (name.trim().isEmpty) {
                    return "Nome é obrigatório";
                  }
                  if (name.trim().length < 3) {
                    return "Nome precisa no mínimo de 3 letras";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _formData["email"]?.toString(),
                decoration: InputDecoration(labelText: 'E-mail'),
                textInputAction: TextInputAction.next,
                onSaved: (email) => _formData['email'] = email ?? '',
                validator: (_email) {
                  final email = _email ?? '';

                  if (email.trim().isEmpty) {
                    return "E-mail é obrigatório";
                  }
                  if (email.trim().length < 3) {
                    return "E-mail precise no mínimo de 3 letras";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _formData["imageUrl"]?.toString(),
                decoration: InputDecoration(labelText: 'URL da foto'),
                textInputAction: TextInputAction.done,
                onSaved: (imageUrl) => _formData['imageUrl'] = imageUrl ?? '',
                validator: (_imageUrl) {
                  final imageUrl = _imageUrl ?? '';

                  if (!isValidImageUrl(imageUrl)) {
                    return "Informe uma URL válida";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
