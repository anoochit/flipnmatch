import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class CardItem extends StatefulWidget {
  const CardItem({super.key});

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  @override
  Widget build(BuildContext context) {
    return FlipCard(
      front: Container(),
      back: Container(),
    );
  }
}
