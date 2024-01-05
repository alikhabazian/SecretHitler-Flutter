import 'package:flutter/material.dart';
import 'package:secret_hitler/gameFunctions.dart';
import 'package:secret_hitler/state_management.dart';

Widget lastStatus(last_president,last_chancellor){
  return RichText(
    text: TextSpan(
      style:const TextStyle(color:Colors.black,fontSize: 18),
      children: <TextSpan>[
        if (last_president!='')... [
          const TextSpan(text: 'Last president: '),
          TextSpan(text: '${last_president}\n', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ],
        if (last_chancellor!='')... [
          const TextSpan(text: 'Last chancellor: '),
          TextSpan(text: '${last_chancellor}\n', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),

        ]
      ],
    ),
  );
}

Widget dangerZone(hitler_state,state){
  if ((hitler_state&& (state!='lib win' && state!='fash win')))
    return const Padding(
        padding: EdgeInsets.all(8.0),
        child:Text(
          "We stand at a precipice of danger; should Hitler ascend as Chancellor, the forces of fascism shall claim victory.",
          style: TextStyle(fontSize: 15),
          textAlign: TextAlign.center,
        ),
      );
  else{
    return Container();
  }
}

Widget winState(state){
  if (!(state!='lib win' && state!='fash win')) {
    return Text(
      (state == 'lib win')
          ? "Liberals Win the Game"
          : "Fascists Win the Game",
      style: const TextStyle(fontSize: 30),
      textAlign: TextAlign.center,
    );
  }
  else{
    return Container();
  }
}

Widget tableBoard(List<TableCell> facTable,List<TableCell> libTable){
  return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(1.0),
      minScale: 0.1,
      maxScale: 3,
      child:Table(
          border: TableBorder.all(
          ),
          columnWidths:const <int, TableColumnWidth>{
            0: IntrinsicColumnWidth(),
            1: IntrinsicColumnWidth(),
            2: IntrinsicColumnWidth(),
            3: IntrinsicColumnWidth(),
            4: IntrinsicColumnWidth(),
            5: IntrinsicColumnWidth(),
          },
          children:<TableRow>[
            TableRow(children: facTable),
            TableRow(children: libTable),
          ]
      )
  );
}

Widget failedElection(numberRejected){
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
      [0,1,2,3].asMap().entries.map((entry)=>
          Padding(
              padding: const EdgeInsets.all(8.0),
              child:ClipOval(
                child: Material(
                  child: Container(

                    decoration: BoxDecoration(
                      color:entry.key==numberRejected?Colors.blueAccent:Colors.white,
                      border: Border.all(width: 5.0,color: entry.key==3?Colors.red:Colors.blueAccent,),
                      shape: BoxShape.circle,
                    ),
                    child:const Text(
                      '',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    height: 40.0,
                    width: 40.0,

                  ),
                ),
              )
          )
      ).toList()
  );
}

void discardPresident(GameState game_state){
  game_state.changeLastPresident(game_state.names[game_state.turn]);
  game_state.changeState('president_discarded');
  game_state.changeChancellorSelect(-1);
  game_state.addLog("${game_state.names[game_state.turn]} discard:${game_state.dec[game_state.presidentSelected]}\n");
  game_state.disDec.add(game_state.dec.removeAt(game_state.presidentSelected));
  game_state.updatePage();
}

