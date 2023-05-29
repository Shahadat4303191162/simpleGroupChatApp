import 'package:class12chatapp/auth/firebase_auth.dart';
import 'package:class12chatapp/models/usermodel.dart';
import 'package:class12chatapp/page/launcher_page.dart';
import 'package:class12chatapp/page/profile_page.dart';
import 'package:class12chatapp/providers/user_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class loginPage extends StatefulWidget {
  static const String routeName = 'Login';
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  bool isObscureText = true,
      isLogin = true;
  final formkey = GlobalKey<FormState>();
  String errMsg = '';

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: formkey,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 200.0,horizontal: 20.0),
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                  filled: true,
                ),
                validator: (value){
                  if(value ==null||value.isEmpty){
                    return 'This field must not be empty';
                  }
                  if(!emailRegex.hasMatch(value)){
                    return 'please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                obscureText: isObscureText,
                controller: passController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(isObscureText ? Icons.visibility_off: Icons.visibility),
                    onPressed: (){
                      setState(() {
                        isObscureText = !isObscureText;
                      });
                    },
                  ),
                  filled: true,

                ),
                validator: (value){
                  if(value ==null||value.isEmpty){
                    return 'This field must not be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  isLogin = true;
                  authenticate();
                },
                child: const Text('LOGIN'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New User?'),
                  TextButton(
                    onPressed: () {
                      isLogin = false;
                      authenticate();
                    },
                    child: const Text('Register Here'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Forget Password?'),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Click Here'),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Text(errMsg, style: TextStyle(color: Theme
                  .of(context)
                  .errorColor),)
            ],
          ),
        ),
      ),
    );
  }
  void authenticate() async{
    if(formkey.currentState!.validate()){
      bool status;

      try{
        if(isLogin){
          status = await AuthService.login(emailController.text, passController.text);
        }else{
          status = await AuthService.register(emailController.text, passController.text);
          final userModel = UserModel(
              uid: AuthService.user!.uid,
              email: AuthService.user!.email!);
          if(mounted){
            await Provider.of<Userprovider>(context,listen: false)
                .addUser(userModel);
            Navigator.pushReplacementNamed(context, launcherPage.routeName);
          }
        }if(status){
          Navigator.pushReplacementNamed(context, launcherPage.routeName);
        }
      }on FirebaseAuthException catch(e){
        setState(() {
          errMsg=e.message!;
        });
      }
    }

  }
}
