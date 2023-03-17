import 'package:WeatherApp/delegates/SearchDelegate.dart';
import 'package:WeatherApp/events/WeatherEvent.dart';
import 'package:WeatherApp/states/WeatherState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/WeatherBloc.dart';
import 'components/MainScreenWrapper.dart';


void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorDark: Colors.white,
        primaryColor: Colors.white,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(),
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoadSuccess) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Color.fromRGBO(3, 4, 5, 6),
                actions: [
                  IconButton(
                    icon: Icon(Icons.gps_fixed),
                    onPressed: () {
                      BlocProvider.of<WeatherBloc>(context).add(WeatherCurrentPositionRequested());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.error),
                    onPressed: () {
                      _showDialog(context);

                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                          context: context, delegate: MySearchDelegate((query) {
                            BlocProvider.of<WeatherBloc>(context).add(WeatherRequested(city: query));
                      }));
                    },
                  )
                ],
              ),
              body: Padding(
                padding: EdgeInsets.only(top: 64),
                child: MainScreenWrapper(
                    weather: state.weather, hourlyWeather: state.hourlyWeather),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Color.fromRGBO(6, 6, 6, 6),
              actions: [
                IconButton(
                  icon: Icon(Icons.gps_fixed),
                  onPressed: () {
                    BlocProvider.of<WeatherBloc>(context).add(WeatherCurrentPositionRequested());
                  },
                ),
                IconButton(
                  icon: Icon(Icons.error),
                  onPressed: () {
                    _showDialog(context);

                  },
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                        context: context, delegate: MySearchDelegate((query) {
                      BlocProvider.of<WeatherBloc>(context).add(WeatherRequested(city: query));
                    }));
                  },
                )
              ],
            ),
            body: Center(
              child: CircularProgressIndicator(),
            )

          );
        },
      ),
    );
  }
}

void _showDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context)
  {
    return AlertDialog(
      title: new Text("Внимание!!"),
      content: new Text("Для корректного функционирования приложения необходимо в настройках разрешить приложению доступ к местоположению!"),
      actions: <Widget>[
    IconButton(
    icon: Icon(Icons.check),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  },
  );
}