List <Widget> getUiState(context,width,height,GameState game_state){
  List <Widget> temp=<Widget>[];
  switch (game_state.state){
    case 'base':
      temp+=<Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child:RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style:TextStyle(color:Colors.black,fontSize: 20),
              children: <TextSpan>[
                TextSpan(text: 'Round '),
                TextSpan(text: '${game_state.round}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                TextSpan(text: ' has begun.\n'),
                TextSpan(text: '${game_state.names[game_state.turn]},',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
                TextSpan(text: ' select your Chancellor for the upcoming election.'),
              ],
            ),
          ),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              const Padding(
                  padding: EdgeInsets.all(8.0),
                  child:Text(
                      'Your Chancellor: ',
                      style: TextStyle(fontSize: 30)
                  )),
              DropdownButton<String>(
                value: game_state.selectedChancellor,

                onChanged: (String? value) {
                  // first_selected=true;
                  print('$value');
                  // This is called when the user selects an item.
                  // setState(() {
                  game_state.changeSelectedChancellor(value);
                  // });
                },
                items:game_state.chancellorList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

            ]
        ),

        TextButton(
          child: Container(
              height: (height*0.95)/15,
              width:(width*0.95)/3,
              color:Colors.blue,
              child:
              Center(child:Text('Select!',style:TextStyle(color:Colors.white, fontSize: (width*0.95)/15),textAlign: TextAlign.center))
          ),
          onPressed: () {
            showMessageDialog(context,game_state.selectedChancellor, game_state);
          },
        )

      ];
      break;
    case 'elected':
      temp+=<Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child:RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style:TextStyle(color:Colors.black,fontSize: 15),
              children: <TextSpan>[
                TextSpan(text: '${game_state.names[game_state.turn]},', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                TextSpan(text: ' in your esteemed role as the'),
                TextSpan(text: ' President,',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                TextSpan(text: ' please select a policy card to be discarded.'),


              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[]+game_state.dec.sublist(0, 3).asMap().entries.map((entry)=>
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                    // highlightColor:Colors.black,
                    //   hoverColor:Colors.yellow,
                    onTap: () {
                      game_state.changePresidentSelect(entry.key);
                    },
                    child:Container(
                      decoration: BoxDecoration(
                          color :entry.value=='lib'?Colors.blue[400]:Colors.red,
                          border: game_state.presidentSelected!=entry.key?null:Border.all(width: 5.0,color: Colors.blueAccent)
                      ),

                      child:Image(image: AssetImage('assets/'+entry.value+'.png')),

                      height: 155,
                      width: 85,
                    ),

                  )
              )
          ).toList(),
        ),
        TextButton(
          child: Container(
              height: 40,
              width: 80,
              color:Colors.blue,
              child:Center(
                  child:Text('Discard!',style:TextStyle(color:Colors.white), textAlign: TextAlign.center,)
              )
          ),
          onPressed: () {
            discardPresident(game_state);
          },
        )
      ];
      break;
    case 'president_discarded':
      temp+=<Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          //"${chancellor}, entrusted as the Chancellor, graciously pick a card to shape our policy."
          child:RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style:TextStyle(color:Colors.black,fontSize: 15),
              children: <TextSpan>[
                TextSpan(text: '${game_state.selectedChancellor},', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                TextSpan(text: ' entrusted as the'),
                TextSpan(text: ' Chancellor,', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                TextSpan(text: ' graciously pick a card to shape our policy.'),

              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[]+(game_state.hide?['hide','hide']:game_state.dec.sublist(0, 2)).asMap().entries.map((entry)=>
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(

                    onTap: () {
                      print("entry.key: ${entry.key}");
                      game_state.changeChancellorSelect(entry.key);
                      game_state.updatePage();
                    },
                    child:Container(
                      decoration: BoxDecoration(
                          color : (entry.value=='hide'?Colors.grey[400]:(entry.value=='lib'?Colors.blue[400]:Colors.red)),
                          border: game_state.chancellorSelected!=entry.key?null:Border.all(width: 5.0,color: Colors.blueAccent)
                      ),

                      child:entry.value=='hide'?Center(child:Icon(Icons.question_mark_outlined,size: 70.0,)):Image(image: AssetImage('assets/'+entry.value+'.png')),

                      height: 155,
                      width: 85,
                    ),

                  )
              )
          ).toList(),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              if(!game_state.hide)TextButton(
                child: Container(
                    height: 40,
                    width: 80,
                    color:Colors.blue,
                    child:Center(
                        child:Text('Select!',style:TextStyle(color:Colors.white), textAlign: TextAlign.center,)
                    )
                ),
                onPressed: () {
                  // first_selected=false;
                  game_state.changeLastChancellor(game_state.selectedChancellor);

                  game_state.addLog("${game_state.selectedChancellor} play:${game_state.dec[game_state.chancellorSelected]}\n");
                  if(game_state.dec[game_state.chancellorSelected]=='fash'){
                    game_state.fashBoard.add('Done');
                    if(game_state.boardFash[game_state.numberPlayersInitial][game_state.fashBoard.length-1]!='blank'){
                      print('it is ${game_state.boardFash[game_state.numberPlayersInitial][game_state.fashBoard.length-1]} state');
                      game_state.changeState(game_state.boardFash[game_state.numberPlayersInitial][game_state.fashBoard.length-1]);
                      if (game_state.state=='kill_veto'){
                        game_state.changeState('kill');
                        game_state.activateVeto();
                      }
                      if (game_state.state=='Search'){
                        game_state.changeWillSearch(game_state.candidateList()[0]);
                      }
                      if (game_state.state=='next-persident'){
                        game_state.changeWillPresident(game_state.candidateList()[0]);
                      }
                      if (game_state.state=='kill'){
                        game_state.changeWillKilled(game_state.candidateList()[0]);
                      }

                    }
                    else {
                      game_state.changeState('base');
                      game_state.nextRound();
                      // round=round+1;
                    }
                  }
                  else if(game_state.dec[game_state.chancellorSelected]=='lib'){
                    game_state.libBoard.add('Done');
                    game_state.changeState('base');
                    game_state.nextRound();
                    // round=round+1;
                  }
                  print("chancellor select1");

                  game_state.removeSelectedDec(game_state.chancellorSelected);
                  game_state.addDisDec();
                  game_state.enoughDec();
                  game_state.updatePage();
                  print("chancellor select1");

                },
              ),
              TextButton(
                child: Container(
                    height: 40,
                    width: 80,
                    color:Colors.blue,
                    child:Center(
                        child:Text(game_state.hide?'Unhide!':'Hide!',style:TextStyle(color:Colors.white), textAlign: TextAlign.center,)
                    )
                ),
                onPressed: () {
                  game_state.toggleHide();
                  game_state.updatePage();
                },
              )

            ] +
                (!game_state.possibleVeto?<Widget>[]:<Widget>[
                  TextButton(
                    child: Container(
                        height: 40,
                        width: 80,
                        color:Colors.orange,
                        child:Center(
                            child:Text("Veto",style:TextStyle(color:Colors.white), textAlign: TextAlign.center,)
                        )
                    ),
                    onPressed: () {
                      // dis_dec.add(dec.removeAt(0));
                      // dis_dec.add(dec.removeAt(0));
                      // if(dec.length==2){
                      //   dec=dec+dis_dec;
                      //   dec=dec..shuffle();
                      //   dis_dec=[];
                      // }
                      // game_state.posible_veto=false;
                      // state='base';
                      // round=round+1;
                      game_state.doVeto();
                      game_state.nextRound();
                      // first_selected=false;
                      game_state.updatePage();
                    },
                  )

                ])

        )

      ];
      break;
    case 'top-three':
      temp+=<Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),

          child:RichText(
            textAlign:TextAlign.center,
            text: TextSpan(
              style:TextStyle(color:Colors.black,fontSize: 20),
              children: <TextSpan>[
                TextSpan(text: '${game_state.names[game_state.turn]},', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
                TextSpan(text: ' as the '),
                TextSpan(text: 'President,',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                TextSpan(text: ' you may now privately reveal the top three  policy cards.'),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[]+game_state.dec.sublist(0, 3).asMap().entries.map((entry)=>
              Padding(
                padding: EdgeInsets.all(8.0),
                child: !game_state.topThreeSeen?null:Container(
                  decoration: BoxDecoration(
                    color :entry.value=='lib'?Colors.blue[400]:Colors.red,
                    // border: chancellor_selected!=entry.key?null:Border.all(width: 5.0,color: Colors.blueAccent)
                  ),

                  child:Image(image: AssetImage('assets/'+entry.value+'.png')),

                  height: 155,
                  width: 85,
                ),


              )
          ).toList(),
        ),
        TextButton(
          child: Container(
              height: 40,
              width: 90,
              color:Colors.blue,
              child:Center(
                  child:Text(game_state.topThreeSeen?"I've Seen":'Show cards',style:TextStyle(color:Colors.white), textAlign: TextAlign.center,)
              )
          ),
          onPressed: () {
            if(!game_state.topThreeSeen) {
              game_state.changeTopThreeSeen(true);
            }
            else{
              game_state.changeTopThreeSeen(false);
              game_state.changeState('base');
              game_state.nextRound();
              // round=round+1;
              // first_selected=false;

            }
            game_state.updatePage();
          },
        )
      ];
      break;
    case 'kill':
    case 'kill_veto':
      temp+=<Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          //"${game_state.names[turn]}, Mr. President, when you're prepared, you have the option to eliminate a person. Removing Hitler would lead to a Liberal victory."
          // child:Text(
          //   '${game_state.names[turn]},mr president, If you are ready you can kill a person if you kill the hitler liberals will win ',
          //   style: TextStyle(fontSize: 15),
          //   textAlign: TextAlign.center,
          // )
          //"${game_state.names[turn]}, as the President, when you're ready, you have the option to eliminate a person. Removing Hitler would lead to a victory for the Liberals."
          child:RichText(
            textAlign:TextAlign.center,
            text: TextSpan(
              style:TextStyle(color:Colors.black),
              children: <TextSpan>[
                TextSpan(text: '${game_state.names[game_state.turn]}, as the President,', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                TextSpan(text: " when you're ready, you have the option to eliminate a person. Removing Hitler would lead to a victory for the Liberals.\n"),
                if(game_state.state=='kill_veto') TextSpan(text: "When both the President and Chancellor, both loyal to the Liberals, concur, the Veto option becomes viable."),
              ],
            ),
          ),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child:Text(
                      'Eliminated: ',
                      style: TextStyle(fontSize: 30)
                  )),
              DropdownButton<String>(
                value: game_state.willKilled,

                onChanged: (String? value) {
                  // first_selected=true;
                  print('$value');
                  // This is called when the user selects an item.
                  game_state.changeWillKilled(value!);
                  game_state.updatePage();
                },
                items:game_state.candidateList().map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

            ]
        ),
        TextButton(

          child: Container(
              height: 40,
              width: 90,
              color:Colors.blue,
              child:Center(
                  child:Text("Eliminate",style:TextStyle(color:Colors.white), textAlign: TextAlign.center,)
              )
          ),
          onPressed: () {
            game_state.eliminate();
          },
        )
      ];
      break;
    case 'Search':
      temp+=<Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          //"${game_state.names[turn]}, as the President, you have the power to investigate the role of a person, whether they be a Fascist or a Liberal."
          // child:Text(

          //   '${game_state.names[turn]},mr president, You can search role of a person that know it is fashist of liberal ',
          //   style: TextStyle(fontSize: 15),
          //   textAlign: TextAlign.center,
          // )
          child:RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style:TextStyle(color:Colors.black,fontSize: 20),
              children: <TextSpan>[
                TextSpan(text: '${game_state.names[game_state.turn]}, as the President,', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                TextSpan(text: ' you have the power to investigate the role of a person, whether they be a Fascist or a Liberal.'),

              ],
            ),
          ),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child:Text(
                      'Role Revealed:',
                      style: TextStyle(fontSize: 30)
                  )),
              DropdownButton<String>(
                value: game_state.willSearch,
                onChanged: (String? value) {
                  // first_selected=true;
                  print('$value');
                  // This is called when the user selects an item.
                  game_state.changeWillSearch(value!) ;
                  game_state.updatePage();
                },
                items:(game_state.candidateList()).map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

            ]

        ),
        TextButton(

          child: Container(
              height: 40,
              width: 90,
              color:Colors.blue,
              child:Center(
                  child:Text("Search!",style:TextStyle(color:Colors.white), textAlign: TextAlign.center,)
              )
          ),
          onPressed: () {
            showRoleDialog(context,game_state);
            game_state.changeState('base');
            game_state.nextRound();
            // first_selected=false;
            game_state.updatePage();
          },
        )
      ];
      break;
    case 'next-persident':
      temp+=<Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          //"${game_state.names[turn]}, as the President, you have the honor of selecting the next president!"
          // child:Text(
          //   '${game_state.names[turn]},mr president, You choose next president!',
          //   style: TextStyle(fontSize: 15),
          //   textAlign: TextAlign.center,
          // )
          child:RichText(
            text: TextSpan(
              style:TextStyle(color:Colors.black, fontSize: 20),
              children: <TextSpan>[
                TextSpan(text: '${game_state.names[game_state.turn]}, as the President,', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                TextSpan(text: 'you have the honor of selecting the next president!'),
              ],
            ),
          ),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child:Text(
                      'Next President: ',
                      style: TextStyle(fontSize: 20)
                  )),
              DropdownButton<String>(
                value: game_state.willresident,

                onChanged: (String? value) {
                  // first_selected=true;
                  print('$value');
                  // This is called when the user selects an item.
                  game_state.changeWillPresident(value!);
                  game_state.updatePage();
                },
                items:game_state.candidateList().map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

            ]
        ),
        TextButton(
          child: Container(
              height: 40,
              width: 90,
              color:Colors.blue,
              child:Center(
                  child:Text("Appoint!",style:TextStyle(color:Colors.white), textAlign: TextAlign.center,)
              )
          ),
          onPressed: () {
            game_state.specialRound();
            // // showRoleDialog(context,will_Search);
            // game_state.changeSpecial(true);
            // game_state.changeState('base');
            // //
            //
            //
            // game_state.changeOldRound(game_state.round);
            // //
            // game_state.first_starter=game_state.first_starter-1;
            // game_state.next_round();
            // // first_selected=false;
            // setState(() {});
          },
        )
      ];
      break;
  }
  return temp;
}

