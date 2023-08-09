import 'package:flutter/material.dart';
import 'dart:math';


class Game_state {

  int number_players=0;//
  int number_players_at_start=0;//
  int round=0;//
  int first_starter=0;
  List<String> fash_board=[];
  List<String> lib_board=[];
  bool top_tree_seen=false;
  
  List<String> names=[];//
  List<String> roles=[];//
  List<String> dec=[];//
  List<String> dis_dec=[];//
  String chancellor='';
  String state='';//
  int number_rejected=0;
  String last_chancellor='';
  String last_president='';
  int turn=0;
  List<List<String>> governments=[];
  List<String> chancellor_list=[];
  String selected_chancellor='';
  int president_selected=-1;
  int chancellor_selected=-1;
  String log='';

  
  Game_state({required this.names,required this.roles});

  void update_chancellor_list(){
    chancellor_list=[];
    for (int i = 0; i < names.length; i++) {
      if (i==turn || names[i]==last_chancellor || names[i]==last_president){
        continue;
      }
      chancellor_list.add(names[i]);
      
    }
    selected_chancellor=chancellor_list[0];
    

  }

  void set_up(){
    round=1;
    
    number_players_at_start= names.length;
    number_players=number_players_at_start;
    dec=[];
    for (int i = 0; i < 6; i++) {
      dec.add('lib');
    }
    for (int i = 0; i < 11; i++) {
      dec.add('fash');
    }
    dec=dec..shuffle();
    dis_dec=[];
    state='base';
    number_rejected=0;
    var rng = Random();
    first_starter=rng.nextInt(number_players);
    turn=(first_starter+round)%number_players;
    update_chancellor_list();

  }

  void next_round(){
    round=round=1;
    turn=(first_starter+round)%number_players;
    if(dec.length<=2){
        dec=dec+dis_dec;
        dec=dec..shuffle();
        dis_dec=[];
      }
    update_chancellor_list();
  }
  
  @override
  String toString() {
    return '''
    Game_state:
    round:${round}
    number_players:${number_players}
    dec:${dec}
    dis_dec:${dis_dec}
    number_rejected:${number_rejected}
    state:${state}
    turn:${turn}
    governments:${governments}
    selected_chancellor:${selected_chancellor}
    chancellor_list:${chancellor_list}
    ''';
  }
}


class Game extends StatefulWidget {
  final List<String> name;
  final List<String> roles;

  const Game({Key? key, required this.name, required this.roles}) : super(key: key);

  @override
  _Game createState() => _Game();
}
class _Game extends State<Game> {
  late Game_state game_state;
  int round = 0;
  int first_starter = 0;
  int number_players = 0;
  int number_players_at_start = 0;
  List<String> dec=[];
  List<String> dis_dec=[];
  String chancellor='';
  String will_killed='';
  String will_Search='';
  String will_president='';
  bool first_selected=false;
  String state='base';// elected
  int number_rejected=0;
  Map<int,dynamic> board_fash={
    5:['blank','blank','top-three','kill','kill_veto','fash'],
    6:['blank','blank','top-three','kill','kill_veto','fash'],
    7:['blank','Search','next-persident','kill','kill_veto','fash'],
    8:['blank','Search','next-persident','kill','kill_veto','fash'],
    9:['Search','Search','next-persident','kill','kill_veto','fash'],
    10:['Search','Search','next-persident','kill','kill_veto','fash'],
  };
  List<String> board_lib=['blank','blank','blank','blank','lib','lib'];
  // int president_selected=-1;
  int chancellor_selected=-1;
  List<String> fash_board=[];
  List<String> lib_board=[];
  bool top_tree_seen=false;
  bool is_hitler_alive=true;
  bool hitler_state=false;
  bool hitler_chancellor=false;
  bool special = false;
  bool hide = false;
  bool veto = false;
  bool posible_veto = false;
  int old_round=-1;
  String last_chancellor='';
  String last_president='';

  // bool last_done=true;


