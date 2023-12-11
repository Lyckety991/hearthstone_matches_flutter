import 'package:flutter/material.dart';
import 'package:hearthstone_matches_flutter/appconfig/appconfig.dart';

class MatchTile extends StatefulWidget {
   const MatchTile({
    super.key,
    required this.title,
    required this.yourClass,
    required this.enemyClass,
    required this.result,
      required this.date,
  });

  final String title;
  final DateTime date;
  final String yourClass;
  final String enemyClass;
  final String result;



  @override
  State<MatchTile> createState() => _MatchTileState();
}

class _MatchTileState extends State<MatchTile> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        elevation: 1,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          width: MediaQuery.of(context).size.width,
          height: 80,
          decoration:
          const BoxDecoration(

            color: Colors.transparent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title, style: titleStyle),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.yourClass,
                    style: subTitleStyle,
                  ),
                  const SizedBox(width: 10),
                  const Text("vs", style: subTitleStyle),
                  const SizedBox(width: 10),
                  Text(
                    widget.enemyClass,
                    style: subTitleStyle,
                  ),
                  const SizedBox(width: 180),
                  Text(widget.result, style: subTitleStyle),
                ],
              ),
              Text(widget.date as String),
            ],
          ),
        ),
      ),
    );
  }
}
