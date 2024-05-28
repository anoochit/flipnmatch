import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FlipCardController> cardControllers = [];

  List<String> cards = [];
  List<bool> cardsFlipable = [];

  List<String> chars = [
    'assets/images/dart.png',
    'assets/images/flutter.png',
    'assets/images/google.png'
  ];

  int total = 0;

  String? tapVal;
  int? tapValIndex;
  bool toggle = false;
  bool match = false;
  bool start = false;

  int matchCount = 0;

  @override
  void initState() {
    super.initState();
    // init card
    initCard();
  }

  initCard() {
    // init list size
    total = (chars.length) * 4;
    // fill with default value
    cards.clear();
    cardsFlipable.clear();
    List.generate(total, (i) => cards.add(''));
    List.generate(total, (i) => cardsFlipable.add(true));
    // fill card item
    int currentCharIndex = 0;
    for (int i = 0; i < total; i++) {
      cards[i] = chars[currentCharIndex];
      currentCharIndex = (currentCharIndex + 1) % chars.length;
    }
    // shuffle
    cards.shuffle();
    // init card controller
    cardControllers.clear();
    List.generate(total, (i) => cardControllers.add(FlipCardController()));
    // init
    toggle = false;
    match = false;
    tapVal = null;
    tapValIndex = null;
    score = 0;
    countdown = 30;
    matchCount = 0;
  }

  late Timer timer;
  late int countdown;

  int score = 0;

  startGame() {
    timer = Timer.periodic(const Duration(seconds: 1), (value) {
      setState(() {
        countdown--;
        if (countdown == 0) {
          stopGame();
        }
      });
    });
    initCard();
    setState(() {
      start = true;
    });
  }

  stopGame() {
    timer.cancel();
    setState(() {
      for (int i = 0; i < total; i++) {
        cardsFlipable[i] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: start,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Score = $score',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            Visibility(
              visible: (start),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Time left $countdown sec',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            Visibility(
              visible: start,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(4.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
                itemCount: total,
                itemBuilder: (BuildContext context, int index) {
                  return FlipCard(
                    controller: cardControllers[index],
                    side: CardSide.BACK,
                    flipOnTouch: cardsFlipable[index],
                    speed: 250,
                    front: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Image.asset(cards[index]),
                    ),
                    back: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onFlipDone: (isFront) {
                      //
                      if ((isFront == false)) {
                        log('card =  ${cards[index]}');

                        // if toggle = false is a fist click, assign first value
                        if (isFront == false) {
                          if (toggle == false) {
                            log('assign value');
                            tapVal = cards[index];
                            tapValIndex = index;
                            toggle = true;
                          } else {
                            // if toggle is true, check match
                            log('check');
                            if (cards[tapValIndex!] == cards[index]) {
                              log('match');
                              setState(() {
                                match = true;
                                cardsFlipable[index] = false;
                                cardsFlipable[tapValIndex!] = false;
                                score++;
                                matchCount++;
                                if (matchCount == (total / 2)) {
                                  stopGame();
                                }
                              });
                            } else {
                              log('not match');
                              log('first${cards[tapValIndex!]}');
                              log('last${cards[index]}');
                              Future.delayed(const Duration(milliseconds: 50))
                                  .then((v) {
                                cardControllers[tapValIndex!].toggleCard();
                              });
                              Future.delayed(const Duration(milliseconds: 50))
                                  .then((v) {
                                cardControllers[index].toggleCard();
                              });

                              match = false;
                            }
                            toggle = false;
                          }
                        }
                      }
                    },
                  );
                },
              ),
            ),
            Visibility(
              visible: !start,
              child: FilledButton(
                onPressed: () {
                  startGame();
                },
                child: Text('Start!'),
              ),
            )
          ],
        ),
      )),
    );
  }
}