  @override
  initState() {
    game_state = Game_state(names: widget.name, roles: widget.roles);
    game_state.set_up();
    // print(game_state);

    // number_players_at_start= widget.name.length;
    // number_players = widget.name.length;
    // dec=[];
    // for (int i = 0; i < 6; i++) {
    //   dec.add('lib');
    // }
    // for (int i = 0; i < 11; i++) {
    //   dec.add('fash');
    // }
    // dec=dec..shuffle();
    // var rng = Random();
    // first_starter=rng.nextInt(number_players_at_start);
    // print("first_starter:${first_starter}");
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
          title: Text('Message'),
          // content: Text("You investigated ${name}, and their role is ${role}."),
          content:RichText(
                      text: TextSpan(
                        style:TextStyle(color:Colors.black),
                        children: <TextSpan>[
                          TextSpan(text: 'You investigated '),
                          TextSpan(text: '${name}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          TextSpan(text: ' and their role is '),
                          TextSpan(text: '${rool}.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

                        ],
                      ),
                    ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
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
          title: Text('Confirmation'),
          //"Please confirm your selection of ${name} as Chancellor."
          // content: Text('Are you sure you select ${name} as chancellor'),
          content:RichText(
                      text: TextSpan(
                        style:TextStyle(color:Colors.black),
                        children: <TextSpan>[
                          TextSpan(text: 'Please confirm your selection of '),
                          TextSpan(text: '${name}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          TextSpan(text: ' as Chancellor.'),
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
                      return AlertDialog(
                        title: Text('Election'),
                        content: Text("Has the election for the government concluded?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () {
                              first_selected=true;
                              if(veto && widget.roles[game_state.names.indexOf(name)]=='Liberal' && widget.roles[turn]=='Liberal'){
                                posible_veto=true;
                              }
                              game_state.state='elected';
                              game_state.president_selected=-1;
                              if(widget.roles[game_state.names.indexOf(name)]=='Hitler'&& hitler_state){
                                hitler_chancellor=true;
                              }
                              Navigator.of(context).pop();
                              setState(() { });

                            },
                          ),
                          TextButton(
                            child: Text('No'),
                            onPressed: () {

                              // round=round+1;
                              // first_selected=false;
                              game_state.number_rejected=game_state.number_rejected+1;
                              if(game_state.number_rejected==3){
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




  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(game_state);
    // print(game_state.names);
    // print(first_starter);
    // print(round);
    // print(old_round);
    // print(number_players);

    // print('last_president : ${last_president}');
    // print('last_chancellor : ${last_chancellor}');

    if(fash_board.length>2){
      hitler_state=true;
    }

 
    List<String> candidate_list=[...game_state.names];
    List<String> president_list=[...game_state.names];


    List<TableCell> fac_table = [];
    for (int i = 0; i < 6; i++) {

      fac_table.add(TableCell(
        verticalAlignment: TableCellVerticalAlignment.top,
        child: Container(
          child:game_state.fash_board.length>i?Image(image: AssetImage('assets/fash_policy.png')):(board_fash[game_state.number_players_at_start][i]=='blank'?null:Image(image: AssetImage('assets/'+board_fash[game_state.number_players_at_start][i]+'.png'))),
          height: 120,
          width: (width*0.95)/6,
          color: i>=3?Colors.red[900]:Colors.red,
        ),
      ));
    }
    List<TableCell> lib_table= [];
    for (int i = 0; i < 6; i++) {
      if(i==5){
        lib_table.add(TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,

        child: RotatedBox(
          quarterTurns: 1,
          child:Container(
          // child:lib_board.length>i?Image(image: AssetImage('assets/lib_policy.png')):(board_lib[i]=='blank'?null:Image(image: AssetImage('assets/'+board_lib[i]+'.png'))),

          child:board_lib[i]=='blank'?null:Image(color:Colors.blue[400],image: AssetImage('assets/'+board_lib[i]+'.png')),

          height: 70,
          width:(width*0.95)/6,
          color: Colors.white,
        ),
        )
      ));
      }
      else{
      lib_table.add(TableCell(
        verticalAlignment: TableCellVerticalAlignment.top,

        child: Container(
          child:game_state.lib_board.length>i?Image(image: AssetImage('assets/lib_policy.png')):(board_lib[i]=='blank'?null:Image(image: AssetImage('assets/'+board_lib[i]+'.png'))),

          // child:board_lib[i]=='blank'?null:Image(image: AssetImage('assets/'+board_lib[i]+'.png')),

          height: 120,
          width:(width*0.95)/6,
          color: Colors.blue[400],
        ),
      ));
      }
    }


    // print("president_selected : ${president_selected}");

    // if(lib_board.length==5 || !is_hitler_alive){
    //   state='lib win';

    // }
    // if(fash_board.length==6 || hitler_chancellor ){
    //   state='fash win';

    // }

    return Scaffold(
      appBar: AppBar(
        title: Text('Game'),
      ),
      body:
      SingleChildScrollView(
          child:Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                SizedBox(height: 8.0),
                RichText(
                  text: TextSpan(
                    style:TextStyle(color:Colors.black,fontSize: 18),
                    children: <TextSpan>[
                      if (game_state.last_president!='')... [
                      TextSpan(text: 'Last president: '),
                      TextSpan(text: '${game_state.last_president}\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ],
                      if (game_state.last_chancellor!='')... [
                      TextSpan(text: 'Last chancellor: '),
                      TextSpan(text: '${game_state.last_chancellor}\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          
                      ]
                    ],
                  ),
                ),


                if ((hitler_state&& (state!='lib win' && state!='fash win'))) ...<Widget>[
                  Padding(
                        padding: EdgeInsets.all(8.0),
                        child:Text(
                  "We stand at a precipice of danger; should Hitler ascend as Chancellor, the forces of fascism shall claim victory.",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                  )
                ],

                if (!(state!='lib win' && state!='fash win')) Text(
                    (state=='lib win')? "Liberals Win the Game" : "Fascists Win the Game",
                    style: TextStyle(fontSize: 30),
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
                    TableRow(children: fac_table),
                    TableRow(children: lib_table),
                  ]
                )
                ),
                SizedBox(height: 8.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children:
                  [0,1,2,3].asMap().entries.map((entry)=>
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child:ClipOval(
                        child: Material(
                          child: Container(

                            decoration: BoxDecoration(
                              color:entry.key==number_rejected?Colors.blueAccent:Colors.white,
                              border: Border.all(width: 5.0,color: entry.key==3?Colors.red:Colors.blueAccent,),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
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
                )
                ]+
                  (game_state.state!='base'?<Widget>[]:<Widget>[
                Padding(
                    padding: EdgeInsets.all(8.0),
                    //"Round 3 has begun."
                    //"Jack, select your Chancellor for the upcoming election."
                    // child:Text(
                    //     'It is round ${(round+1).toString()}\n ${game_state.names[turn]} must choose Chancellor',
                    //     style: TextStyle(fontSize: 20),
                    //     textAlign: TextAlign.center,
                    // )
                    child:RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style:TextStyle(color:Colors.black,fontSize: 20),
                        children: <TextSpan>[
                          TextSpan(text: 'Round '),
                          TextSpan(text: '${game_state.round+1}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
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
                    Padding(
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

              ]
                  )+
                  (game_state.state!='elected'?<Widget>[]:<Widget>[
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
            ]
                  )+
                  (game_state.state!='president_discarded'?<Widget>[]:<Widget>[
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
                          if(board_fash[game_state.number_players_at_start][game_state.fash_board.length-1]!='blank'){
                            print('it is ${board_fash[game_state.number_players_at_start][game_state.fash_board.length-1]} state');
                            game_state.state=board_fash[game_state.number_players_at_start][game_state.fash_board.length-1];
                            if (state=='kill_veto'){
                              game_state.state='kill';
                              veto=true;
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
                        // if(game_state.dec.length==2){
                        //   dec=game_state.dec+dis_dec;
                        //   dec=dec..shuffle();
                        //   dis_dec=[];
                        // }
                        
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
                          (!posible_veto?<Widget>[]:<Widget>[
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
                                dis_dec.add(dec.removeAt(0));
                                dis_dec.add(dec.removeAt(0));
                                if(dec.length==2){
                                  dec=dec+dis_dec;
                                  dec=dec..shuffle();
                                  dis_dec=[];
                                }
                                posible_veto=false;
                                state='base';
                                round=round+1;
                                first_selected=false;
                                setState((){});
                              },
                            )

                          ])

                    )

                  ]
                  )+
                  (game_state.state!='top-three'?<Widget>[]:<Widget>[
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
                  ]
                  )+
                  ((game_state.state!='kill'&&game_state.state!='kill_veto')?<Widget>[]:<Widget>[
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
                              if(state=='kill_veto') TextSpan(text: "When both the President and Chancellor, both loyal to the Liberals, concur, the Veto option becomes viable."),
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
                            value: will_killed,

                            onChanged: (String? value) {
                              first_selected=true;
                              print('$value');
                              // This is called when the user selects an item.
                              setState(() {
                                will_killed = value!;
                              });
                            },
                            items:candidate_list.map<DropdownMenuItem<String>>((String value) {
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
                              if(first_starter+round/number_players>=1){
                                first_starter=((first_starter+round)%number_players)-round;

                              }
                              var index=game_state.names.indexOf(will_killed);
                              if(widget.roles[index]=='Hitler'){
                                is_hitler_alive=false;
                              }
                              game_state.names.removeAt(index);
                              widget.roles.removeAt(index);
                              number_players = game_state.names.length;
                              first_selected=false;
                              state='base';

                              round=round+1;


                              setState(() {});
                            },
                          )
                  ]
                  )+
                  (state!='Search'?<Widget>[]:<Widget>[
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
                            value: will_Search,

                            onChanged: (String? value) {
                              first_selected=true;
                              print('$value');
                              // This is called when the user selects an item.
                              setState(() {
                                will_Search = value!;
                              });
                            },
                            items:candidate_list.map<DropdownMenuItem<String>>((String value) {
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
                              showRoleDialog(context,will_Search);
                              state='base';

                              round=round+1;

                              first_selected=false;
                              setState(() {});
                            },
                          )
                  ]
                  )+
                  (game_state.state!='next-persident'?<Widget>[]:<Widget>[
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
                            value: will_president,

                            onChanged: (String? value) {
                              first_selected=true;
                              print('$value');
                              // This is called when the user selects an item.
                              setState(() {
                                will_president = value!;
                              });
                            },
                            items:president_list.map<DropdownMenuItem<String>>((String value) {
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
                              special=true;
                              state='base';
                              //

                              round=round+1;
                              old_round=round;
                              //
                              first_starter=first_starter-1;
                              first_selected=false;
                              setState(() {});
                            },
                          )
                  ]
                  )
            ,
          )
        )
      )

      );


  }
}