import 'package:secret_hitler/state_management.dart';
import 'package:secret_hitler/gameFunctions.dart';
import 'package:secret_hitler/gameUIFunctions.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class GameTester {

  void runTester(context,GameState gameState){
    if(gameState.state=='base'){
      Random random = Random();
      int index = random.nextInt(gameState.chancellorList.length);
      gameState.changeSelectedChancellor(gameState.chancellorList[index]);
      Future.delayed(Duration(seconds: 2), () {
        showMessageDialog(context,gameState.selectedChancellor, gameState);
        Future.delayed(Duration(seconds: 2), () {
          onPressedConfirmationYes(context,gameState.selectedChancellor,gameState);
          Future.delayed(Duration(seconds: 2), () {
            gameState.changeLockTester(false);
            onPressedSuccessElection(context,gameState.selectedChancellor,gameState);

          });
        });

      });





    }
    else if (gameState.state=='lib win' || gameState.state=='fash win'){

    }
    else if(gameState.state=='elected'){
      Random random = Random();
      int index = random.nextInt(3);
      gameState.changePresidentSelect(index);
      Future.delayed(Duration(seconds: 2), () {
        gameState.changeLockTester(false);
         discardPresident(gameState);

        }
      );
    }
    else if(gameState.state=='president_discarded'){
      print("Hi now I am in president_discarded");

    }
    else if(gameState.state=='kill_veto'){

    }
    else if(gameState.state=='kill'){

    }
    else if(gameState.state=='Search'){

    }
    else if(gameState.state=='next-persident'){

    }
    else{
      print ("I am in unknown state");

    }

  }

  void performAction(){

  }


}