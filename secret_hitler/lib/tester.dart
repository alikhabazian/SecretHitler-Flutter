import 'package:secret_hitler/state_management.dart';
import 'package:secret_hitler/gameFunctions.dart';
import 'package:secret_hitler/gameUIFunctions.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class GameTester {

  void runTester(context,GameState gameState){
    if(gameState.state=='base'){
      print("I am in base");
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
      print("Game has been finished");
    }
    else if(gameState.state=='elected'){
      Random random = Random();
      int index = random.nextInt(3);
      gameState.changePresidentSelect(index);
      Future.delayed(Duration(seconds: 2), () {
        gameState.changeLockTester(false);
         discardPresident(gameState);
        });
    }
    else if(gameState.state=='president_discarded'){
      Random random = Random();
      int index = random.nextInt(2);
      gameState.changeChancellorSelect(index);
      if(gameState.possibleVeto &&(gameState.roles[gameState.turn]=='lib') && (gameState.roles[gameState.names.indexOf(gameState.selectedChancellor)]=='lib')) {
        Future.delayed(Duration(seconds: 2),() {
          gameState.changeLockTester(false);
          vetoOnPressed(gameState);
        });
      }
      else{
        Future.delayed(Duration(seconds: 2), () {
          gameState.changeLockTester(false);
          discardChancellor(gameState);
        });
      }


    }
    else if(gameState.state=='kill_veto'|| gameState.state=='kill'){
      Random random = Random();
      int index = random.nextInt(gameState.candidateList().length);
      gameState.changeWillKilled(gameState.candidateList()[index]);
      Future.delayed(Duration(seconds: 2), () {
        gameState.changeLockTester(false);
        gameState.eliminate();
      });

    }
    else if(gameState.state=='top-three'){
    topThreeSeenToggle(gameState);
    Future.delayed(Duration(seconds: 2), () {
      gameState.changeLockTester(false);
      topThreeSeenToggle(gameState);
    });
    }
    else if(gameState.state=='Search'){
      Random random = Random();
      int index = random.nextInt(gameState.candidateList().length);
      gameState.changeWillSearch(gameState.candidateList()[index]);
      Future.delayed(Duration(seconds: 2), () {
        searchOnPressed(context,gameState);
        Future.delayed(Duration(seconds: 2), () {
          gameState.changeLockTester(false);
          Navigator.of(context).pop();
          gameState.updatePage();
        });
      });

    }
    else if(gameState.state=='next-persident'){
      Random random = Random();
      int index = random.nextInt(gameState.candidateList().length);
      gameState.changeWillPresident(gameState.candidateList()[index]);
      Future.delayed(Duration(seconds: 2), () {
        gameState.changeLockTester(false);
        gameState.specialRound();
      });


    }
    else{
      print ("I am in unknown state");

    }

  }



}