import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FancyLoader extends StatelessWidget {
  FancyLoader({this.loaderType, this.lines});

  final String loaderType;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      period: Duration(milliseconds: 500),
      highlightColor: Colors.white,
      child: getLoaderType(loaderType: loaderType, lines: lines),
    );
  }

  Widget getLoaderType({String loaderType, int lines}) {
    switch (loaderType) {
      case "list":
        {
          return getListLoader();
        }
        break;

      case "sLine":
        {
          return getSingleLineLoader();
        }
        break;

      case "mLine":
        {
          return getMultiLineLoader(lines);
        }
        break;

      default:
        {
          return getLogoLoader();
        }
        break;
    }
  }

  Widget getLogoLoader() {
    return Center(
      child: Text(
        'ACC',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.grey,
            fontSize: 150.0,
            fontWeight: FontWeight.bold,
            wordSpacing: 2,
            fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget getSingleLineLoader() {
    return Center(
      child: Container(
        color: Colors.grey[500],
        height: 200,
        width: 300,
      ),
    );
  }

  Widget getMultiLineLoader(int lines) {
    return Container(
      color: Colors.grey[500],
      height: lines.toDouble() * 50,
      width: 300,
    );
  }

  Widget getListLoader() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            ListTile(
              title: Container(
                color: Colors.grey[500],
                height: 15,
                width: 100,
              ),
              subtitle: Container(
                color: Colors.grey[500],
                height: 10,
                width: 10,
              ),
              leading: CircleAvatar(
                radius: 25,
                // backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }
}
