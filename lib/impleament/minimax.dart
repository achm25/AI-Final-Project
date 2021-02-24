import 'file:///D:/release/ai/lib/impleament/block_unit.dart';
import 'file:///D:/release/ai/lib/impleament/coordinate.dart';
import 'file:///D:/release/ai/lib/impleament/empty_block.dart';

class MiniMax{

  List<List<EmptyBlock>> emptySpaces;
  int currentTurn = 1;
   Map ThinkingDepth = {"Easy": 1, "Medium": 2, "Hard": 4};
   int INF = 2000000; // infinity
  List chooses = new List();
  List<List<BlockUnit>> table;
  static const int ITEM_EMPTY = 0;
  static const int ITEM_WHITE = 1;
  static const int ITEM_BLACK = -1;
    int x = 0;
     int y = 0;

  void initTable() { // ساخت حالت اولیه بازی
    table = List(); // وظیفه نگه داری مقدار هر خونه رو داره که سفیده سیاهه یا خالیه
    emptySpaces = List();
    for (int row = 0; row < 8; row++) {
      List<BlockUnit> list = List();
      List<EmptyBlock> emptyList = List();
      for (int col = 0; col < 8; col++) {
        list.add(BlockUnit(value: ITEM_EMPTY));   // با مقدار صفر ساخته می شه
        emptyList.add(EmptyBlock(row:row ,col: col));
      }
      table.add(list); // هر ردیف که ساخته شد به جدول بازی اضافه می شه
      emptySpaces.add(emptyList);
    }
  }

 List getBlockCanChoose(int player){
    List chooses = new List();
    for(List rowList in emptySpaces){
      for(EmptyBlock emptyBlock in rowList){
        //print("here5"+table[4][4].value.toString());
          if(canPlay(emptyBlock,player)){
          //  print(emptyBlock.row.toString() + " === " + emptyBlock.col.toString());
          chooses.add(emptyBlock);
          }
      }
    }
    return chooses;
  }


  Future<List> aiMove(List<List<BlockUnit>> table1, List<List<EmptyBlock>> emptySpaces1)async {
  for(int i = 0 ; i<8 ;i++){
    for(int j =0 ; j<8 ; j++){
      table[i][j].value = table1[i][j].value;
    }
  }
//   print("here4"+table1[4][4].value.toString());
//   print("here3"+table[4][4].value.toString());
//    print("=======");
    emptySpaces = new List();
    for(int i = 0 ; i<8 ;i++){
      List<EmptyBlock> emptyList = List();
      for(int j =0 ; j<emptySpaces1[i].length ; j++){
        EmptyBlock emptyBlock =  EmptyBlock(row:emptySpaces1[i][j].row ,col: emptySpaces1[i][j].col);
        emptyList.add(emptyBlock);
      }
      emptySpaces.add(emptyList);
    }
   

    findBestMove(3,1,-INF,INF);
    print("x::: " + x.toString());
    print("y::: " + y.toString());
  }

 int findBestMove(int depth, int maximizingPlayer, int alpha, int beta){

    if(depth == 0){
      print("ddddddddd");
      return  _score(maximizingPlayer) ;
    }
    if (maximizingPlayer == 1)
    {
      int best = -INF;
      List tempChooses = getBlockCanChoose(1); // پیدا کردن حرکات معتبر اون ترن
      for(EmptyBlock emptyBlock in tempChooses){
//        print("ssss1"+emptyBlock.col.toString());
        List<List<BlockUnit>> tempTable = table;
        List<List<EmptyBlock>> tempEmptySpaces = emptySpaces;
        move(emptyBlock.row,emptyBlock.col,1);
        int val = findBestMove(depth-1, -1, alpha, beta);
        table = tempTable;
        emptySpaces = tempEmptySpaces;
        if(val > best){
          x = emptyBlock.row;
          y = emptyBlock.col;

       //   print(" HHH ccccdsfadf  " + best.toString() + "  " + val.toString() );
          best = val;
        }
//        if(depth==3){
//          print(emptyBlock.row.toString() +" HHH " + emptyBlock.col.toString());
//          print(best);
//          print(alpha);
//          print(beta);
//        }
        if(best > alpha){
          alpha = best;
        }
        if(beta <= alpha){
          break;
        }
      }
      return best;
    }
    else
    {
      int best = INF;
      List tempChooses = getBlockCanChoose(-1); // پیدا کردن حرکات معتبر اون ترن
      for(EmptyBlock emptyBlock in tempChooses){
//        print("ssss2"+emptyBlock.col.toString());
        List<List<BlockUnit>> tempTable = table;
        List<List<EmptyBlock>> tempEmptySpaces = emptySpaces;
        move(emptyBlock.row,emptyBlock.col,-1);
        int val = findBestMove(depth-1, 1, alpha, beta);
        table = tempTable;
        emptySpaces = tempEmptySpaces;
        if(val < best){
          print(" HHH ccccdsfadf  " + best.toString() + "  " + val.toString() );
          best = val;
        }
        if(beta < best){
          beta = best;
        }

        if (beta <= alpha)
          break;
      }
      return best;
    }
  }



