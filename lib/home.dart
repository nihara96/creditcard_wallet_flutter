import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:soc_project/components/rounded_button.dart';
import 'package:soc_project/login.dart';
import 'package:soc_project/models/credit_card.dart';
import 'package:soc_project/models/credit_card_data.dart';
import 'package:soc_project/services/networking.dart';
import 'package:soc_project/utils/constants.dart';
import 'credit_cards_list.dart';


class HomeScreen extends StatefulWidget {

  final Map<String,dynamic> arguments;


  HomeScreen(this.arguments);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _networkHelper = NetworkHelper();

  // final Map<String,dynamic> sampleUser = {
  //   "username":"nihara",
  //   "email":"nihara@gmail.com",
  //   "password":"123456"
  // };

  Future<dynamic> getCards(Map<String,dynamic> params,BuildContext context) async {

    final uri = Uri.http(Service.MAIN_URL, "/api/v1/cards/user/");

    var data = await _networkHelper.postRequest(body:widget.arguments, uri: uri);

    // Build credit card and add to the list;
   // Provider.of<CreditCardData>(context,listen: false).clearCardList();

    for(Map map in data)
    {
      print(map['cardNumber']);

      Provider.of<CreditCardData>(context,listen: false).
      addCard(CreditCard(
          cardNumber: map['cardNumber'],
          cvv: map['cvv'],
          scheme: map['scheme'],
          bank: map['bank'],
          type: map['type'],
          branch: map['branch'],
          bankEmoji: map['bankEmoji']));

    }

    return data;

  }

  Future<dynamic> getCardData(String input) async {

    var data = await _networkHelper.getRequest(uri: Uri.https(Service.BINLIST_URL, "/$input"));

    print(data);
    return data;

  }

  Future assignUserToCard(Map<String,dynamic> params,String cardNumber) async{

    return _networkHelper.putRequest(body: params, uri: Uri.http(Service.MAIN_URL, "/api/v1/cards/$cardNumber/appUser/"));

  }

  Future addCardToNetwork( CreditCard creditCard) async {
    await _networkHelper.
    postRequest(body: {
      "cardNumber":creditCard.cardNumber,
      "cvv":creditCard.cvv,
      "scheme":creditCard.scheme,
      "type":creditCard.type,
      "bank":creditCard.bank,
      "bankEmoji":creditCard.bankEmoji,
      "branch":creditCard.branch
    }, uri: Uri.http(Service.MAIN_URL, "/api/v1/cards/"));

    await assignUserToCard(widget.arguments,creditCard.cardNumber);
  }

  @override
  Widget build(BuildContext context) {

    String _cardNumber="-",
        _cvv="-",_scheme="-",
        _bank="-",
        _bankEmoji="-",
        _type="-",
        _branch="-";

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: kPrimaryColor,
        onPressed: () async {
          final _formKey = GlobalKey<FormState>();
          showModalBottomSheet(
            isScrollControlled: true,
              context: context,
              builder: (BuildContext context){
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      height: 300.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Enter Card Number'),
                              TextFormField(
                                onChanged: (value){
                                  _cardNumber = value;
                                },
                                validator: (text)
                                {
                                  final value = text!.replaceAll(RegExp('\\s+'), '');

                                  if(value.isEmpty)
                                  {
                                  return "please enter the card number";
                                  }
                                  else if(value.length>16 || value.length <16)
                                  {
                                    return "invalid card number";
                                  }else if(!RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$').hasMatch(value))
                                  {
                                    return "should only have numbers";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20.0,),
                              Text('Enter CVV'),
                              TextFormField(
                                onChanged: (value){
                                  _cvv = value;
                                },
                                validator: (text){
                                  final value = text!.replaceAll(RegExp('\\s+'), '');

                                  if(!RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$').hasMatch(value))
                                  {
                                  return "should only have numbers";
                                  }

                                  return null;

                                },
                              ),
                              SizedBox(height: 10.0,),
                              Center(
                                child: RoundedButton(
                                    text: "ADD",
                                    onPressed: () async {
                                      if(_formKey.currentState!.validate()){
                                        var data = await getCardData(_cardNumber.substring(0,8));

                                        if(data!=null)
                                        {
                                          _scheme = data['scheme'];
                                          _bankEmoji = data['country']['emoji'];
                                          _type = data['type'];
                                          try{
                                            _bank = data['bank']['name'];
                                          }catch(e){

                                            await showDialog(
                                                context: context,
                                                builder: (context){
                                                  return AlertDialog(
                                                    title: Text('Enter Bank Name'),
                                                    content: TextField(
                                                      onChanged: (value)
                                                      {
                                                        _bank = value;

                                                      },
                                                    ),
                                                    actions: [
                                                      RoundedButton(
                                                          text: "OK",
                                                          onPressed: (){
                                                            if(_bank.isEmpty){_bank="-";}
                                                            Navigator.of(context, rootNavigator: true).pop();
                                                          })
                                                    ],
                                                  );
                                                }
                                            );

                                            setState(() {

                                            });

                                          }

                                          await addCardToNetwork(CreditCard(
                                              cardNumber: _cardNumber,
                                              cvv: _cvv,
                                              scheme: _scheme,
                                              bank: _bank,
                                              type: _type,
                                              branch: _branch,
                                              bankEmoji: _bankEmoji));
                                          Navigator.pop(context);
                                        }

                                      }
                                      setState(() {

                                      });
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('CreditCard Wallet'),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    LoginScreen()), (Route<dynamic> route) => false);
              },
              icon: Icon(IconData(0xe3b3, fontFamily: 'MaterialIcons')))
        ],
      ),
      body: Container(
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: FutureBuilder(
           future: getCards(widget.arguments,context),
           builder: (BuildContext context,AsyncSnapshot snapshot){

             if(snapshot.hasData){

               return CreditCardList();
             }else if(snapshot.hasError)
             {
            return Text('No data found');
             }
             else{
               return Center(
                 child: SpinKitRotatingCircle(
                   color: kPrimaryColor,
                   size: 50.0,
                 ),
               );
             }
           },
         ),
       ),
      ),
    );
  }
}

