import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Giris extends StatefulWidget {
  @override
  _GirisState createState() => _GirisState();
}

class _GirisState extends State<Giris> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String mesaj = "";
  @override
  void initState() {
    _auth.onAuthStateChanged.listen((user) {
      if (user != null) {
        mesaj += "\nKullanıcı oturumu açık";
      } else {
        mesaj += "\nKullanıcı oturumu kapalı";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Giris yap")),
        body: Center(
            child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Kullanıcı oluştur"),
              color: Colors.green,
              onPressed: emailvesifrekayit,
            ),
            RaisedButton(
              child: Text("Kullanıcı girişi"),
              color: Colors.pink,
              onPressed: emailvesifregiris,
            ),
            RaisedButton(
              child: Text("Çıkış yap"),
              color: Colors.red,
              onPressed: cikisYap,
            ),
            RaisedButton(
              child: Text("Şifremi unuttum!"),
              color: Colors.red,
              onPressed: sifremiUnuttum,
            ),
            RaisedButton(
              child: Text("Şifremi güncelle!"),
              color: Colors.red,
              onPressed: sifremiGuncelle,
            ),
            RaisedButton(
              child: Text("Email güncelle!"),
              color: Colors.red,
              onPressed: emailGuncelle,
            ),
            Text(mesaj),
          ],
        )));
  }

  emailvesifrekayit() async {
    String email = "ummuhanoksuz1@gmail.com";
    String sifre = "1234567";
    var firebaseUser = await _auth
        .createUserWithEmailAndPassword(email: email, password: sifre)
        .catchError((e) => debugPrint(e));

    debugPrint("Uid ${firebaseUser.user}");
    if (firebaseUser != null) {
      // firebaseUser.sendEmailVerification().then((data){}).catchError((e)=>debugPrint("Mail gönderirken hata"));
      setState(() {
        mesaj += "\nUid ${firebaseUser.user}";
      });
    }
  }

  void emailvesifregiris() {
    String email = "ummuhanoksuz1@gmail.com";
    String sifre = "234567";
    _auth.signInWithEmailAndPassword(email: email, password: sifre);
    setState(() {
      mesaj += "\nBaşarılı bir sekilde giriş yaptınız";
    });
  }

  void cikisYap() {
    if (_auth.currentUser() != null) {
      _auth.signOut().then((data) {
        setState(() {
          mesaj += "\nBaşarılı bir şeilde çıkış yapıldı";
        });
      }).catchError((e) {
        setState(() {
          mesaj += "\nÇıkış yaparken hata meydana geldi";
        });
      });
    } else {
      setState(() {
        mesaj += "\nOturum açmış kullanıcı yok";
      });
    }
  }

  void sifremiUnuttum() {
    String email = "ummuhanoksuz1@gmail.com";
    _auth.sendPasswordResetEmail(email: email).then((v) {
      setState(() {
        mesaj +=
            "\nMail başarı ile gönerilirildi lütfen sıfırlama işlemni yapınız";
      });
    }).catchError((e) {
      setState(() {
        mesaj +=
            "\nŞifre sıfırlamada bir hata meydana geldi lütfen emailinizin doğru olduğundan emin olunuz.";
      });
    });
  }

  void sifremiGuncelle() {
    _auth.currentUser().then((user) {
      if (user != null) {
        user.updatePassword("234567").then((a) {
          setState(() {
            mesaj = "Şİfre güncellendi";
          });
        }).catchError((e) {
          setState(() {
            mesaj = "Şifre güncelleme hatası";
          });
        });
      }
    }).catchError((e) {
      setState(() {
        mesaj = "Kullanıcı henüz giriş yapmamış";
      });
    });
  }

  void emailGuncelle() {
    _auth.currentUser().then((user) {
      if (user != null) {
        user.updateEmail("ummu@gmail.com").then((a) {
          setState(() {
            mesaj = "\nEmail güncellendi";
          });
        }).catchError((e) {
          setState(() {
            mesaj = "\nEmail güncelleme hatası";
          });
        });
      }
    }).catchError((e) {
      setState(() {
        mesaj = "\nKullanıcı henüz giriş yapmamış";
      });
    });
  }
}
