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
  List<String> dec=[];
  String chancellor='';
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


  @override
  initState() {
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
    int turn=(first_starter+round)%number_players;
    print(turn);
    print(dec);
    List<String> chancellor_list=[...widget.name];
    chancellor_list.remove(chancellor_list[turn]);
    if(!first_selected) {
      chancellor = widget.name[(turn+1) % number_players];
    }
    print("chancellor : ${chancellor}");
    print("chancellor list : ${chancellor_list}");


    List<TableCell> fac_table = [];
    for (int i = 0; i < 6; i++) {

      fac_table.add(new TableCell(
        verticalAlignment: TableCellVerticalAlignment.top,
        child: Container(
          child:board_fash[number_players][i]=='blank'?null:Image(image: AssetImage('assets/'+board_fash[number_players][i]+'.png')),
          height: 120,
          width: 60,
          color: Colors.red,
        ),
      ));
    }
    List<TableCell> lib_table= [];
    for (int i = 0; i < 6; i++) {
      lib_table.add(new TableCell(
        verticalAlignment: TableCellVerticalAlignment.top,

        child: Container(
          child:board_lib[i]=='blank'?null:Image(image: AssetImage('assets/'+board_lib[i]+'.png')),

          height: 120,
          width: 60,
          color: Colors.blue[400],
        ),
      ));
    }

    if (state=='elected'){

    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Roll Assigning'),
      ),
      body:Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[

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
                    onTap: () {print('hi');},
                  child:Container(
                    child:Image(image: AssetImage('assets/'+entry.value+'.png')),
                    color :entry.value=='lib'?Colors.blue[400]:Colors.red,
                    height: 150,
                    width: 80,
                  ),

                )
            )
        ).toList(),
        )
      ]
                  ),
          )
        )
      );


  }
}