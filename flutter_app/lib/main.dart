import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(new MaterialApp(
  title: "Currency Converter",
  home: CurrencyConverter(),
));

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final fromTextController = TextEditingController();
  List<String> currencies=new List();
  String fromCurrency = "EUR";
  // var toCurrency = [ "SPGP"] ;
  String toCurrency = 'CHF';

  List<String> convertedlist=new List();


  String result;

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }



  Future<String> _loadCurrencies() async {
    String uri = "https://api.exchangeratesapi.io/latest";
    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    Map curMap = responseBody['rates'];
    currencies = curMap.keys.toList();
    setState(() {});
    print(currencies);
    return "Success";
  }

  Future<String> _doConversion() async {

    if(currencies.length>0)
    {
      for(int i=0;i<currencies.length;i++)
      {

        Future.delayed(const Duration(milliseconds: 500), () async{

          var tmp=  currencies[i];
          print(tmp+ "abc");
          String uri =
              "https://api.exchangeratesapi.io/latest?base=$fromCurrency&symbols=$tmp";
          var response = await http
              .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
          var responseBody = json.decode(response.body);
          setState(() {
            result = (double.parse(fromTextController.text) *
                (responseBody["rates"][tmp]))
                .toString();


          });
          //   print(result);

          convertedlist.add(result);
          setState(() {

          });

          print(convertedlist);
        });

      }

    }


    return "Success";
  }

  _handleRefresh()  {
    result = " ";

  }


  _onFromChanged(String value) {
    setState(() {
      fromCurrency = value;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                'Currency Converter',style: new TextStyle(
              fontSize: 25.0,)
            ),
            Visibility(
              visible: true,
              child: Text(
                _getDate(),
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child:
            new IconButton(icon: new Icon(Icons.refresh), onPressed:() {



            }),

          ),

        ],
      ),
      /* appBar: AppBar(
        title:  Text(_getDate(), style: new TextStyle(
    fontSize: 15.0,),


      ),),*/
      body: currencies == null
          ? Center(child: CircularProgressIndicator())
          : Container(
        height: MediaQuery.of(context).size.height ,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(

            elevation: 3.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ListTile(
                  title: TextField(
                    controller: fromTextController,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                    keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                  ),
                  trailing: Text(fromCurrency),
                ),
                FlatButton(
                  color: Colors.teal,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.transparent,
                  onPressed: () {
                    _doConversion();
                  },
                  child: Text(
                    "Convert",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),


                convertedlist.length>0? new ListView.builder
                  (
                    itemCount: convertedlist.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Row(
                        children: <Widget>[
                          Text(
                              currencies[index]
                          ),
                          Text(
                              ":="
                          ),
                          Text(
                              convertedlist[index]
                          )
                        ],
                      );
                      //  return new Text(convertedlist[index]);

                    }
                ):Text(
                    " "
                )


                /*   ListTile(
                          title: Chip(
                            label: result != null
                                ? Text(
                                    result,
                                    style: Theme.of(context).textTheme.display1,
                                  )
                                : Text(" "),
                          ),
                          trailing:

                              Text("$toCurrency")

                      ),*/

              ],
            ),
          ),
        ),
      ),
    )   ;
  }




  String _getDate() {
    DateTime now = new DateTime.now();
    var dateFormatter = new DateFormat('MMMM dd, yyyy');

    return dateFormatter.format(now);
  }

  void _refresh() {
    super.dispose();
    _doConversion(
    );

  }


}

