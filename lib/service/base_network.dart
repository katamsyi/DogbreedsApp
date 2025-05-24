import 'dart:convert';
import 'package:finalproject/model/dogs.dart';
import 'package:http/http.dart' as http;


class BaseNetwork{
  Future<List<Dogs?>> fetchDogs() async {
    var url = Uri.parse('https://api.api-ninjas.com/v1/dogs?max_height=200&offset=10');
    var response = await http.get(url,
        headers: {'X-Api-Key': 'U/m2jiX4hjQMgWA7U4DqWQ==IGiDqsuROi2BYIJF'});

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Dogs?> dogs = [];
    for (var i in data) {
      if (i != null) {
        dogs.add(Dogs.fromJson(i));
      }
    }

    print(response);
    return dogs;
  }

  Future<List<Dogs?>> fetchDogsBreeds(String name) async {
    var url = Uri.parse("https://api.api-ninjas.com/v1/dogs?name=$name");
    var response = await http.get(url,
        headers: {'X-Api-Key': 'U/m2jiX4hjQMgWA7U4DqWQ==IGiDqsuROi2BYIJF'});

    var data = await jsonDecode(utf8.decode(response.bodyBytes));
    var checkDogs =
        await jsonDecode(utf8.decode(response.bodyBytes));

    List<Dogs?> items = [];
    print(checkDogs);
    if (data != null && checkDogs != "No dog's breed found") {
      for (var i in data) {
        if (i != null && i['lines'] == null) {
          items.add(Dogs.fromJson(i));
        }
      }
    }

    print(response);
    return items;
  }
}