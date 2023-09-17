import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
class Donatepage extends StatefulWidget {
  const Donatepage({Key? key}) : super(key: key);

  @override
  State<Donatepage> createState() => _DonatepageState();
}

class _DonatepageState extends State<Donatepage> {
  double progressValue = 0.0; // Initial progress value
  String title = "";

  @override
  void initState() {
    super.initState();
    fetchDataFromNetwork();
  }

  Future<void> fetchDataFromNetwork() async {
    var url = Uri.https('hamibash.com', '/api/api/Goal/getGoalPageShow/26505');
    var response = await http.get(url);
    var jsonResponse = json.decode(response.body);
    // Handle the response here and update progressValue accordingly.
    // For example, you can update progressValue based on the response data.
    if (response.statusCode == 200) {
      // {"status":200,"message":"Success","data":[{"title":"اصافه کردن نسخه کومونیست بازی","description":"","persent":0.0}]}

    // Parse the response and update progressValue accordingly.
      // For now, let's assume progressValue is set to 0.5 as in your example.
      progressValue=jsonResponse['data'][0]["persent"];
      title = jsonResponse['data'][0]["title"];
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(title);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          fetchDataFromNetwork();
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Donate"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // const Text(
            //   'Linear progress indicator with a fixed color',
            //   style: TextStyle(fontSize: 20),
            // ),
            SizedBox(
              width: width*0.9,
              height: 50,
              child:ElevatedButton(
                style: style,
                onPressed: ()async{



                  final Uri _url = Uri.parse('https://hamibash.com/secrethitler/');
                  await launchUrl(_url);


                  // _launchURL('https://youtu.be/mbGXIDYdtas?si=l8QQgu_Bm3-i99jI');

                },
                child: const Text('Donation Link Hamibash'),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        title,
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: width * 0.9,
                          height: 30,
                          child: LinearProgressIndicator(
                            value: progressValue,
                            minHeight: 40,
                            semanticsLabel: 'Linear progress indicator',
                            semanticsValue:
                            'What percentage of the donation has been completed?',
                          ),
                        ),
                        const Text(
                          'What percentage of the donation has been completed?', // Replace X with the actual percentage
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }
}