  bool move(int row, int col, int item) { // item هم مشخص می کنه سفیده یا سیاهه
    if (table[row][col].value == ITEM_EMPTY || table[row][col].value == 2) { // اول می بینه خونه خالی هست یا نه اگه خالی بود در مورد گذاشتن روش تصمیم می گیره
      List<Coordinate> listCoordinate = List();
      listCoordinate.addAll(checkRight(row, col, item));// این خط ها لیست تغییرات رو اضافه می کنند
      listCoordinate.addAll(checkDown(row, col, item));
      listCoordinate.addAll(checkLeft(row, col, item));
      listCoordinate.addAll(checkUp(row, col, item));
      listCoordinate.addAll(checkUpLeft(row, col, item));
      listCoordinate.addAll(checkUpRight(row, col, item));
      listCoordinate.addAll(checkDownLeft(row, col, item));
      listCoordinate.addAll(checkDownRight(row, col, item));

      if (listCoordinate.isNotEmpty) {
        table[row][col].value = item; // مهره من تو خونه مورد نظرم می شینه
        inverseItemFromList(listCoordinate);// عوض کردن رنگ خونه های اضافه شده بهش
        emptySpaces[row].removeWhere((element) => element.row == row && element.col==col);
        return true;
      }
    }
    return false;
  }


  void inverseItemFromList(List<Coordinate> list) { //اون خونه هایی که بهش اضافه کردیم و گفتیم باید تغییر کنند ، اینجا رنگشون رو دونه دونه عوض می کنیم
    for (Coordinate c in list) {
      table[c.row][c.col].value = inverseItem(table[c.row][c.col].value);
    }
  }

  int inverseItem(int item) {// تغییر رنگ ها رو انجام می ده
    if (item == ITEM_WHITE) {
      return ITEM_BLACK;
    } else if (item == ITEM_BLACK) {
      return ITEM_WHITE;
    }
    return item;
  }

  countItem(){
    int countWhite = 0;
    int countBlack = 0;
    for(int i = 0 ; i < 8 ; i++){
      for(int j = 0 ; j < 8 ; j++){
        if(table[i][j].value == ITEM_WHITE){
          countWhite++;
        }
        else if(table[i][j].value == ITEM_BLACK){
          countBlack++;
        }
      }
    }
  }



  int _score(player) {
    var weight = [
      [100,-20,10,5,5,10,-20,100],
      [-20,-50,-2,-2,-2,-2,-50,-20],
      [10,-2,-1,-1,-1,-1,-2,10],
      [5,-2,-1,-1,-1,-1,-2,5],
      [5,-2,-1,-1,-1,-1,-2,5],
      [10,-2,-1,-1,-1,-1,-2,-50,-20],
      [-20,-50,-2,-2,-2,-2,-50,-20],
      [100,-20,10,5,5,10,-20,100]
      ,];

//    weight[1][1] = weight[1][0] = weight[0][1] = (table[0][0] == player) ? 2 : -1;
//    weight[1][6] = weight[1][7] = weight[0][6] = (table[0][7] == player) ? 2 : -1;
//    weight[6][1] = weight[7][1] = weight[6][0] = (table[7][0] == player) ? 2 : -1;
//    weight[6][6] = weight[7][6] = weight[6][7] = (table[7][7] == player) ? 2 : -1;

    int s = 0;
    for(int i=0; i<8; i++)
      for(int j=0; j<8; j++)
        s += (table[i][j].value == player ? 1 : table[i][j].value == -player ? -1 : 0) * weight[i][j];


    print(s);
    return s;
  }




  bool canPlay(EmptyBlock emptyBlock,int player){
        List<Coordinate> listCoordinate = List();
        //print("here2"+table[4][4].value.toString());
        listCoordinate.addAll(checkRight(emptyBlock.row, emptyBlock.col, player)); // این خط ها لیست تغییرات رو اضافه می کنند
        if(listCoordinate.isNotEmpty){return true;}
        listCoordinate.addAll(checkDown(emptyBlock.row, emptyBlock.col, player));
        if(listCoordinate.isNotEmpty){return true;}
        listCoordinate.addAll(checkLeft(emptyBlock.row, emptyBlock.col, player));
        if(listCoordinate.isNotEmpty){return true;}
        listCoordinate.addAll(checkUp(emptyBlock.row, emptyBlock.col, player));
        if(listCoordinate.isNotEmpty){return true;}
        listCoordinate.addAll(checkUpLeft(emptyBlock.row, emptyBlock.col, player));
        if(listCoordinate.isNotEmpty){return true;}
        listCoordinate.addAll(checkUpRight(emptyBlock.row, emptyBlock.col, player));
        if(listCoordinate.isNotEmpty){return true;}
        listCoordinate.addAll(checkDownLeft(emptyBlock.row, emptyBlock.col, player));
        if(listCoordinate.isNotEmpty){return true;}
        listCoordinate.addAll(checkDownRight(emptyBlock.row, emptyBlock.col, player));
        if(listCoordinate.isNotEmpty){return true;}
    return false;
  }

