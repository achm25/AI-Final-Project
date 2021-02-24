import 'dart:async';

import 'package:ai/generate_children.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


int moveCounter=0;
const int BOARD_SIZE = 8;
const int X = 1;
const int O = -1;
const int EMPTY = 0;
const int INF = 2000000000; // infinity

const Color EmptyCellColor = Colors.white10;
const CellColors = {X: Colors.black54, O: Colors.white};
const PlayerNames = {X: "Black", O: "White"};
const ThinkingDepth = {"Easy": 1, "Medium": 2, "Hard": 6};

class AIVSAI extends StatefulWidget {
  final String title;
  final String difficulty;


  AIVSAI({this.title, this.difficulty = "Easy"});

  @override
  AIVSAIState createState() => AIVSAIState();
}

class AIVSAIState extends State<AIVSAI> {
  List<List> board;
  List<List> canMove;
  int _currentPlayer;
  var _cnt;
  String _info;
  int _thinkingDepth;
  Children children = new Children();


  bool nextGame = false;
  int leagueNumber = 1;
  int numberOfMatchPlayed = 0;
  int firstPlayer = 0;
  int secondPlayer = 1;
  var weightFirstPlayer;
  var weightSecondPlayer;

  @override
  void initState() {
    super.initState();
    _initialize();
    children.generateGroupe();
    weightFirstPlayer = children.groupe1[0].gene;
    weightSecondPlayer = children.groupe1[1].gene;
  }

  void _initialize() {
    _currentPlayer = X;
    board = List.generate(BOARD_SIZE, (i) => List.generate(BOARD_SIZE, (j) => 0));

    _put(3, 3, O);
    _put(3, 4, X);
    _put(4, 3, X);
    _put(4, 4, O);

    _cnt = {X: 2, O: 2};

    _info = '';
    _thinkingDepth = ThinkingDepth[widget.difficulty];
  }

