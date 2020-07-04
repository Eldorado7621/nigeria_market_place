import 'dart:async';
import 'package:flutter/material.dart';
import 'ErrorScreen.dart';
import 'package:connectivity/connectivity.dart';
import 'ConnectivityService.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

String closeVal="";
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

class MyApp extends StatelessWidget {
  static String id='my_app';
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nigeria Market Place',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Nigeria Market Place'),
      routes: {
        ErrorScreen.id:(context)=>ErrorScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  static String id='my_app';
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return new SplashScreen(
      title: new Text(
        ' ',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      seconds: 3,
      navigateAfterSeconds: AfterSplash(),
      image: new Image.asset(
          'image/nmp-logo.png'),
      backgroundColor: Color(0xffffffff),
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 150.0,
      onClick: () => print(""),
      loaderColor: Colors.greenAccent,
    );
  }
}

class AfterSplash extends StatefulWidget {
  @override
  _AfterSplashState createState() => new _AfterSplashState();
}
class _AfterSplashState extends State {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  StreamSubscription<WebViewHttpError> _onHttpError;

  StreamSubscription<double> _onProgressChanged;

  StreamSubscription<double> _onScrollYChanged;

  StreamSubscription<double> _onScrollXChanged;
  final _history = [];


  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    checkConnectivity2();

    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
          if (mounted) {
            setState(() {
              // _history.add('onProgressChanged: $progress');
              closeVal="loading...";
            });
          }
        });

    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          // _history.clear();
          //  _history.add('loading...');
          // _history.add('onUrlChanged: $url');
          closeVal="";
        });
      }
      else{
        setState(() {
          // _history.clear();
          //  _history.add('loading...');
          // _history.add('onUrlChanged: $url');
          closeVal="";
        });
      }
    });


  }
  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();

    flutterWebViewPlugin.dispose();

    super.dispose();
  }
  String _networkStatus2 = '';
  Connectivity connectivity = Connectivity();
  void checkConnectivity2() async {
    // Subscribe to the connectivity change
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          var conn = getConnectionValue(result);
          setState(() {
            _networkStatus2 =  conn;
          });
        });
  }
  String getConnectionValue(var connectivityResult) {
    String status = '';
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        status = 'Mobile';
        break;
      case ConnectivityResult.wifi:
        status = 'Wi-Fi';
        break;
      case ConnectivityResult.none:
        status = 'None';
        break;
      default:
        status = 'None';
        break;
    }
    return status;
  }
  bool showLoading = false;
  void updateLoading(bool ls) {
    this.setState((){
      showLoading = ls;
    });
  }
  Widget build(BuildContext context) {
    if (_networkStatus2 == 'None') {
      print("not none");
      return new Scaffold(

        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'image/nmp-logo.png',
                height: 300,
                width: 160,
              ),
              Text(
                'You do not have internet connection:',
                style: TextStyle(fontSize: 20),


              ),

            ],
          ),
        ),


      );
    }

    return new Scaffold(

      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 22,
              child: WebviewScaffold
                (url: "https://www.mobile.nigeriamarketplace.org",
                hidden: true,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(closeVal),
            ),
          ],
        ),
      ),
    );
  }
}