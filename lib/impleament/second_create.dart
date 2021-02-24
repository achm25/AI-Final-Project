import 'dart:math';

import 'file:///D:/release/ai/lib/impleament/block_unit.dart';
import 'file:///D:/release/ai/lib/impleament/coordinate.dart';
import 'file:///D:/release/ai/lib/impleament/empty_block.dart';
import 'file:///D:/release/ai/lib/impleament/minimax.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'اتللو',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'اتللو'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const double BLOCK_SIZE = 30; // انداره هر خونه
const int ITEM_EMPTY = 0;
const int ITEM_WHITE = 1;
const int ITEM_BLACK = -1;
// اگه یک بود سفید می ذاره اگه دو بود سیاه
class _MyHomePageState extends State<MyHomePage> {

  MiniMax miniMax = MiniMax();
  List<List<BlockUnit>> table;
  List<List<BlockUnit>> canChooseTable;
  List<List<EmptyBlock>> emptySpaces;
  int currentTurn = ITEM_BLACK;
  int countItemWhite = 0;
  int countItemBlack = 0;
// تعداد رو توی منو نمایش می ده

  @override
  void initState() {
    initTable();
    initTableItems();
    miniMax.initTable();
    super.initState();
  }

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

  void initTableItems() { // چهارتا مهره اولیه بازی می شینن سرجاشون
    table[3][3].value = ITEM_WHITE;
    table[4][3].value = ITEM_BLACK;
    table[3][4].value = ITEM_BLACK;
    table[4][4].value = ITEM_WHITE;
    print(emptySpaces[3].length);
    emptySpaces[3].removeWhere((element) => element.row == 3 && element.col==4);
    emptySpaces[3].removeWhere((element) => element.row == 3 && element.col==3);
    print(emptySpaces[3].length);
    emptySpaces[4].removeWhere((element) => element.row == 4 && element.col==4);
    emptySpaces[4].removeWhere((element) => element.row == 4 && element.col==3);
//    for(List rowList in emptySpaces){
//      for(EmptyBlock emptyBlock in rowList){
//        print(emptyBlock.row.toString() + " :: " + emptyBlock.col.toString());
//      }
//    }
  }

