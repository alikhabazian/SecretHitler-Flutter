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
  bool first_selected=false;
  String state='base';// elected
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
                              state='elected';
                              president_selected=-1;
                              Navigator.of(context).pop();
                              setState(() { });

                            },
                          ),
                          TextButton(
                            child: Text('No'),
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




  @override
  Widget build(BuildContext context) {
    print(widget.name);
    print(first_starter);
    print(round);
    print(number_players);

    bool hitler_state=false;
    if(fash_board.length>2){
      hitler_state=true;
    }

    int turn=(first_starter+round)%number_players;
    print(turn);
    print('dec : ${dec}');
    print('dis_dec : ${dis_dec}');
    List<String> chancellor_list=[...widget.name];
    chancellor_list.remove(chancellor_list[turn]);
    if(!first_selected) {
      chancellor = widget.name[(turn+1) % number_players];
      will_killed= widget.name[(turn+1) % number_players];
    }
    print("chancellor : ${chancellor}");
    print("chancellor list : ${chancellor_list}");

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Game'),
      ),
      body:Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[

                SizedBox(height: 16.0),
                Text(
                  hitler_state?'we are in a dangerous state if hitler became a chancellor fashists will win the game ':'',
                  style: TextStyle(fontSize: 15),
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
                ClipOval(
                  child: Material(
                    color: Colors.red,
                    child: Container(
                      child: Text(
                        '1',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      height: 25.0,
                      width: 25.0,
                      color: Colors.blue,
                    ),
                  ),
                ),]+
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

              ])+
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
                    '${widget.name[turn]},mr chancellor, pick a card to select policy',
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
            )
            ,
          )
        )
      );


  }
}