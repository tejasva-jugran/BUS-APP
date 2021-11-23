// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minoragain/models/Provider.dart';
import 'package:minoragain/pages/Scanqr.dart';
import 'package:provider/provider.dart';
//import 'package:minoragain/screens/ListofDetails.dart';

class BusDetailScreen extends StatefulWidget {
  //const BusDetailScreen({Key? key}) : super(key: key);

  Map<String, String> detailInfo;
  BusDetailScreen(this.detailInfo);

  @override
  _BusDetailScreenState createState() => _BusDetailScreenState();
}

class _BusDetailScreenState extends State<BusDetailScreen> {
  bool _isLoading = true;

  TextEditingController _controller = TextEditingController();

  void submitData() async {
    await Provider.of<BList>(context, listen: false)
        .fetchData(widget.detailInfo);
    await Future.delayed(Duration(seconds: 4));
    setState(() {
      _isLoading = false;
    });
  }

  bool _isExpanded = false;
  UniqueKey? keyTile;

  void expandTile() {
    setState(() {
      _isExpanded = true;
      keyTile = UniqueKey();
    });
  }

  void shrinkTile() {
    setState(() {
      _isExpanded = false;
      keyTile = UniqueKey();
    });
  }

  Future<void> _updateData(
      String busNo, String destination, int to_board) async {
    String? Bid = await Provider.of<BList>(context, listen: false).getID(busNo);
    String? sID =
        await Provider.of<BList>(context, listen: false).getSID(destination);

    int? sPasLog = await Provider.of<BList>(context, listen: false)
        .getsPasLog(destination, busNo);

    int? PasCount =
        await Provider.of<BList>(context, listen: false).getPasLog(busNo);

    print(PasCount);
    //print("Bus id hai => $Bid");
    //print("Station id hai => $sID");
    if (Bid != null && sID != null) {
      await Provider.of<BList>(context, listen: false)
          .changeData(Bid, PasCount, sID, sPasLog, busNo, to_board);
    }
  }

  @override
  void initState() {
    submitData();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<BList>(context, listen: false).screenChange();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Details"),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/b1.png",
                fit: BoxFit.fill,
              ),
            ),
            Consumer<BList>(
              builder: (ctx, data, ch) {
                return _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 6,
                        ),
                      )
                    : data.l4.length == 0
                        ? AlertDialog(
                            scrollable: true,
                            title: Text("Oops !"),
                            content: Text("No bus for the route"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("OK"),
                              )
                            ],
                          )
                        : ListView.builder(
                            itemBuilder: (ctx, index) {
                              Map<String, dynamic> temp = data.l4[index];
                              Map<String, dynamic> mp = temp["Sdetails"];

                              return Padding(
                                padding: EdgeInsets.only(
                                  top: 10,
                                  left: 10,
                                  right: 10,
                                ),
                                child: Card(
                                  child: ExpansionTile(
                                    key: keyTile,
                                    initiallyExpanded: _isExpanded,
                                    childrenPadding:
                                        EdgeInsets.all(10).copyWith(top: 0),
                                    leading: Icon(Icons.train),
                                    title: Text(temp["BusNum"]),
                                    subtitle: Text(
                                        "Available Seats ${100 - temp["PasLog"]}"),
                                    //trailing: Text("Time Required"),
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text("Bus Type"),
                                              Spacer(),
                                              Text("AC"),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text("Station Name"),
                                              Spacer(),
                                              Text("ETA"),
                                              Spacer(),
                                              Text("Delay in (min)"),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemBuilder: (cctx, ind) {
                                              Map<String, dynamic> sName =
                                                  mp[(ind + 1).toString()];

                                              var name = sName.keys.toString();
                                              name = name.substring(
                                                  1, name.length - 1);

                                              return Row(
                                                children: [
                                                  Text("$name"),
                                                  Spacer(),
                                                  Text("${sName[name][0]}"),
                                                ],
                                              );
                                            },
                                            itemCount: mp.length,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: 85,
                                                child: TextField(
                                                  controller: _controller,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    hintText: "Ticket",
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              FloatingActionButton.extended(
                                                onPressed: () {},
                                                label: Text("Pay Now"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: data.l4.length,
                          );
              },
            ),
          ],
        ),
      ),
    );
  }
}
