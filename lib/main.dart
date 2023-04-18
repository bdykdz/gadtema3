import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MaterialApp(
    home: TicTacToeGame(),
  ));
}

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({Key? key}) : super(key: key);

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<String> _board = List.filled(9, '');
  bool _isPlayerTurn = true;
  List<int>? _winningIndices;

  @override
  Widget build(BuildContext context) {
    _winningIndices = _checkWinner(_board);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Stack(
        children: [
          _buildBoard(),
          if (_winningIndices != null) _buildPlayAgainButton(),
        ],
      ),
    );
  }

  Widget _buildBoard() {
    return GridView.builder(
      itemCount: 9,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        return _buildSquare(index);
      },
    );
  }

Widget _buildSquare(int index) {
  bool isWinningSquare = _winningIndices != null && _winningIndices!.contains(index);
  bool gameOver = _isGameOver();

  return GestureDetector(
    onTap: () => _handleTap(index),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: isWinningSquare
            ? (_board[index] == 'P' ? Colors.green : Colors.red)
            : gameOver
                ? Colors.white
                : _board[index] == 'P'
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
    if (_isGameOver()) {
      if (_winningIndices != null) {
        return board[_winningIndices![0]] == 'A' ? 1 : -1;
      } else {
        return 0;
      }
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

  bool _isGameOver() {
    return _checkWinner(_board) != null || !_board.contains('');
  }

  List<int>? _checkWinner(List<String> board) {
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
        return winningPosition;
      }
    }

    return null;
  }

  Widget _buildPlayAgainButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _board = List.filled(9, '');
            _isPlayerTurn = true;
          });
        },
        child: const Text('Play again'),
      ),
    );
  }
}

