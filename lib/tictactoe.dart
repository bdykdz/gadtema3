import 'package:flutter/material.dart';

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({Key? key}) : super(key: key);

  @override
  TicTacToeGameState createState() => TicTacToeGameState();
}

class TicTacToeGameState extends State<TicTacToeGame> {
  // Tabla de joc și variabilele aferente stării.
  List<String> _board = List.filled(9, '');
  bool _isPlayer1Turn = true;
  List<int>? _winningIndices;

  @override
  Widget build(BuildContext context) {
    _winningIndices = _checkWinner(_board);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tic Tac Toe',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellow,
      ),
      body: Column(
        children: [
          // Construiește tabla de joc.
          Expanded(child: _buildBoard()),
          // Dacă există un câștigător sau remiză, afișează butonul "Play Again".
          if (_winningIndices != null || _isGameOver()) _buildPlayAgainButton(),
        ],
      ),
    );
  }

  // _buildBoard generează o grilă 3x3 folosind GridView.builder.
  Widget _buildBoard() {
    return GridView.builder(
      itemCount: 9,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        // Creează un pătrat la indexul dat.
        return _buildSquare(index);
      },
    );
  }

  // _buildSquare creează un pătrat la indexul dat, gestionând evenimentele onTap
  // și aplicând culoarea corespunzătoare în funcție de starea jocului.
  Widget _buildSquare(int index) {
    // Verifică dacă pătratul face parte din linia câștigătoare.
    bool isWinningSquare = _winningIndices != null && _winningIndices!.contains(index);
    bool gameOver = _isGameOver();

    // Construiește pătratul cu culoarea și comportamentul onTap corespunzător.
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

// _handleTap gestionează evenimentele de atingere pe fiecare pătrat, umplând
// pătratul dacă este gol și schimbând rândul între cei doi jucători.
  void _handleTap(int index) {
    if (_board[index] == '' && !_isGameOver()) {
      setState(() {
        _board[index] = _isPlayer1Turn ? 'P1' : 'P2';
        _isPlayer1Turn = !_isPlayer1Turn;
      });
    }
  }

// _isGameOver verifică dacă jocul s-a încheiat verificând dacă există un câștigător
// sau dacă tabla este plină.
  bool _isGameOver() {
    return _checkWinner(_board) != null || !_board.contains('');
  }

// _checkWinner verifică dacă există un câștigător pe tabla de joc comparând starea
// acesteia cu o listă de poziții câștigătoare posibile.
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

// _buildPlayAgainButton creează un buton care resetează starea jocului când este apăsat.
  Widget _buildPlayAgainButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _board = List.filled(9, '');
            _isPlayer1Turn = true;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
        ),
        child: const Text('Play again'),
      ),
    );
  }
}
