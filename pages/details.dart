import 'package:flutter/material.dart';
import 'package:firestore/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore/pages/home.dart';

class details extends StatefulWidget {
  final String id;

  const details(this.id, {super.key});

  @override
  State<details> createState() => _detailsState();
}

class _detailsState extends State<details> {
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController agecontroller = new TextEditingController();
  TextEditingController locationcontroller = new TextEditingController();

  Widget Details(){
    CollectionReference users = FirebaseFirestore.instance.collection('Employee');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          // return Text("Full Name: ${data['Name']} ${data['Location']}");
          return Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name : "+data["Name"],
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20.0, fontWeight: FontWeight.bold
                      ),
                    ),

                    Text(
                      "Age : "+data["Age"],
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 20.0, fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "Location : "+data["Location"],
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20.0, fontWeight: FontWeight.bold
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            namecontroller.text=data["Name"];
                            agecontroller.text=data["Age"];
                            locationcontroller.text=data["Location"];
                            EditEmployeeDetail(data["Id"]);
                          },
                          child:
                          Icon(Icons.edit, color: Colors.orange,),
                        ),
                        SizedBox(width: 5.0,),
                        GestureDetector(
                            onTap: () async{
                              await DatabaseMethods().deleteEmployeeDetail(data["Id"]);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => Home(),
                                ),
                                    (route) => false,
                              );
                            },
                            child: Icon(Icons.delete, color: Colors.orange,)
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          );
        }

        return Text("loading");
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Details",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(
              "Gas",
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: Column(
          children: [
            Expanded(child: Details())
          ],
        ),
      ),

    );
  }
  Future EditEmployeeDetail(String id)=> showDialog(context: context, builder: (context)=> AlertDialog(
    content: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.cancel),
              ),
              SizedBox(width: 60.0,),
              Text(
                "Edit",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                "Details",
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0,),
          Text(
            "Name",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10)
            ),
            child: TextField(
              controller: namecontroller,
              decoration: InputDecoration(border: InputBorder.none),
            ),
          ),
          SizedBox(height: 20.0,),
          Text(
            "Age",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10.0,),
          Container(
            padding: EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10)
            ),
            child: TextField(
              controller: agecontroller,
              decoration: InputDecoration(border: InputBorder.none),
            ),
          ),
          SizedBox(height: 20.0,),
          Text(
            "Location",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10.0,),
          Container(
            padding: EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10)
            ),
            child: TextField(
              controller: locationcontroller,
              decoration: InputDecoration(border: InputBorder.none),
            ),
          ),
          SizedBox(height: 30.0,),
          Center(child: ElevatedButton(onPressed: () async{
            Map<String, dynamic>updateInfo={
              "Name": namecontroller.text,
              "Age": agecontroller.text,
              "Id": id,
              "Location": locationcontroller.text,
            };
            await DatabaseMethods().updateEmployeeDetail(id, updateInfo).then((value){
              Navigator.pop(context);
              setState(() {});
            });
          }, child: Text("Update")))
        ],
      ),
    ),
  ));
}
