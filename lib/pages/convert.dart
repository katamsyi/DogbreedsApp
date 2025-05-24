import 'package:flutter/material.dart';

class ConvertPage extends StatefulWidget {
  const ConvertPage({Key? key}) : super(key: key);

  @override
  State<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  late double input;
  late double output;
  late String currencyInput;
  late String currencyOutput;
  late String result;

  TextEditingController _moneyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    input = 0;
    currencyInput = 'IDR';
    currencyOutput = 'IDR';
    result = '';
  }

  void onInputChanged(String value) {
    setState(() {
      input = double.tryParse(value) ?? 0;
    });
  }

  void onCurrencyInputChanged(String? value) {
    setState(() {
      currencyInput = value ?? 'IDR';
    });
  }

  void onCurrencyOutputChanged(String? value) {
    setState(() {
      currencyOutput = value ?? 'IDR';
    });
  }

  void convert() {
    setState(() {
      switch (currencyInput) {
        case 'IDR':
          switch (currencyOutput) {
            case 'IDR':
              output = input;
              break;
            case 'USD':
              output = input / 14200;
              break;
            case 'EUR':
              output = input / 17000;
              break;
          }
          break;
        case 'USD':
          switch (currencyOutput) {
            case 'IDR':
              output = input * 14200;
              break;
            case 'USD':
              output = input;
              break;
            case 'EUR':
              output = input * 0.85;
              break;
          }
          break;
        case 'EUR':
          switch (currencyOutput) {
            case 'IDR':
              output = input * 17000;
              break;
            case 'USD':
              output = input * 1.17;
              break;
            case 'EUR':
              output = input;
              break;
          }
          break;
      }
      result = output.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Money Converter',
        ),
        backgroundColor: Color(0xffCEAB93),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              height: 200,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Image.asset("assets/image/convert_money.jpg"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: TextField(
                    onChanged: onInputChanged,
                    controller: _moneyController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xffAD8B73),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xffAD8B73),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton(
                  dropdownColor: Colors.white,
                  value: currencyInput,
                  items: const <String>['IDR', 'USD', 'EUR']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  }).toList(),
                  onChanged: onCurrencyInputChanged,
                )
              ],
            ),
            SizedBox(height: 20),
            Icon(Icons.keyboard_arrow_down_outlined),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffAD8B73)),
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: 55,
                  child: Text(
                    result,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton(
                  dropdownColor: Colors.white,
                  value: currencyOutput,
                  items: const <String>['IDR', 'USD', 'EUR']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  }).toList(),
                  onChanged: onCurrencyOutputChanged,
                ),
              ],
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: convert,
              height: 45,
              color: Color(0xffAD8B73),
              child: Text(
                "Convert",
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputMoneyField() {
    return TextField(
      controller: _moneyController,
      cursorColor: Color(0xffAD8B73),
      decoration: InputDecoration(
        labelText: 'Input Money',
        labelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 14.0,
        ),
        prefixIcon: Icon(
          Icons.money_outlined,
          color: Color(0xffAD8B73),
          size: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        floatingLabelStyle: TextStyle(
          color: Color(0xffAD8B73),
          fontSize: 18.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAD8B73), width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
