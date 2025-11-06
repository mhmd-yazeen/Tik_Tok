import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class SettingsProvider with ChangeNotifier {
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  String _aiDifficulty = 'Medium'; // Easy, Medium, Hard
  int _wins = 0;
  int _losses = 0;
  int _draws = 0;

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;
  String get aiDifficulty => _aiDifficulty;
  int get wins => _wins;
  int get losses => _losses;
  int get draws => _draws;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('sound') ?? true;
    _musicEnabled = prefs.getBool('music') ?? true;
    _aiDifficulty = prefs.getString('difficulty') ?? 'Medium';
    _wins = prefs.getInt('wins') ?? 0;
    _losses = prefs.getInt('losses') ?? 0;
    _draws = prefs.getInt('draws') ?? 0;
    if (_musicEnabled) _playBackgroundMusic();
    notifyListeners();
  }

  void toggleSound(bool value) {
    _soundEnabled = value;
    _saveSetting('sound', value);
    notifyListeners();
  }

  void toggleMusic(bool value) {
    _musicEnabled = value;
    _saveSetting('music', value);
    if (_musicEnabled) {
      _playBackgroundMusic();
    } else {
      _musicPlayer.stop();
    }
    notifyListeners();
  }

  void setDifficulty(String value) {
    _aiDifficulty = value;
    SharedPreferences.getInstance().then((prefs) => prefs.setString('difficulty', value));
    notifyListeners();
  }

  void updateStats({required bool isWin, required bool isDraw}) async {
    final prefs = await SharedPreferences.getInstance();
    if (isDraw) {
      _draws++;
      await prefs.setInt('draws', _draws);
    } else if (isWin) {
      _wins++;
      await prefs.setInt('wins', _wins);
    } else {
      _losses++;
      await prefs.setInt('losses', _losses);
    }
    notifyListeners();
  }
  
  void resetStats() async {
      final prefs = await SharedPreferences.getInstance();
      _wins = 0; _losses = 0; _draws = 0;
      await prefs.setInt('wins', 0);
      await prefs.setInt('losses', 0);
      await prefs.setInt('draws', 0);
      notifyListeners();
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) prefs.setBool(key, value);
  }

  void playSfx(String assetPath) {
    if (_soundEnabled) {
      _sfxPlayer.stop();
      // Ensure you have assets/audio/move.mp3 etc.
      _sfxPlayer.play(AssetSource(assetPath)); 
    }
  }

  void _playBackgroundMusic() {
      // _musicPlayer.setReleaseMode(ReleaseMode.loop);
      // _musicPlayer.play(AssetSource('audio/cyberpunk_bg.mp3'), volume: 0.3);
  }
}