import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

enum GameMode { pvp, ai }

class GameProvider with ChangeNotifier {
  List<String> _board = List.filled(9, '');
  bool _isXTurn = true;
  String _winner = '';
  List<int> _winningLine = [];
  bool _isGameOver = false;
  GameMode _mode = GameMode.pvp;
  int _timeLeft = 10;
  Timer? _timer;

  List<String> get board => _board;
  bool get isXTurn => _isXTurn;
  String get winner => _winner;
  List<int> get winningLine => _winningLine;
  bool get isGameOver => _isGameOver;
  int get timeLeft => _timeLeft;

  void startGame(GameMode mode) {
    _board = List.filled(9, '');
    _isXTurn = true;
    _winner = '';
    _winningLine = [];
    _isGameOver = false;
    _mode = mode;
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 10;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
      } else {
        // Time ran out, switch turn or auto-move randomly
         _makeMove( _getRandomEmptyIndex(), isTimeOut: true);
      }
      notifyListeners();
    });
  }
  
  int _getRandomEmptyIndex() {
      List<int> empty = [];
      for (int i = 0; i < 9; i++) if (_board[i] == '') empty.add(i);
      if (empty.isEmpty) return -1;
      return empty[Random().nextInt(empty.length)];
  }

  Future<void> makeMove(int index, BuildContext context) async {
     _makeMove(index);
  }

  void _makeMove(int index, {bool isTimeOut = false}) {
    if (_board[index] != '' || _isGameOver) return;

    _board[index] = _isXTurn ? 'X' : 'O';
    _checkWinner();

    if (!_isGameOver) {
      _isXTurn = !_isXTurn;
      _startTimer();
      if (_mode == GameMode.ai && !_isXTurn) {
         // AI's turn (O)
         _timer?.cancel(); // Pause timer for AI thinking
         Future.delayed(const Duration(milliseconds: 700), () {
             _playAIMove();
         });
      }
    } else {
        _timer?.cancel();
    }
    notifyListeners();
  }

  void _playAIMove() {
     if (_isGameOver) return;
     // Simple AI hook - connect to difficulty in SettingsProvider for real app
     // Defaulting to Minimax (Hard) for demonstration
     int bestMove = _minimax(_board, 'O').index;
     if (bestMove != -1) {
        _board[bestMove] = 'O';
        _checkWinner();
        if (!_isGameOver) {
            _isXTurn = true;
            _startTimer();
        } else {
             _timer?.cancel();
        }
        notifyListeners();
     }
  }

  void _checkWinner() {
    // Winning combinations
    final List<List<int>> winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Cols
      [0, 4, 8], [2, 4, 6]             // Diagonals
    ];

    for (var pattern in winPatterns) {
      if (_board[pattern[0]] != '' &&
          _board[pattern[0]] == _board[pattern[1]] &&
          _board[pattern[1]] == _board[pattern[2]]) {
        _winner = _board[pattern[0]];
        _winningLine = pattern;
        _isGameOver = true;
        _timer?.cancel();
        return;
      }
    }

    if (!_board.contains('')) {
      _winner = 'Draw';
      _isGameOver = true;
       _timer?.cancel();
    }
  }
  
  // --- Minimax AI Implementation ---
  Move _minimax(List<String> newBoard, String player) {
    List<int> availSpots = [];
    for (int i = 0; i < 9; i++) if (newBoard[i] == '') availSpots.add(i);

    if (_checkWin(newBoard, 'X')) return Move(score: -10);
    if (_checkWin(newBoard, 'O')) return Move(score: 10);
    if (availSpots.isEmpty) return Move(score: 0);

    List<Move> moves = [];
    for (int i = 0; i < availSpots.length; i++) {
      Move move = Move();
      move.index = availSpots[i];
      newBoard[availSpots[i]] = player;

      if (player == 'O') {
        move.score = _minimax(newBoard, 'X').score;
      } else {
        move.score = _minimax(newBoard, 'O').score;
      }

      newBoard[availSpots[i]] = '';
      moves.add(move);
    }

    int bestMove = 0;
    if (player == 'O') {
      int bestScore = -10000;
      for (int i = 0; i < moves.length; i++) {
        if (moves[i].score > bestScore) {
          bestScore = moves[i].score;
          bestMove = i;
        }
      }
    } else {
      int bestScore = 10000;
      for (int i = 0; i < moves.length; i++) {
        if (moves[i].score < bestScore) {
          bestScore = moves[i].score;
          bestMove = i;
        }
      }
    }
    return moves[bestMove];
  }

  bool _checkWin(List<String> board, String player) {
     final wins = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]];
     for(var win in wins) {
         if (board[win[0]] == player && board[win[1]] == player && board[win[2]] == player) return true;
     }
     return false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class Move {
  int index;
  int score;
  Move({this.index = -1, this.score = 0});
}