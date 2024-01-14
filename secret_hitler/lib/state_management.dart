import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';



bool toBoolean(String str, [bool strict = false]) {
  if (strict == true) {
    return str == '1' || str == 'true';
  }
  return str != '0' && str != 'false' && str != '';
}

class Player{
  String name='';
  String role='';
  bool killed=false;

  Player({required this.name,required this.role,this.killed = false});

  String searchResult(){
    if (role=='Liberal'){
      return 'Liberal';
    }
    else{
      return 'Fascist';
    }
  }

  @override
  String toString() {
    return 'Player(${name},${role},${killed?'killed':'alive'})';
  }
}


class GameState extends ChangeNotifier {
  bool _continuegame=false;
  bool _lockTester=false;

  int _numberPlayers=0;
  // int _numberPlayersInitial=0;
  int _round=0;
  int _firstStarter=0;
  List<String> _fashBoard=[];
  List<String> _libBoard=[];
  bool _topThreeSeen=false;
  bool _chaos = false;
  bool _isHitlerAlive=true;

  List<Player> _players=[];


  List<String> _dec=[];
  List<String> _disDec=[];
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

  bool _veto = false;
  bool _possibleVeto = false;
  bool _hide=false;

  Map<int,dynamic> _boardFash={
    5:['blank','blank','top-three','kill','kill_veto','fash'],
    6:['blank','blank','top-three','kill','kill_veto','fash'],
    7:['blank','Search','next-persident','kill','kill_veto','fash'],
    8:['blank','Search','next-persident','kill','kill_veto','fash'],
    9:['Search','Search','next-persident','kill','kill_veto','fash'],
    10:['Search','Search','next-persident','kill','kill_veto','fash'],
  };
  List<String> _boardLib=['blank','blank','blank','blank','lib','lib'];
  int _specialEffect=0;


  // int get counter => _counter;
  List<String> get fashBoard =>_fashBoard;
  List<String> get libBoard =>_libBoard;
  Map<int,dynamic> get boardFash =>_boardFash;
  List<String>  get boardLib =>_boardLib;
  int get numberPlayersInitial =>_numberPlayers;
  String get lastChancellor => _lastChancellor;
  String get lastPresident =>_lastPresident;
  bool get hitlerState =>_hitlerState;
  String get state => _state;
  int get numberRejected=>_numberRejected;
  String get selectedChancellor => _selectedChancellor;
  int get round=>_round;
  // List<String>get names=>_names;
  List<Player>get players=>_players;
  int get turn=>_turn;
  List<String> get chancellorList=> _chancellorList;
  bool get veto =>_veto;
  bool get continuegame =>_continuegame;
  // List<String> get roles=>_roles;
  // bool get chaos =>_chaos;
  List<String> get dec=>_dec;
  int get presidentSelected =>_presidentSelected;
  List<String> get disDec =>_disDec;
  bool get hide=>_hide;
  int get chancellorSelected =>_chancellorSelected;
  bool get possibleVeto => _possibleVeto;
  bool get topThreeSeen => _topThreeSeen;
  String get willKilled =>_willKilled;
  String get willSearch =>_willSearch;
  String get willresident =>_willPresident;
  bool get special =>_special;
  bool get lockTester =>_lockTester;

  void changeLockTester(bool value){
    _lockTester=value;
  }

  void specialRound(){
    changeSpecial(true);
    changeState('base');
    nextRound();
    notifyListeners();
  }



  void changeSpecial(bool value){
    _special=value;
  }

  void eliminate(){
    // if(_firstStarter+_round/_numberPlayers>=1){
    //   _firstStarter=((_firstStarter+_round)%_numberPlayers)-_round;
    // }

    // var index=_names.indexOf(_willKilled);
    Player eliminatedPlayer=_players.lastWhere((player){
      return player.name==_willKilled;
    });
    if(eliminatedPlayer.role=='Hitler'){
      _isHitlerAlive=false;
    }
    // _killedturns.add(index);
    eliminatedPlayer.killed=true;
    // _names.removeAt(index);
    // _roles.removeAt(index);
    // _numberPlayers = _names.length;
    _state='base';
    // //todo why?
    // _firstStarter-=1;
    nextRound();
    notifyListeners();
  }


