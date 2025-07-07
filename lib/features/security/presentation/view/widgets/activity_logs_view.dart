
// import 'package:app_mobile/core/resources/manager_strings.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../../../core/resources/manager_colors.dart';
// import '../../../../../core/resources/manager_font_size.dart';
// import '../../../../../core/resources/manager_styles.dart';
//
// class ActivityLogsTabsView extends StatefulWidget {
//   const ActivityLogsTabsView({super.key});
//
//   @override
//   State<ActivityLogsTabsView> createState() => _ActivityLogsTabsViewState();
// }
//
// class _ActivityLogsTabsViewState extends State<ActivityLogsTabsView> with TickerProviderStateMixin {
//   final List<String> sections = [
//     'users',
//     'products',
//     'product_main_category',
//     'orders',
//     'contact_us_info',
//     'product_rates',
//     'addresses'
//   ];
//
//   late TabController _tabController;
//   final Map<String, List<Map<String, dynamic>>> dataPerTable = {};
//   final Map<String, bool> loadingState = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: sections.length, vsync: this);
//     for (var table in sections) {
//       loadingState[table] = true;
//       fetchTableData(table);
//     }
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//   }
//
//   Future<void> fetchTableData(String table) async {
//     final supabase = Supabase.instance.client;
//     try {
//       dynamic result;
//       if (["orders", "addresses", "product_rates"].contains(table)) {
//         result = await supabase.from(table).select("*, users:users(email)").order('created_at', ascending: false);
//       } else {
//         result = await supabase.from(table).select().order('created_at', ascending: false);
//       }
//       setState(() {
//         dataPerTable[table] = (result as List).cast<Map<String, dynamic>>();
//         loadingState[table] = false;
//       });
//     } catch (e) {
//       print(' Error fetching $table: $e');
//       setState(() => loadingState[table] = false);
//     }
//   }
//
//   Widget buildTable(String tableName, List<Map<String, dynamic>> rows) {
//     if (rows.isEmpty) {
//       return Center(
//         child: Text(
//           ManagerStrings.noDataInTable,
//           style: getRegularTextStyle(
//             fontSize: ManagerFontSize.s20,
//             color: ManagerColors.primaryColor,
//           ),
//         ),
//       );
//     }
//
//     final columns = rows.first.keys.where((key) => key != 'id' && key != 'password').toList();
//
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: DataTable(
//         border: TableBorder(borderRadius: BorderRadius.circular(10)),
//         headingRowColor: MaterialStateProperty.all(ManagerColors.greyLight),
//         columns: columns.map((col) {
//           return DataColumn(
//             label: Text(
//               col == 'user_id' ? 'email' : col,
//               style: getBoldTextStyle(
//                 fontSize: ManagerFontSize.s14,
//                 color: ManagerColors.primaryColor,
//               ),
//             ),
//           );
//         }).toList(),
//         rows: rows.map((row) {
//           return DataRow(
//             cells: columns.map((col) {
//               dynamic value;
//               if (col == 'user_id') {
//                 value = row['users']?['email'] ?? '—';
//               } else {
//                 value = row[col];
//               }
//
//               final isImage = col.contains('image') || col.contains('photo') || col.contains('avatar');
//
//               return DataCell(
//                 isImage && value != null && value.toString().startsWith('http')
//                     ? CircleAvatar(
//                   backgroundImage: NetworkImage('$value'),
//                   radius: 20,
//                   backgroundColor: Colors.grey.shade200,
//                 )
//                     : Text(
//                   '$value',
//                   style: getRegularTextStyle(
//                     fontSize: ManagerFontSize.s12,
//                     color: ManagerColors.primaryColor,
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//     ]);
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ManagerColors.white,
//       appBar: AppBar(
//         backgroundColor: ManagerColors.white,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: ManagerColors.primaryColor),
//         title: Text(
//           ManagerStrings.tables,
//           style: getRegularTextStyle(
//             fontSize: ManagerFontSize.s16,
//             color: ManagerColors.primaryColor,
//           ),
//         ),
//         bottom: TabBar(
//           isScrollable: true,
//           controller: _tabController,
//           indicatorColor: ManagerColors.primaryColor,
//           labelColor: ManagerColors.primaryColor,
//           unselectedLabelColor: Colors.grey,
//           tabs: sections.map((e) => Tab(text: e)).toList(),
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: sections.map((table) {
//           if (loadingState[table] == true) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final rows = dataPerTable[table] ?? [];
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: buildTable(table, rows),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_styles.dart';

class ActivityLogsTabsView extends StatefulWidget {
  const ActivityLogsTabsView({super.key});

  @override
  State<ActivityLogsTabsView> createState() => _ActivityLogsTabsViewState();
}

class _ActivityLogsTabsViewState extends State<ActivityLogsTabsView> with TickerProviderStateMixin {
  final List<String> sections = [
    'users',
    'products',
    'product_main_category',
    'orders',
    'contact_us_info',
    'product_rates',
    'addresses',
  ];

  late TabController _tabController;
  final Map<String, List<Map<String, dynamic>>> dataPerTable = {};
  final Map<String, bool> loadingState = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: sections.length, vsync: this);
    for (var table in sections) {
      loadingState[table] = true;
      fetchTableData(table);
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> fetchTableData(String table) async {
    final supabase = Supabase.instance.client;
    try {
      dynamic result;

      if (table == "product_rates") {
        result = await supabase
            .from(table)
            .select("*, users:users(email), products:products(name, image)")
            .order('created_at', ascending: false);
      } else if (["orders", "addresses"].contains(table)) {
        result = await supabase
            .from(table)
            .select("*, users:users(email)")
            .order('created_at', ascending: false);
      } else {
        result = await supabase.from(table).select().order('created_at', ascending: false);
      }

      setState(() {
        dataPerTable[table] = (result as List).cast<Map<String, dynamic>>();
        loadingState[table] = false;
      });
    } catch (e) {
      print(' Error fetching $table: $e');
      setState(() => loadingState[table] = false);
    }
  }

  Widget buildTable(String tableName, List<Map<String, dynamic>> rows) {
    if (rows.isEmpty) {
      return Center(
        child: Text(
          ManagerStrings.noDataInTable,
          style: getRegularTextStyle(
            fontSize: ManagerFontSize.s20,
            color: ManagerColors.primaryColor,
          ),
        ),
      );
    }

    final columns = rows.first.keys.where((key) => key != 'id' && key != 'password').toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        border: TableBorder(borderRadius: BorderRadius.circular(10)),
        headingRowColor: MaterialStateProperty.all(ManagerColors.greyLight),
        columns: columns.map((col) {
          String title = col;
          if (col == 'user_id') title = 'email';
          if (col == 'product_id') title = 'product';

          return DataColumn(
            label: Text(
              title,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.primaryColor,
              ),
            ),
          );
        }).toList(),
        rows: rows.map((row) {
          return DataRow(
            cells: columns.map((col) {
              dynamic value;

              if (col == 'product_id' && row.containsKey('products')) {
                final product = row['products'];
                return DataCell(Row(
                  children: [
                    if (product['image'] != null)
                      CircleAvatar(
                        backgroundImage: NetworkImage(product['image']),
                        radius: 18,
                      ),
                    const SizedBox(width: 8),
                    Text(
                      '${product['name']}',
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s12,
                        color: ManagerColors.primaryColor,
                      ),
                    ),
                  ],
                ));
              }

              if (col == 'user_id' && row.containsKey('users')) {
                value = row['users']?['email'] ?? '—';
              } else {
                value = row[col];
              }

              final isImage = col.contains('image') || col.contains('photo') || col.contains('avatar');

              return DataCell(
                isImage && value != null && value.toString().startsWith('http')
                    ? CircleAvatar(
                  backgroundImage: NetworkImage('$value'),
                  radius: 20,
                  backgroundColor: Colors.grey.shade200,
                )
                    : Text(
                  '$value',
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: ManagerColors.primaryColor,
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.white,
      appBar: AppBar(
        backgroundColor: ManagerColors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: ManagerColors.primaryColor),
        title: Text(
          ManagerStrings.tables,
          style: getRegularTextStyle(
            fontSize: ManagerFontSize.s16,
            color: ManagerColors.primaryColor,
          ),
        ),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          indicatorColor: ManagerColors.primaryColor,
          labelColor: ManagerColors.primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: sections.map((e) => Tab(text: e)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: sections.map((table) {
          if (loadingState[table] == true) {
            return  const Center(child: CircularProgressIndicator(color: ManagerColors.primaryColor,
            ));
          }
          final rows = dataPerTable[table] ?? [];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildTable(table, rows),
          );
        }).toList(),
      ),
    );
  }
}
