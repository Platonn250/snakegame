// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake/pages/blank.dart';
import 'package:snake/pages/food.dart';
import 'package:snake/pages/snakepixel.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snakeDirections { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  // grid dimensin
  int rowSize = 10;

  // curren score
  int currentScore = 0;

  bool gameStarted = false;

  int totalNumberOfSquares = 100;

  // snake position
  List<int> snakePos = [
    0,
    1,
    2,
  ];
  // snake direction is right
  var curretDirection = snakeDirections.RIGHT;

  //food location
  int foodPos = 55;

  // startgame
  void startGame() {
    gameStarted = true;
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        // keep snake moving
        moveSnake();
        // check game over
        if (gameOver()) {
          timer.cancel();
          // display message to the user
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Center(child: Text("G A M E   O V E R")),
                content: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(hintText: 'Enter name'),
                    ),
                    Text("Your Score is $currentScore"),
                  ],
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      submitScore();
                      Navigator.pop(context);
                      newGame();
                    },
                    child: Text('Submit'),
                    color: Colors.pink,
                  )
                ],
              );
            },
          );
        }

        // add a new head
        // snakePos.add(snakePos.last + 1);
        // // remove the tail
        // snakePos.removeAt(0);
      });
    });
  }

  void eatFood() {
    // snake is not where the foos=d is
    currentScore += 1;
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalNumberOfSquares);
    }
  }

  void moveSnake() {
    switch (curretDirection) {
      case snakeDirections.RIGHT:
        {
          // if nake is at the right need to djust
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            snakePos.add(snakePos.last + 1);
          }
          // add a head,

          // remove tail

        }

        break;
      case snakeDirections.LEFT:
        {
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            snakePos.add(snakePos.last - 1);
          }
          // add a head,

          // remove tail

        }

        break;
      case snakeDirections.UP:
        {
          // add a head,
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalNumberOfSquares);
          } else {
            snakePos.add(snakePos.last - rowSize);
          }
          // snakePos.add(snakePos.last - rowSize);
          // remove tail

        }

        break;
      case snakeDirections.DOWN:
        {
          // add a head,
          if (snakePos.last + rowSize > totalNumberOfSquares) {
            snakePos.add(snakePos.last + rowSize - totalNumberOfSquares);
          } else {
            snakePos.add(snakePos.last + rowSize);
          }
          // snakePos.add(snakePos.last + rowSize);
          // remove tail

        }

        break;

      default:
    }
    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      snakePos.removeAt(0);
    }

    // game over
  }

  bool gameOver() {
    // this occurs when there is duplicate postion list
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);

    if (bodySnake.contains(snakePos.last)) {
      return true;
    } else {
      return false;
    }
  }

  void submitScore() {}
  void newGame() {
    setState(() {
      snakePos = [0, 1, 2];
      foodPos = 55;
      curretDirection = snakeDirections.RIGHT;
      gameStarted = false;
      currentScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // high Scores
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // user current score
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("CUrrent Score"),
                    Text(
                      currentScore.toString(),
                    ),
                  ],
                ),

                Text(
                  'HIGH SCORE',
                  style: TextStyle(fontSize: 30),
                )
                // high scores
              ],
            ),
          ),

          // game grid
          Expanded(
            flex: 3,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 &&
                    curretDirection != snakeDirections.UP) {
                  // down
                  curretDirection = snakeDirections.DOWN;
                  print('moving down');
                } else if (details.delta.dy < 0 &&
                    curretDirection != snakeDirections.DOWN) {
                  // up
                  curretDirection = snakeDirections.UP;
                  print("moving up");
                }
              },
              onHorizontalDragUpdate: (details) {
                // back
                if (details.delta.dx > 0 &&
                    curretDirection != snakeDirections.LEFT) {
                  curretDirection = snakeDirections.RIGHT;
                  print('moving forward');
                  // forward
                } else if (details.delta.dx < 0 &&
                    curretDirection != snakeDirections.RIGHT) {
                  curretDirection = snakeDirections.LEFT;
                  print("moving backword");
                }
              },
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: totalNumberOfSquares,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowSize),
                itemBuilder: (context, index) {
                  if (snakePos.contains(index)) {
                    return SnakePixel();
                  } else if (foodPos == index) {
                    return FoodPixel();
                  } else {
                    return BlankPixel();
                  }
                  // return Text(index.toString());
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Center(
                child: MaterialButton(
                  onPressed: gameStarted ? () {} : startGame,
                  color: gameStarted ? Colors.grey[500] : Colors.pink,
                  child: Text("P L A Y"),
                ),
              ),
            ),
          )

          // payButon
        ],
      ),
    );
  }
}
