import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:richhabit/constants.dart';

class InvestDetail extends StatelessWidget {
  final title;
  final mdpath;

  InvestDetail({Key key, @required this.title, this.mdpath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final markdownController = ScrollController();
    return Scaffold(
        appBar: AppBar(
            title: Text(
              title,
              style:
                  TextStyle(color: kPurpleColor, fontSize: kSubTitleFontSize),
            ),
            backgroundColor: kIvoryColor,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: kPurpleColor,
              iconSize: kSubTitleFontSize,
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: FutureBuilder<String>(
          future: rootBundle.loadString(mdpath),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return SafeArea(
                child: Container(
                    color: kIvoryColor,
                    child: Markdown(
                      data: snapshot.data,
                      controller: markdownController,
                      selectable: true,
                      shrinkWrap: false,
                    )),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }
}
