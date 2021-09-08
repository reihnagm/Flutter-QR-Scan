import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:mbw204_club_ina_qr_scanner/models/event_scanner.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyHome()
  ),
);

class MyHome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF58595b),
        title: Row(
          children: [
            Image.asset('assets/images/logo.png',
              width: 45.0,
              height: 45.0,
            ),
            SizedBox(width: 15.0),
            Text('MB W204 INA',
              style: TextStyle(
                fontFamily: "poppins"
              ),
            )
          ],
        )
      ),
      body: EventScannerScreen(),
    );
  }
}

class EventScannerScreen extends StatelessWidget {

  Future<EventScannerModel> fetchEvents(BuildContext context) async {
    try {
      Dio dio = Dio();
      Response res = await dio.get("https://api-w204.connexist.id/content-service/event-scanner");
      EventScannerModel eventScannerModel = EventScannerModel.fromJson(json.decode(res.data));
      return eventScannerModel;
    } on DioError catch(e) {
      print(e?.response?.statusCode);
      print(e?.response?.data);
    } catch(e) {
      print(e);
    }
    return EventScannerModel();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchEvents(context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator()
          );
        }
        EventScannerModel eventScannerModel = snapshot.data;
        return Container(
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          child: ListView.builder(
            itemCount: eventScannerModel.body.length,
            itemBuilder: (BuildContext context, int i) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 20,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(top: 8.0),
                padding: EdgeInsets.all(8.0),
                child: ListTile(  
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QRViewScreen(
                    eventId: eventScannerModel.body[i].eventId,
                  ))),
                  title: Text(eventScannerModel.body[i].description,
                    style: TextStyle(
                      fontFamily: "poppins",
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0
                    ),
                  ),
                  subtitle: Column(
                    children: [      
                      SizedBox(height: 5.0),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Location :",
                              style: TextStyle(
                                fontFamily: "poppins",
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Expanded(
                            flex:3,
                            child: Text(eventScannerModel.body[i].location,
                              style: TextStyle(
                                fontFamily: "poppins",
                                fontSize: 12.0
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text("Start :",
                                    style: TextStyle(
                                      fontFamily: "poppins",
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(eventScannerModel.body[i].start,
                                    style: TextStyle(
                                      fontFamily: "poppins",
                                      fontSize: 12.0
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text("End :",
                                    style: TextStyle(
                                      fontFamily: "poppins",
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(eventScannerModel.body[i].end,
                                    style: TextStyle(
                                      fontFamily: "poppins",
                                      fontSize: 12.0
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  leading: FadeInImage.assetNetwork(
                    placeholder: "assets/images/default_image.png", 
                    image: "http://feedapi.connexist.id/d/f${eventScannerModel.body[i].media[0].path}"
                  )
                ),
              );
            },
          ),
        );
      }
    );
  }
}

class QRViewScreen extends StatefulWidget {
  final int eventId;
  
  QRViewScreen({
    this.eventId
  });

  @override
  State<StatefulWidget> createState() => _QRViewScreenState();
}

class _QRViewScreenState extends State<QRViewScreen> {
  Barcode result;
  QRViewController controller;
  GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  
  Future<Response> checkEvent(BuildContext context, int eventId, String userId) async {
    Response res;
    try { 
      Dio dio = Dio();
      res = await dio.post("https://api-w204.connexist.id/content-service/event/present", data: {
        "event_id" : eventId.toString(),
        "user_id" : userId.toString()
      });
      return res;
    } on DioError catch(e) {
      print(e?.response?.data);
      print(e?.response?.statusCode);
    } catch(e) {
      print(e);
    }
    return res;
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4, 
            child: buildQrView(context)
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (result != null)
                  FutureBuilder(
                    future: checkEvent(context, widget.eventId, result.code),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if(snapshot.hasError) {
                        return Center(
                          child: Text("Failed: Internal Server Problem",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[200]
                            ),
                          ),
                        );
                      }
                      Response res = snapshot.data;
                      if(res?.statusCode == 500) {
                        return Center(
                          child: Text("Failed: Internal Server Problem",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[200]
                            ),
                          ),
                        ); 
                      }
                      return Center(
                        child: Text("Success",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[200]
                          ),
                        ),
                      );
                    },
                  ),
                if(result != null)
                  InkWell(
                    onTap: () {
                      controller.resumeCamera();
                    },
                    child: Text('Resume Camera',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'poppins'
                      ),
                    ),
                  ),
                if(result == null)
                  Text('Scan a code',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'poppins'
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildQrView(BuildContext context) {
    double scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF58595b),
        title: Row(
          children: [
            Image.asset('assets/images/logo.png',
              width: 45.0,
              height: 45.0,
            ),
            SizedBox(width: 15.0),
            Text('MB W204 INA',
              style: TextStyle(
                fontFamily: "poppins"
              ),
            )
          ],
        )
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: scanArea
        ),
        onPermissionSet: (QRViewController qrViewController, bool p) => onPermissionSet(context, qrViewController, p),
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((scanData) {
      if(scanData.code.isNotEmpty) {
        controller.pauseCamera();
      }
      setState(() {
        result = scanData;
      });
    });
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) async {
    PermissionStatus status = await Permission.camera.status;
    if(!status.isGranted) {
      await Permission.camera.request();
    } 
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}