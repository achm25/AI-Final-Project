import 'package:ai/ai_vs_ai.dart';
import 'package:ai/game_page.dart';
import 'package:flutter/material.dart';


String title = "Reversi";

void main() {
  runApp(Reversi());
}

class Reversi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: title),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String difficulty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff34495e),
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset('assets/img/menu.jpg'),
            Text("Select Game Mode", style: TextStyle(fontSize: 24),),
//          DropdownButton<String>(
//            value: difficulty,
//            onChanged: (String newValue) {
//              setState(() {
//                difficulty = newValue;
//              });
//            },
//            items: <String>['Easy', 'Medium', 'Hard']
//                .map<DropdownMenuItem<String>>((String value) {
//              return DropdownMenuItem<String>(
//                value: value,
//                child: Text(value),
//              );
//            }).toList(),
//            hint: Text('Select AI Level'),
//          ),
            Center(
              child: RaisedButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GamePage(title: widget.title, difficulty: 'Hard')
                      )
                  );
                },
                color: Colors.greenAccent,
                child: Text("One VS AI", style: TextStyle(fontSize: 24),),
              ),
            ),
            Center(
              child: RaisedButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AIVSAI(title: widget.title, difficulty: 'Hard')
                      )
                  );
                },
                color: Colors.greenAccent,
                child: Text("AI VS AI ", style: TextStyle(fontSize: 24),),
              ),
            )
          ],
        ),
      ),
    );
  }
}