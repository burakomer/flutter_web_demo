import 'package:flutter/material.dart';

import '/models/db_model.dart';

import 'base_page.dart';

class DataPage<T extends DbModel> extends BasePage {
  DataPage({Key? key, required String title, required this.loadData})
      : super(key: key, title: title);

  final Future<List<T>> loadData;

  @override
  DataPageState createState() => DataPageState<DataPage<T>, T>();
}

class DataPageState<T extends DataPage, TData extends DbModel>
    extends BaseState<T> {
  late DataPage<TData> realWidget = widget as DataPage<TData>;
  late List<TData> data;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    loadDataOnInit();
  }

  void loadDataOnInit() async {
    data = await loadData();
    setState(() {
      loaded = true;
    });
  }

  @override
  Widget body() {
    return loaded
        ? DataTable(columns: dataColumns(), rows: dataRows())
        : CircularProgressIndicator();
  }

  Future<List<TData>> loadData() async {
    return await realWidget.loadData;
  }

  List<DataColumn> dataColumns() {
    return data.length == 0
        ? [DataColumn(label: Text('No Data'))]
        : data.first
            .toJson()
            .keys
            .map((column) => DataColumn(label: Text(column)))
            .toList();
  }

  List<DataRow> dataRows() {
    return data
        .map((customer) => DataRow(
            cells: customer
                .toJson()
                .entries
                .map((e) => DataCell(Text(e.value.toString())))
                .toList()))
        .toList();
  }
}
