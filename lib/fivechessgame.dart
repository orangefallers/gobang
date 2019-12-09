import 'package:flutter/material.dart';
import 'package:flutter_app/fivechessgame/chessboard.dart';
import 'package:flutter_app/fivechessgame/whitecircle.dart';
import 'package:flutter_app/fivechessgame/blackcircle.dart';
import 'package:piecemeal/piecemeal.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:collection';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "five chess game",
      theme: new ThemeData(
          primaryColor: Colors.deepPurple, accentColor: Colors.yellowAccent),
      home: new testWidget(),
    );
  }
}

class testWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new testState();
  }
}

class testState extends State<testWidget> {
  double posX = 10;
  double posY = 10;

  bool _isWhite = false;
  bool _isWin = false;

  ChessBoard chessBoard;

  GlobalKey paintKey = new GlobalKey();

  List<ChessPoint> chessList = new List();

  ChessPoint chessPoint = new ChessPoint(0, 0, false, 0, 0);

  // 1= white , 2= black , 0= none
  Array2D array2d = new Array2D<int>(19, 19);

  void onTapDown(BuildContext context, TapDownDetails tabDownDetails) {
    print('tapDown = ${tabDownDetails.globalPosition}');

    final RenderBox box = paintKey.currentContext.findRenderObject();
    Size size = paintKey.currentContext.size;
    print('size width = ${size.width}, height = ${size.height}');

    final Offset localOffset = box.globalToLocal(tabDownDetails.globalPosition);

    setState(() {
      if (_isWin) {
        return;
      }

      posX = localOffset.dx;
      posY = localOffset.dy;
      this._isWhite = !this._isWhite; //白子變黑子 or 黑子變白子

      chessPoint = calculateChessPos(size.width, posX, posY, _isWhite);

      if (!chessList.contains(chessPoint)) {
        chessList.add(chessPoint);
        array2d.set(chessPoint.pX, chessPoint.pY, _isWhite ? 1 : 2);

        this._isWin = ixFiveConnectWin(
            chessPoint.pX, chessPoint.pY, chessPoint.isWhite, array2d);
      } else {
        print('is added x= ${chessPoint.x}, y= ${chessPoint.y}');
        this._isWhite = !this._isWhite; //因為下到已下過得位置，所以要變回來
      }

      print(
          'array 2d chess postion (${chessPoint.pX},${chessPoint.pY}) = color(${array2d.get(chessPoint.pX - 1, chessPoint.pY)})');
//      chessBoard.addChess(posX, posY, false);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      posX = 0;
      posY = 0;
      this._isWhite = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Container(
        color: Colors.white70,
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            new Container(
              child: new Text(
                '來下五子棋囉',
                style: new TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 32,
                    decoration: TextDecoration.none),
              ),
              padding: EdgeInsets.all(32.0),
            ),
            new Center(
              child: new AspectRatio(
                aspectRatio: 1.0,
                child: new GestureDetector(
                  onTapDown: (TapDownDetails details) =>
                      onTapDown(context, details),
                  child: CustomPaint(
                    key: paintKey,
                    painter: new ChessBoard(chessList),
                  ),
                ),
              ),
            ),
            new GameStatusWidget(
              _isWhite,
              _isWin,
            )
          ],
        ));
  }

  ChessPoint calculateChessPos(
      double cWidth, double tX, double tY, bool isWhite) {
    int intWidth = cWidth.floor();
    intWidth = intWidth - intWidth % 2;
    var lineWidth = (intWidth - ChessBoard.boardPadding * 2);
    var realLineWidth = lineWidth - (lineWidth % 18);
    var offsetX = realLineWidth / 18;

    int startPosX = ((intWidth - realLineWidth) / 2).floor();
    int startPosY = ((intWidth - realLineWidth) / 2).floor();

    int cx = startPosX + ((tX / offsetX).floor() * offsetX).floor();
    int cy = startPosY + ((tY / offsetX).floor() * offsetX).floor();

    if (cx > (startPosX + (offsetX * 18))) {
      cx = startPosX + (offsetX * 18).floor();
    }

    if (cy > (startPosY + (offsetX * 18))) {
      cy = startPosY + (offsetX * 18).floor();
    }

    int ax = ((cx - startPosX) / offsetX).floor();
    int ay = ((cy - startPosY) / offsetX).floor();

    print('startPosX = $startPosX, cx = $cx , cy = $cy, ax = $ax, ay = $ay');
    return ChessPoint(cx, cy, isWhite, ax, ay);
  }

  bool ixFiveConnectWin(
      int posX, int posY, bool isWhite, Array2D<int> array2d) {
    int colorNum = isWhite ? 1 : 2;
    print('isWin colorNum = $colorNum');

//-----------------------------------------
    int count = 0;
    bool isEnd = false;

    for (int i = 0; !isEnd; i++) {
      if (array2d.get(posX + i, posY) == colorNum) {
        print('isWin posX = ${posX + i}, posY = $posY');
        count++;
      } else {
        isEnd = true;
      }
    }

    isEnd = false;
    for (int i = 1; !isEnd; i++) {
      if ((posX - i) < 0) {
        isEnd = true;
        break;
      }

      if (array2d.get(posX - i, posY) == colorNum) {
        print('isWin posX = ${posX - i}, posY = $posY');
        count++;
      } else {
        isEnd = true;
      }
    }
    print('isWin count = $count');

    if (count > 4) {
      return true;
    }
//-----------------------------------------

//-----------------------------------------
    count = 0;
    isEnd = false;

    for (int i = 0; !isEnd; i++) {
      if (array2d.get(posX, posY + i) == colorNum) {
        print('isWin posX = $posX, posY = ${posY + i}');
        count++;
      } else {
        isEnd = true;
      }
    }

    isEnd = false;

    for (int i = 1; !isEnd; i++) {
      if ((posY - i) < 0) {
        isEnd = true;
        break;
      }

      if (array2d.get(posX, posY - i) == colorNum) {
        print('isWin posX = $posX, posY = ${posY - i}');
        count++;
      } else {
        isEnd = true;
      }
    }

    print('isWin count = $count');
    if (count > 4) {
      return true;
    }
//-----------------------------------------

//-----------------------------------------
    count = 0;
    isEnd = false;

    for (int i = 0; !isEnd; i++) {
      if (array2d.get(posX + i, posY + i) == colorNum) {
        print('isWin posX = $posX, posY = ${posY + i}');
        count++;
      } else {
        isEnd = true;
      }
    }

    isEnd = false;

    for (int i = 1; !isEnd; i++) {
      if ((posX - i) < 0 || (posY - i) < 0) {
        isEnd = true;
        break;
      }

      if (array2d.get(posX - i, posY - i) == colorNum) {
        print('isWin posX = $posX, posY = ${posY - i}');
        count++;
      } else {
        isEnd = true;
      }
    }

    print('isWin count = $count');
    if (count > 4) {
      return true;
    }

    //-----------------------------------------

    count = 0;
    isEnd = false;

    for (int i = 0; !isEnd; i++) {
      if ((posY - i) < 0) {
        isEnd = true;
        break;
      }

      if (array2d.get(posX + i, posY - i) == colorNum) {
        print('isWin posX = $posX, posY = ${posY + i}');
        count++;
      } else {
        isEnd = true;
      }
    }

    isEnd = false;

    for (int i = 1; !isEnd; i++) {
      if ((posX - i) < 0) {
        isEnd = true;
        break;
      }

      if (array2d.get(posX - i, posY + i) == colorNum) {
        print('isWin posX = $posX, posY = ${posY - i}');
        count++;
      } else {
        isEnd = true;
      }
    }

    print('isWin count = $count');
    if (count > 4) {
      return true;
    }

    return false;
  }
}

class GameStatusWidget extends StatelessWidget {
  bool isWhite = false;

  bool isWin = false;

  GameStatusWidget(this.isWhite, this.isWin);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.black54,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Text(
            isGameOver(!isWhite, isWin),
            style: new TextStyle(
                color: !isWhite ? Colors.white : Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none),
          ),
          new Text(isWhoWin(isWhite, isWin),
              style: new TextStyle(
                  color: Colors.amber,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none))
        ],
      ),
    );
  }
}

String isWhoWin(bool isWhite, bool isWin) {
  if (isWin) {
    return isWhite ? '白子獲勝' : '黑子獲勝';
  } else {
    return ' 尚未分出勝負';
  }
}

String isGameOver(bool isWhite, bool isWin) {
  if (isWin) {
    return '比賽結束';
  } else {
    return isWhite ? '輪到白子' : '輪到黑子';
  }
}
