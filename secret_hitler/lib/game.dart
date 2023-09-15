import 'package:flutter/material.dart';
import 'package:secret_hitler/Game_state.dart';


class Game extends StatefulWidget {
  final List<String> name;
  final List<String> roles;

  const Game({Key? key, required this.name, required this.roles}) : super(key: key);

  @override
  _Game createState() => _Game();
}
class _Game extends State<Game> {
  late Game_state game_state;
  bool hide = false;

  @override
  initState() {
    game_state = Game_state(names: widget.name, roles: widget.roles);
    game_state.set_up();

    setState(() {});
  }

  void showRoleDialog(BuildContext context,String name) {
    showDialog(
      context: context,
      barrierDismissible:false,
      builder: (BuildContext context) {
        String rool='';
        if (widget.roles[game_state.names.indexOf(name)]=='Liberal'){
          rool='Liberal';
        }
        else{
          rool='Fascist';
        }
        return AlertDialog(
          title: const Text('Message'),
          // content: Text("You investigated ${name}, and their role is ${role}."),
          content:RichText(
                      text: TextSpan(
                        style:const TextStyle(color:Colors.black),
                        children: <TextSpan>[
                          const TextSpan(text: 'You investigated '),
                          TextSpan(text: name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const TextSpan(text: ' and their role is '),
                          TextSpan(text: '$rool.', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

                        ],
                      ),
                    ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showMessageDialog(BuildContext context,String name,int turn) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          //"Please confirm your selection of ${name} as Chancellor."
          // content: Text('Are you sure you select ${name} as chancellor'),
          content:RichText(
                      text: TextSpan(
                        style:const TextStyle(color:Colors.black),
                        children: <TextSpan>[
                          const TextSpan(text: 'Please confirm your selection of '),
                          TextSpan(text: name, style:const  TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const TextSpan(text: ' as Chancellor.'),
                        ],
                      ),
                    ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {

                Navigator.of(context).pop();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Election'),
                        content: const Text("Has the election for the government concluded?"),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Yes'),
                            onPressed: () {
                              // first_selected=true;
                              if(game_state.veto && widget.roles[game_state.names.indexOf(name)]=='Liberal' && widget.roles[turn]=='Liberal'){
                                game_state.posible_veto=true;
                              }
                              game_state.state='elected';
                              game_state.president_selected=-1;
                              if(widget.roles[game_state.names.indexOf(name)]=='Hitler'&& game_state.hitler_state){
                                game_state.hitler_chancellor=true;

                              }
                              game_state.number_rejected=0;
                              Navigator.of(context).pop();
                              setState(() { });

                            },
                          ),
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {

                              // round=round+1;
                              // first_selected=false;
                              game_state.number_rejected+=1;
                              if(game_state.number_rejected==3){
                                game_state.chaos=true;
                                game_state.number_rejected=0;
                                if(game_state.dec[0]=='fash'){
                                  game_state.fash_board.add('Done');

                                }
                                else if(game_state.dec[0]=='lib'){
                                  game_state.lib_board.add('Done');

                                }
                                game_state.dec.removeAt(0);
                                

                              }
                              game_state.next_round();
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


  List <Widget> get_ui_state(width,height){
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
                  value: game_state.selected_chancellor,

                  onChanged: (String? value) {
                    // first_selected=true;
                    print('$value');
                    // This is called when the user selects an item.
                    setState(() {
                      game_state.selected_chancellor = value!;
                    });
                  },
                  items:game_state.chancellor_list.map<DropdownMenuItem<String>>((String value) {
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
              showMessageDialog(context,game_state.selected_chancellor,game_state.turn);
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
                        print("entry.key: ${entry.key}");
                        game_state.president_selected=entry.key;
                        setState(() {});
                      },
                      child:Container(
                        decoration: BoxDecoration(
                            color :entry.value=='lib'?Colors.blue[400]:Colors.red,
                            border: game_state.president_selected!=entry.key?null:Border.all(width: 5.0,color: Colors.blueAccent)
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
              game_state.last_president=game_state.names[game_state.turn];
              game_state.state='president_discarded';
              game_state.chancellor_selected=-1;
              game_state.log=game_state.log+"${game_state.names[game_state.turn]} discard:${game_state.dec[game_state.president_selected]}\n";
              game_state.dis_dec.add(game_state.dec.removeAt(game_state.president_selected));

              setState(() {});
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
                  TextSpan(text: '${game_state.selected_chancellor},', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  TextSpan(text: ' entrusted as the'),
                  TextSpan(text: ' Chancellor,', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  TextSpan(text: ' graciously pick a card to shape our policy.'),

                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[]+(hide?['hide','hide']:game_state.dec.sublist(0, 2)).asMap().entries.map((entry)=>
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(

                      onTap: () {
                        print("entry.key: ${entry.key}");
                        game_state.chancellor_selected=entry.key;
                        setState(() {});
                      },
                      child:Container(
                        decoration: BoxDecoration(
                            color : (entry.value=='hide'?Colors.grey[400]:(entry.value=='lib'?Colors.blue[400]:Colors.red)),
                            border: game_state.chancellor_selected!=entry.key?null:Border.all(width: 5.0,color: Colors.blueAccent)
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
                if(!hide)TextButton(
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
                    game_state.last_chancellor=game_state.selected_chancellor;
                    game_state.log=game_state.log+"${game_state.selected_chancellor} play:${game_state.dec[game_state.chancellor_selected]}\n";
                    if(game_state.dec[game_state.chancellor_selected]=='fash'){
                      game_state.fash_board.add('Done');
                      if(game_state.board_fash[game_state.number_players_at_start][game_state.fash_board.length-1]!='blank'){
                        print('it is ${game_state.board_fash[game_state.number_players_at_start][game_state.fash_board.length-1]} state');
                        game_state.state=game_state.board_fash[game_state.number_players_at_start][game_state.fash_board.length-1];
                        if (game_state.state=='kill_veto'){
                          game_state.state='kill';
                          game_state.veto=true;
                        }
                        if (game_state.state=='Search'){
                          game_state.will_Search=game_state.candidate_list()[0];
                        }
                        if (game_state.state=='next-persident'){
                          game_state.will_president=game_state.candidate_list()[0];
                        }
                        if (game_state.state=='kill'){
                          game_state.will_killed=game_state.candidate_list()[0];
                        }

                      }
                      else {
                        game_state.state = 'base';
                        game_state.next_round();
                        // round=round+1;
                      }
                    }
                    else if(game_state.dec[game_state.chancellor_selected]=='lib'){
                      game_state.lib_board.add('Done');
                      game_state.state = 'base';
                      game_state.next_round();
                      // round=round+1;
                    }

                    game_state.dec.removeAt(game_state.chancellor_selected);
                    game_state.dis_dec.add(game_state.dec.removeAt(0));

                    if(game_state.dec.length==2){
                      game_state.dec=game_state.dec+game_state.dis_dec;
                      game_state.dec=game_state.dec..shuffle();
                      game_state.dis_dec=[];
                    }

                    setState(() {});
                  },
                ),
                TextButton(
                  child: Container(
                      height: 40,
                      width: 80,
                      color:Colors.blue,
                      child:Center(
                          child:Text(hide?'Unhide!':'Hide!',style:TextStyle(color:Colors.white), textAlign: TextAlign.center,)
                      )
                  ),
                  onPressed: () {
                    hide= !hide;
                    setState((){});
                  },
                )

              ] +
                  (!game_state.posible_veto?<Widget>[]:<Widget>[
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
                        game_state.do_veto();
                        game_state.next_round();
                        // first_selected=false;
                        setState((){});
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
                  child: !game_state.top_tree_seen?null:Container(
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
                    child:Text(game_state.top_tree_seen?"I've Seen":'Show cards',style:TextStyle(color:Colors.white), textAlign: TextAlign.center,)
                )
            ),
            onPressed: () {
              if(!game_state.top_tree_seen) {
                game_state.top_tree_seen = true;
              }
              else{
                game_state.top_tree_seen = false;
                game_state.state='base';
                game_state.next_round();
                // round=round+1;
                // first_selected=false;

              }
              setState(() {});
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
                  value: game_state.will_killed,

                  onChanged: (String? value) {
                    // first_selected=true;
                    print('$value');
                    // This is called when the user selects an item.
                    setState(() {
                      game_state.will_killed = value!;
                    });
                  },
                  items:game_state.candidate_list().map<DropdownMenuItem<String>>((String value) {
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
              if(game_state.first_starter+game_state.round/game_state.number_players>=1){
                game_state.first_starter=((game_state.first_starter+game_state.round)%game_state.number_players)-game_state.round;

              }
              var index=game_state.names.indexOf(game_state.will_killed);
              if(game_state.roles[index]=='Hitler'){
                game_state.is_hitler_alive=false;
              }
              game_state.names.removeAt(index);
              game_state.roles.removeAt(index);
              game_state.number_players = game_state.names.length;
              // first_selected=false;
              game_state.state='base';
              game_state.first_starter-=1;
              game_state.next_round();

              // round=round+1;


              setState(() {});
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
                  value: game_state.will_Search,

                  onChanged: (String? value) {
                    // first_selected=true;
                    print('$value');
                    // This is called when the user selects an item.
                    setState(() {
                      game_state.will_Search = value!;
                    });
                  },
                  items:(game_state.candidate_list()).map<DropdownMenuItem<String>>((String value) {
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
              showRoleDialog(context,game_state.will_Search);
              game_state.state='base';

              game_state.next_round();

              // first_selected=false;
              setState(() {});
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
                  value: game_state.will_president,

                  onChanged: (String? value) {
                    // first_selected=true;
                    print('$value');
                    // This is called when the user selects an item.
                    setState(() {
                      game_state.will_president = value!;
                    });
                  },
                  items:game_state.candidate_list().map<DropdownMenuItem<String>>((String value) {
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
              // showRoleDialog(context,will_Search);
              game_state.special=true;
              game_state.state='base';
              //


              game_state.old_round=game_state.round;
              //
              game_state.first_starter=game_state.first_starter-1;
              game_state.next_round();
              // first_selected=false;
              setState(() {});
            },
          )
        ];
        break;
    }
    return temp;
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    game_state.end_game();
    print(game_state);


    List<TableCell> facTable = game_state.get_fac_table(width);

    List<TableCell> libTable= game_state.get_lib_table(width);

    List <Widget>  uiState = get_ui_state(width,height);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
      ),
      body:
      SingleChildScrollView(
          child:Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                const SizedBox(height: 8.0),
                RichText(
                  text: TextSpan(
                    style:const TextStyle(color:Colors.black,fontSize: 18),
                    children: <TextSpan>[
                      if (game_state.last_president!='')... [
                        const TextSpan(text: 'Last president: '),
                      TextSpan(text: '${game_state.last_president}\n', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ],
                      if (game_state.last_chancellor!='')... [
                        const TextSpan(text: 'Last chancellor: '),
                      TextSpan(text: '${game_state.last_chancellor}\n', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          
                      ]
                    ],
                  ),
                ),


                if ((game_state.hitler_state&& (game_state.state!='lib win' && game_state.state!='fash win'))) ...<Widget>[
                  const Padding(
                        padding: EdgeInsets.all(8.0),
                        child:Text(
                  "We stand at a precipice of danger; should Hitler ascend as Chancellor, the forces of fascism shall claim victory.",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                  )
                ],

                if (!(game_state.state!='lib win' && game_state.state!='fash win'))
                  Text(
                    (game_state.state=='lib win')? "Liberals Win the Game" : "Fascists Win the Game",
                    style: const TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),


                InteractiveViewer(
                    boundaryMargin: const EdgeInsets.all(1.0),
                    minScale: 0.1,
                    maxScale: 3,
                    child:Table(
                  border: TableBorder.all(
                    // color:Colors.white,
                    // width:2
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
                ),
                const SizedBox(height: 8.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children:
                  [0,1,2,3].asMap().entries.map((entry)=>
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:ClipOval(
                        child: Material(
                          child: Container(

                            decoration: BoxDecoration(
                              color:entry.key==game_state.number_rejected?Colors.blueAccent:Colors.white,
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
                ),

                ]
                  +uiState
            ,
          )
        )
      )

      );


  }
}