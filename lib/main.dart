import 'package:flutter/material.dart';

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
  bool _isPlayer1Turn = true;
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
              ? (_board[index] == 'P1' ? Colors.green : Colors.red)
              : gameOver
                  ? Colors.white
                  : _board[index] == 'P1'
                      ? Colors.green
                      : _board[index] == 'P2'
                          ? Colors.red
                          : Colors.white,
        ),
      ),
    );
  }

  void _handleTap(int index) {
    if (_board[index] == '' && !_isGameOver()) {
      setState(() {
        _board[index] = _isPlayer1Turn ? 'P1' : 'P2';
        _isPlayer1Turn = !_isPlayer1Turn;
      });
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
_isPlayer1Turn = true;
});
},
child: const Text('Play again'),
),
);
}
}