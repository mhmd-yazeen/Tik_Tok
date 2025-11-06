import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/theme.dart';
import '../providers/settings_provider.dart';
import '../widgets/background_wrapper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text("SETTINGS", style: AppTheme.neonFont),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.primaryNeon),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: BackgroundWrapper(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 60),
            _buildSectionTitle("GAMEPLAY"),
            _buildSwitch("Sound Effects", settings.soundEnabled, (val) => settings.toggleSound(val)),
            _buildSwitch("Background Music", settings.musicEnabled, (val) => settings.toggleMusic(val)),
             const SizedBox(height: 20),
            _buildSectionTitle("AI DIFFICULTY"),
            SegmentedButton<String>(
              segments: const [
                 ButtonSegment(value: 'Easy', label: Text('EASY')),
                 ButtonSegment(value: 'Medium', label: Text('MED')),
                 ButtonSegment(value: 'Hard', label: Text('HARD')),
              ],
              selected: {settings.aiDifficulty},
              onSelectionChanged: (Set<String> newSelection) {
                settings.setDifficulty(newSelection.first);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.selected)) {
                    return AppTheme.primaryNeon;
                  }
                  return AppTheme.bgLight;
                }),
                foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                   if (states.contains(MaterialState.selected)) return AppTheme.bgDark;
                   return Colors.white;
                })
              ),
            ),
             const SizedBox(height: 40),
             _buildSectionTitle("STATS"),
             Container(
               padding: const EdgeInsets.all(16),
               decoration: AppTheme.neonBox(Colors.white24, isBorderOnly: true),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                   _buildStat("WINS", settings.wins, Colors.greenAccent),
                   _buildStat("LOSSES", settings.losses, Colors.redAccent),
                   _buildStat("DRAWS", settings.draws, Colors.orangeAccent),
                 ],
               ),
             ),
             const SizedBox(height: 20),
             Center(
               child: TextButton(
                 onPressed: () => settings.resetStats(),
                 child: Text("RESET STATS", style: AppTheme.neonFont.copyWith(color: Colors.red)),
               ),
             )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(title, style: AppTheme.neonFont.copyWith(color: AppTheme.secondaryNeon, fontSize: 16)),
    );
  }

  Widget _buildSwitch(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: AppTheme.neonFont.copyWith(fontSize: 18)),
      value: value,
      activeColor: AppTheme.primaryNeon,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildStat(String label, int value, Color color) {
    return Column(
      children: [
        Text(value.toString(), style: AppTheme.neonFont.copyWith(fontSize: 30, color: color, fontWeight: FontWeight.bold)),
        Text(label, style: AppTheme.neonFont.copyWith(fontSize: 12, color: Colors.white70)),
      ],
    );
  }
}