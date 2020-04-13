import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_firebase/models/user.dart';
import 'package:first_firebase/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null && user.isEmailVerified ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  // sign in anonymously
  Future signInAnonymous() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signinWithEmailAndPass(String email, String pass) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: pass);
      FirebaseUser user = result.user;
      if (user.isEmailVerified){
        return _userFromFirebaseUser(user);
      } else {
        print('Please verify email first.');
        return await signOut();
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPass(String email, String pass) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      FirebaseUser user = result.user;

      // call sendEmailVerification function
      await sendEmailVerification(user);

      // if(await isEmailVerified()){
      //   // create a new document for the vendor with the uid
      //   await DatabaseService(uid: user.uid).updateUserData('merkato', 23.0, 50);
      // }
      await signOut();
      return 'verify';
      
      //return _userFromFirebaseUser(user);

    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // send email verification 
  Future sendEmailVerification(FirebaseUser user) async {
    try{
      return await user.sendEmailVerification();
    } catch(e){
      print(e.toString());
      return null;
    }
    
  }

  // check if email is verified
  Future<bool> isEmailVerified() async {
    var user = await _auth.currentUser();
    return user.isEmailVerified;
  }
}
