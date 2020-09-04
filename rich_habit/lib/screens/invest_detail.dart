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
            brightness: Brightness.light,
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
                      styleSheet:
                          MarkdownStyleSheet.fromTheme(Theme.of(context))
                              .copyWith(
                                  p: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(fontSize: 15.0),
                                  h3: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold)),
                    )),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }
}
