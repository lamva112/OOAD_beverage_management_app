import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//import constants
import 'package:ui_fresh_app/constants/colors.dart';
import 'package:ui_fresh_app/constants/fonts.dart';
import 'package:ui_fresh_app/constants/images.dart';
import 'package:ui_fresh_app/constants/others.dart';
import 'package:ui_fresh_app/firebase/firestoreDocs.dart';
import 'package:ui_fresh_app/models/importModel.dart';
import 'package:ui_fresh_app/models/importSubModel.dart';

//import widgets
import 'package:ui_fresh_app/views/widget/dialogWidget.dart';
import 'package:ui_fresh_app/views/widget/snackBarWidget.dart';

//import views
import 'package:ui_fresh_app/views/bartender/inventory/btImportEditing.dart';

//import others
import 'package:iconsax/iconsax.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';

class btImportDetailScreen extends StatefulWidget {
  String idImport;
  btImportDetailScreen({Key? key, required this.idImport}) : super(key: key);

  @override
  _btImportDetailScreenState createState() =>
      _btImportDetailScreenState(idImport);
}

class _btImportDetailScreenState extends State<btImportDetailScreen> {
  bool isCheckout = false;
  String idImport = '';

  _btImportDetailScreenState(this.idImport);
  Import import = Import(
      id: '',
      sender: '',
      description: '',
      receiver: '',
      code: '',
      status: '',
      note: '',
      goodsDetail: [],
      total: '',
      time: '');
  Future getImportDetail() async {
    FirebaseFirestore.instance
        .collection('imports')
        .where('id', isEqualTo: idImport)
        .snapshots()
        .listen((value) {
      setState(() {
        import = Import.fromDocument(value.docs.first.data());
        importSubIdList = import.goodsDetail;
      });
    });
  }

  // Future deleteImport() async {
  //   setState(() {
  //     FirebaseFirestore.instance
  //         .collection("importSubs")
  //         .snapshots()
  //         .listen((value) {
  //       value.docs.forEach((element) {
  //         if (importSubIdList.contains(element.data()['id'] as String)) {
  //           FirebaseFirestore.instance
  //               .collection("importSubs")
  //               .doc(element.data()['id'] as String)
  //               .delete();
  //         }
  //       });
  //     });
  //     FirebaseFirestore.instance.collection("imports").doc(idImport).delete();
  //   });
  // }

  List importSubIdList = [];
  List<ImportSub> importSubList = [];
  Future getImportSubList() async {
    FirebaseFirestore.instance
        .collection("imports")
        .doc(idImport)
        .snapshots()
        .listen((value1) {
      FirebaseFirestore.instance.collection("importSubs").get().then((value2) {
        setState(() {
          importSubList.clear();
          importSubIdList = value1.data()!["goodsDetail"];
          value2.docs.forEach((element) {
            if (importSubIdList.contains(element.data()['id'] as String)) {
              importSubList.add(ImportSub.fromDocument(element.data()));
            }
          });
        });
      });
    });
  }

