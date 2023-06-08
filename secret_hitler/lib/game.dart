import 'package:flutter/material.dart';
// RollAssigning(name: widget.data,roles:roles)
class Game extends StatefulWidget {
  final List<String> name;
  final List<String> roles;

  const Game({Key? key, required this.name, required this.roles}) : super(key: key);

  @override
  _Game createState() => _Game();
}
class _Game extends State<Game> {
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
  List<String> board_lib=['blank','blank','blank','blank','blank','lib'];
  int president_selected=-1;
  int chancellor_selected=-1;
  List<String> fash_board=[];
  List<String> lib_board=[];
  bool top_tree_seen=false;
  bool is_hitler_alive=true;
  bool hitler_state=false;
  bool hitler_chancellor=false;
  bool special = false;
  int old_round=-1;


  @override
  initState() {
    number_players_at_start= widget.name.length;
    number_players = widget.name.length;
    dec=[];
    for (int i = 0; i < 6; i++) {
      dec.add('lib');
    }
    for (int i = 0; i < 11; i++) {
      dec.add('fash');
    }
    dec=dec..shuffle();
    setState(() {});
  }

  void showRoleDialog(BuildContext context,String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String rool='';
        if (widget.roles[widget.name.indexOf(name)]=='Liberal'){
          rool='Liberal';
        }
        else{
          rool='Fascist';
        }
        return AlertDialog(
          title: Text('Message'),
          content: Text('You searched ${name} and it is ${rool}'),
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

  void showMessageDialog(BuildContext context,String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message'),
          content: Text('Are you sure you select ${name} ad chancellor'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {

                Navigator.of(context).pop();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Message'),
                        content: Text('is the Government got elected?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () {
                              first_selected=false;
                              state='elected';
                              president_selected=-1;
                              if(widget.roles[widget.name.indexOf(name)]=='Hitler'&& hitler_state){
                                hitler_chancellor=true;
                              }
                              Navigator.of(context).pop();
                              setState(() { });

                            },
                          ),
                          TextButton(
                            child: Text('No'),
                            onPressed: () {
                              round=round+1;
                              number_rejected=number_rejected+1;
                              if(number_rejected==3){
                                number_rejected=0;
                                if(dec[0]=='fash'){
                                  fash_board.add('Done');

                                }
                                else if(dec[0]=='lib'){
                                  lib_board.add('Done');

                                }
                                dec.removeAt(0);

                              }
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
    print(widget.name);
    print(first_starter);
    print(round);
    print(old_round);
    print(number_players);

    if(fash_board.length>2){
      hitler_state=true;
    }

    int turn=(first_starter+round)%number_players;
    if(special &&(round-old_round!=1)){
      print('will_president : ${will_president}');
      turn=widget.name.indexOf(will_president);
    }
    print(turn);
    print('dec : ${dec}');
    print('dis_dec : ${dis_dec}');
    List<String> chancellor_list=[...widget.name];
    List<String> president_list=[...widget.name];
    chancellor_list.remove(chancellor_list[turn]);
    if(state=='next-persident') {
      president_list.remove(widget.name[turn]);
      president_list.remove(widget.name[widget.name.indexOf(chancellor)]);
    }
    if(!first_selected && !special) {
      chancellor = widget.name[(turn+1) % number_players];
      will_killed= widget.name[(turn+1) % number_players];
      will_Search= widget.name[(turn+1) % number_players];
      will_president=president_list[(turn+1) % number_players];
    }
    print("chancellor : ${chancellor}");
    print('chancellor_selected : ${chancellor_selected}');
    print("chancellor list : ${chancellor_list}");
    print("president list : ${president_list}");

    print('fash_board : ${fash_board}');


    List<TableCell> fac_table = [];
    for (int i = 0; i < 6; i++) {

      fac_table.add(new TableCell(
        verticalAlignment: TableCellVerticalAlignment.top,
        child: Container(
          child:fash_board.length>i?Image(image: AssetImage('assets/fash_policy.png')):(board_fash[number_players_at_start][i]=='blank'?null:Image(image: AssetImage('assets/'+board_fash[number_players_at_start][i]+'.png'))),
          height: 120,
          width: 60,
          color: i>=3?Colors.red[900]:Colors.red,
        ),
      ));
    }
    List<TableCell> lib_table= [];
    for (int i = 0; i < 6; i++) {
      lib_table.add(new TableCell(
        verticalAlignment: TableCellVerticalAlignment.top,

        child: Container(
          child:lib_board.length>i?Image(image: AssetImage('assets/lib_policy.png')):(board_lib[i]=='blank'?null:Image(image: AssetImage('assets/'+board_lib[i]+'.png'))),

          // child:board_lib[i]=='blank'?null:Image(image: AssetImage('assets/'+board_lib[i]+'.png')),

          height: 120,
          width: 60,
          color: Colors.blue[400],
        ),
      ));
    }


    print("president_selected : ${president_selected}");

    if(lib_board.length==6 || !is_hitler_alive){
      state='lib win';

    }
    if(fash_board.length==6 || hitler_chancellor ){
      state='fash win';

    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Game'),
      ),
      body:
      Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[

                SizedBox(height: 16.0),
                Text(
                  (hitler_state&& (state!='lib win' && state!='fash win'))?'we are in a dangerous state if hitler became a chancellor fashists will win the game ':'',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                Text(
                  (state!='lib win' && state!='fash win')?'':'${state}s the game',
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                InteractiveViewer(
                    boundaryMargin: const EdgeInsets.all(1.0),
                    minScale: 0.1,
                    maxScale: 2,
                    child:Table(
                  border: TableBorder.all(),
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
                  (state!='base'?<Widget>[]:<Widget>[
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child:Text(
                        'It is round ${(round+1).toString()}\n ${widget.name[turn]} must choose Chancellor',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                    )
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child:Text(
                      'Chancellor:',
                      style: TextStyle(fontSize: 30)
                    )),
                    DropdownButton<String>(
                      value: chancellor,

                      onChanged: (String? value) {
                        first_selected=true;
                        print('$value');
                        // This is called when the user selects an item.
                        setState(() {
                          chancellor = value!;
                        });
                      },
                      items:chancellor_list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    TextButton(
                        child: Container(
                          color:Colors.blue,
                            child:Text('Selected!',style:TextStyle(color:Colors.white))
                        ),
                        onPressed: () {
                          showMessageDialog(context,chancellor);
                        },
                    )
                  ]
                )

              ]
                  )+
                  (state!='elected'?<Widget>[]:<Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child:Text(
              '${widget.name[turn]},mr president, pick a card to get discarded',
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[]+dec.sublist(0, 3).asMap().entries.map((entry)=>
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        // highlightColor:Colors.black,
                        //   hoverColor:Colors.yellow,
                          onTap: () {
                            print("entry.key: ${entry.key}");
                            president_selected=entry.key;
                            setState(() {});
                            },
                        child:Container(
                          decoration: BoxDecoration(
                              color :entry.value=='lib'?Colors.blue[400]:Colors.red,
                              border: president_selected!=entry.key?null:Border.all(width: 5.0,color: Colors.blueAccent)
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
                      child:Text('Selected!',style:TextStyle(color:Colors.white), textAlign: TextAlign.center,)
                  )
              ),
              onPressed: () {
                state='president_discarded';
                chancellor_selected=-1;
                dis_dec.add(dec.removeAt(president_selected));
                setState(() {});
              },
            )
            ]
                  )+
                  (state!='president_discarded'?<Widget>[]:<Widget>[
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child:Text(
                          '${chancellor},mr chancellor, pick a card to select policy',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:<Widget>[]+dec.sublist(0, 2).asMap().entries.map((entry)=>
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: InkWell(

                                onTap: () {
                                  print("entry.key: ${entry.key}");
                                  chancellor_selected=entry.key;
                                  setState(() {});
                                },
                                child:Container(
                                  decoration: BoxDecoration(
                                      color :entry.value=='lib'?Colors.blue[400]:Colors.red,
                                      border: chancellor_selected!=entry.key?null:Border.all(width: 5.0,color: Colors.blueAccent)
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
                              child:Text('Selected!',style:TextStyle(color:Colors.white), textAlign: TextAlign.center,)
                          )
                      ),
                      onPressed: () {

                        if(dec[chancellor_selected]=='fash'){
                          fash_board.add('Done');
                          if(board_fash[number_players_at_start][fash_board.length-1]!='blank'){
                            print('it is ${board_fash[number_players_at_start][fash_board.length-1]} state');
                            state=board_fash[number_players_at_start][fash_board.length-1];
                          }
                          else {
                            state = 'base';
                            round=round+1;
                          }
                        }
                        else if(dec[chancellor_selected]=='lib'){
                          lib_board.add('Done');
                          state = 'base';
                          round=round+1;
                        }

                        dec.removeAt(chancellor_selected);
                        dis_dec.add(dec.removeAt(0));
                        if(dec.length==2){
                          dec=dec+dis_dec;
                          dec=dec..shuffle();
                          dis_dec=[];
                        }
                        setState(() {});
                      },
                    )
                  ]
                  )+
                  (state!='top-three'?<Widget>[]:<Widget>[
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child:Text(
                          '${widget.name[turn]},mr president, If you are ready you can see top three dec',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:<Widget>[]+dec.sublist(0, 3).asMap().entries.map((entry)=>
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: !top_tree_seen?null:Container(
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
                          width: 80,
                          color:Colors.blue,
                          child:Center(
                              child:Text(top_tree_seen?'Ok':'Show cards',style:TextStyle(color:Colors.white), textAlign: TextAlign.center,)
                          )
                      ),
                      onPressed: () {
                        if(!top_tree_seen) {
                          top_tree_seen = true;
                        }
                        else{
                          top_tree_seen = false;
                          state='base';
                          round=round+1;
                        }
                        setState(() {});
                      },
                    )
                  ]
                  )+
                  ((state!='kill'&&state!='kill_veto')?<Widget>[]:<Widget>[
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child:Text(
                          '${widget.name[turn]},mr president, If you are ready you can kill a person if you kill the hitler liberals will win ',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        )
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child:Text(
                                  'who will killed:',
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
                            items:chancellor_list.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          TextButton(
                            child: Container(
                                color:Colors.blue,
                                child:Text('Kill!',style:TextStyle(color:Colors.white))
                            ),
                            onPressed: () {
                              if(first_starter+round/number_players>=1){
                                first_starter=((first_starter+round)%number_players)-round;

                              }
                              var index=widget.name.indexOf(will_killed);
                              if(widget.roles[index]=='Hitler'){
                                is_hitler_alive=false;
                              }
                              widget.name.removeAt(index);
                              widget.roles.removeAt(index);
                              number_players = widget.name.length;
                              first_selected=false;
                              state='base';

                              round=round+1;


                              setState(() {});
                            },
                          )
                        ]
                    )
                  ]
                  )+
                  (state!='Search'?<Widget>[]:<Widget>[
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child:Text(
                          '${widget.name[turn]},mr president, You can search role of a person that know it is fashist of liberal ',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        )
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child:Text(
                                  'whose side:',
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
                            items:chancellor_list.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          TextButton(
                            child: Container(
                                color:Colors.blue,
                                child:Text('Search!',style:TextStyle(color:Colors.white))
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
                    )
                  ]
                  )+
                  (state!='next-persident'?<Widget>[]:<Widget>[
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child:Text(
                          '${widget.name[turn]},mr president, You choose next president!',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        )
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child:Text(
                                  'It will be next president:',
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
                          TextButton(
                            child: Container(
                                color:Colors.blue,
                                child:Text('Go!',style:TextStyle(color:Colors.white))
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
                  ]
                  )
            ,
          )
        )

      );


  }
}