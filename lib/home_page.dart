import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var serviceController = TextEditingController();
  int? currentRadio;
  bool roundUp = false;
  double tip = 0.0;
  var radioGroup = {0: "Amazing 20%", 1: "Good 18%", 2: "Okay 15%"};
  var percentages = [0.2, 0.18, 0.15];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tip time'),
      ),
      body: ListView(
        children: [
          SizedBox(height: 14),
          ListTile(
            leading: Icon(Icons.store),
            title: Padding(
              padding: EdgeInsets.only(right: 24),
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: serviceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Cost of service"),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.room_service),
            title: Text("How was the service?"),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: radioGroupGenerator(),
            ),
          ),
          ListTile(
            leading: Icon(Icons.north_east),
            title: Text("Round up tip"),
            trailing: Switch(
              value: roundUp,
              onChanged: (value) {
                setState(() {
                  roundUp = value;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: MaterialButton(
              child: Text("CALCULATE"),
              onPressed: () {
                _tipCalculation();
              },
              color: Colors.green,
            ),
          ),
          Text(
            "Tip amount: \$${tip.toStringAsFixed(2)}",
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  void _tipCalculation() {
    if (currentRadio == null) {
      emptyRadio();
    } else if (serviceController.text.isEmpty) {
      emptyTextField();
    } else {
      tip = double.parse(serviceController.text) * percentages[currentRadio!];
      if (roundUp) tip = tip.ceilToDouble();
      setState(() {});
    }
  }

  radioGroupGenerator() {
    return radioGroup.entries
        .map(
          (radioElement) => ListTile(
            leading: Radio(
              value: radioElement.key,
              groupValue: currentRadio,
              onChanged: (int? selected) {
                currentRadio = selected;
                setState(() {});
              },
            ),
            title: Text("${radioElement.value}"),
          ),
        )
        .toList();
  }

  void emptyTextField() {
    showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: Text("Error while calculating tip"),
          content: Text("Service cost empty \nPlease fill the field"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            )
          ],
        );
      }),
    );
  }

  void emptyRadio() {
    showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: Text("Error while calculating tip"),
          content:
              Text("No tip percentage selected \nPlease select one option"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            )
          ],
        );
      }),
    );
  }
}
