import 'package:flutter/material.dart';

//A function to show an alert dialogue to display login error messages
//showDialog is flutter inbuilt method that requires  a BuildContext to
//produce a dialogue with a title and content then uses the context to
// perform some actions such as pop the dialogue when it is clicked

class ShowDialogue{


   Future<String> alert( BuildContext ctx, String error) async => await showDialog(
       context: ctx,
       builder: (dialogContext)=>AlertDialog(
         title: const Text('Oops Error', style: TextStyle(fontSize: 20, color: Colors.redAccent, fontWeight: FontWeight.bold),),
         content:  Text(error,style:const TextStyle(fontSize:13, color: Colors.black ),),
         actions: [
           TextButton(onPressed: (){Navigator.pop(dialogContext); }, child:const Text('OK', style: TextStyle(fontSize:15, fontWeight: FontWeight.bold, color: Colors.blue ),) )
         ],
       )
   );
}
