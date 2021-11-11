import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:soc_project/components/rounded_button.dart';
import 'package:soc_project/login.dart';
import 'package:soc_project/models/credit_card.dart';
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
                      color: Color(0xFF737373),
                      child: Container(
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(10.0),
                                topRight: const Radius.circular(10.0))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Enter Card Number'),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 17),
                                    hintText: 'xxxx xxxx xxxx xxxx',
                                    contentPadding: EdgeInsets.all(20),
                                  ),
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
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 17),
                                    hintText: 'xxx',
                                    contentPadding: EdgeInsets.all(20),
                                  ),
                                  onChanged: (value){
                                    _cvv = value;
                                  },
                                  validator: (text){
                                    final value = text!.replaceAll(RegExp('\\s+'), '');

                                    if(value.isEmpty)
                                    {
                                      return "please enter the cvv number";
                                    }
                                    else if(!RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$').hasMatch(value))
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
                                          var data = await _networkHelper.getCardData(_cardNumber.substring(0,8));

                                          if(data!=null)
                                          {
                                            _scheme = data['scheme'];
                                            _bankEmoji = data['country']['emoji'];
                                            _type = data['type'];
                                            try{
                                              _bank = data['bank']['name'];
                                            }catch(e){
                                              setState(() {

                                              });

                                            }

                                            await _networkHelper.addCardToNetwork(widget.arguments,CreditCard(
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
                  ),
                );
              }
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('CreditCard Wallet'),
        //TODO: Implement sign out
      ),
      body: Container(
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: FutureBuilder(
           future: _networkHelper.getCards(widget.arguments,context),
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

