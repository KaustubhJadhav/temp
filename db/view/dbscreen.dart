import 'package:flutter/material.dart';
import 'package:io8/commans/styles/app_colors.dart';
import 'package:io8/commans/styles/app_text_styles.dart';
import 'package:io8/data/response/status.dart';
import 'package:io8/features/backend/view_model/backend_view_model.dart';
import 'package:io8/features/db/model/db_model.dart';
import 'package:io8/features/db/view/create_update_db_screen.dart';
import 'package:io8/features/db/view/dbCardWidget.dart';
import 'package:io8/features/db/viewModel/create_db_viewmode.dart';
import 'package:provider/provider.dart';

class Dbscreen extends StatefulWidget {
  final String projId;

  const Dbscreen({super.key, required this.projId});

  @override
  State<Dbscreen> createState() => _DbscreenState();
}

class _DbscreenState extends State<Dbscreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateDbViewmode>().getDb(widget.projId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.adaptive.arrow_back)),
        title: Text(
          "Database",
          style: AppTextStyles.textStyle18
              .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.darkerShade,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateUpdateDbScreen(
                  dbModel: null,
                  projId: widget.projId,
                ),
              ));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<CreateDbViewmode>(
          builder: (context, provider, _) {
            switch (provider.dbData.status) {
              case null:
                return Container();
              case Status.LOADING:
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              case Status.SUCCESS:
                return provider.dbData.data!.isEmpty
                    ? const Center(
                        child: Text("No Data"),
                      )
                    : ListView.builder(
                        itemCount: provider.dbData.data!.length,
                        itemBuilder: (context, index) {
                          final DbModel dbModel = provider.dbData.data![index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Dbcardwidget(
                              dbModel: dbModel,
                              projId: widget.projId,
                            ),
                          );
                        },
                      );
              case Status.ERROR:
                return Center(
                  child: Text(provider.dbData.message.toString()),
                );
            }
          },
        ),
      ),
    );
  }
}
