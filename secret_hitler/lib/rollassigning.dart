import 'package:flutter/material.dart';
import 'package:secret_hitler/game.dart';
import 'dart:convert';
class RollAssigning extends StatefulWidget {
  final List<String> data;

  const RollAssigning({Key? key, required this.data}) : super(key: key);

  @override
  _RollAssigning createState() => _RollAssigning();
}

class _RollAssigning extends State<RollAssigning> {
  List<String> roles=[];
  List<bool> seen = [];

  @override
  initState() {
    int number_players=widget.data.length;
    seen = [];
    for (int i = 0; i < number_players; i++) {
      seen.add(false);
    }

    int libc=(number_players/2).floor()+1;
    int fasc=number_players-libc-1;
    roles=[];
    for (int i = 0; i < libc; i++) {
      roles.add('Liberal');
    }
    for (int i = 0; i < fasc; i++) {
      roles.add('Fascist');
    }
    roles.add('Hitler');
    roles=roles..shuffle();
    // print(roles);
    setState(() { });
  }

  void showMessageDialog(BuildContext context,int index ,String name,String role,String extend) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message'),
          content: Text('Are you sure you are ${name}'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {

                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    seen[index]=true;
                    return AlertDialog(
                      title: Text('Message'),
                      content: Text('You are ${role}\n'+extend),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Ok'),
                          onPressed: () {

                            Navigator.of(context).pop();
                            setState(() { });

                          },
                        ),
                      ],
                    );
                  },
                    barrierDismissible:false
                );
              },
            ),
          ],
        );
      },
    );
  }


  void _start_game() {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Game(name: widget.data,roles:roles)),
      );

  }


  @override
  Widget build(BuildContext context) {
    print(seen);
    print(roles);
    bool every_one_know_his_role=false;
    every_one_know_his_role=seen.every((value)=>value==true);
    // every_one_know_his_role=true;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Roll Assigning'),
      ),
      body:
      SingleChildScrollView(
          child:
      Center(
        child:Column(
        // child: Text(widget.data.toString()),
        children:<Widget>[
          SizedBox(height: 16.0),
          ]+widget.data.asMap().entries.map((entry)=>
            GestureDetector(
            onTap: seen[entry.key] ?null:(){
              var extend='';
              if(roles[entry.key]=='Fascist'){
                for (int i = 0; i < widget.data.length; i++) {
                  if((roles[i]=='Fascist') &&(i!=entry.key) ){
                    extend=extend+'Fascist:'+widget.data[i]+'\n';
                  }
                  else if(roles[i]=='Hitler'){
                    extend=extend+'Hitler:'+widget.data[i]+'\n';
                  }
                }
              }
              else if(roles[entry.key]=='Hitler' && roles.length<=6){
                for (int i = 0; i < widget.data.length; i++) {
                  if((roles[i]=='Fascist') &&(i!=entry.key) ){
                    extend=extend+'Fascist:'+widget.data[i]+'\n';
                  }
                }

              }


              showMessageDialog(context,entry.key, entry.value,roles[entry.key],extend);
            },
            child:Card(
              color:seen[entry.key]?Colors.grey[300]:Colors.white,
              elevation: 50,
              child:SizedBox(
                width: width*0.9,
                height: 100,
                child:Center(
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    children:[Text(entry.value)]
                  )
                ),
              ),
            )
            )
        ).toList(),
        ),
      )),
      floatingActionButton:every_one_know_his_role?
      FloatingActionButton(
        onPressed:_start_game ,
        tooltip: 'Game start',
        child: const Icon(Icons.arrow_forward_sharp),
      )
          :
      FloatingActionButton(
        onPressed: initState,
        tooltip: 'restart',
        child: const Icon(Icons.restart_alt),
      ),
    );
  }
}
