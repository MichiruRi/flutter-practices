import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tiles.dart';

class TilesScreen extends StatelessWidget {
  TilesScreen({super.key});
  final int size = 8;
  int tapCounter = 0;
  List<Tile> gameTiles = [];

  @override
  Widget build(BuildContext context) {
    Provider.of<Tiles>(context, listen: false).getGameTiles(size);
    gameTiles = Provider.of<Tiles>(context, listen: false).gameTiles;
    return Consumer<Tiles>(
      builder: (context, tiles, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Memory Game'),
            actions: [
              IconButton(
                onPressed: () => resetGame(context),
                icon: Icon(Icons.refresh),
              )
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                      ),
                      itemCount: gameTiles.length,
                      itemBuilder: (context, index) {
                        var gameTile = gameTiles[index];
                        return GestureDetector(
                          onTap: () => tapTile(context, index, gameTile),
                          child: Card(
                            color: gameTile.isTapped || gameTile.isCleared
                                ? Colors.white
                                : Colors.blue,
                            child: GridTile(
                              child: Card(
                                color: Colors.blue,
                                child: gameTile.isTapped || gameTile.isCleared
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          'assets/images/${gameTile.image}',
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Taps: '),
                            TextSpan(
                              text: tiles.totalTaps.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Clears: '),
                            TextSpan(
                              text: tiles.totalClears.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        style: TextStyle(color: Colors.green),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Wrongs: '),
                            TextSpan(
                              text: tiles.totalWrongs.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void tapTile(BuildContext context, int index, Tile tile) {
    if (tapCounter == 2) {
      Provider.of<Tiles>(context, listen: false).clearTiles();
      Provider.of<Tiles>(context, listen: false).clearTaps();
      tapCounter = 0;
    }
    if (tile.isCleared == false) {
      if (tile.isTapped == false) {
        playSound(tile);
        tapCounter++;
      }
      Provider.of<Tiles>(context, listen: false).tap(index);
    }
  }

  void playSound(Tile tile) async {
    final player = AudioPlayer();
    await player.play(AssetSource(tile.sound));
  }

  void resetGame(BuildContext context) {
    if (gameTiles.isNotEmpty) {
      gameTiles.clear();
      Provider.of<Tiles>(context, listen: false).reset();
      Provider.of<Tiles>(context, listen: false).getGameTiles(size);
      gameTiles = Provider.of<Tiles>(context, listen: false).gameTiles;
    }
  }
}
