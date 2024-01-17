import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:joistic_assignment/google_signup.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({Key? key}) : super(key: key);

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  ValueNotifier userCredential = ValueNotifier('');

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
      print('xxxx ${googleAuth?.accessToken}');
      print('xxxx ${googleAuth?.idToken}');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);

    } on Exception catch (e) {
      // TODO
      print('exception->$e');

    }
  }


  Future<GoogleSignInAccount?> _handleSignIn() async {
    try {
      //GoogleSignInAccount? googleSignInAccount = await GoogleSignInApi.login();
      GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email','openid'],signInOption: SignInOption.standard,);
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      //print("google login----------------------------${googleSignInAccount!.serverAuthCode}");
      print("google Signin----------------------------${account}");



      return account;
    } catch (error) {
      print('Error signing in with Google: $error');
      return null;
    }
  }


  Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignInApi.logout();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Google SignIn Screen')),
        body: ValueListenableBuilder(
            valueListenable: userCredential,
            builder: (context, value, child) {
              return (userCredential.value == '' ||
                  userCredential.value == null)
                  ? Center(
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: IconButton(
                    iconSize: 40,
                    icon: const Icon(Icons.login,size: 20,),
                    onPressed: () async {
                      //GoogleSignInAccount? account = await _handleSignIn();
                      userCredential.value = await signInWithGoogle();
                      if (userCredential.value != null)
                        print('ssssss');
                     print(userCredential.value.user!.email);
                    },
                  ),
                ),
              )
                  : Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 1.5, color: Colors.black54)),
                      child: Image.network(
                          userCredential.value.user!.photoURL.toString()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(userCredential.value.user!.displayName
                        .toString()),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(userCredential.value.user!.email.toString()),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          bool result = await signOutFromGoogle();
                          if (result) userCredential.value = '';
                        },
                        child: const Text('Logout'))
                  ],
                ),
              );
            }));
  }}
