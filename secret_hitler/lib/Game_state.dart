
import 'dart:math';
import 'package:flutter/material.dart';
class Game_state {

  int number_players=0;//
  int number_players_at_start=0;//
  int round=0;//
  int first_starter=0;
  List<String> fash_board=[];
  List<String> lib_board=[];
  bool top_tree_seen=false;
  bool chaos = false;
  bool is_hitler_alive=true;
  List<String> names=[];//
  List<String> roles=[];//
  List<String> dec=[];//
  List<String> dis_dec=[];//
  String chancellor='';
  String state='';//
  int number_rejected=0;
  String last_chancellor='';
  String last_president='';
  int turn=0;
  List<List<String>> governments=[];
  List<String> chancellor_list=[];
  String selected_chancellor='';
  int president_selected=-1;
  int chancellor_selected=-1;
  String log='';
  bool hitler_state=false;
  bool hitler_chancellor=false;

  String will_Search='';
  String will_president='';
  String will_killed='';


  bool special = false;
  int old_round=-1;

  bool veto = false;
  bool posible_veto = false;

  Map<int,dynamic> board_fash={
    5:['blank','blank','top-three','kill','kill_veto','fash'],
    6:['blank','blank','top-three','kill','kill_veto','fash'],
    7:['blank','Search','next-persident','kill','kill_veto','fash'],
    8:['blank','Search','next-persident','kill','kill_veto','fash'],
    9:['Search','Search','next-persident','kill','kill_veto','fash'],
    10:['Search','Search','next-persident','kill','kill_veto','fash'],
  };
  List<String> board_lib=['blank','blank','blank','blank','lib','lib'];


  Game_state({required this.names,required this.roles});

  void update_chancellor_list(){
    chancellor_list=[];
    for (int i = 0; i < names.length; i++) {
      if (i==turn || !chaos &&(names[i]==last_chancellor || (number_players_at_start>5 && names[i]==last_president))){
        continue;
      }
      chancellor_list.add(names[i]);

    }
    selected_chancellor=chancellor_list[0];


  }

  void set_up(){
    round=1;

    number_players_at_start= names.length;
    number_players=number_players_at_start;
    dec=[];
    for (int i = 0; i < 6; i++) {
      dec.add('lib');
    }
    for (int i = 0; i < 11; i++) {
      dec.add('fash');
    }
    dec=dec..shuffle();
    dis_dec=[];
    state='base';
    number_rejected=0;
    var rng = Random();
    first_starter=rng.nextInt(number_players);
    turn=(first_starter+round)%number_players;
    update_chancellor_list();

  }

  void end_game(){
    if(lib_board.length==5 || !is_hitler_alive){
      state='lib win';

    }
    if(fash_board.length==6 || hitler_chancellor ) {
      state = 'fash win';
    }
  }
  //List<String> candidate_list=[...game_state.names];
  List<String> candidate_list(){
    List<String> candidate_list=[... names];
    candidate_list.removeAt(turn);


    return candidate_list;
  }


  void next_round(){
    end_game();
    round=round+1;
    turn=(first_starter+round)%number_players;
    if(special ){
      turn=names.indexOf(will_president);
    }
    special=false;
    if(dec.length<=2){
      dec=dec+dis_dec;
      dec=dec..shuffle();
      dis_dec=[];
    }
    update_chancellor_list();
    chaos=false;
    if(fash_board.length>2){
      hitler_state=true;
    }
  }

  void do_veto(){
    dis_dec.add(dec.removeAt(0));
    dis_dec.add(dec.removeAt(0));
    if(dec.length==2){
      dec=dec+dis_dec;
      dec=dec..shuffle();
      dis_dec=[];
    }
    posible_veto=false;
    state='base';

  }

  List<TableCell> get_fac_table(width){
    List<TableCell> fac_table = [];
    for (int i = 0; i < 6; i++) {
      fac_table.add(TableCell(
        verticalAlignment: TableCellVerticalAlignment.top,
        child: Container(
          child:fash_board.length>i?Image(image: AssetImage('assets/fash_policy.png')):(board_fash[number_players_at_start][i]=='blank'?null:Image(image: AssetImage('assets/'+board_fash[number_players_at_start][i]+'.png'))),
          height: 120,
          width: (width*0.95)/6,
          color: i>=3?Colors.red[900]:Colors.red,
        ),
      ));
    }
    return fac_table;

  }


  List<TableCell> get_lib_table(width){
    List<TableCell> lib_table= [];
    for (int i = 0; i < 6; i++) {
      if(i==5){
        lib_table.add(TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,

            child: RotatedBox(
              quarterTurns: 1,
              child:Container(
                // child:lib_board.length>i?Image(image: AssetImage('assets/lib_policy.png')):(board_lib[i]=='blank'?null:Image(image: AssetImage('assets/'+board_lib[i]+'.png'))),

                child:board_lib[i]=='blank'?null:Image(color:Colors.blue[400],image: AssetImage('assets/'+board_lib[i]+'.png')),

                height: 70,
                width:(width*0.95)/6,
                color: Colors.white,
              ),
            )
        ));
      }
      else{
        lib_table.add(TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,

          child: Container(
            child:lib_board.length>i?Image(image: AssetImage('assets/lib_policy.png')):(board_lib[i]=='blank'?null:Image(image: AssetImage('assets/'+board_lib[i]+'.png'))),

            // child:board_lib[i]=='blank'?null:Image(image: AssetImage('assets/'+board_lib[i]+'.png')),

            height: 120,
            width:(width*0.95)/6,
            color: Colors.blue[400],
          ),
        ));
      }
    }
    return lib_table;
  }

  @override
  String toString() {
    return '''
    Game_state:
    round:${round}
    first_starter:${first_starter}
    number_players:${number_players}
    dec:${dec}
    dis_dec:${dis_dec}
    number_rejected:${number_rejected}
    state:${state}
    turn:${turn}
    governments:${governments}
    selected_chancellor:${selected_chancellor}
    chancellor_list:${chancellor_list}
    will_Search:${will_Search}
    candidate_list:${candidate_list()}
    ''';
  }
}

