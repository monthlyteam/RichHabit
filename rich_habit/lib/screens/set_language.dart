import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:richhabit/constants.dart';

class SetLanguagePage extends StatefulWidget {
  @override
  _SetLanguagePageState createState() => _SetLanguagePageState();
}



class _SetLanguagePageState extends State<SetLanguagePage> {
  bool isAlarmOn =true;
  bool isSoundOn =true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPurpleColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppBar(
          centerTitle: true,
          backgroundColor: kPurpleColor,
          elevation: 0,
          leading: IconButton(
              padding: EdgeInsets.only(left: 20),
              icon: Icon(Icons.arrow_back_ios,color: kWhiteIvoryColor,size: 25,),
              onPressed: (){Navigator.of(context).pop();}
          ),
          title:Text("언어",style: TextStyle(color: kWhiteIvoryColor,fontSize: 20,fontWeight: FontWeight.bold),),
        ),
      ),
      body: Column(
        children: [
        ],
      ),
    );
  }
  _buildContents(IconData icon, String text, VoidCallback callback,index) {
    return Container(
      decoration: BoxDecoration(
          color: kIvoryColor,
          border: Border.symmetric(
              vertical:
              BorderSide(color: Colors.grey.withOpacity(0.1), width: 1))),
      height: 45,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [

        ],
      ),
    );
  }
}
