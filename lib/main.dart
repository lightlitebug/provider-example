import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:provider1/counter.dart';
import 'package:provider1/weather.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.brown,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Counter>.value(value: Counter()),
        ChangeNotifierProvider<Weather>.value(value: Weather()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Provider Pattern'),
        ),
        body: ListView(
          children: <Widget>[
            MyCounter(),
            MyButtons(),
            Divider(color: Colors.black),
            MyWeather(),
          ],
        ),
      ),
    );
  }
}

class MyCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var counter = Provider.of<Counter>(context);

    return Padding(
      padding: EdgeInsets.only(top: 96, bottom: 24),
      child: Center(
        child: Text(
          '${counter.count}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 48.0,
          ),
        ),
      ),
    );
  }
}

class MyButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var counter = Provider.of<Counter>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Center(
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: counter.incrementCounter,
              child: Text('Increment'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
            ),
            RaisedButton(
              onPressed: counter.decrementCounter,
              child: Text('Decrement'),
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class MyWeather extends StatefulWidget {
  @override
  _MyWeatherState createState() => _MyWeatherState();
}

class _MyWeatherState extends State<MyWeather> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController = TextEditingController();
  bool _autovalidate = false;

  _submit(Weather weather) {
    final form = _formKey.currentState;

    if (form.validate()) {
      final cityName = _locationController.text;
      print(cityName);
      weather.getWeather(cityName);
    } else {
      _autovalidate = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var weather = Provider.of<Weather>(context);

    var mainWeatherDesc = weather.weatherInfo == null
        ? ''
        : weather.weatherInfo['weather'][0]['main'];

    return Form(
      key: _formKey,
      autovalidate: _autovalidate,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 36.0,
          horizontal: 16.0,
        ),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                filled: true,
                prefixIcon: Icon(Icons.search),
                labelText: 'City',
                hintText: 'Enter Location to watch for',
              ),
              validator: (value) {
                return value.length <= 1 ? 'Loaction too short' : null;
              },
            ),
            mainWeatherDesc.length > 0
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      mainWeatherDesc,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: RaisedButton(
                onPressed: () {
                  _submit(weather);
                },
                child: weather.loading
                    ? SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(),
                      )
                    : Text('Get Weather'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
