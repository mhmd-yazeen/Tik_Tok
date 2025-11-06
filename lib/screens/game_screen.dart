import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import '../utils/theme.dart';
import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/background_wrapper.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final settings = context.read<SettingsProvider>();

    // Listen for Game Over to show dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (game.isGameOver) {
        _showResultDialog(context, game, settings);
      }
    });

    return Scaffold(
      body: BackgroundWrapper(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.primaryNeon),
                      onPressed: () => Navigator.pop(context)),
                  Text("TIME: ${game.timeLeft}s", style: AppTheme.neonFont.copyWith(fontSize: 20, color: game.timeLeft < 4 ? Colors.red : Colors.white)),
                  IconButton(
                      icon: const Icon(Icons.refresh, color: AppTheme.primaryNeon),
                      onPressed: () => _restart(context)),
                ],
              ),
            ),
            const Spacer(),
            // Turn Indicator
            Text(
              game.isXTurn ? "X's TURN" : "O's TURN",
              style: AppTheme.neonFont.copyWith(
                fontSize: 28,
                color: game.isXTurn ? AppTheme.primaryNeon : AppTheme.secondaryNeon,
                shadows: AppTheme._neonShadow(game.isXTurn ? AppTheme.primaryNeon : AppTheme.secondaryNeon),
              ),
            ),
            const SizedBox(height: 30),
            // Game Grid
            Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    final isWinningTile = game.winningLine.contains(index);
                    return GestureDetector(
                      onTap: () {
                        if (game.board[index] == '') {
                          settings.playSfx('audio/move.mp3'); // Placeholder
                          game.makeMove(index, context);
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: AppTheme.neonBox(
                           isWinningTile ? Colors.greenAccent : (game.board[index] == 'X' ? AppTheme.primaryNeon : (game.board[index] == 'O' ? AppTheme.secondaryNeon : Colors.white24)),
                           isBorderOnly: true
                        ).copyWith(
                          color: isWinningTile ? Colors.greenAccent.withOpacity(0.2) : AppTheme.bgLight,
                        ),
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                            child: Text(
                              game.board[index],
                              key: ValueKey(game.board[index]),
                              style: AppTheme.neonFont.copyWith(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: game.board[index] == 'X' ? AppTheme.primaryNeon : AppTheme.secondaryNeon,
                                shadows: AppTheme._neonShadow(game.board[index] == 'X' ? AppTheme.primaryNeon : AppTheme.secondaryNeon)
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  void _restart(BuildContext context) {
     // Use the same mode as before
     // This is a simplified restart, ideally pass mode back
     context.read<GameProvider>().startGame(GameMode.pvp);
  }

  void _showResultDialog(BuildContext context, GameProvider game, SettingsProvider settings) {
    String title = game.winner == 'Draw' ? "IT'S A DRAW!" : "${game.winner} WINS!";
    bool isWin = game.winner == 'X'; // Assuming User is always X in Single Player for simplicity here
    
    // Update stats ONLY if it's the first time this dialog shows for this game
    // (Requires slightly more complex state to prevent double counting on hot reload, but works for standard play)
    // settings.updateStats(isWin: isWin, isDraw: game.winner == 'Draw');
    // if(isWin) settings.playSfx('audio/win.mp3');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
             Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.bgDark.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.primaryNeon, width: 2),
                boxShadow: [BoxShadow(color: AppTheme.primaryNeon.withOpacity(0.5), blurRadius: 30)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Placeholder for Lottie: Lottie.asset(isWin ? 'assets/lottie/win.json' : 'assets/lottie/lose.json', height: 150),
                  Icon(game.winner == 'Draw' ? Icons.balance : Icons.emoji_events, size: 80, color: Colors.yellowAccent),
                  const SizedBox(height: 16),
                  Text(title, style: AppTheme.neonFont.copyWith(fontSize: 28, color: Colors.white)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.home, size: 40, color: AppTheme.secondaryNeon),
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context); // Go home
                        },
                      ),
                       IconButton(
                        icon: const Icon(Icons.replay, size: 40, color: AppTheme.primaryNeon),
                        onPressed: () {
                          Navigator.pop(context);
                          _restart(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            // Confetti overlay if win
            // if (game.winner != 'Draw') Positioned.fill(child: Lottie.asset('assets/lottie/confetti.json', repeat: false)),
          ],
        ),
      ),
    );
  }
}