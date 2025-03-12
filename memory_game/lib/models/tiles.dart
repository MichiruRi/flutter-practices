import 'package:flutter/material.dart';

class Tiles extends ChangeNotifier {
  final List<Tile> _tiles = [
    Tile(
      name: 'Car',
      image: 'laugh-point.gif',
      sound: 'cat point laugh.mp3',
    ),
    Tile(
      name: 'Bogos Binted',
      image: 'bogos binted.jpg',
      sound: 'bogos binted.mp3',
    ),
    Tile(
      name: 'aj',
      image: 'aj.png',
      sound: 'Vine-boom-sound-effect.mp3',
    ),
  ];
  final List<Tile> _gameTiles = [];
  bool isStart = false;
  int totalTaps = 0;
  int totalClears = 0;
  int totalWrongs = 0;

  List<Tile> get tiles => _tiles;
  List<Tile> get gameTiles => _gameTiles;

  void getGameTiles(int size) {
    if (isStart == false) {
      for (var i = 0; i < size; i++) {
        for (var i = 0; i < _tiles.length; i++) {
          var tile = Tile(
            name: _tiles[i].name,
            image: _tiles[i].image,
            sound: _tiles[i].sound,
          );
          _gameTiles.add(tile);
        }
      }
      _gameTiles.shuffle();
      isStart = true;
    }
  }

  int oldIndex = -1;
  void tap(int index) {
    totalTaps++;
    _gameTiles[index].isTapped = true;
    notifyListeners();
  }

  void clearTaps() {
    for (var tile in _gameTiles) {
      tile.isTapped = false;
    }
    notifyListeners();
  }

  void clearTiles() {
    int index1 = -1;
    int index2 = -1;
    for (var i = 0; i < _gameTiles.length; i++) {
      if (_gameTiles[i].isTapped) {
        index1 == -1 ? index1 = i : index2 = i;
      }
    }
    if (index1 != -1 && index2 != -1) {
      if (_gameTiles[index1].name == _gameTiles[index2].name) {
        _gameTiles[index1].isCleared = true;
        _gameTiles[index2].isCleared = true;
        totalClears++;
      } else {
        totalWrongs++;
      }
    }
    notifyListeners();
  }

  void reset() {
    isStart = false;
    totalTaps = 0;
    totalClears = 0;
    totalWrongs = 0;
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }
}

class Tile {
  late int id;
  final String name;
  final String image;
  late String sound;
  late bool isTapped;
  late bool isCleared;

  Tile({
    this.id = 0,
    required this.name,
    required this.image,
    this.sound = 'Vine-boom-sound-effect.mp3',
    this.isTapped = false,
    this.isCleared = false,
  });
}
