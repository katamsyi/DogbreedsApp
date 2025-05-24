import 'dart:convert';

List<Dogs> dogsFromJson(String str) => List<Dogs>.from(json.decode(str).map((x) => Dogs.fromJson(x)));

String dogsToJson(List<Dogs> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Dogs {
    String imageLink;
    double goodWithChildren;
    double goodWithOtherDogs;
    double shedding;
    double grooming;
    double drooling;
    double coatLength;
    double goodWithStrangers;
    double playfulness;
    double protectiveness;
    double trainability;
    double energy;
    double barking;
    double minLifeExpectancy;
    double maxLifeExpectancy;
    double maxHeightMale;
    double maxHeightFemale;
    double maxWeightMale;
    double maxWeightFemale;
    double minHeightMale;
    double minHeightFemale;
    double minWeightMale;
    double minWeightFemale;
    String name;

    Dogs({
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
    });

    factory Dogs.fromJson(Map<String, dynamic> json) => Dogs(
        imageLink: json["image_link"],
        goodWithChildren: json["good_with_children"]?.toDouble(),
        goodWithOtherDogs: json["good_with_other_dogs"]?.toDouble(),
        shedding: json["shedding"]?.toDouble(),
        grooming: json["grooming"]?.toDouble(),
        drooling: json["drooling"]?.toDouble(),
        coatLength: json["coat_length"]?.toDouble(),
        goodWithStrangers: json["good_with_strangers"]?.toDouble(),
        playfulness: json["playfulness"]?.toDouble(),
        protectiveness: json["protectiveness"]?.toDouble(),
        trainability: json["trainability"]?.toDouble(),
        energy: json["energy"]?.toDouble(),
        barking: json["barking"]?.toDouble(),
        minLifeExpectancy: json["min_life_expectancy"],
        maxLifeExpectancy: json["max_life_expectancy"],
        maxHeightMale: json["max_height_male"],
        maxHeightFemale: json["max_height_female"],
        maxWeightMale: json["max_weight_male"],
        maxWeightFemale: json["max_weight_female"],
        minHeightMale: json["min_height_male"],
        minHeightFemale: json["min_height_female"],
        minWeightMale: json["min_weight_male"],
        minWeightFemale: json["min_weight_female"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "image_link": imageLink,
        "good_with_children": goodWithChildren,
        "good_with_other_dogs": goodWithOtherDogs,
        "shedding": shedding,
        "grooming": grooming,
        "drooling": drooling,
        "coat_length": coatLength,
        "good_with_strangers": goodWithStrangers,
        "playfulness": playfulness,
        "protectiveness": protectiveness,
        "trainability": trainability,
        "energy": energy,
        "barking": barking,
        "min_life_expectancy": minLifeExpectancy,
        "max_life_expectancy": maxLifeExpectancy,
        "max_height_male": maxHeightMale,
        "max_height_female": maxHeightFemale,
        "max_weight_male": maxWeightMale,
        "max_weight_female": maxWeightFemale,
        "min_height_male": minHeightMale,
        "min_height_female": minHeightFemale,
        "min_weight_male": minWeightMale,
        "min_weight_female": minWeightFemale,
        "name": name,
    };
}
