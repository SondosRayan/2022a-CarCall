import 'package:flutter/cupertino.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

class OCR_Scanner extends StatefulWidget {
  const OCR_Scanner({Key? key}) : super(key: key);
  @override
  _OCR_ScannerState createState() => _OCR_ScannerState();
}

class _OCR_ScannerState extends State<OCR_Scanner> {
  //int _ocrCamera = FlutterMobileVision.CAMERA_BACK;
  String text = "TEXT";
  bool isInitialized =false;
  /*@override
  void initState() {
    FlutterMobileVision.start().then((value){
      isInitialized=true;
    });
    super.initState();
  }*/
  @override
  void initState() {
    super.initState();
    FlutterMobileVision.start().then((x) => setState(() {}));
  }

  Future<void> _read() async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        //camera: _ocrCamera,
        waitTap: true,
      );
      setState(() {
        text = texts[0].value;
      });
    } on Exception {
      texts.add( OcrText('Failed to recognize text'));
    }
  }
  @override
  Widget build(BuildContext context) {
    _read();
    return Text(text);
  }
}