  void changeTopThreeSeen(bool value){
    _topThreeSeen=value;

  }

  void toggleHide(){
    _hide=!hide;
  }

  void enoughDec(){
    if(_dec.length<=2){
      _dec=_dec+_disDec;
      _dec=_dec..shuffle();
      _disDec=[];
    }
  }

  void removeSelectedDec(int index){
    _dec.removeAt(index);
  }
  void addDisDec(){
    _disDec.add(_dec.removeAt(0));
  }

  void changeWillKilled(String willKilled){
    _willKilled=willKilled;
    notifyListeners();
  }

  void changeWillPresident(String willPresident){
    _willPresident=willPresident;
    notifyListeners();
  }

  void changeWillSearch(String willSearch){
    _willSearch=willSearch;
    notifyListeners();
  }

  void changeLastChancellor(String lastChancellor){
    _lastChancellor=lastChancellor;
  }

  void addLog(String log){
    _log=_log+log;
  }


  void changeChancellorSelect(int value){
    _chancellorSelected=value;
    notifyListeners();
  }

  void changeLastPresident(String lastPresident){
    _lastPresident=lastPresident;
  }
  void changePresidentSelect(int value){
    _presidentSelected=value;
    notifyListeners();
  }
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
    for (int i = 0; i < _players.length; i++) {
      if (i==_turn || _players[i].killed || !_chaos &&(_players[i].name==_lastChancellor || (_numberPlayers>5 && _players[i].name==_lastPresident))){
        continue;
      }
      _chancellorList.add(_players[i].name);
    }
    _selectedChancellor=_chancellorList[0];
  }


  void setUp(List<String> names,List<String> roles){
    _round=1;
    for (int i =0;i<names.length;i++){
      _players.add(new Player(name:names[i],role:roles[i]));
    }
    // _names=names;
    // _roles=roles;
    // _numberPlayersInitial=names.length;
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
    // List<String> _candidateList=[... _names];
    // _candidateList.removeAt(_turn);
    // _killedturns.forEach((element) {
    //   _candidateList.remove(element);
    // });
    List<String> _candidateList=[];
    for(int i=0;i<_players.length;i++ ){
      if(i!=_turn && _players[i].killed==false){
        _candidateList.add(_players[i].name);
      }
    }
    return _candidateList;
  }

  void nextRound(){


    endGame();
    _round=_round+1;
    int killedEffect=0;
    do {
      if (_special) {
        _turn =_players.lastIndexWhere((player){
          return player.name==_willPresident;
        });
        // _turn = _names.indexOf(_willPresident);
        _specialEffect=-1;
      }
      else {
        _turn = (_firstStarter + _round + _specialEffect + killedEffect) % _numberPlayers;
      }
      killedEffect++;
    }while(_players[_turn].killed==true);
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
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    _prefs.then((pref) => {updateSharedPreferences(pref)});

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

  Player findPlayerWithName(String name){
    return _players.lastWhere((player){
      return player.name==name;
    });

  }


  @override
  String toString() {
    return '''
    Game_state:
    round:${_round}
    first_starter:${_firstStarter}
    number_players:${_numberPlayers}
    players:${_players}
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

  void loadSharedPreferences(final SharedPreferences prefs) {
    // Retrieve values from SharedPreferences and assign them to variables
    _continuegame = true;
    _lockTester = prefs.getBool('_lockTester') ?? false;
    _numberPlayers = prefs.getInt('_numberPlayers') ?? 0;
    _round = prefs.getInt('_round') ?? 0;
    _firstStarter = prefs.getInt('_firstStarter') ?? 0;
    _fashBoard = prefs.getStringList('_fashBoard') ?? [];
    _libBoard = prefs.getStringList('_libBoard') ?? [];
    _topThreeSeen = prefs.getBool('_topThreeSeen') ?? false;
    _chaos = prefs.getBool('_chaos') ?? false;
    _isHitlerAlive = prefs.getBool('_isHitlerAlive') ?? false;
    List<String> names = prefs.getStringList('_names') ?? [];
    List<String> roles = prefs.getStringList('_roles') ?? [];
    List<bool> killed = (prefs.getStringList('_killedturns') ?? []).map((e) => toBoolean(e)).toList();
    _players=[];
    for(int i=0;i<names.length;i++){
      _players.add(new Player(name:names[i],role:roles[i],killed:killed[i]));
    }
    _dec = prefs.getStringList('_dec') ?? [];
    _disDec = prefs.getStringList('_disDec') ?? [];
    _state = prefs.getString('_state') ?? '';
    _numberRejected = prefs.getInt('_numberRejected') ?? 0;
    _lastChancellor = prefs.getString('_lastChancellor') ?? '';
    _lastPresident = prefs.getString('_lastPresident') ?? '';
    _turn = prefs.getInt('_turn') ?? 0;

    _chancellorList = prefs.getStringList('_chancellorList') ?? [];
    _selectedChancellor = prefs.getString('_selectedChancellor') ?? '';
    _presidentSelected = prefs.getInt('_presidentSelected') ?? -1;
    _chancellorSelected = prefs.getInt('_chancellorSelected') ?? -1;
    _log = prefs.getString('_log') ?? '';
    _hitlerState = prefs.getBool('_hitlerState') ?? false;
    _hitlerChancellor = prefs.getBool('_hitlerChancellor') ?? false;
    _willSearch = prefs.getString('_willSearch') ?? '';
    _willPresident = prefs.getString('_willPresident') ?? '';
    _willKilled = prefs.getString('_willKilled') ?? '';
    _special = prefs.getBool('_special') ?? false;
    _veto = prefs.getBool('_veto') ?? false;
    _possibleVeto = prefs.getBool('_possibleVeto') ?? false;
    _hide = prefs.getBool('_hide') ?? false;
    _specialEffect = prefs.getInt('_specialEffect') ?? 0;
  }



  void updateSharedPreferences(final SharedPreferences prefs){
    prefs.setBool('hasGame',true);
    prefs.setBool('_lockTester', _lockTester);
    prefs.setInt('_numberPlayers',_numberPlayers);
    prefs.setInt('_round',_round);
    prefs.setInt('_firstStarter',_firstStarter);
    prefs.setStringList('_fashBoard', _fashBoard);
    prefs.setStringList('_libBoard', _libBoard);
    prefs.setBool('_topThreeSeen',_topThreeSeen);
    prefs.setBool('_chaos',_chaos);
    prefs.setBool('_isHitlerAlive',_isHitlerAlive);
    prefs.setStringList('_names',  _players.map((player) => player.name).toList());
    prefs.setStringList('_roles',  _players.map((player) => player.role).toList());
    prefs.setStringList('_killedturns', _players.map((player) => player.killed.toString()).toList());
    prefs.setStringList('_dec', _dec);
    prefs.setStringList('_disDec', _disDec);
    prefs.setString('_state', _state);
    prefs.setInt('_numberRejected', _numberRejected);
    prefs.setString('_lastChancellor', _lastChancellor);
    prefs.setString('_lastPresident', _lastPresident);
    prefs.setInt('_turn', _turn);

    // List<List<String>> _governments=[];
    prefs.setStringList('_chancellorList',_chancellorList);
    prefs.setString('_selectedChancellor',_selectedChancellor);
    prefs.setInt('_presidentSelected',_presidentSelected);
    prefs.setInt('_chancellorSelected',_chancellorSelected);
    prefs.setString('_log',_log);
    prefs.setBool('_hitlerState',_hitlerState);
    prefs.setBool('_hitlerChancellor',_hitlerChancellor);
    prefs.setString('_willSearch',_willSearch);
    prefs.setString('_willPresident',_willPresident);
    prefs.setString('_willKilled',_willKilled);
    prefs.setBool('_special',_special);
    prefs.setBool('_veto',_veto);
    prefs.setBool('_possibleVeto',_possibleVeto);
    prefs.setBool('_hide',_hide);
    prefs.setInt('_specialEffect',_specialEffect);

  }


}