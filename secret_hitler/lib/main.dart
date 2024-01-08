import 'package:flutter/material.dart';
import 'package:secret_hitler/GameSetting.dart';
import 'package:secret_hitler/donate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:secret_hitler/state_management.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:secret_hitler/gameUI.dart';

void main() {
  // runApp(const MyApp());
  runApp(
      MultiProvider(
          providers: [
          ChangeNotifierProvider(create: (context) => GameState()),
          ],

          child: MyApp()
      )
  );
}







class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
      ),
      // home: const MyHomePage(title: 'Secret Hitler'),
        home: const Home(),
    );
  }
}


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences loadedPrefs;
  late Future<bool> _hasGame;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hasGame = _prefs.then((SharedPreferences prefs) {
      loadedPrefs=prefs;
      return prefs.getBool('hasGame') ?? false;
    });
  }



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      backgroundColor: Colors.amber[50],
      body: SingleChildScrollView(
        child:SafeArea(
        child:Center(
        child: Column(
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child:Image.asset(
                "assets/logo.png",
                // height: 125.0,
                // width: 125.0,
              ),

            ),
            FutureBuilder<bool>(
              future: _hasGame,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While the future is still resolving
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // If there's an error with the future
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data == true) {
                  // If _hasGame is true, show this button
                  return SizedBox(
                    width: width * 0.6,
                    height: 50,
                    child: ElevatedButton(
                      style: style,
                      onPressed: () {
                        GameState gameState = Provider.of<GameState>(context,listen: false);
                        gameState.loadSharedPreferences(loadedPrefs);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Game(name: gameState.names,roles:gameState.roles)),
                        );
                      },
                      child: const Text('Continue previous game'),
                    ),
                  );
                } else {
                  // If _hasGame is false or null, show null
                  return SizedBox.shrink();
                }
              },
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: width*0.6,
              height: 50,
              child:ElevatedButton(
                style: style,
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameSetting(title:"Secret Hitler" )),
                  );
                },
                child: const Text('Play'),
              ),
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: width*0.6,
              height: 50,
              child:ElevatedButton(
                style: style,
                onPressed: ()async{



                  final Uri _url = Uri.parse('https://youtu.be/mbGXIDYdtas?si=l8QQgu_Bm3-i99jI');
                  await launchUrl(_url);


                   // _launchURL('https://youtu.be/mbGXIDYdtas?si=l8QQgu_Bm3-i99jI');

                },
                child: const Text('How to Play'),
              ),
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: width*0.6,
              height: 50,
              child:ElevatedButton(
                style: style,
                onPressed: ()async{
                  // var url = Uri.https('hamibash.com','/api/api/Goal/getGoalPageShow/26505');
                  // var response = await http.get(url);
                  // print(response.body);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Donatepage()),
                  );


                  // LinearProgressIndicator

                },
                child: const Text('About Me'),
              ),
            ),


            Padding(
                padding: EdgeInsets.all(16.0),
                child:Image.asset(
                  "assets/box.gif",
                  // height: 125.0,
                  // width: 125.0,
                ),

            )

          ],
        ),
      ),

    )
      )
    );
  }
}



