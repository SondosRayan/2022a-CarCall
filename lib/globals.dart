import 'package:flutter/material.dart';

//Colors
Color grey = const Color.fromRGBO(207,216,220,1);
Color lightGreen1 = const Color.fromRGBO(36,202,198,1);
Color green11 = const Color.fromRGBO(0,96,100,1);
Color green2 = const Color.fromRGBO(0,151,167,1);
Color blue1 = const Color.fromRGBO(223,235,237,1); //#DFEBED
Color blue2 = const Color.fromRGBO(204,232,237,1); //#CCE8ED
Color blue3 = const Color.fromRGBO(183,214,218,1); //#B7D6DA
Color blue4 = const Color.fromRGBO(157,201,207,1); //#9DC9CF
Color blue5 = const Color.fromRGBO(123,191,200,1); //#7BBFC8
Color blue6 = const Color.fromRGBO(95,157,165,1);  //#5F9DA5

// TextStyle
Text getText(String text, Color color ,double fontSize, bool isBold) {
  return Text(text,
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    ),
    textAlign: TextAlign.center,
  );
}

// Padding
EdgeInsets paddingAll5 = const EdgeInsets.all(5);
EdgeInsets paddingLeft10 = const EdgeInsets.only(left: 10.0);
EdgeInsets paddingLeft20 = const EdgeInsets.only(left: 20.0);
EdgeInsets paddingRight20 = const EdgeInsets.only(right: 20.0);

// Numbers
double imageRadius = 50.0;

// Box
SizedBox box = const SizedBox(height: 20.0);
SizedBox box9 = const SizedBox(height: 9.0);
SizedBox makeBox(String text, double width, double height, Color boxColor,
    Color textColor, double fontSize, Null Function()? onPress){
  return SizedBox(
    width: width,
    height: height,
    child: Material(
      color: boxColor,
      borderRadius: BorderRadius.circular(20.0),
      child: MaterialButton(
        // color: Colors.blue,
        child: Align(
          alignment: Alignment.center,
          child: getText(text, textColor, fontSize, true),
        ),
        onPressed: onPress,
      ),
    ),
  );
}
SizedBox makeBox2(String text, double width, double height, Color boxColor,
    Color textColor, double fontSize, Future<Null> Function() onPress){
  return SizedBox(
    width: width,
    height: height,
    child: Material(
      color: boxColor,
      borderRadius: BorderRadius.circular(20.0),
      child: MaterialButton(
        // color: Colors.blue,
        child: Align(
          alignment: Alignment.center,
          child: getText(text, textColor, fontSize, true),
        ),
        onPressed: onPress,
      ),
    ),
  );
}

SizedBox makeBoxWithPic(String imagePath, double imageHeight, double imageWidth,
    String text, double width, double height, Color boxColor,
    Color textColor, double fontSize, Null Function()? onPress){
  return SizedBox(
    width: width,
    height: height,
    child: Material(
      color: boxColor,
      borderRadius: BorderRadius.circular(20.0),
      child: MaterialButton(
        // color: Colors.blue,
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: imageHeight,
                width: imageWidth,
              ),
              getText(text, textColor, fontSize, true),
            ],
          ),
        ),
        onPressed: onPress,
      ),
    ),
  );
}



