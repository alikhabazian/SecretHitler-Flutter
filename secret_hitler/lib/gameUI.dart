import 'package:flutter/material.dart';
// import 'package:secret_hitler/Game_state.dart';
import 'package:provider/provider.dart';
import 'package:secret_hitler/state_management.dart';
import 'package:secret_hitler/gameFunctions.dart';
import 'package:secret_hitler/gameUIFunctions.dart';
import 'package:secret_hitler/tester.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Game extends StatefulWidget {

  const Game({Key? key}) : super(key: key);

  @override
  _Game createState() => _Game();
}
class _Game extends State<Game> {
  late GameState gameState;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool activeTester=false;
  // bool hide = false;



  @override
  initState() {
    print("initState");
    gameState = Provider.of<GameState>(context,listen: false);
    // game_state = Game_state(names: widget.name, roles: widget.roles);
    // if(!gameState.continuegame) {
    //   gameState.setUp(widget.name);
    // }
    print("initState after setUp");
    super.initState();
    _prefs.then((SharedPreferences prefs) {
        gameState.updateSharedPreferences(prefs);
    });

  }



  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        // return Text('Total price: ${cart.totalPrice}');

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    gameState.endGame();
    print(gameState);


    List<TableCell> facTable = generateFacTable(width,gameState.fashBoard,gameState.boardFash,gameState.numberPlayersInitial);
    List<TableCell> libTable= generateLibTable(width, gameState.libBoard, gameState.boardLib);

    List <Widget>  uiState = getUiState(context,width,height,gameState);
    if (activeTester) {
      if(!gameState.lockTester) {
        Future.delayed(Duration(seconds: 2), () {
          GameTester gameTester = GameTester();
          gameTester.runTester(context, gameState);
        });
        gameState.changeLockTester(true);
      }
    }


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
      },
    );


  }
}