  Widget buildItem(int block) {
    if (block == X) {
      return Container(width: 30, height: 30,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black));
    } else if (block == O) {
      return Container(width: 30, height: 30,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white));
    }
    return Container();
  }


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild(context));

    return Scaffold(
      backgroundColor: Color(0xff34495e),
      appBar: AppBar(
        backgroundColor: Color(0xffbdc3c7),
        title: Text("White : " + _cnt[X].toString()),
        actions: [
          Expanded(child: Container(color: Color(0xffbdc3c7),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(padding: EdgeInsets.all(16),
                        child: buildItem(O)),
                    Text( _cnt[O].toString(), style: TextStyle(fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black))
                  ]))),
          Expanded(child: Container(color: Color(0xffbdc3c7),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(padding: EdgeInsets.all(16),
                        child: buildItem(X)),
                    Text( _cnt[X].toString(), style: TextStyle(fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black))
                  ]))),
          FlatButton.icon(onPressed: (){
            showDialog(context: context, child:
            new AlertDialog(
              title: new Text("Change Difficulty : "),
              actions: [
                FlatButton(onPressed: (){
                  _thinkingDepth= 1;
                  Navigator.pop(context);
                }, child: Text('Easy')),
                FlatButton(onPressed: (){
                  _thinkingDepth = 2;
                  Navigator.pop(context);
                }, child: Text('Medium')),
                FlatButton(onPressed: (){
                  _thinkingDepth = 4;
                  Navigator.pop(context);
                }, child: Text('Hard')),
              ],
            )
            );
          }, icon: Icon(Icons.settings), label: Text(''))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildBoard(),
        ),
      ),
    );
  }

  void afterBuild(BuildContext context) {

    if(nextGame){
      numberOfMatchPlayed++;
      secondPlayer++;
      if(secondPlayer>=10){
        firstPlayer++;
        secondPlayer = firstPlayer+1;
      }
      if(firstPlayer ==9 || numberOfMatchPlayed >= 45){
        children.makeChild(leagueNumber);
        firstPlayer = 0;
        secondPlayer = 1;
        numberOfMatchPlayed = 0;
        if(leagueNumber == 4){
          leagueNumber = 1;
        }else{
          leagueNumber++;
        }
      }
      if(leagueNumber == 1){
        weightFirstPlayer = children.groupe1[firstPlayer].gene;
        weightSecondPlayer = children.groupe1[secondPlayer].gene;
        print('here2');
      }else if(leagueNumber == 2){
        weightFirstPlayer = children.groupe2[firstPlayer].gene;
        weightSecondPlayer = children.groupe2[secondPlayer].gene;
      }else if(leagueNumber == 3){
        weightFirstPlayer = children.groupe3[firstPlayer].gene;
        weightSecondPlayer = children.groupe3[secondPlayer].gene;
      }else{
        weightFirstPlayer = children.groupe4[firstPlayer].gene;
        weightSecondPlayer = children.groupe4[secondPlayer].gene;
      }

      nextGame = false;
    }

    if (_currentPlayer == O) {
      var timer = Timer(Duration(seconds: 0), () => _AImove());
    }
    else{
      var timer = Timer(Duration(seconds: 0), () => _AImove());
    }
  }

  void _AImove() {
    Move m = _findBestMove(_currentPlayer, _thinkingDepth, -INF, INF, _currentPlayer);
    _update(m.x, m.y);
    moveCounter += 2;
  }


  List<Widget> _buildBoard() {
    List<Widget> L = List<Widget>();

    for(int i=0; i<BOARD_SIZE; i++) {
      L.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildRow(i),
      ));
    }
    L.add(Container(
        margin: EdgeInsets.only(top: 20),
        child: Text('$_info', style: TextStyle(fontSize: 18,color: Colors.white),)
    ));
    return L;
  }

  List<Widget> _buildRow(int r) {
    List<Widget> L = List<Widget>();
    for(int i=0; i<BOARD_SIZE; i++) {
      L.add(_buildCell(r, i));
    }
    return L;
  }

  Widget _buildCell(int r, int c) {
    return GestureDetector(
      onTap: () => _userMove(r, c),
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
          border: _getBorder(r, c),
          color: EmptyCellColor,
        ),
        child: _buildPeg(r, c),
      ),
    );
  }

  _getBorder(int r, int c) {
    if (_currentPlayer == X && _isValid(r, c, X))
      return Border.all(color: Colors.green, width: 2);
    return Border.all(color: Colors.grey, width: 1);
  }

  Widget _buildPeg(int r, int c) {
    if (board[r][c] == EMPTY)
      return null;
    return Container(
      decoration: BoxDecoration(
        color: CellColors[board[r][c]],
        shape: BoxShape.circle,
      ),
    );
  }

  void _put(int i, int j, int peg) {
    board[i][j] = peg;
  }

  _userMove(int r, int c) {
    _update(r, c);
  }


  resetGame(){
    _currentPlayer = X;
    board = List.generate(BOARD_SIZE, (i) => List.generate(BOARD_SIZE, (j) => 0));
    _put(3, 3, O);
    _put(3, 4, X);
    _put(4, 3, X);
    _put(4, 4, O);
    _cnt = {X: 2, O: 2};
    _info = '';
    _thinkingDepth = ThinkingDepth[widget.difficulty];
    nextGame = true;
  }

  void _update(int r, int c) {
    if (!_isValid(r, c, _currentPlayer)) return;

    setState(() {
      _move(r, c, _currentPlayer);
      var w = _winner();
      if (w == X || w == O) {
        String s = PlayerNames[w];
        if(leagueNumber == 1){
          if(s == "Black"){
            children.groupe1[firstPlayer].score += 1;
          }else{
            children.groupe1[secondPlayer].score += 1;
          }
        }else if(leagueNumber == 2){
          if(s == "Black"){
            children.groupe2[firstPlayer].score += 1;
          }else{
            children.groupe2[secondPlayer].score += 1;
          }
        }else if(leagueNumber == 3){
          if(s == "Black"){
            children.groupe3[firstPlayer].score += 1;
          }else{
            children.groupe3[secondPlayer].score += 1;
          }
        }else {
          if(s == "Black"){
            children.groupe4[firstPlayer].score += 1;
          }else{
            children.groupe4[secondPlayer].score += 1;
          }
        }
        _info = "$s won";
        resetGame();
        setState(() {

        });
      } else if (!_hasValidMove(-_currentPlayer)) {
        String current = PlayerNames[_currentPlayer];
        String opponent = PlayerNames[-_currentPlayer];
        _info = "$opponent doesn't have a valid move!\n $current should play again!";
      } else {
        _currentPlayer = -_currentPlayer;
        _info = '';
      }
    });
  }

  bool _inRange(int x, int y) {
    return (x >= 0 && x < BOARD_SIZE && y >= 0 && y < BOARD_SIZE);
  }

  bool _isValid(int x, int y, int player) {
    if (!_inRange(x, y))  return false;
    if (board[x][y] != EMPTY) return false;

    for(int dx=-1; dx<=1; dx++)
      for(int dy=-1; dy<=1; dy++) {
        var opponent = false, self = false;
        for(int i=x+dx,j=y+dy; _inRange(i, j); i+=dx,j+=dy) {

          if (board[i][j] == EMPTY) break;
          if (board[i][j] == player) {
            self = true;
            break;
          } else
            opponent = true;
        }
        if (self && opponent) return true;
      }
    return false;
  }

  bool _hasValidMove(int player) {
    // one of the players has no pegs left
    if (_cnt[X] == 0 || _cnt[O] == 0)
      return false;
    // there are no empty cells
    if (_cnt[X] + _cnt[O] == BOARD_SIZE*BOARD_SIZE)
      return false;

    for(int i=0; i<BOARD_SIZE; i++)
      for(int j=0; j<BOARD_SIZE; j++)
        if (_isValid(i, j, player))
          return true;

    return false;
  }

  int _winner() {
    // if one of the players has a valid move, the game is not finished
    if (!_hasValidMove(X) && !_hasValidMove(O))
      return (_cnt[X] > _cnt[O] ? X : _cnt[X] < _cnt[O] ? O : X);
    return INF;
  }


  void _move(int x, int y, int player) {
    board[x][y] = player;

    _cnt[player]++;
    for(int dx=-1; dx<=1; dx++)
      for(int dy=-1; dy<=1; dy++) {
        var opponent = false, self = false;
        int i = x+dx, j = y+dy;
        for(; _inRange(i, j); i+=dx,j+=dy) {
          if (board[i][j] == EMPTY) break;
          if (board[i][j] == player) { self = true; break; }
          else opponent = true;
        }
        if (self && opponent)
          for(int I=x+dx,J=y+dy; I!=i || J!=j; I+=dx,J+=dy) {
            board[I][J] = player;
            _cnt[X] += player;
            _cnt[O] -= player;
          }
      }
  }

  int _score(player) {

   var weight;
    if(player == X){
      weight = weightFirstPlayer;
    }else{
      weight = weightSecondPlayer;
    }
      weight[1][1] = weight[1][0] = weight[0][1] = (board[0][0] == player) ? 2 : -1;
      weight[1][6] = weight[1][7] = weight[0][6] = (board[0][7] == player) ? 2 : -1;
      weight[6][1] = weight[7][1] = weight[6][0] = (board[7][0] == player) ? 2 : -1;
      weight[6][6] = weight[7][6] = weight[6][7] = (board[7][7] == player) ? 2 : -1;

      int s = 0;
      for(int i=0; i<BOARD_SIZE; i++)
        for(int j=0; j<BOARD_SIZE; j++)
          s += (board[i][j] == player ? 1 : board[i][j] == -player ? -1 : 0) * weight[i][j];


      return s;

  }

  Move _findBestMove(int player, int depth, int alpha, int beta, int maxPlayer) {


    var w = _winner();
    if (w != INF) {
      var val = (w == 0 ? 0 : w == maxPlayer ? INF : -INF);
      return Move(score: val);
    }

    if (depth == 0) {
      return Move(score: _score(maxPlayer));
    };

    var cut = false;
    var xx = -1, yy = -1;
    var tmpBoard, tmpCnt;
    var notMoved = true;

    for(int i=0; i<BOARD_SIZE && !cut; i++) {
      for (int j = 0; j < BOARD_SIZE && !cut; j++) {
        if (!_isValid(i, j, player)) continue;
        if (xx == -1) {
          xx = i;
          yy = j;
        }

        tmpBoard = [for(var L in board) [...L]];
        tmpCnt = Map.from(_cnt);

        _move(i, j, player);
        notMoved = false;
        var r = _findBestMove(-player, depth - 1, alpha, beta, maxPlayer);

        board = [for(var L in tmpBoard) [...L]];
        _cnt = Map.from(tmpCnt);

        if (player == maxPlayer) {
          if (r.score > alpha) {
            alpha = r.score;
            xx = i;
            yy = j;
          }
        }
        else {
          if (r.score < beta)
            beta = r.score;
        }


        if (beta <= alpha)
          cut = true;

//        if(moveCounter==0 && r.score ==-3){
//          print('cut');
//          cut = true;
//        }
      }
    }
    if (notMoved) {

      tmpBoard = [for(var L in board) [...L]];
      tmpCnt = Map.from(_cnt);

      var r = _findBestMove(-player, depth-1, alpha, beta, maxPlayer);

      board = [for(var L in tmpBoard) [...L]];
      _cnt = Map.from(tmpCnt);

      if (player == maxPlayer) {
        if (r.score > alpha) alpha = r.score;
      }
      else {
        if (r.score < beta) beta = r.score;
      }
    }

    if (player == maxPlayer) {
      return Move(score: alpha, x: xx, y: yy);
    }

    return Move(score: beta, x: xx, y: yy);
  }

}

class Move {
  int score;
  int x;
  int y;

  Move({this.score, this.x = -1, this.y = -1});
}
