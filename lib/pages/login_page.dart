import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../authentication/auth.dart';

class LoginPage extends ConsumerWidget {

  const LoginPage({Key? key}) : super(key: key);
  // final  emailController = TextEditingController();
  // final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        // fit: StackFit.loose,
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: const Color(0xff03314B),

                ),
              ),
              Expanded(
                  child: Container(
                    color: const Color(0xff1CBF8E),
                  )
              )
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.6,
            width: MediaQuery.of(context).size.width*0.85,
            padding: const EdgeInsets.symmetric(vertical:30,horizontal:15 ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15)
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                  const Text("Login", style:TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color:Color(0xff03314B) ) ,),
                  const  AuthForm(),
                  const Divider(color: Colors.white,),
                  const Text('Or'),
                  const Divider(color: Colors.white,),
                  TextButton(
                      onPressed: (){
                        ref.read(authenticationProvider).googleSignIn(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xff1CBF8E), width: 2.0),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: const Text('Continue with Google',style:TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18) ,),
                      )
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


class AuthForm extends ConsumerStatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  AuthFormState createState() => AuthFormState();
}

class AuthFormState extends ConsumerState<AuthForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:20.0),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Valid Email',
                ) ,
                validator: (email){
                  if (email==null||email.isEmpty){
                    return 'Email is Required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18,),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    labelText: '6 character Password',
                    labelStyle: TextStyle()
                ) ,
                validator: (password){
                  if(password.toString().length<6){
                    return 'Minimum 6 characters Required';
                  }
                  return null;
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed:(){context.go('/signup');}, child:const Text('Create account') ),
                  TextButton(onPressed: (){}, child:const Text('Forgot Password?') ),
                ],
              ),

              // const Divider(color: Colors.white),

              TextButton(
                  onPressed: (){

                    String email = emailController.text;
                    String password = passwordController.text;
                    ref.read(authenticationProvider).signInWithEmailAndPassword(email, password, context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 60),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2.0),
                        color:const Color(0xff1CBF8E) ,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: const Text('Login',style:TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18) ,),
                  )
              )
            ],
          )
      ),
    );
  }
}
