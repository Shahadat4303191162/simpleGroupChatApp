import 'package:class12chatapp/auth/firebase_auth.dart';
import 'package:class12chatapp/page/chat_room_page.dart';
import 'package:class12chatapp/page/launcher_page.dart';
import 'package:class12chatapp/page/login_page.dart';
import 'package:class12chatapp/page/profile_page.dart';
import 'package:class12chatapp/page/user_list_page.dart';
import 'package:class12chatapp/providers/chat_room_provider.dart';
import 'package:class12chatapp/providers/user_providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Userprovider()),
        ChangeNotifierProvider(create: (_) => chatRoomProvider()),
      ],
      child: const MyApp(),));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(AuthService.user !=null){
      Provider.of<Userprovider>(context, listen: false)
          .updateprofile(AuthService.user!.uid, {'available' : true});
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused){
      if(AuthService.user != null) {
        Provider.of<Userprovider>(context,listen: false)
            .updateprofile(AuthService.user!.uid, {'available' : false});
      }
    }else if(state == AppLifecycleState.resumed){
        if(AuthService.user != null){
          Provider.of<Userprovider>(context,listen: false)
              .updateprofile(AuthService.user!.uid, {'available' : true});
        }
      }
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: launcherPage.routeName,
      routes: {
        launcherPage.routeName:(_) => launcherPage(),
        loginPage.routeName:(_) => loginPage(),
        profilePage.routeName:(_) => profilePage(),
        ChatRoomPage.routeName:(_) => ChatRoomPage(),
        UserListPage.routeName:(_) => UserListPage(),
      },
    );
  }
}