  int randomItem() {  // هیچ جا استفاده نشده
    Random random = Random();
    return random.nextInt(3);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Color(0xffecf0f1),
          child: Column(children: <Widget>[
            buildMenu(),
            Expanded(child: Center(
              child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xff34495e),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 8, color: Color(0xfc2c3e50))),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: buildTable() // وظیفه بروزرسانی ساخت ردیف ویجت هرخونه رو داره
                  )),
            )),
            buildScoreTab()
          ])),
    );
  }

  Widget buildScoreTab() {
    return Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
      Expanded(child: Container(color: Color(0xff34495e),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(padding: EdgeInsets.all(16),
                    child: buildItem(BlockUnit(value: ITEM_WHITE))),
                Text("x $countItemWhite", style: TextStyle(fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))
              ]))),
      Expanded(child: Container(color: Color(0xffbdc3c7),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(padding: EdgeInsets.all(16),
                    child: buildItem(BlockUnit(value: ITEM_BLACK))),
                Text("x $countItemBlack", style: TextStyle(fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))
              ])))
    ]);
  }

  Container buildMenu() {
    return Container(
      padding: EdgeInsets.only(top: 36, bottom: 12, left: 16, right: 16),
      color: Color(0xff34495e),
      child:
      Row(mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(onTap: () {
              restart();

            },
                child: Container(constraints: BoxConstraints(minWidth: 120),
                    decoration: BoxDecoration(color: Color(0xff27ae60),
                        borderRadius: BorderRadius.circular(4)),
                    padding: EdgeInsets.all(12),
                    child: Column(children: <Widget>[
                      Text("بازی جدید", style: TextStyle(fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))
                    ]))),
            Expanded(child: Container()),
            Container(constraints: BoxConstraints(minWidth: 120),
                decoration: BoxDecoration(color: Color(0xffbbada0),
                    borderRadius: BorderRadius.circular(4)),
                padding: EdgeInsets.all(8),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  Text("نوبت", style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
                  Container(margin: EdgeInsets.only(left: 8), child:
                  buildItem(BlockUnit(value: currentTurn)))
                ]))
          ]),
    );
  }

  List<Row> buildTable() {
    List<Row> listRow = List();
    for (int row = 0; row < 8; row++) {
      List<Widget> listCol = List();
      for (int col = 0; col < 8; col++) {
        listCol.add(buildBlockUnit(row, col));
      }
      Row rowWidget = Row(mainAxisSize: MainAxisSize.min, children: listCol);
      listRow.add(rowWidget);
    }
    return listRow;
  }

  Widget buildBlockUnit(int row, int col) {  // هرخونه سبز بازی رو می سازه
    return GestureDetector(
        onTap: ()async { // روش کلیک می کنیم بروزرسانی می شه با مقدار جدید
          bool hasChanged = pasteItemToTable(row, col, currentTurn);
          setState(() {

          });

          if(hasChanged){
            await miniMax.aiMove(table,emptySpaces);
            pasteItemToTable(miniMax.x, miniMax.y, 1);
            updateCountItem();
            setState(() {

            });
          }

        }, child: Container(
      decoration: BoxDecoration(
        color: Color(0xdf27ae68),
        borderRadius: BorderRadius.circular(2),
      ),
      width: BLOCK_SIZE,
      height: BLOCK_SIZE,
      margin: EdgeInsets.all(2),
      child: Center(child: buildItem(table[row][col])),
    ));
  }

  Widget buildItem(BlockUnit block) {
    if (block.value == ITEM_BLACK) {
      return Container(width: 30, height: 30,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black));
    } else if (block.value == ITEM_WHITE) {
      return Container(width: 30, height: 30,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white));
    }else if(block.value == 2){
      return Container(width: 30, height: 30,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red.shade200));
    }
    return Container();
  }
  // row , col مختصات نقطه داده شده هستند
  bool pasteItemToTable(int row, int col, int item) { // item هم مشخص می کنه سفیده یا سیاهه
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

        if(canPlay(inverseItem(currentTurn)))// چک می کنه ببینه نفر بعدی می تونه بازی کنه یا ن
            {
          currentTurn = inverseItem(currentTurn);// عوض کردن نوبت
        }
        updateCountItem();
        emptySpaces[row].removeWhere((element) => element.row == row && element.col==col);
        //canChoose(-1);
        return true;
      }
    }
    return false;
  }



  canChoose(int turn){
    for(int row=0 ; row < 8 ; row++)
    {
      for(EmptyBlock emptyBlock in emptySpaces[row]){
        List<Coordinate> listCoordinate = List();
        listCoordinate.addAll(checkRight(emptyBlock.row, emptyBlock.col, turn)); // این خط ها لیست تغییرات رو اضافه می کنند
        if(listCoordinate.isNotEmpty){table[emptyBlock.row][emptyBlock.col].value=2; break;}
        listCoordinate.addAll(checkDown(emptyBlock.row, emptyBlock.col, turn));
        if(listCoordinate.isNotEmpty){table[emptyBlock.row][emptyBlock.col].value=2; break;}
        listCoordinate.addAll(checkLeft(emptyBlock.row, emptyBlock.col, turn));
        if(listCoordinate.isNotEmpty){table[emptyBlock.row][emptyBlock.col].value=2; break;}
        listCoordinate.addAll(checkUp(emptyBlock.row, emptyBlock.col, turn));
        if(listCoordinate.isNotEmpty){table[emptyBlock.row][emptyBlock.col].value=2; break;}
        listCoordinate.addAll(checkUpLeft(emptyBlock.row, emptyBlock.col, turn));
        if(listCoordinate.isNotEmpty){table[emptyBlock.row][emptyBlock.col].value=2; break;}
        listCoordinate.addAll(checkUpRight(emptyBlock.row, emptyBlock.col, turn));
        if(listCoordinate.isNotEmpty){table[emptyBlock.row][emptyBlock.col].value=2; break;}
        listCoordinate.addAll(checkDownLeft(emptyBlock.row, emptyBlock.col, turn));
        if(listCoordinate.isNotEmpty){table[emptyBlock.row][emptyBlock.col].value=2; break;}
        listCoordinate.addAll(checkDownRight(emptyBlock.row, emptyBlock.col, turn));
        if(listCoordinate.isNotEmpty){table[emptyBlock.row][emptyBlock.col].value=2; break;}
      }
    }
  }

  bool canPlay(int nextTurn){

    for(int row=0 ; row < 8 ; row++)
    {
      for(EmptyBlock emptyBlock in emptySpaces[row]){
        List<Coordinate> listCoordinate = List();
        listCoordinate.addAll(checkRight(emptyBlock.row, emptyBlock.col, nextTurn)); // این خط ها لیست تغییرات رو اضافه می کنند
        if(listCoordinate.isNotEmpty){return true;}
        listCoordinate.addAll(checkDown(emptyBlock.row, emptyBlock.col, nextTurn));
        if(listCoordinate.isNotEmpty){return true;}
        listCoordinate.addAll(checkLeft(emptyBlock.row, emptyBlock.col, nextTurn));
        if(listCoordinate.isNotEmpty){return true;}
        listCoordinate.addAll(checkUp(emptyBlock.row, emptyBlock.col, nextTurn));
        if(listCoordinate.isNotEmpty){return true;}
        listCoordinate.addAll(checkUpLeft(emptyBlock.row, emptyBlock.col, nextTurn));
        if(listCoordinate.isNotEmpty){return true;}
        listCoordinate.addAll(checkUpRight(emptyBlock.row, emptyBlock.col, nextTurn));
        if(listCoordinate.isNotEmpty){return true;}
        listCoordinate.addAll(checkDownLeft(emptyBlock.row, emptyBlock.col, nextTurn));
        if(listCoordinate.isNotEmpty){return true;}
        listCoordinate.addAll(checkDownRight(emptyBlock.row, emptyBlock.col, nextTurn));
        if(listCoordinate.isNotEmpty){return true;}
      }
    }

    print('ggggggggggggggggg');
    //print(table[2][2].value);
//    showDialog(context: context, child:
//    new AlertDialog(
//      title: new Text("خونه ای برای بازی ندارید"),
//      content: new Text("این دست رو حریفتون بازی می کنه"),
//    )
//    );

    return false;


  }

  List<Coordinate> checkRight(int row, int col, int item) {
    List<Coordinate> list = List();
    if (col + 1 < 8) { //چک می کنیم خارج صفخه یه وقت نباشه
      for (int c = col + 1; c < 8; c++) {// میاد خونه هارو دونه دونه می گرده از خونه ای که هست به سمت راست این خونه حرکت می کنه
        if (table[row][c].value == item) {// اگه هم رنگ بود که دست نمیزنه
          return list;
        } else if (table[row][c].value == ITEM_EMPTY|| table[row][c].value == 2) {// اگه خالی بود هم چیزی اضافه نمی کنه
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
        } else if (table[row][c].value == ITEM_EMPTY|| table[row][c].value == 2) {
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
        } else if (table[r][col].value == ITEM_EMPTY|| table[r][col].value == 2) {
          return List();
        } else {
          list.add(Coordinate(row: r, col: col));
        }
      }
    }
    return List();
  }

  List<Coordinate> checkUp(int row, int col, int item) {
    List<Coordinate> list = List();
    if (row - 1 >= 0) {
      for (int r = row - 1; r >= 0; r--) {
        if (table[r][col].value == item) {
          return list;
        } else if (table[r][col].value == ITEM_EMPTY|| table[r][col].value == 2) {
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
        if (table[r][c].value == item) {
          return list;
        } else if (table[r][c].value == ITEM_EMPTY|| table[r][c].value == 2) {
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
        if (table[r][c].value == item) {
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
        } else if (table[r][c].value == ITEM_EMPTY|| table[r][c].value == 2) {
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

  void updateCountItem() {
    countItemBlack = 0;
    countItemWhite = 0;
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if (table[row][col].value == ITEM_BLACK|| table[row][col].value == 2) {
          countItemBlack++;
        } else if (table[row][col].value == ITEM_WHITE) {
          countItemWhite++;
        }
      }
    }
  }

  void restart() {
    setState(() {
      countItemWhite = 0;
      countItemBlack = 0;
      currentTurn = ITEM_BLACK;
      initTable();
      initTableItems();
    });
  }
}