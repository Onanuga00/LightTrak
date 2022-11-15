import 'package:cloud_firestore/cloud_firestore.dart';

class Train {
  final String? id;
  final String? name;
  final String? code;


  Train({
    this.code,
    this.name,
    this.id,
  });

  factory Train.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options,
      ){
    final data = snapshot.data();
    return Train(
        id: data?['id'],
        name: data?['name'],
        code: data?['code']
    );
  }

  Map<String,dynamic> toFireStore(){
    return {

      if (id!=null) "id":id,
      if (name!=null) "name":name,
      if (code!=null) "code":code,
    };
  }
}
