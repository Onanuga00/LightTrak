import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:train_app/authentication/auth.dart';
import 'package:train_app/models/model_dao.dart';
import 'package:train_app/models/users.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({Key? key}) : super(key: key);
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
              ))
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.85,
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Create Account",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Color(0xff03314B)),
                  ),
                  const AuthFormSignUp(),
                  const Divider(
                    color: Colors.white,
                  ),
                  const Text('Or'),
                  const Divider(
                    color: Colors.white,
                  ),
                  TextButton(
                      onPressed: () {
                        ref.read(authenticationProvider).googleSignIn(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 40),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xff1CBF8E), width: 2.0),
                            borderRadius: BorderRadius.circular(15)),
                        child: const Text(
                          'Continue with Google',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthFormSignUp extends ConsumerStatefulWidget {
  const AuthFormSignUp({Key? key}) : super(key: key);

  @override
  AuthFormSignUpState createState() => AuthFormSignUpState();
}

class AuthFormSignUpState extends ConsumerState<AuthFormSignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              // First Name form Field

              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please add First Name';
                  }
                  return null;
                },
                controller: firstNameController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(12)),
                  hintText: 'First Name',
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              // Last Name Controller
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please add Last Name';
                  }
                  return null;
                },
                controller: lastNameController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(12)),
                  hintText: 'Last Name',
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Email Text Field
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is Required';
                  }
                  return null;
                },
                controller: emailController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(12)),
                  hintText: 'Email',
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //Password text form field
              TextFormField(
                obscureText: true,
                validator: (value) {
                  if (value!.length < 6) {
                    return 'Password must be minimun 6 characters';
                  }
                  return null;
                },
                controller: passwordController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(12)),
                  hintText: 'Password',
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // confirm Password Field
              TextFormField(
                obscureText: true,
                validator: (value) {
                  if (value!.trim() != passwordController.text.trim()) {
                    return 'No match. Please Check';
                  }
                  return null;
                },
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(12)),
                  hintText: 'Confirm Password',
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        context.go(
                            '/login'); //Go back to login page if you already have account
                      },
                      child: const Text('Sign In')),
                ],
              ),
              TextButton(
                  onPressed: () {
                    String email = emailController.text;
                    String password = passwordController.text;
                    String firstName = firstNameController.text.trim();
                    String lastName = lastNameController.text.trim();
                    if (_formKey.currentState!.validate()) {
                      ref
                          .read(authenticationProvider)
                          .createUserWithEmailAndPassword(
                              email, password, context)
                          .then((value) {
                        String id = ref
                            .read(authenticationProvider)
                            .currentUser!
                            .uid; //id of the current user
                        //Adding the created User to the database after creating account
                        ref.read(daoProvider).addUser(TrainUser(
                              firstName: firstName,
                              lastName: lastName,
                              email: email,
                              id: id,
                            ));
                        return null;
                      });
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 60),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2.0),
                        color: const Color(0xff1CBF8E),
                        borderRadius: BorderRadius.circular(15)),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ))
            ],
          )),
    );
  }
}
