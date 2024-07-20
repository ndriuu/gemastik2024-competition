import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore/pages/employee.dart';
import 'package:firestore/pages/details.dart';
import 'package:firestore/service/database.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? EmployeeStream;

  getontheload() async{
    EmployeeStream= await DatabaseMethods().getEmployeeDetails();
    setState(() {

    });
  }

  @override
  void initState(){
    getontheload();
    super.initState();
  }


  Widget allEmployeeDetails(){
    return StreamBuilder(
        stream: EmployeeStream,
        builder: (context, AsyncSnapshot snapshot){
          return snapshot.hasData
              ? ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index){
                DocumentSnapshot ds=snapshot.data.docs[index];
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
                          Row(
                            children: [
                              Text(
                                "Name : "+ds["Name"],
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20.0, fontWeight: FontWeight.bold
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: (){
                                  details(ds["Id"]);
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>details(ds["Id"])));
                                },
                                  child:
                                  Icon(Icons.arrow_forward_ios, color: Colors.orange,),
                              ),
                            ],
                          ),
                          Text(
                            "Age : "+ds["Age"],
                            style: TextStyle(
                                color: Colors.orange,
                                fontSize: 20.0, fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            "Location : "+ds["Location"],
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20.0, fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })
              : Container();
    });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Employee()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Flutter",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24.0,
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              "Firebase",
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
            Expanded(child: allEmployeeDetails()),
          ],
        ),
      ),
    );
  }
}
