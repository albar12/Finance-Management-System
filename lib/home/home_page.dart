import 'dart:ui' as ui;

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fms/helper/app_colors.dart';
import 'package:fms/helper/extensions.dart';
import 'package:fms/helper/helper_size.dart';
import 'package:fms/home/bloc/home_bloc.dart';
import 'package:fms/home/bloc/home_event.dart';
import 'package:fms/home/bloc/home_state.dart';
import 'package:fms/pemasukkan/list_pemasukkan/list_pemasukkan.dart';
import 'package:fms/pengeluaran/list_pengeluaran_page.dart';
import 'package:fms/widget/text_sheet.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int totalPemasukkan = 0;
  int totalPengeluaran = 0;
  int totalSaldo = 0;

  final NumberFormat formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<HomeBloc>().add(HomeStart());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeInitial) {
          AlertDialog(
            content: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is HomeLoading) {
          AlertDialog(
            content: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is HomeLoaded) {
          if (state.totalPemasukan.length > 0) {
            setState(() {
              totalPemasukkan = state.totalPemasukan
                  .reduce((value, element) => value + element);
            });
          } else {
            totalPemasukkan = 0;
          }

          if (state.totalPengeluaran.length > 0) {
            setState(() {
              totalPengeluaran = state.totalPengeluaran
                  .reduce((value, element) => value + element);
            });
          } else {
            setState(() {
              totalPengeluaran = 0;
            });
          }

          setState(() {
            totalSaldo = totalPemasukkan - totalPengeluaran;
          });
        } else if (state is HomeFailed) {
          showCustomDialog(state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Financial Management System'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              menu(
                  color: Colors.blue,
                  onTap: () {
                    print("text");
                  },
                  iconData: Icons.money,
                  name: "Saldo : ${formatCurrency.format(totalSaldo)}"),
              SizedBox(
                height: HelperSize.sizeBoxHeight,
              ),
              menu(
                  color: Colors.green,
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListPemasukkanPage()),
                    );
                  },
                  iconData: Icons.monetization_on,
                  name:
                      "Pemasukkan : ${formatCurrency.format(totalPemasukkan)}"),
              SizedBox(
                height: HelperSize.sizeBoxHeight,
              ),
              menu(
                  color: Colors.red,
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListPengeluaranPage()),
                    );
                  },
                  iconData: Icons.money_off,
                  name:
                      "Pengeluaran : ${formatCurrency.format(totalPengeluaran)}"),
            ],
          ),
        ),
      ),
    );
  }

  Widget menu({
    required ui.Color color,
    required GestureTapCallback onTap,
    required IconData iconData,
    required String name,
    String? badge,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        splashColor: color.lighten(50),
        // radius: Dimensions.radius15,
        radius: MediaQuery.of(context).size.height /
            (MediaQuery.of(context).size.height / 15),
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Ink(
          color: color.lighten(95),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.height /
                  (MediaQuery.of(context).size.height / 15),
              vertical: MediaQuery.of(context).size.height /
                  (MediaQuery.of(context).size.height / 20),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.height /
                        (MediaQuery.of(context).size.height / 5)),
                Icon(iconData, color: color, size: 30),
                SizedBox(
                    width: MediaQuery.of(context).size.height /
                        (MediaQuery.of(context).size.height / 10)),
                Expanded(
                  child: TextSheet(
                    name,
                    fontSize: 20,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StringUtils.isNotNullOrEmpty(badge)
                    ? Card(
                        elevation: 0,
                        color: AppColors.alertShaded.lighten(80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.height /
                                  (MediaQuery.of(context).size.height / 5)),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.error_outline,
                                size: 18,
                                color: AppColors.alertShaded,
                              ),
                              SizedBox(width: 3),
                              TextSheet('3', color: AppColors.alertShaded)
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showCustomDialog(String msg) {
    TextButton yesButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text("Yes"),
    );

    TextButton noButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text("No"),
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "${msg}",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        yesButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext) {
        return alertDialog;
      },
    );
  }
}
