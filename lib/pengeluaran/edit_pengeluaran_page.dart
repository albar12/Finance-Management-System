import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fms/helper/helper_size.dart';
import 'package:fms/model/pengeluaran.dart';
import 'package:fms/model/pengeluaran.dart';
import 'package:fms/pengeluaran/bloc/pengeluaran_bloc.dart';
import 'package:fms/pengeluaran/bloc/pengeluaran_event.dart';
import 'package:fms/pengeluaran/bloc/pengeluaran_state.dart';
import 'package:intl/intl.dart';

class EditPengeluaranPage extends StatefulWidget {
  final Pengeluaran pengeluaran;
  const EditPengeluaranPage({
    super.key,
    required this.pengeluaran,
  });

  @override
  State<EditPengeluaranPage> createState() => _EditPengeluaranPageState();
}

class _EditPengeluaranPageState extends State<EditPengeluaranPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nominal = TextEditingController();
  TextEditingController keteragan = TextEditingController();
  TextEditingController waktu = TextEditingController();

  DateTime nowDate = DateTime.now();

  String? datePicked;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      nominal.text = widget.pengeluaran.nominal.toString();

      keteragan.text = widget.pengeluaran.keterangan.toString();

      waktu.text = widget.pengeluaran.waktu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PengeluaranBloc, PengeluaranState>(
      listener: (context, state) {
        if (state is PengeluaranPopClose) {
          Navigator.pop(context);
        }
      },
      child: AlertDialog(
        content: Form(
          child: Column(
            children: [
              Text("Form Edit Pengeluaran"),
              SizedBox(
                height: HelperSize.sizeBoxHeight,
              ),
              TextFormField(
                controller: waktu,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Waktu",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                ),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2015, 8),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      waktu.text = DateFormat('d-MMMM-yyyy').format(pickedDate);
                      datePicked = DateFormat('d-MMMM-yyyy').format(pickedDate);
                    });
                  }
                },
              ),
              SizedBox(
                height: HelperSize.sizeBoxHeight,
              ),
              TextFormField(
                key: _formKey,
                controller: nominal,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  labelText: "Nominal",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Bagian ini wajib diisi";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: HelperSize.sizeBoxHeight,
              ),
              TextFormField(
                maxLines: 3,
                minLines: 1,
                controller: keteragan,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  labelText: "Keterangan",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Bagian ini wajib diisi";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: HelperSize.sizeBoxHeight,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "CANCEL",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.amber)),
                      onPressed: () {
                        if (waktu.text.isEmpty) {
                          AlertDialog(
                            content: Center(
                              child: Text("Waktu tidak dapat kosong"),
                            ),
                          );
                        } else {
                          String createDate = DateFormat('d-MMMM-yyyy H:m')
                              .format(DateTime.now());
                          Pengeluaran dataPengeluaran = Pengeluaran(
                            id: widget.pengeluaran.id,
                            nominal: int.parse(nominal.text),
                            keterangan: keteragan.text.toString(),
                            waktu: waktu.text.toString(),
                          );

                          context.read<PengeluaranBloc>().add(
                              EditPengeluaran(pengeluaran: dataPengeluaran));
                        }
                      },
                      child: Text(
                        "Edit",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
