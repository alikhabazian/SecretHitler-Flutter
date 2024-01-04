import 'package:flutter/material.dart';
import 'package:secret_hitler/Game_state.dart';
import 'package:provider/provider.dart';
import 'package:secret_hitler/state_management.dart';
import 'package:secret_hitler/gameFunctions.dart';
import 'package:secret_hitler/gameUIFunctions.dart';



class Game extends StatefulWidget {
  final List<String> name;
  final List<String> roles;

  const Game({Key? key, required this.name, required this.roles}) : super(key: key);

  @override
  _Game createState() => _Game();
}
class _Game extends State<Game> {
  late GameState gameState;
  bool hide = false;

  @override
  initState() {
    gameState = Provider.of<GameState>(context);
    // game_state = Game_state(names: widget.name, roles: widget.roles);
    gameState.setUp(widget.name,widget.roles);
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





  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    gameState.endGame();
    print(gameState);


    List<TableCell> facTable = generateFacTable(width,gameState.fashBoard,gameState.boardFash,gameState.numberPlayersInitial);
    List<TableCell> libTable= generateLibTable(width, gameState.libBoard, gameState.boardLib);

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
                    lastStatus(gameState.lastPresident,gameState.lastChancellor),
                    dangerZone(gameState.hitlerState,gameState.state),
                    winState(gameState.state),
                    tableBoard(facTable,libTable),
                    const SizedBox(height: 8.0),
                    failedElection(gameState.numberRejected),


                  ]
                      +uiState
                  ,
                )
            )
        )

    );


  }
}