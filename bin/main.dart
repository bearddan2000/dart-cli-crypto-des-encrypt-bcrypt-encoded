import 'package:dbcrypt/dbcrypt.dart';
import 'package:dargon2/dargon2.dart';
import 'package:convert/convert.dart';
import 'package:dart_des/dart_des.dart';
import 'dart:convert';

final s = Salt.newSalt();
String key = '12345678'; // 8-byte
List<int> iv = [1, 2, 3, 4, 5, 6, 7, 8];

encrypt(psw) {
  DES desECB = DES(key: key.codeUnits, mode: DESMode.ECB);
  List<int> encrypted = desECB.encrypt(psw.codeUnits);
  return base64.encode(encrypted);
}

verify(psw1, psw2, hashed) {
  print("[VERIFY] $psw1\t$psw2");
  psw1 = encrypt(psw1);
  var isCorrect = new DBCrypt().checkpw(psw1, hashed);
  print("[VERIFY] $isCorrect");
}

hash(psw) {
  print("[HASH] plainPassword: $psw");
  psw = encrypt(psw);
  var hashed = new DBCrypt().hashpw(psw, new DBCrypt().gensalt());
  print("[HASH] hashedPassword: $hashed");
  return hashed;
}

main() async {
  String psw1 = "pass1234";
  String psw2 = "1234pass";
  String hash1 = await hash(psw1);
  String hash2 = await hash(psw2);
  verify(psw1, psw2, hash2);
  verify(psw1, psw1, hash1);
}
