import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({Key? key}) : super(key: key);

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<String> _board = List.filled(9, '');
  bool _isPlayerTurn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text(
    'Tic Tac Toe',
    style: TextStyle(
      color: Colors.black,
    ),
  ),
  backgroundColor: Colors.yellow,
  centerTitle: true,
      ),
      body: _buildBoard(),
    );
  }

  Widget _buildBoard() {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: 9,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return _buildSquare(index);
      },
    );
  }

  Widget _buildSquare(int index) {
  return GestureDetector(
    onTap: () => _handleTap(index),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: _board[index] == 'P'
            ? Colors.green
            : _board[index] == 'A'
                ? Colors.red
                : Colors.white,
      ),
    ),
  );
}


  void _handleTap(int index) {
  if (_board[index] == '' && _isPlayerTurn) {
    setState(() {
      _board[index] = 'P';
      _isPlayerTurn = false;
    });

    if (_isGameOver()) {
      return;
    }

    _aiTurn();
  }
}

void _aiTurn() {
  int bestScore = -1000;
  int bestMove = -1;

  for (int i = 0; i < 9; i++) {
    if (_board[i] == '') {
      _board[i] = 'A';
      int score = _minimax(_board, false);
      _board[i] = '';

      if (score > bestScore) {
        bestScore = score;
        bestMove = i;
      }
    }
  }

  if (bestMove != -1) {
    setState(() {
      _board[bestMove] = 'A';
      _isPlayerTurn = true;
    });
  }

  _isGameOver();
}



  int _minimax(List<String> board, bool isMaximizing) {
    String winner = _checkWinner(board);
    if (winner != '') {
      return winner == 'P' ? -1 : 1;
    }

    if (board.every((square) => square != '')) {
      return 0;
    }

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
    if (board[i] == '') {
      board[i] = 'A';
      int score = _minimax(board, false);
      board[i] = '';
      bestScore = max(score, bestScore);
    }
  }
  return bestScore;
} else {
  int bestScore = 1000;

  for (int i = 0; i < 9; i++) {
    if (board[i] == '') {
      board[i] = 'P';
      int score = _minimax(board, true);
      board[i] = '';
      bestScore = min(score, bestScore);
    }
  }
  return bestScore;
}
}

String _checkWinner(List<String> board) {
List<List<int>> winningPositions = [
[0, 1, 2],
[3, 4, 5],
[6, 7, 8],
[0, 3, 6],
[1, 4, 7],
[2, 5, 8],
[0, 4, 8],
[2, 4, 6],
];

for (List<int> winningPosition in winningPositions) {
  String a = board[winningPosition[0]];
  String b = board[winningPosition[1]];
  String c = board[winningPosition[2]];

  if (a == b && b == c && a != '') {
    return a;
  }
}

return '';
}

bool _isGameOver() {
String winner = _checkWinner(_board);
if (winner != '') {
  String message = winner == 'P' ? 'Player wins!' : 'AI wins!';
  _showDialog(message);
  return true;
} else if (_board.every((square) => square != '')) {
  _showDialog('It\'s a draw!');
  return true;
}

return false;
}

void _showDialog(String message) {
showDialog<void>(
context: context,
barrierDismissible: false,
builder: (BuildContext context) {
return AlertDialog(
title: Text(message),
actions: <Widget>[
TextButton(
child: const Text('Play again'),
onPressed: () {
setState(() {
_board = List.filled(9, '');
_isPlayerTurn = true;
});
Navigator.of(context).pop();
},
),
],
);
},
);
}
}
     