  List<Coordinate> checkRight(int row, int col, int item) {
    List<Coordinate> list = List();
    if (col + 1 < 8) { //چک می کنیم خارج صفخه یه وقت نباشه
      for (int c = col + 1; c < 8; c++) {// میاد خونه هارو دونه دونه می گرده از خونه ای که هست به سمت راست این خونه حرکت می کنه
        if (table[row][c].value == item) {// اگه هم رنگ بود که دست نمیزنه
          return list;
        } else if (table[row][c].value == ITEM_EMPTY || table[row][c].value == 2) { // اگه خالی بود هم چیزی اضافه نمی کنه
          return List();
        } else {  // درحالتی که رنگ مخالف هست ، مختصات اونو اضافه می کنه
          list.add(Coordinate(row: row, col: c));
        }
      }
    }
    return List();
  }

  List<Coordinate> checkLeft(int row, int col, int item) {
    List<Coordinate> list = List();
    if (col - 1 >= 0) {
      for (int c = col - 1; c >= 0; c--) {
        if (table[row][c].value == item) {
          return list;
        } else if (table[row][c].value == ITEM_EMPTY || table[row][c].value == 2) {
          return List();
        } else {
          list.add(Coordinate(row: row, col: c));
        }
      }
    }
    return List();
  }

  List<Coordinate> checkDown(int row, int col, int item) {
    List<Coordinate> list = List();
    if (row + 1 < 8) {
      for (int r = row + 1; r < 8; r++) {
        if (table[r][col].value == item) {
          return list;
        } else if (table[r][col].value == ITEM_EMPTY || table[r][col].value == 2) {
          return List();
        } else {
          list.add(Coordinate(row: r, col: col));
        }
      }
    }
    return List();
  }

  List<Coordinate> checkUp(int row, int col, int item) {
   //print("here1"+table[4][4].value.toString());
    List<Coordinate> list = List();
    if (row - 1 >= 0) {
      for (int r = row - 1; r >= 0; r--) {
        if (table[r][col].value == item) {
          return list;
        } else if (table[r][col].value == ITEM_EMPTY || table[r][col].value == 2) {
          return List();
        } else {
          list.add(Coordinate(row: r, col: col));
        }
      }
    }
    return List();
  }

  List<Coordinate> checkUpLeft(int row, int col, int item) {
    List<Coordinate> list = List();
    if (row - 1 >= 0 && col - 1 >= 0) {
      int r = row - 1;
      int c = col - 1;
      while (r >= 0 && c >= 0) {
        if (table[r][c].value == item ) {
          return list;
        } else if (table[r][c].value == ITEM_EMPTY || table[r][c].value == 2) {
          return List();
        } else {
          list.add(Coordinate(row: r, col: c));
        }
        r--;
        c--;
      }
    }
    return List();
  }

  List<Coordinate> checkUpRight(int row, int col, int item) {
    List<Coordinate> list = List();
    if (row - 1 >= 0 && col + 1 < 8) {
      int r = row - 1;
      int c = col + 1;
      while (r >= 0 && c < 8) {
        if (table[r][c].value == item ) {
          return list;
        } else if (table[r][c].value == ITEM_EMPTY|| table[r][c].value == 2) {
          return List();
        } else {
          list.add(Coordinate(row: r, col: c));
        }
        r--;
        c++;
      }
    }
    return List();
  }

  List<Coordinate> checkDownLeft(int row, int col, int item) {
    List<Coordinate> list = List();

    if (row + 1 < 8 && col - 1 >= 0) {
      int r = row + 1;
      int c = col - 1;
      while (r < 8 && c >= 0) {
        if (table[r][c].value == item) {
          return list;
        } else if (table[r][c].value == ITEM_EMPTY || table[r][c].value == 2) {
          return List();
        } else {
          list.add(Coordinate(row: r, col: c));
        }
        r++;
        c--;
      }
    }
    return List();
  }

  List<Coordinate> checkDownRight(int row, int col, int item) {
    List<Coordinate> list = List();
    if (row + 1 < 8 && col + 1 < 8) {
      int r = row + 1;
      int c = col + 1;
      while (r < 8 && c < 8) {
        if (table[r][c].value == item) {

          return list;
        } else if (table[r][c].value == ITEM_EMPTY || table[r][c].value == 2) {

          return List();
        } else {
          list.add(Coordinate(row: r, col: c));
        }
        r++;
        c++;
      }
    }
    return List();
  }


}


class Move {
  int score;
  int x;
  int y;

  Move({this.score, this.x = -1, this.y = -1});
}


