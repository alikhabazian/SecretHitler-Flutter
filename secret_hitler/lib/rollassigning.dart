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

  void showMessageDialog(BuildContext context,int index ,String name,String role,List<TextSpan> extend) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // print(DefaultTextStyle.of(context).style);
        return AlertDialog(
          title: Text('Message'),
          // "Please confirm your identity, Jack, to reveal your role."
          //RichText(text: TextSpan(
            // style: DefaultTextStyle.of(context).style,
          // )
          content: RichText(
              text: TextSpan(
                style:TextStyle(color:Colors.black),
                children: <TextSpan>[
                  TextSpan(text: 'Please confirm your identity, '),
                  TextSpan(text: name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  TextSpan(text: ' to reveal your role.'),
                ],
              ),
            ),
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
                      content:RichText(
                                text: TextSpan(
                                  style:TextStyle(color:Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(text: 'You are '),
                                    TextSpan(text: '${role}\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                    TextSpan(text: '---------------\n'),
                                    
                                  ]+extend,
                                ),
                              ),
                      // content: Text('You are ${role}\n'+extend),
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

    // TODO if you want to skip instantly
    every_one_know_his_role=true;


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
              List<TextSpan> extend=[];
              if(roles[entry.key]=='Fascist'){
                for (int i = 0; i < widget.data.length; i++) {
                  if((roles[i]=='Fascist') &&(i!=entry.key) ){
                    extend.add(TextSpan(text:'Fascist: '));
                    extend.add(TextSpan(text:'${widget.data[i]}\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)));
                  }
                  else if(roles[i]=='Hitler'){
                    // extend=extend+'Hitler:'+widget.data[i]+'\n';
                    extend.add(TextSpan(text:'Hitler: '));
                    extend.add(TextSpan(text:'${widget.data[i]}\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color:Colors.red)));
                  }
                }
              }
              else if(roles[entry.key]=='Hitler' && roles.length<=6){
                for (int i = 0; i < widget.data.length; i++) {
                  if((roles[i]=='Fascist') &&(i!=entry.key) ){
                    // extend=extend+'Fascist:'+widget.data[i]+'\n';
                    extend.add(TextSpan(text:'Fascist: '));
                    extend.add(TextSpan(text:'${widget.data[i]}\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)));
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
