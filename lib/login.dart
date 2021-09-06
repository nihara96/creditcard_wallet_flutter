import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:soc_project/services/networking.dart';
import 'package:soc_project/utils/constants.dart';

import 'components/rounded_button.dart';
import 'components/rounded_input_field.dart';
import 'components/rounded_password_field.dart';
import 'home.dart';

class LoginScreen extends StatelessWidget {

  final _networkHelper = NetworkHelper();
  final _formKey = GlobalKey<FormState>();

  Future loginTask(Map body) async
  {
    var response = await _networkHelper
        .postRequest(body: body, uri: Uri.http(Service.MAIN_URL, "api/v1/user/login/"));

    return response;
  }

  @override
  Widget build(BuildContext context) {

     String _username="",_password="";

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
                    if(value == null || value.isEmpty)
                    {
                      return "Please enter username";
                    }
                    return null;
                  },
                  hintText: "Username",
                  onChanged: (value) {
                    _username = value;
                  },
                ),
                RoundedPasswordField(
                  validator: (value)
                  {
                    if(value == null || value.isEmpty)
                    {
                      return "Please enter password";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _password = value;
                  },
                ),
                RoundedButton(
                  text: "LOGIN",
                  onPressed: () async {

                    if(_formKey.currentState!.validate())
                    {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          content: FutureBuilder(
                            future: loginTask({
                              "username": _username,
                              "password":_password,
                            }),
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
                                    Text('Login Successful'),
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
                                  Text('Please wait...'),
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
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('dont have an account ?'),
                    SizedBox(width: 5,),
                    GestureDetector(
                        child: Text('Create'),
                      onTap: (){
                          Navigator.pushNamed(context, PageId.signup);
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
