import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../utils/theme.dart';
import '../widgets/neon_button.dart';
import '../widgets/background_wrapper.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWrapper(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(
                duration: const Duration(seconds: 1),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppTheme.primaryNeon, AppTheme.secondaryNeon],
                  ).createShader(bounds),
                  child: Text("TIC TAC\nTOE NEO",
                      textAlign: TextAlign.center,
                      style: AppTheme.neonFont.copyWith(
                        fontSize: 50,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        color: Colors.white, // Required for ShaderMask
                      )),
                ),
              ),
              const SizedBox(height: 60),
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: Column(
                  children: [
                    NeonButton(
                      text: "PLAY VS AI",
                      color: AppTheme.primaryNeon,
                      onTap: () {
                        context.read<GameProvider>().startGame(GameMode.ai);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
                      },
                    ),
                    NeonButton(
                      text: "LOCAL MULTIPLAYER",
                      color: AppTheme.secondaryNeon,
                      onTap: () {
                        context.read<GameProvider>().startGame(GameMode.pvp);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
                      },
                    ),
                    NeonButton(
                      text: "SETTINGS",
                      color: Colors.white,
                      onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}