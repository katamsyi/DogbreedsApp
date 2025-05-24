import 'package:flutter/material.dart';

class DogDetails extends StatelessWidget {
  final String? imageLink;
  final double? goodWithChildren;
  final double? goodWithOtherDogs;
  final double? shedding;
  final double? grooming;
  final double? drooling;
  final double? coatLength;
  final double? goodWithStrangers;
  final double? playfulness;
  final double? protectiveness;
  final double? trainability;
  final double? energy;
  final double? barking;
  final double? minLifeExpectancy;
  final double? maxLifeExpectancy;
  final double? maxHeightMale;
  final double? maxHeightFemale;
  final double? maxWeightMale;
  final double? maxWeightFemale;
  final double? minHeightMale;
  final double? minHeightFemale;
  final double? minWeightMale;
  final double? minWeightFemale;
  final String? name;

  const DogDetails({
    Key? key,
    required this.imageLink,
    required this.goodWithChildren,
    required this.goodWithOtherDogs,
    required this.shedding,
    required this.grooming,
    required this.drooling,
    required this.coatLength,
    required this.goodWithStrangers,
    required this.playfulness,
    required this.protectiveness,
    required this.trainability,
    required this.energy,
    required this.barking,
    required this.minLifeExpectancy,
    required this.maxLifeExpectancy,
    required this.maxHeightMale,
    required this.maxHeightFemale,
    required this.maxWeightMale,
    required this.maxWeightFemale,
    required this.minHeightMale,
    required this.minHeightFemale,
    required this.minWeightMale,
    required this.minWeightFemale,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${name}"),
        backgroundColor: Color(0xffCEAB93),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 3,
            child: Image.network("${imageLink}"),
          ),
          Text(
            "${name}",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 0, 5),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Protectiveness"),
                    Text("Trainability"),
                    Text("Playfulness"),
                    Text("Energy"),
                    Text("Barking"),
                    Text("Shedding"),
                    Text("Grooming"),
                    Text("Drooling"),
                    Text("Good With Strangers"),
                    Text("Good With Children"),
                    Text("Good With Other Dogs"),
                    Text("Coat Length"),
                    Text("Min Life Expectancy"),
                    Text("Max Life Expectancy"),
                    Text("Max Height Male"),
                    Text("Max Height Female"),
                    Text("Max Weight Male"),
                    Text("Max Weight Female"),
                    Text("Min Height Male"),
                    Text("Min Height Female"),
                    Text("Min Weight Male"),
                    Text("Min Weight Female"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(" : ${protectiveness}"),
                    Text(" : ${trainability}"),
                    Text(" : ${playfulness}"),
                    Text(" : ${energy}"),
                    Text(" : ${barking}"),
                    Text(" : ${shedding}"),
                    Text(" : ${grooming}"),
                    Text(" : ${drooling}"),
                    Text(" : ${goodWithStrangers}"),
                    Text(" : ${goodWithChildren}"),
                    Text(" : ${goodWithOtherDogs}"),
                    Text(" : ${coatLength}"),
                    Text(" : ${minLifeExpectancy}"),
                    Text(" : ${maxLifeExpectancy}"),
                    Text(" : ${maxHeightMale}"),
                    Text(" : ${maxHeightFemale}"),
                    Text(" : ${maxWeightMale}"),
                    Text(" : ${maxWeightFemale}"),
                    Text(" : ${minHeightMale}"),
                    Text(" : ${minHeightFemale}"),
                    Text(" : ${minWeightMale}"),
                    Text(" : ${minWeightFemale}"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