  void initState() {
    super.initState();
    getImportDetail();
    getImportSubList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(background), fit: BoxFit.cover),
            ),
          ),
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 80 + 28),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: appPadding,
                        right: appPadding,
                        bottom: appPadding + 8),
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8),
                                      Container(
                                        child: Text(
                                          "Import #" + import.code,
                                          style: TextStyle(
                                            fontFamily: "SFProText",
                                            fontSize: 24.0,
                                            color: black,
                                            fontWeight: FontWeight.w700,
                                            height: 1.6,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 24),
                                      Container(
                                        width: 319,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: blueLight,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 16,
                                            ),
                                            Icon(Iconsax.clock,
                                                size: 20, color: blueWater),
                                            SizedBox(
                                              width: 16,
                                            ),
                                            Text(
                                              'Time: ',
                                              style: TextStyle(
                                                fontFamily: "SFProText",
                                                fontSize: content14,
                                                color: grey8,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Text(
                                              import.time,
                                              style: TextStyle(
                                                fontFamily: "SFProText",
                                                fontSize: content14,
                                                color: blackLight,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // SizedBox(height: 24),
                                      // Container(
                                      //   child: Text(
                                      //     "Status",
                                      //     style: TextStyle(
                                      //       fontFamily: "SFProText",
                                      //       fontSize: title20,
                                      //       color: blackLight,
                                      //       fontWeight: FontWeight.w600,
                                      //     ),
                                      //   ),
                                      // ),
                                      // SizedBox(height: 16),
                                      // Container(
                                      //   width: 122,
                                      //   height: 40,
                                      //   decoration: BoxDecoration(
                                      //     color: blueWater,
                                      //     borderRadius: BorderRadius.all(
                                      //       Radius.circular(8.0),
                                      //     ),
                                      //     gradient: LinearGradient(
                                      //         begin: Alignment.centerLeft,
                                      //         end: Alignment.centerRight,
                                      //         colors: [
                                      //           Color(0xFF159957),
                                      //           Color(0xFF159199),
                                      //         ],
                                      //         stops: [
                                      //           0.0,
                                      //           1.0,
                                      //         ]),
                                      //   ),
                                      //   padding: EdgeInsets.zero,
                                      //   alignment: Alignment.center,
                                      //   child: Text(
                                      //     'Done',
                                      //     style: TextStyle(
                                      //       fontFamily: "SFProText",
                                      //       fontSize: 14.0,
                                      //       color: white,
                                      //       fontWeight: FontWeight.w500,
                                      //     ),
                                      //   ),
                                      // ),
                                      SizedBox(height: 24),
                                      Container(
                                        child: Text(
                                          "Sender",
                                          style: TextStyle(
                                            fontFamily: "SFProText",
                                            fontSize: title20,
                                            color: blackLight,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Container(
                                        child: Text(
                                          import.sender,
                                          style: TextStyle(
                                            fontFamily: "SFProText",
                                            fontSize: content14,
                                            color: grey8,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                      SizedBox(height: 24),
                                      Container(
                                        child: Text(
                                          "Receiver",
                                          style: TextStyle(
                                            fontFamily: "SFProText",
                                            fontSize: title20,
                                            color: blackLight,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Container(
                                        child: Text(
                                          import.receiver,
                                          style: TextStyle(
                                            fontFamily: "SFProText",
                                            fontSize: content14,
                                            color: grey8,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                      // Container(
                                      //   // height: 465,
                                      //   child: ListView.separated(
                                      //     physics:
                                      //         const NeverScrollableScrollPhysics(),
                                      //     padding: EdgeInsets.zero,
                                      //     scrollDirection: Axis.vertical,
                                      //     shrinkWrap: true,
                                      //     itemCount: 1,
                                      //     separatorBuilder:
                                      //         (BuildContext context,
                                      //                 int index) =>
                                      //             SizedBox(height: 12),
                                      //     itemBuilder: (context, index) {
                                      //       return GestureDetector(
                                      //         onTap: () {
                                      //           //watchUserDialog(context);
                                      //         },
                                      //         child: Container(
                                      //           decoration: BoxDecoration(
                                      //               color: blueLight,
                                      //               borderRadius:
                                      //                   BorderRadius.circular(
                                      //                       8)),
                                      //           height: 48,
                                      //           width: 319,
                                      //           child: Column(
                                      //               mainAxisAlignment:
                                      //                   MainAxisAlignment
                                      //                       .center,
                                      //               crossAxisAlignment:
                                      //                   CrossAxisAlignment
                                      //                       .start,
                                      //               children: [
                                      //                 Row(
                                      //                   crossAxisAlignment:
                                      //                       CrossAxisAlignment
                                      //                           .center,
                                      //                   mainAxisAlignment:
                                      //                       MainAxisAlignment
                                      //                           .start,
                                      //                   children: [
                                      //                     SizedBox(width: 16),
                                      //                     AnimatedContainer(
                                      //                       alignment: Alignment
                                      //                           .center,
                                      //                       duration: Duration(
                                      //                           milliseconds:
                                      //                               300),
                                      //                       height: 32,
                                      //                       width: 32,
                                      //                       decoration:
                                      //                           BoxDecoration(
                                      //                         color: blueWater,
                                      //                         borderRadius:
                                      //                             BorderRadius
                                      //                                 .circular(
                                      //                                     8),
                                      //                         image: DecorationImage(
                                      //                             image: NetworkImage(
                                      //                                 currentUser
                                      //                                     .avatar),
                                      //                             fit: BoxFit
                                      //                                 .cover),
                                      //                         shape: BoxShape
                                      //                             .rectangle,
                                      //                       ),
                                      //                     ),
                                      //                     SizedBox(width: 16),
                                      //                     Column(
                                      //                       crossAxisAlignment:
                                      //                           CrossAxisAlignment
                                      //                               .start,
                                      //                       mainAxisAlignment:
                                      //                           MainAxisAlignment
                                      //                               .center,
                                      //                       children: [
                                      //                         Row(
                                      //                           children: [
                                      //                             Container(
                                      //                               width: 168,
                                      //                               child: Text(
                                      //                                 'Pan Cái Chảo',
                                      //                                 style:
                                      //                                     TextStyle(
                                      //                                   fontSize:
                                      //                                       content14,
                                      //                                   fontWeight:
                                      //                                       FontWeight.w600,
                                      //                                   fontFamily:
                                      //                                       'SFProText',
                                      //                                   color:
                                      //                                       blackLight,
                                      //                                 ),
                                      //                               ),
                                      //                             ),
                                      //                             SizedBox(
                                      //                                 width: 43 -
                                      //                                     24),
                                      //                             Container(
                                      //                               height: 16,
                                      //                               width: 44,
                                      //                               decoration:
                                      //                                   BoxDecoration(
                                      //                                 borderRadius:
                                      //                                     BorderRadius.circular(
                                      //                                         4.0),
                                      //                                 color:
                                      //                                     blueWater,
                                      //                               ),
                                      //                               child:
                                      //                                   Center(
                                      //                                 child:
                                      //                                     Text(
                                      //                                   'Bartender',
                                      //                                   style:
                                      //                                       TextStyle(
                                      //                                     fontFamily:
                                      //                                         'SFProText',
                                      //                                     fontSize:
                                      //                                         content6,
                                      //                                     fontWeight:
                                      //                                         FontWeight.w500,
                                      //                                     color:
                                      //                                         white,
                                      //                                   ),
                                      //                                 ),
                                      //                               ),
                                      //                             ),
                                      //                           ],
                                      //                         ),
                                      //                         SizedBox(
                                      //                             height: 4),
                                      //                         Row(
                                      //                           children: [
                                      //                             Icon(
                                      //                               Iconsax.sms,
                                      //                               color:
                                      //                                   blackLight,
                                      //                               size: 12,
                                      //                             ),
                                      //                             SizedBox(
                                      //                               width: 4,
                                      //                             ),
                                      //                             Text(
                                      //                               'nhatkb2001@gmail.com',
                                      //                               style:
                                      //                                   TextStyle(
                                      //                                 fontFamily:
                                      //                                     'SFProText',
                                      //                                 fontSize:
                                      //                                     content8,
                                      //                                 fontWeight:
                                      //                                     FontWeight
                                      //                                         .w500,
                                      //                                 color:
                                      //                                     grey8,
                                      //                               ),
                                      //                             ),
                                      //                           ],
                                      //                         ),
                                      //                       ],
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //               ]),
                                      //         ),
                                      //       );
                                      //     },
                                      //   ),
                                      // ),
                                      // Container(
                                      //   child: Column(children: [
                                      //     Container(
                                      //       child: Text(
                                      //         "Nguyen Tri Minh",
                                      //         style: TextStyle(
                                      //           fontFamily: "SFProText",
                                      //           fontSize: content14,
                                      //           color: grey8,
                                      //           fontWeight: FontWeight.w400,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ]),
                                      // ),
                                      SizedBox(height: 24),
                                      Container(
                                        child: Text(
                                          "Description",
                                          style: TextStyle(
                                            fontFamily: "SFProText",
                                            fontSize: title20,
                                            color: blackLight,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Container(
                                        child: Text(
                                          import.description,
                                          style: TextStyle(
                                            fontFamily: "SFProText",
                                            fontSize: content14,
                                            color: grey8,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                      // SizedBox(height: 24),
                                      // Container(
                                      //   child: Text(
                                      //     "Reason",
                                      //     style: TextStyle(
                                      //       fontFamily: "SFProText",
                                      //       fontSize: title20,
                                      //       color: blackLight,
                                      //       fontWeight: FontWeight.w600,
                                      //     ),
                                      //   ),
                                      // ),
                                      // SizedBox(height: 16),
                                      // Container(
                                      //   child: Text(
                                      //     'Create an article to welcome customers to the new branch of the store with an article to welcome customers',
                                      //     style: TextStyle(
                                      //       fontFamily: "SFProText",
                                      //       fontSize: content14,
                                      //       color: grey8,
                                      //       fontWeight: FontWeight.w400,
                                      //     ),
                                      //     textAlign: TextAlign.justify,
                                      //   ),
                                      // ),
                                      SizedBox(height: 24),
                                      Container(
                                        child: Text(
                                          "Note",
                                          style: TextStyle(
                                            fontFamily: "SFProText",
                                            fontSize: title20,
                                            color: blackLight,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Container(
                                        child: Text(
                                          import.note,
                                          style: TextStyle(
                                            fontFamily: "SFProText",
                                            fontSize: content14,
                                            color: grey8,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                      // SizedBox(height: 24),
                                      // Container(
                                      //   child: Text(
                                      //     "The party in trouble",
                                      //     style: TextStyle(
                                      //       fontFamily: "SFProText",
                                      //       fontSize: title20,
                                      //       color: blackLight,
                                      //       fontWeight: FontWeight.w600,
                                      //     ),
                                      //   ),
                                      // ),
                                      // SizedBox(height: 16),
                                      // Container(
                                      //   child: Text(
                                      //     'Create an article to welcome customers to the new branch of the store with an article to welcome customers',
                                      //     style: TextStyle(
                                      //       fontFamily: "SFProText",
                                      //       fontSize: content14,
                                      //       color: grey8,
                                      //       fontWeight: FontWeight.w400,
                                      //     ),
                                      //     textAlign: TextAlign.justify,
                                      //   ),
                                      // ),
                                      SizedBox(height: 24),
                                      Container(
                                        child: Text(
                                          "Details of goods",
                                          style: TextStyle(
                                            fontFamily: "SFProText",
                                            fontSize: title20,
                                            color: blackLight,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Container(
                                        child: ListView.separated(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: importSubList.length,
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  SizedBox(
                                            height: 1,
                                            child: Divider(
                                                color: grey8, thickness: 0.2),
                                          ),
                                          itemBuilder: (context, index) {
                                            return Container(
                                              decoration: (index == 0 ||
                                                      index == 8 - 1)
                                                  ? (index == 0)
                                                      ? BoxDecoration(
                                                          color: white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    8),
                                                            topRight:
                                                                Radius.circular(
                                                                    8),
                                                          ),
                                                        )
                                                      : BoxDecoration(
                                                          color: white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    8),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    8),
                                                          ),
                                                        )
                                                  : BoxDecoration(
                                                      color: white,
                                                    ),
                                              width: 319,
                                              height: 48,
                                              padding: EdgeInsets.only(
                                                  top: 8,
                                                  left: 16,
                                                  bottom: 8,
                                                  right: 16),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: blueLight,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(8),
                                                        )),
                                                    height: 30,
                                                    width: 30,
                                                    child: Center(
                                                      child: Text(
                                                        '${index + 1}',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "SFProText",
                                                          fontSize: content16,
                                                          color: blackLight,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 16),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              importSubList[
                                                                      index]
                                                                  .name,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "SFProText",
                                                                  fontSize:
                                                                      content12,
                                                                  color:
                                                                      blackLight,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  height: 1.4),
                                                            ),
                                                          ),
                                                          SizedBox(width: 0),
                                                          Container(
                                                            child: Text(
                                                              ' - ' +
                                                                  importSubList[
                                                                          index]
                                                                      .quantity,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "SFProText",
                                                                  fontSize:
                                                                      content12,
                                                                  color:
                                                                      blackLight,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  height: 1.4),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      // SizedBox(height: 2),
                                                      // Container(
                                                      //   child: Text(
                                                      //     (index == 0 ||
                                                      //             index == 2 ||
                                                      //             index == 3 ||
                                                      //             index == 5)
                                                      //         ? 'Material'
                                                      //         : 'Drink',
                                                      //     style: TextStyle(
                                                      //       fontFamily:
                                                      //           "SFProText",
                                                      //       fontSize: content8,
                                                      //       color: grey8,
                                                      //       fontWeight:
                                                      //           FontWeight.w400,
                                                      //     ),
                                                      //   ),
                                                      // )
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    '-\$' +
                                                        (double.parse(importSubList[
                                                                        index]
                                                                    .unit) *
                                                                double.parse(
                                                                    importSubList[
                                                                            index]
                                                                        .quantity))
                                                            .toStringAsFixed(0)
                                                            .toString(),
                                                    maxLines: 1,
                                                    softWrap: false,
                                                    overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                      fontSize: content14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'SFProText',
                                                      foreground: Paint()
                                                        ..shader = redGradient,
                                                    ),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 24),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Total Money:',
                                            style: TextStyle(
                                              fontFamily: "SFProText",
                                              fontSize: content16,
                                              color: blackLight,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            '- \$' + import.total,
                                            maxLines: 1,
                                            softWrap: false,
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'SFProText',
                                              foreground: Paint()
                                                ..shader = blueGradient,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 40),
                                      Container(
                                          alignment: Alignment.center,
                                          child: GestureDetector(
                                            //action navigate to dashboard screen
                                            onTap: (import.status == 'Checkout')
                                                ? null
                                                : () {
                                                    setState(() {
                                                      checkoutImportDialog(
                                                          context,
                                                          idImport,
                                                          import.total,
                                                          import.code);
                                                      isCheckout = true;
                                                      // Navigator.pop(context);
                                                    });
                                                  },
                                            child: AnimatedContainer(
                                                alignment: Alignment.center,
                                                duration:
                                                    Duration(milliseconds: 300),
                                                height: 48,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  color: (import.status ==
                                                          'Checkout')
                                                      ? white
                                                      : blackLight,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(12)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: black
                                                          .withOpacity(0.25),
                                                      spreadRadius: 0,
                                                      blurRadius: 4,
                                                      offset: Offset(0,
                                                          4), // changes position of shadow
                                                    ),
                                                    BoxShadow(
                                                      color: black
                                                          .withOpacity(0.1),
                                                      spreadRadius: 0,
                                                      blurRadius: 64,
                                                      offset: Offset(15,
                                                          15), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: (import.status ==
                                                        'Checkout')
                                                    ? Container(
                                                        child: Icon(
                                                            Iconsax.refresh,
                                                            size: 24,
                                                            color: blackLight),
                                                      )
                                                    : Container(
                                                        child: Text(
                                                        "Checkout",
                                                        style: TextStyle(
                                                            color: whiteLight,
                                                            fontFamily:
                                                                'SFProText',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize:
                                                                textButton20),
                                                      ))),
                                          )),
                                      SizedBox(height: 24)
                                    ]),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              (import.status != 'Checkout')
                  ? Container(
                      padding: EdgeInsets.only(top: 62),
                      child: Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.only(left: 28),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Iconsax.arrow_square_left,
                                size: 32, color: blackLight),
                          ),
                          Spacer(),
                          Container(
                              child: GestureDetector(
                            onTap: () {
                              removeImportDialog(
                                  context, idImport, importSubIdList);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => svDrinkCartScreen(),
                              //   ),
                              // );
                              // // .then((value) {});
                              showSnackBar(context,
                                  'The order has been removed!', "success");
                            },
                            child: AnimatedContainer(
                              alignment: Alignment.center,
                              duration: Duration(milliseconds: 300),
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFFCB356B),
                                      Color(0xFFBD3F32),
                                    ],
                                    stops: [
                                      0.0,
                                      1.0,
                                    ]),
                                boxShadow: [
                                  BoxShadow(
                                      color: black.withOpacity(0.25),
                                      spreadRadius: 0,
                                      blurRadius: 64,
                                      offset: Offset(8, 8)),
                                  BoxShadow(
                                    color: black.withOpacity(0.2),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Container(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center,
                                  child: Icon(Iconsax.close_circle,
                                      size: 18, color: white)),
                            ),
                          )),
                          SizedBox(width: 8),
                          Container(
                              padding: EdgeInsets.only(right: 28),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          btImportEditingScreen(
                                              idImport: idImport),
                                    ),
                                  );
                                  // .then((value) {});
                                },
                                child: AnimatedContainer(
                                  alignment: Alignment.center,
                                  duration: Duration(milliseconds: 300),
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          blueWater,
                                          Color(0xFF979DFA),
                                        ],
                                        stops: [
                                          0.0,
                                          1.0,
                                        ]),
                                    boxShadow: [
                                      BoxShadow(
                                          color: black.withOpacity(0.25),
                                          spreadRadius: 0,
                                          blurRadius: 64,
                                          offset: Offset(8, 8)),
                                      BoxShadow(
                                        color: black.withOpacity(0.2),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                      padding: EdgeInsets.zero,
                                      alignment: Alignment.center,
                                      child: Icon(Iconsax.edit_2,
                                          size: 18, color: white)),
                                ),
                              )),
                        ],
                      ))
                  : Container(
                      padding: EdgeInsets.only(top: 62),
                      child: IconButton(
                        padding: EdgeInsets.only(left: 28),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Iconsax.arrow_square_left,
                            size: 32, color: blackLight),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
