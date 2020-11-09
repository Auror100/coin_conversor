import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Library para pegar metodos http
import 'dart:async';
import 'dart:convert';
const request ="https://api.hgbrasil.com/finance?format=json&key=69b3dfd2"; // requisitando  a api


void main() async{ // Assincrono


  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(
          hintColor: Colors.green,
          primaryColor: Colors.red,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
            hintStyle: TextStyle(color: Colors.red),
          ))

  )

  );
}

Future<Map> getData() async{
  http.Response response = await http.get(request); // solicitando ao servidor
  return jsonDecode(response.body);
}



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController= TextEditingController();
  final dolarController= TextEditingController();
  final euroController= TextEditingController();
  final bitcoinController= TextEditingController();
  double dolar;
  double euro;
  double bitcoin;
  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    bitcoinController.text= "";
  }

  void _realChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
      double real = double.parse(text);
      dolarController.text= (real/dolar).toStringAsFixed(2);
      euroController.text= (real/euro).toStringAsFixed(2);
      bitcoinController.text= (real/bitcoin).toStringAsFixed(10);

  }

  void _dolarChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);

    realController.text=(dolar*this.dolar).toStringAsFixed(2);
    euroController.text= (dolar * this.dolar / euro).toStringAsFixed(2);
    bitcoinController.text= (dolar * this.dolar / bitcoin).toStringAsFixed(10);
  }

  void _euroChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text=(euro * this.euro).toStringAsFixed(2);
    dolarController.text= (euro * this.euro / dolar).toStringAsFixed(2);
    bitcoinController.text= (euro * this.euro / bitcoin).toStringAsFixed(10);

  }


  void _bitcoinChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double bitcoin = double.parse(text);
    realController.text=(bitcoin * this.bitcoin).toStringAsFixed(2);
    dolarController.text= (bitcoin* this.bitcoin / dolar).toStringAsFixed(2);
    bitcoinController.text= (bitcoin* this.bitcoin/euro).toStringAsFixed(10);

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"), // Deixa de interpretar cifrão como variável
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),




        body: FutureBuilder<Map>(
            future: getData(),

            builder: (context, snapshot){
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:


                  return Center(
                      child: Text("Carregando dados", style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0),
                        textAlign: TextAlign.center,)
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text("Erro :c", style: TextStyle(
                            color: Colors.amber,
                            fontSize: 25.0),
                          textAlign: TextAlign.center,)
                    );
                  } else {
                    dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    bitcoin = snapshot.data["results"]["currencies"]["BTC"]["buy"];
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0) ,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[

                          Icon(Icons.monetization_on,size: 150.0,color: Colors.amber),
                          buildTextField("Reais","R\$",realController, _realChanged),
                          Divider(),
                          buildTextField("Dólares","US\$",dolarController, _dolarChanged),
                          Divider(),
                          buildTextField("Euros","EUR\$",euroController, _euroChanged),
                          Divider(),
                          buildTextField("Bitcoins","BTC\$",bitcoinController, _bitcoinChanged),

                        ],
                      ) ,
                    );

                  }
              }
            }
        )
    );
  }
}

Widget buildTextField(String  label, String prefix, TextEditingController c, Function f){
  return  TextField(
    controller: c,
  decoration: InputDecoration(
  labelText: label,
labelStyle: TextStyle(color:Colors.amber),
border: OutlineInputBorder(),
prefixText: prefix
) ,
style: TextStyle(
color:Colors.amber, fontSize: 25.0
),
    onChanged: f,
    keyboardType: TextInputType.number,
);
}


