import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fms/helper/helper_size.dart';
import 'package:fms/home/home_page.dart';
import 'package:fms/model/pemasukkan.dart';
import 'package:fms/pemasukkan/list_pemasukkan/add_pemasukkan.dart';
import 'package:fms/pemasukkan/list_pemasukkan/bloc/list_pemasukkan_bloc.dart';
import 'package:fms/pemasukkan/list_pemasukkan/bloc/list_pemasukkan_event.dart';
import 'package:fms/pemasukkan/list_pemasukkan/bloc/list_pemasukkan_state.dart';
import 'package:fms/pemasukkan/list_pemasukkan/edit_pemasukkan.dart';
import 'package:intl/intl.dart';

class ListPemasukkanPage extends StatefulWidget {
  const ListPemasukkanPage({super.key});

  @override
  State<ListPemasukkanPage> createState() => _ListPemasukkanPageState();
}

class _ListPemasukkanPageState extends State<ListPemasukkanPage> {
  List<Map<String, dynamic>> pemasukkanList = [];
  int totalPemasukkanList = 0;

  final NumberFormat formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  String? subString;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ListPemasukkanBloc>().add(ListPemasukkanStart());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListPemasukkanBloc, ListPemasukkanState>(
      listener: (context, state) {
        if (state is ListPemasukkanInitial) {
          AlertDialog(
            content: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is ListPemasukkanLoading) {
          AlertDialog(
            content: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is ListPemasukkanLoaded) {
          print("ListPemasukkanLoaded");
          print(state.pemasukkan.length);

          if (state.pemasukkan.length > 0) {
            setState(() {
              if (state.pemasukkan.length > 0) {
                pemasukkanList =
                    state.pemasukkan.map((e) => e.toMap()).toList();
                totalPemasukkanList = state.totalPemasukkan
                    .reduce((value, element) => value + element);
              }
            });
          } else {
            setState(() {
              pemasukkanList.clear();
              totalPemasukkanList = 0;
            });
          }

          print("alif2");
          print(pemasukkanList);
        } else if (state is ListPemasukkanPopClose) {
          context.read<ListPemasukkanBloc>().add(ListPemasukkanStart());
        } else if (state is ListPemasukkanFailed) {
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
            "Pemasukkan : ${formatCurrency.format(totalPemasukkanList)}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: pemasukkanList.isEmpty
            ? Center(
                child: Text(
                  "No Data",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemCount: pemasukkanList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Pemasukkan editPemasukkan = Pemasukkan(
                            id: pemasukkanList[index]['id'],
                            nominal: pemasukkanList[index]['nominal'],
                            keterangan: pemasukkanList[index]['keterangan'],
                            waktu: pemasukkanList[index]['waktu']);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return EditPemasukkanPage(
                                  pemasukkan: editPemasukkan);
                            });
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.lightGreen,
                              child: Icon(
                                Icons.monetization_on_outlined,
                                color: Colors.white,
                              ),
                            ),
                            title: Center(
                              child: Text(
                                "${formatCurrency.format(pemasukkanList[index]['nominal'])}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(pemasukkanList[index]['keterangan']),
                                SizedBox(
                                  height: HelperSize.sizeBoxHeight,
                                ),
                                Text("${pemasukkanList[index]['waktu']}"),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                showDeleteDialog(pemasukkanList[index]['id']);
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
                },
              ),
        floatingActionButton: IconButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddPemasukkanPage();
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
        context.read<ListPemasukkanBloc>().add(DeletePemasukkan(
              id: id,
            ));
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
