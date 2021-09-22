import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:soc_project/screens/home.dart';
import 'package:soc_project/services/networking.dart';
import 'package:soc_project/utils/constants.dart';

import '../components/rounded_button.dart';
import '../components/rounded_input_field.dart';
import '../components/rounded_password_field.dart';
import 'login.dart';

class SignUpScreen extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();

  final _networkHelper = NetworkHelper();

  late String  _username,_email,_password;
  
  Future registerUser() async {

    Map<String,String> register = {
      "username":_username,
      "email":_email,
      "password":_password
    };

    print(register);
    
    return _networkHelper.postRequest(body: register, uri: Uri.http(Service.MAIN_URL, "/api/v1/user"));
    
  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Container(
        child: Center(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundedInputField(
                  validator: (value)
                  {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    }
                    return null;
                  },
                  hintText: "Username",
                  onChanged: (value) {
                    _username = value;
                  },
                ),
                RoundedInputField(
                  validator: (value)
                  {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                  hintText: "Your Email",
                  onChanged: (value) {
                    _email=value;
                  },
                ),
                RoundedPasswordField(
                  validator: (value)
                  {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _password=value;
                  },
                ),
                RoundedButton(
                  text: "SIGNUP",
                  onPressed: () async{
                    if(_formKey.currentState!.validate()){
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          content: FutureBuilder(
                            future: registerUser(),
                            builder: (BuildContext context,AsyncSnapshot snapshot){
                              List<Widget> children;
                              if(snapshot.hasData){

                                if(snapshot.data['status'] == 500)
                                {
                                  children = <Widget>[
                                    Text(snapshot.data['message']),
                                  ];
                                }else{
                                  children = <Widget>[
                                    Text('Registered Successful'),
                                  ];

                                  Future.delayed(Duration(milliseconds: 100), () {
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                        HomeScreen(snapshot.data)), (Route<dynamic> route) => false);
                                  });

                                }

                              }
                              else{
                                children = <Widget>[
                                  SpinKitRotatingCircle(
                                    color: kPrimaryColor,
                                    size: 50.0,
                                  ),
                                  SizedBox(height: 5.0,),
                                  Text('Registering...'),
                                ];
                              }
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: children,
                              );
                            },
                          ),

                        ),
                      );

                    }

                  // var response = await registerUser();
                  // print(response);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('already have an account ?'),
                    SizedBox(width: 5,),
                    GestureDetector(
                      child: Text('Login'),
                      onTap: (){
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            LoginScreen()), (Route<dynamic> route) => false);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
