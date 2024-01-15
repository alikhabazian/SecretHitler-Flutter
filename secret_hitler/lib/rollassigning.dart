import 'package:flutter/material.dart';
import 'package:secret_hitler/gameUI.dart';
import 'package:secret_hitler/state_management.dart';
import 'package:provider/provider.dart';

class RollAssigning extends StatefulWidget {


  const RollAssigning({Key? key}) : super(key: key);

  @override
  _RollAssigning createState() => _RollAssigning();
}

class _RollAssigning extends State<RollAssigning> {
  List<bool> seen = [];
  late GameState gameState;

  @override
  initState() {
    gameState = Provider.of<GameState>(context,listen: false);
    gameState.roleAssigning(gameState.playerNames, gameState.gameType);
    int number_players=gameState.players.length;
    seen = [];
    for (int i = 0; i < number_players; i++) {
      seen.add(false);
    }

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
        MaterialPageRoute(builder: (context) => Game()),
      );

  }


  @override
  Widget build(BuildContext context) {
    print(seen);
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
          ]+gameState.players.asMap().entries.map((entry)=>
            GestureDetector(
            onTap: seen[entry.key] ?null:(){
              List<TextSpan> extend=gameState.nightInfo(entry.value);



              showMessageDialog(context,entry.key, entry.value.name,entry.value.role,extend);
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
                    children:[Text(entry.value.name)]
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
