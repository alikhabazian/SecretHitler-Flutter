import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';


class GameState extends ChangeNotifier {
  int _numberPlayers=0;
  int _numberPlayersInitial=0;
  int _round=0;
  int _firstStarter=0;
  List<String> _fashBoard=[];
  List<String> _libBoard=[];
  bool _topThreeSeen=false;
  bool _chaos = false;
  bool _isHitlerAlive=true;
  List<String> _names=[];
  List<String> _roles=[];
  List<String> _dec=[];
  List<String> _disDec=[];
  String _chancellor='';
  String _state='';
  int _numberRejected=0;
  String _lastChancellor='';
  String _lastPresident='';
  int _turn=0;
  List<List<String>> _governments=[];
  List<String> _chancellorList=[];
  String _selectedChancellor='';
  int _presidentSelected=-1;
  int _chancellorSelected=-1;
  String _log='';
  bool _hitlerState=false;
  bool _hitlerChancellor=false;

  String _willSearch='';
  String _willPresident='';
  String _willKilled='';

  bool _special = false;
  int _oldRound=-1;

  bool _veto = false;
  bool _possibleVeto = false;

  Map<int,dynamic> _boardFash={
    5:['blank','blank','top-three','kill','kill_veto','fash'],
    6:['blank','blank','top-three','kill','kill_veto','fash'],
    7:['blank','Search','next-persident','kill','kill_veto','fash'],
    8:['blank','Search','next-persident','kill','kill_veto','fash'],
    9:['Search','Search','next-persident','kill','kill_veto','fash'],
    10:['Search','Search','next-persident','kill','kill_veto','fash'],
  };

  List<String> _boardLib=['blank','blank','blank','blank','lib','lib'];



  // int get counter => _counter;
  List<String> get fashBoard =>_fashBoard;
  List<String> get libBoard =>_libBoard;
  Map<int,dynamic> get boardFash =>_boardFash;
  List<String>  get boardLib =>_boardLib;
  int get numberPlayersInitial =>_numberPlayersInitial;
  String get lastChancellor => _lastChancellor;
  String get lastPresident =>_lastPresident;
  bool get hitlerState =>_hitlerState;
  String get state => _state;
  int get numberRejected=>_numberRejected;
  String get selectedChancellor => _selectedChancellor;
  int get round=>_round;
  List<String>get names=>_names;
  int get turn=>_turn;
  List<String> get chancellorList=> _chancellorList;
  bool get veto =>_veto;
  List<String> get roles=>_roles;
  // bool get chaos =>_chaos;
  List<String> get dec=>_dec;




  void chaosActivate(){
    _chaos=true;
  }
  void updatePage(){
    notifyListeners();
  }
  void changeNumberOfRejected(int numberOfRejected){
    _numberRejected=numberOfRejected;
  }
  void hitlerChancellor(){
    _hitlerChancellor=true;
  }

  void changePresidentSelected(int president_selected){
    _presidentSelected=president_selected;
  }
  void changeState(String newState){
    _state=newState;
  }
  void changeSelectedChancellor(value){
    _selectedChancellor = value!;
    notifyListeners();
  }

  void activateVeto(){
    _possibleVeto=true;
  }

  void updateChancellorList(){
    _chancellorList=[];
    for (int i = 0; i < _names.length; i++) {
      if (i==_turn || !_chaos &&(_names[i]==_lastChancellor || (_numberPlayersInitial>5 && _names[i]==_lastPresident))){
        continue;
      }
      _chancellorList.add(_names[i]);
    }
    _selectedChancellor=_chancellorList[0];
  }


  void setUp(List<String> names,List<String> roles){
    _round=1;
    _numberPlayersInitial=names.length;
    _numberPlayers=names.length;
    _dec=[];
    for (int i = 0; i < 6; i++) {
      _dec.add('lib');
    }
    for (int i = 0; i < 11; i++) {
      _dec.add('fash');
    }
    _dec=_dec..shuffle();
    _disDec=[];
    _state='base';

    _firstStarter=Random().nextInt(_numberPlayers);
    _turn=(_firstStarter+_round)%_numberPlayers;
    updateChancellorList();
  }

  void endGame(){
    if(_libBoard.length==5 || !_isHitlerAlive){
      _state='lib win';
    }
    if(_fashBoard.length==6 || _hitlerChancellor ) {
      _state = 'fash win';
    }
  }

  List<String> candidateList(){
    List<String> _candidateList=[... _names];
    _candidateList.removeAt(_turn);
    return _candidateList;
  }

  void nextRound(){
    endGame();
    _round=_round+1;
    _turn=(_firstStarter+_round)%_numberPlayers;
    if(_special){
      _turn=_names.indexOf(_willPresident);
    }
    _special=false;
    if(_dec.length<=2){
      _dec=_dec+_disDec;
      _dec=_dec..shuffle();
      _disDec=[];
    }
    updateChancellorList();
    _chaos=false;
    if(_fashBoard.length>2){
      _hitlerState=true;
    }
  }

  void doVeto(){
    _disDec.add(_dec.removeAt(0));
    _disDec.add(_dec.removeAt(0));
    if(_dec.length==2){
      _dec=_dec+_disDec;
      _dec=_dec..shuffle();
      _disDec=[];
    }
    _possibleVeto=false;
    _state='base';
  }


  @override
  String toString() {
    return '''
    Game_state:
    round:${_round}
    first_starter:${_firstStarter}
    number_players:${_numberPlayers}
    dec:${_dec}
    dis_dec:${_disDec}
    number_rejected:${_numberRejected}
    state:${_state}
    turn:${_turn}
    governments:${_governments}
    selected_chancellor:${_selectedChancellor}
    chancellor_list:${_chancellorList}
    will_Search:${_willSearch}
    candidate_list:${candidateList()}
    ''';
  }


  //
  // void incrementCounter() {
  //   _counter++;
  //   notifyListeners();
  // }
}