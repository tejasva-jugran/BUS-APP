// ignore_for_file: file_names, avoid_print, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BList with ChangeNotifier {
  List<dynamic> _l4 = [];

  List<dynamic> get l4 {
    return _l4;
  }

  int _PasCount = 0;

  String? _Id;

  String get Id {
    return _Id as String;
  }

  String? _sID;

  String get sID {
    return _sID as String;
  }

  int get PasCount {
    return _PasCount;
  }

  void setVal(int nval) => _PasCount = nval;

  Future<void> fetchData(_details) async {
    List<dynamic> l1 = [];
    List<dynamic> l2 = [];
    List<dynamic> l3 = [];

    try {
      var s1 = await FirebaseFirestore.instance
          .collection("Station")
          .where("Sname", isEqualTo: "${_details["Source"]}")
          .get();

      s1.docs.forEach((element) {
        Map<String, dynamic> m1 = element.data();
        Map<String, dynamic> mm1 = m1["IncBus"];
        mm1.forEach((key, value) {
          //print(key);
          l1.add(key);
        });
        //l1 = m1["IncBus"];
      });
    } catch (error) {
      print(error);
    }

    try {
      var s2 = await FirebaseFirestore.instance
          .collection("Station")
          .where("Sname", isEqualTo: "${_details["Destination"]}")
          .get();

      s2.docs.forEach((element) {
        Map<String, dynamic> m2 = element.data();
        Map<String, dynamic> mm2 = m2["IncBus"];
        mm2.forEach((key, value) {
          //print(key);
          l2.add(key);
        });
        //l2 = m2["IncBus"];
      });

      l1.forEach((ele1) {
        if (l2.contains(ele1)) {
          l3.add(ele1);
        }
      });

      l3.forEach(
        (element) async {
          //print(element);
          var s3 = await FirebaseFirestore.instance
              .collection("BusQR")
              .where("BusNum", isEqualTo: element)
              .get();
          s3.docs.forEach(
            (elems) {
              Map<String, dynamic> m3 = elems.data();
              Map<String, dynamic> temp = m3["Sdetails"];

              //print("yahanse $temp");

              var index1 = temp.keys.firstWhere((ele) {
                Map<String, dynamic> temp2 = temp[ele];
                return (temp2.containsKey("${_details["Source"]}"));
              });

              //print("C -> $index1");

              var index2 = temp.keys.firstWhere((ele) {
                Map<String, dynamic> temp2 = temp[ele];
                return (temp2.containsKey("${_details["Destination"]}"));
              });

              //print("T -> $index2");

              int a = int.parse(index1);
              int b = int.parse(index2);

              //print(b - a);

              if ((b - a) > 0) {
                //print("andar aaya main");

                _l4.add(m3);
                notifyListeners();
                //print(_l4);
              }
            },
          );
        },
      );
    } catch (error) {
      print(error);
    }

    /* notifyListeners();
    print("notify listener ke upar $amit");
    print("l4 ki updated length${_l4.length}"); */
  }

  Future<void> screenChange() async {
    l4.clear();
    setVal(0);
  }

  Future<void> getPasLog(String busNo) async {
    try {
      FirebaseFirestore.instance
          .collection("BusQR")
          .where("BusNum", isEqualTo: busNo)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          Map<String, dynamic> Finfo = element.data();
          _PasCount = Finfo["PasLog"];
          notifyListeners();
        });
      });
    } catch (error) {
      print(error);
    }
  }

  Future<String?> getID(String busNo) async {
    try {
      QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore
          .instance
          .collection("BusQR")
          .where("BusNum", isEqualTo: busNo)
          .get();

      value.docs.forEach((element) {
        print("provider se ${element.reference.id}");
        _Id = element.reference.id;

        notifyListeners();
      });
    } catch (error) {
      print(error);
    }
    return _Id;
  }

  Future<String?> getSID(String destination) async {
    try {
      QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore
          .instance
          .collection("Station")
          .where("Sname", isEqualTo: destination)
          .get();

      value.docs.forEach((element) {
        print("provider se ${element.reference.id}");
        _sID = element.reference.id;

        notifyListeners();
      });
    } catch (error) {
      print(error);
    }
    return _sID;
  }

  Future<void> changeData(String BID, String destination, int PasData) async {
    try {
      FirebaseFirestore.instance.collection("BusQR").doc(BID).update({
        "PasLog": PasData + 1,
      });

      String fId = "r4xqAhEvOnmdeSuS9ahD";

      FirebaseFirestore.instance.collection("Station").doc(fId).update({
        "IncBus": {
          "UDL200": 1,
        },
      });
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
