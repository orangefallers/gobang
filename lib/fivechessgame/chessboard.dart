import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter_app/fivechessgame/whitecircle.dart';

class ChessBoard extends CustomPainter {
  Paint brownPaint;
  Paint blackPaint;
  Paint whitePaint;

  static final int boardPadding = 10;

  double touchX = -1;
  double touchY = -1;
  bool isWhite = false;

  List<ChessPoint> chessList = new List();

  ChessBoard(List<ChessPoint> list) {
//    this.touchX = tx;
//    this.touchY = ty;
//    this.isWhite = isWhite;
    this.chessList.addAll(list);

    brownPaint = new Paint()
      ..color = Colors.brown
      ..strokeWidth = 4.0;

    blackPaint = new Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    whitePaint = new Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    var width = size.width;
    var height = size.height;
    print('width = $width , height = $height');

    if (size.width > size.height) {
      canvas.drawRect(
          new Rect.fromPoints(Offset(0, 0), Offset(size.height, size.height)),
          brownPaint);

      drawGridLine(canvas, size, size.height);
    } else {
      canvas.drawRect(
          new Rect.fromPoints(Offset(0, 0), Offset(size.width, size.width)),
          brownPaint);

      drawGridLine(canvas, size, size.width);
    }

    if (chessList.isNotEmpty) {
      for (ChessPoint chessPoint in chessList) {
        _paintAddChess(
            canvas, chessPoint._x, chessPoint._y, chessPoint._isWhite);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  drawGridLine(Canvas canvas, Size size, double width) {
    int intWidth = width.floor();
    intWidth = intWidth - intWidth % 2;
    var lineWidth = (intWidth - boardPadding * 2);
    var realLineWidth = lineWidth - (lineWidth % 18);
    var offsetX = realLineWidth / 18;

    var realPadding = (lineWidth - realLineWidth) / 2 + boardPadding;

    print(
        'width = $intWidth, lineWidth  = $lineWidth, realLineWidth = $realLineWidth, offsetX = $offsetX , realPadding = $realPadding');

    var index = 0;

    for (double i = (0 + realPadding);
        i <= (realLineWidth + realPadding);
        i = (i + offsetX)) {
      canvas.drawLine(Offset(i, 0 + realPadding),
          Offset(i, width - realPadding), blackPaint);

      canvas.drawLine(Offset(0 + realPadding, i),
          Offset(width - realPadding, i), blackPaint);

      // draw black point
      switch (index) {
        case 3:
          canvas.drawCircle(Offset(i, i), 4, blackPaint);
          canvas.drawCircle(Offset(i, i + offsetX * 6), 4, blackPaint);
          canvas.drawCircle(Offset(i, i + offsetX * 12), 4, blackPaint);
          break;
        case 9:
          canvas.drawCircle(Offset(i, i), 4, blackPaint);
          canvas.drawCircle(Offset(i, i - offsetX * 6), 4, blackPaint);
          canvas.drawCircle(Offset(i, i + offsetX * 6), 4, blackPaint);
          break;
        case 15:
          canvas.drawCircle(Offset(i, i), 4, blackPaint);
          canvas.drawCircle(Offset(i, i - offsetX * 6), 4, blackPaint);
          canvas.drawCircle(Offset(i, i - offsetX * 12), 4, blackPaint);
          break;
      }

      index++;
    }
  }

  addChess(double x, double y, bool isWhite) {
    touchX = x;
    touchY = y;

    this.isWhite = isWhite;
  }

  _paintAddChess(Canvas canvas, int tX, int tY, bool isWhite) {
    print('tx = $tX , ty = $tY');

    if (isWhite) {
      canvas.drawCircle(Offset(tX.floorToDouble(), tY.floorToDouble()), 8.0, whitePaint);
    } else {
      canvas.drawCircle(Offset(tX.floorToDouble(), tY.floorToDouble()), 8.0, blackPaint);
    }
  }
}

class ChessPoint {
  final int _x, _y;
  final bool _isWhite;
  final int _pX, _pY;  //range 0~18

  ChessPoint(this._x, this._y, this._isWhite, this._pX, this._pY);

  bool get isWhite => _isWhite;

  int get y => _y;

  int get x => _x;

  int get pX => _pX;

  int get pY => _pY;

  @override
  bool operator ==(other) {
    return other is ChessPoint && _x == other.x && _y == other.y;
  }
}
