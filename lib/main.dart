import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soc_project/screens/home.dart';
import 'package:soc_project/screens/login.dart';
import 'package:soc_project/models/credit_card_data.dart';
import 'package:soc_project/screens/signup.dart';
import 'package:soc_project/utils/constants.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context)=> CreditCardData(),
      child:  MaterialApp(
        initialRoute: PageId.login,

        routes: {
          PageId.homeScreen : (context)=>HomeScreen({}),
          PageId.login : (context)=>LoginScreen(),
          PageId.signup : (context)=>SignUpScreen(),
        },
      ),
    );
  }
}
