import 'package:flutter/material.dart';


getNameAvatar(name) {
  if(name == null ){
    return '';
  }
  return "https://ui-avatars.com/api/?bold=true&background=random&name=" +
      name;
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

screenWidth(context) => MediaQuery.of(context).size.width;
screenHeight(context) => MediaQuery.of(context).size.height;
// delete
s50(context) => screenWidth(context) * 0.020 * 6;
s25(context) => s50(context) / 2;
s10(context) => s50(context) / 5;
s5(context) => s10(context) / 2;

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

Color blue7 = const Color.fromRGBO(225,247,255,1);  //
// const seenColor = const Color.fromRGBO(40,162,167,1);//#28A2A7
// TextStyle
Text getText(String text, Color color ,double fontSize, bool isBold/*, {bool isCenter=true}*/) {
  return Text(text,
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    ),
    // textDirection: TextDirection.ltr,
    // textAlign: isCenter ? TextAlign.center : TextAlign.left,
  );
}

Text getTextNoSize(String text, Color color, bool isBold, {bool isCenter=true}) {
  return Text(text,
    style: TextStyle(
      color: color,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    ),
    textDirection: TextDirection.ltr,
    textAlign: isCenter ? TextAlign.center : TextAlign.left,
  );
}

// Padding
EdgeInsets paddingAll5 = const EdgeInsets.all(5);
EdgeInsets paddingLeft10 = const EdgeInsets.only(left: 10.0);
EdgeInsets paddingLeft20 = const EdgeInsets.only(left: 20.0);
EdgeInsets paddingRight20 = const EdgeInsets.only(right: 20.0);

EdgeInsets getPaddingAll(double x){
  return EdgeInsets.all(x);
}

// Numbers
double imageRadius = 50.0;
double my_radius=20.0;

// Box
SizedBox box = const SizedBox(height: 20.0);
SizedBox box9 = const SizedBox(height: 9.0);
SizedBox getSizeBox(double x){
  return SizedBox(height: x);
}

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
              Expanded(
                child: Image.asset(
                  imagePath,
                  height: imageHeight,
                  width: imageWidth,
                ),
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

String getDifference(Duration diff){
  int DaysAgo = diff.inDays;
  int HoursAgo = diff.inHours;
  int MinutesAgo = diff.inMinutes;
  int secondsAgo = diff.inSeconds;
  String stringTimeAgo = "";
  if(DaysAgo > 0){
    if(HoursAgo == 1){
      stringTimeAgo = DaysAgo.toString()+" Day Ago";
    }else{
      stringTimeAgo = DaysAgo.toString()+" Days Ago";
    }
  }
  else if(HoursAgo > 0){
    if(HoursAgo == 1){
      stringTimeAgo = HoursAgo.toString()+" Hour Ago";
    }else{
      stringTimeAgo = HoursAgo.toString()+" Hours Ago";
    }
  }
  else if(MinutesAgo >0){
    if(HoursAgo == 1){
      stringTimeAgo = MinutesAgo.toString()+" Minute Ago";
    }else{
      stringTimeAgo = MinutesAgo.toString()+" Minutes Ago";
    }
  }
  else if(secondsAgo >=3){
    stringTimeAgo = secondsAgo.toString()+" Seconds Ago";
  }
  else{
    stringTimeAgo = "just now";
  }
  return stringTimeAgo;
}




