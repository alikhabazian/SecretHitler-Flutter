import 'package:flutter/material.dart';
// import 'package:secret_hitler/Game_state.dart';
import 'package:secret_hitler/state_management.dart';
void showRoleDialog(BuildContext context,GameState game_state) {
  showDialog(
    context: context,
    barrierDismissible:false,
    builder: (BuildContext context) {
      String rool='';
      if (game_state.roles[game_state.names.indexOf(game_state.willSearch)]=='Liberal'){
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
              TextSpan(text: game_state.willSearch, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
void showMessageDialog(BuildContext context,String name,GameState game_state) {
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
                            if(game_state.veto && game_state.roles[game_state.names.indexOf(name)]=='Liberal' && game_state.roles[game_state.turn]=='Liberal'){
                              game_state.activateVeto();
                            }
                            game_state.changeState('elected');
                            game_state.changePresidentSelected(-1);
                            if(game_state.roles[game_state.names.indexOf(name)]=='Hitler'&& game_state.hitlerState){
                              game_state.hitlerChancellor();
                            }

                            game_state.changeNumberOfRejected(0);

                            Navigator.of(context).pop();

                            game_state.updatePage();
                          },
                        ),
                        TextButton(
                          child: const Text('No'),
                          onPressed: () {

                            // round=round+1;
                            // first_selected=false;
                            game_state.changeNumberOfRejected(game_state.numberRejected+1);
                            if(game_state.numberRejected==3){
                              game_state.chaosActivate();
                              game_state.changeNumberOfRejected(0);
                              if(game_state.dec[0]=='fash'){
                                game_state.fashBoard.add('Done');

                              }
                              else if(game_state.dec[0]=='lib'){
                                game_state.libBoard.add('Done');

                              }
                              game_state.dec.removeAt(0);


                            }
                            game_state.nextRound();
                            Navigator.of(context).pop();
                            game_state.updatePage();
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

List<TableCell> generateFacTable(width,fashBoard,boardFash,numberPlayersInitial){
  List<TableCell> fac_table = [];
  for (int i = 0; i < 6; i++) {
    fac_table.add(TableCell(
      verticalAlignment: TableCellVerticalAlignment.top,
      child: Container(
        child:fashBoard.length>i?Image(image: AssetImage('assets/fash_policy.png')):(boardFash[numberPlayersInitial][i]=='blank'?null:Image(image: AssetImage('assets/'+boardFash[numberPlayersInitial][i]+'.png'))),
        height: 120,
        width: (width*0.95)/6,
        color: i>=3?Colors.red[900]:Colors.red,
      ),
    ));
  }

  return fac_table;
}
List<TableCell> generateLibTable(width,libBoard,boardLib){
  List<TableCell> libTable= [];
  for (int i = 0; i < 6; i++) {
    if(i==5){
      libTable.add(TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: RotatedBox(
            quarterTurns: 1,
            child:Container(
              // child:lib_board.length>i?Image(image: AssetImage('assets/lib_policy.png')):(board_lib[i]=='blank'?null:Image(image: AssetImage('assets/'+board_lib[i]+'.png'))),
              child:boardLib[i]=='blank'?null:Image(color:Colors.blue[400],image: AssetImage('assets/'+boardLib[i]+'.png')),
              height: 70,
              width:(width*0.95)/6,
              color: Colors.white,
            ),
          )
      ));
    }
    else{
      libTable.add(TableCell(
        verticalAlignment: TableCellVerticalAlignment.top,

        child: Container(
          child:libBoard.length>i?Image(image: AssetImage('assets/lib_policy.png')):(boardLib[i]=='blank'?null:Image(image: AssetImage('assets/'+boardLib[i]+'.png'))),

          // child:board_lib[i]=='blank'?null:Image(image: AssetImage('assets/'+board_lib[i]+'.png')),

          height: 120,
          width:(width*0.95)/6,
          color: Colors.blue[400],
        ),
      ));
    }
  }
  return libTable;
}

void selectAtBase(BuildContext context,String name){

}




