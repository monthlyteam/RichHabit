//import 'package:flutter/material.dart';
//
//class BottomPositionedBox extends StatelessWidget{
//
//  @override
//  Widget build(BuildContext context) {
//    return Positioned(
//      bottom: 0,
//      left: 0,
//      child: GestureDetector(
//        onTap: () {
//          if(icons_selected.indexOf(true) == -1){
//            Fluttertoast.showToast(
//                msg: "최소 한개를 선택해주세요!",
//                toastLength: Toast.LENGTH_SHORT,
//                gravity: ToastGravity.CENTER,
//                timeInSecForIosWeb: 1,
//                backgroundColor: Colors.grey,
//                textColor: Colors.white,
//                fontSize: 16.0
//            );
//          }else{
//            Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => InitNext(selectedItem: _selectedListGenerator(icons_selected),)));
//          }
//        },
//        child: Container(
//          decoration:BoxDecoration(
//            color: kPurpleColor,
//            borderRadius: BorderRadius.vertical(top: Radius.circular(19)),
//            boxShadow: [
//              BoxShadow(
//                color: Colors.grey.withOpacity(0.5),
//                spreadRadius: 5,
//                blurRadius: 7,
//                offset: Offset(0, 3), // changes position of shadow
//              ),
//            ],
//          ),
//          width: size.width,
//          height: 80,
//          child: Center(
//            child: Text("다 체크 했어요!  →",style: TextStyle(fontSize: 20,color: kWhiteIvoryColor,fontWeight: FontWeight.w600)),
//          ),
//        ),
//      ),
//    )
//  }
//}