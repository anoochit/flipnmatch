import 'dart:async';
import 'dart:developer';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flipnmatch/pages/start.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.column, required this.multiply});

  final int column;
  final int multiply;

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

  // total    12    16    30    36
  // size     3x4   4x4   5x6   6x6
  // multipy  4     8    10      12

  int total = 0;
  int column = 3;
  int multipy = 4;
  String? tapVal;
  int? tapValIndex;
  bool toggle = false;
  bool match = false;
  bool start = true;

  int matchCount = 0;
  int countdown = 30;
  int score = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    // init card

    initCard();
    startGame();
  }

  initCard() {
    log('init card');
    // init size
    column = widget.column;
    multipy = widget.multiply;
    // init list size
    total = (chars.length) * multipy;
    // set time out
    if (total > 16) {
      countdown = 45;
    } else {
      countdown = 30;
    }
    // fill with default value
    cards.clear();
    cardsFlipable.clear();
    cardControllers.clear();
    List.generate(total, (i) => cardControllers.add(FlipCardController()));
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
    // init
    toggle = false;
    match = false;
    tapVal = null;
    tapValIndex = null;
    score = 0;
    matchCount = 0;
  }

  startGame() {
    log('start game');

    timer = Timer.periodic(const Duration(seconds: 1), (value) {
      setState(() {
        log('${value.tick}');

        countdown--;
        log('count down = $countdown');

        if (countdown == 0) {
          stopGame();
        }
      });
    });
  }

  stopGame() {
    timer?.cancel();
    timer = null;
    log('stop game');
    setState(() {
      for (int i = 0; i < total; i++) {
        cardsFlipable[i] = false;
      }
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Center(child: Text('Your score')),
          content: SizedBox(
              height: 100,
              child:
                  Center(child: Text('${((score * 10) + (countdown * 10))}'))),
          contentTextStyle: Theme.of(context).textTheme.displayLarge!,
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StartPage(),
                    ));
              },
              child: const Text('Ok'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: column,
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
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onFlipDone: (isFront) {
                      //

                      log('card =  ${cards[index]}');
                      // if toggle = false is a fist click, assign first value
                      if (isFront == false) {
                        if (toggle == false) {
                          log('assign value');
                          tapVal = cards[index];
                          tapValIndex = index;
                          toggle = true;
                        } else if ((toggle) && (tapValIndex != index)) {
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
                    },
                  );
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
