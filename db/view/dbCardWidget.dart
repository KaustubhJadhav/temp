import 'package:flutter/material.dart';
import 'package:io8/commans/styles/app_colors.dart';
import 'package:io8/commans/styles/app_text_styles.dart';
import 'package:io8/features/db/model/db_model.dart';
import 'package:io8/features/db/view/create_update_db_screen.dart';
import 'package:io8/features/db/viewModel/create_db_viewmode.dart';
import 'package:provider/provider.dart';

class Dbcardwidget extends StatelessWidget {
  final DbModel dbModel;

  final String projId;
  const Dbcardwidget({
    super.key,
    required this.dbModel,
    required this.projId,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: 200,
      decoration: BoxDecoration(
          color: AppColors.softComplement,
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  dbModel.db_name ?? "N/A",
                  style: AppTextStyles.textStyle16.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateUpdateDbScreen(
                              dbModel: dbModel,
                              projId: projId,
                            ),
                          ));
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    )),
                IconButton(
                    onPressed: () {
                      _showDeleteDialogue(context, dbModel.id);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: AppColors.error,
                    )),
              ],
            ),
            ListTile(
              title: Text(
                "Security profile - ${dbModel.techstack ?? "N/A"}",
                style: AppTextStyles.textStyle14
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialogue(BuildContext context, dynamic dbId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Delete Database",
            style:
                AppTextStyles.textStyle16.copyWith(fontWeight: FontWeight.w600),
          ),
          content: Text(
            "Are you sure you want to delete this database? This action cannot be undone.",
            style: AppTextStyles.textStyle14,
          ),
          actions: [
            InkWell(
              onTap: () {
                // Close the dialog without performing any action
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: AppTextStyles.textStyle14.copyWith(color: Colors.grey),
              ),
            ),
            InkWell(
              onTap: () {
                context
                    .read<CreateDbViewmode>()
                    .deleteDb(dbId, projId, context);
                // Navigator.pop(context);
              },
              child: Text(
                "Delete",
                style: AppTextStyles.textStyle14.copyWith(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
