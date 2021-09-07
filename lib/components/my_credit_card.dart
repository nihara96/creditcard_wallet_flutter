import 'package:flutter/material.dart';

class MyCreditCard extends StatelessWidget {

  final String cardNumber,cvv,scheme,type,bank,bankEmoji,branch;


  MyCreditCard({required this.cardNumber,
    required this.cvv, required this.scheme,
    required this.type, required this.bank,
    required this.bankEmoji, required this.branch});


  @override
  Widget build(BuildContext context) {

    final formattedNumber = cardNumber
        .replaceAllMapped(RegExp(r".{4}"),
            (match) => "${match.group(0)} ");


    return Card(
      elevation: 5.0,
      child: Container(
          height: 240.0,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Card Number'),
                    Text(formattedNumber,style: TextStyle(
                      fontSize: 20.0,
                    ),),
                  ],
                ),
                SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('SCHEME/NETWORK'),
                              Text(scheme,style: TextStyle(
                                fontSize: 20.0,
                              ),),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('TYPE'),
                              Text(type,style: TextStyle(
                                fontSize: 20.0,
                              ),),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 60.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('CVV'),
                              Text(cvv,style: TextStyle(
                                fontSize: 20.0,
                              ),),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.0,),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('EXP'),
                              Text(branch,style: TextStyle(
                                fontSize: 20.0,
                              ),),
                            ],
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
                SizedBox(height: 20.0,),
                Row(
                  children: [
                    Text('BANK'),
                    SizedBox(width: 2.0,),
                    Text(bankEmoji),
                  ],
                ),
                Text(bank,style: TextStyle(fontSize: 20.0),),
              ],
            ),
          )

      ),
    );
  }
}
