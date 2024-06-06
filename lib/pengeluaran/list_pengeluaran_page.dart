import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fms/helper/helper_size.dart';
import 'package:fms/home/home_page.dart';
import 'package:fms/model/pengeluaran.dart';
import 'package:fms/pengeluaran/add_pengeluaran_page.dart';
import 'package:fms/pengeluaran/bloc/pengeluaran_bloc.dart';
import 'package:fms/pengeluaran/bloc/pengeluaran_event.dart';
import 'package:fms/pengeluaran/bloc/pengeluaran_state.dart';
import 'package:fms/pengeluaran/edit_pengeluaran_page.dart';
import 'package:intl/intl.dart';

class ListPengeluaranPage extends StatefulWidget {
  const ListPengeluaranPage({super.key});

  @override
  State<ListPengeluaranPage> createState() => _ListPengeluaranPageState();
}

class _ListPengeluaranPageState extends State<ListPengeluaranPage> {
  List<Map<String, dynamic>> pengeluaranList = [];

  int totalPengeluaran = 0;

  final NumberFormat formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<PengeluaranBloc>().add(PengeluaranStart());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PengeluaranBloc, PengeluaranState>(
      listener: (context, state) {
        if (state is PengeluaranInitial) {
          AlertDialog(
            content: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is PengeluaranLoading) {
          AlertDialog(
            content: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is PengeluaranPopClose) {
          context.read<PengeluaranBloc>().add(PengeluaranStart());
        } else if (state is PengeluaranLoaded) {
          if (state.pengeluaranList.length > 0) {
            setState(() {
              pengeluaranList =
                  state.pengeluaranList.map((e) => e.toMap()).toList();
              totalPengeluaran = state.totalPengeluaran
                  .reduce((value, element) => value + element);
            });
          } else {
            setState(() {
              pengeluaranList.clear();
              totalPengeluaran = 0;
            });
          }
        } else if (state is PengeluaranFailed) {
          showCustomDialog(state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                icon: Icon(Icons.arrow_back)),
            title: Text(
              "Pengeluaran : ${formatCurrency.format(totalPengeluaran)}",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        body: pengeluaranList.length == 0
            ? Center(
                child: Text(
                  "No Data",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemCount: pengeluaranList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Pengeluaran editPengeluaran = Pengeluaran(
                            id: pengeluaranList[index]['id'],
                            nominal: pengeluaranList[index]['nominal'],
                            keterangan: pengeluaranList[index]['keterangan'],
                            waktu: pengeluaranList[index]['waktu']);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return EditPengeluaranPage(
                                  pengeluaran: editPengeluaran);
                            });
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.redAccent,
                              child: Icon(
                                Icons.money_off,
                                color: Colors.white,
                              ),
                            ),
                            title: Center(
                              child: Text(
                                "${formatCurrency.format(pengeluaranList[index]['nominal'])}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(pengeluaranList[index]['keterangan']),
                                SizedBox(
                                  height: HelperSize.sizeBoxHeight,
                                ),
                                Text("${pengeluaranList[index]['waktu']}"),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                showDeleteDialog(pengeluaranList[index]['id']);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
        floatingActionButton: IconButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddPengeluaranPage();
                });
          },
          icon: Icon(Icons.add),
        ),
      ),
    );
  }

  void showDeleteDialog(int id) {
    TextButton yesButton = TextButton(
      onPressed: () {
        context.read<PengeluaranBloc>().add(DeletePengeluaran(id: id));
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
        "Konfirmasi Delete",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text("Delete Data Berikut?"),
      actions: [
        noButton,
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
