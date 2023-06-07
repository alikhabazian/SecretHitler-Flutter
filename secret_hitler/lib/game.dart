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


  @override
  initState() {
    number_players = widget.name.length;
    dec=[];
    for (int i = 0; i < 6; i++) {
      dec.add('Lib');
    }
    for (int i = 0; i < 11; i++) {
      dec.add('Fas');
    }
    dec=dec..shuffle();
    setState(() {});
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Roll Assigning'),
      ),
      body:Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[

                SizedBox(height: 16.0),
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
                        onPressed: () { },
                    )
                  ]
                )

              ],
          )
        )
      );


  }
}