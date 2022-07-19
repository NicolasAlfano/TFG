import 'package:flutter/material.dart';
import 'package:productos_app/providers/providers.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CreateWSService(),
        ),
        ChangeNotifierProvider(
          create: (_) => GeolocatorProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PetsService(),
        ), //el lazy por defecto esta en true, esto hace que no llame a la peticion http hasta que no se necesite
        ChangeNotifierProvider(
          create: (_) => UsersService(),
        ), //el lazy por defecto esta en true, esto hace que no llame a la peticion http hasta que no se necesite
        ChangeNotifierProvider(
          create: (_) => WalkersService(),
        ),
        ChangeNotifierProvider(
          create: (_) => WalkService(),
        ),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      initialRoute: HomeWalkerScreen.routeName,
      routes: {
        CreatePetScreen.routeName: (_) => CreatePetScreen(),
        CreateServiceScreen.routeName: (_) => CreateServiceScreen(),
        LoginScreen.routeName: (_) => LoginScreen(),
        HomeScreen.routeName: (_) => HomeScreen(),
        HomeWalkerScreen.routeName: (_) => HomeWalkerScreen(),
        TrackingMapScreen.routeName: (_) => TrackingMapScreen(),
        WalksScreen.routeName: (_) => WalksScreen(),
      },
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: AppBarTheme(
            elevation: 0,
            color: Colors.deepPurple,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.deepPurple, elevation: 0)),
    );
  }
}
