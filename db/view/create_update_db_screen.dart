import 'package:flutter/material.dart';
import 'package:io8/commans/styles/app_colors.dart';
import 'package:io8/commans/styles/app_text_styles.dart';
import 'package:io8/commans/widgets/buttons/elevated_button.dart';

import 'package:io8/commans/widgets/reusable_text_feilds/reusablle_text_feild.dart';
import 'package:io8/features/db/model/db_model.dart';
import 'package:io8/features/db/viewModel/create_db_viewmode.dart';

import 'package:io8/utils/validators/text_feild_validator.dart';
import 'package:provider/provider.dart';

class CreateUpdateDbScreen extends StatefulWidget {
  final DbModel? dbModel;
  final String projId;
  const CreateUpdateDbScreen(
      {super.key, required this.dbModel, required this.projId});

  @override
  State<CreateUpdateDbScreen> createState() => _CreateUpdateDbScreenState();
}

class _CreateUpdateDbScreenState extends State<CreateUpdateDbScreen> {
  final TextEditingController _dbName = TextEditingController();
  final TextEditingController _dbUserName = TextEditingController();
  final TextEditingController _dbportNo = TextEditingController();
  final TextEditingController _dbPassword = TextEditingController();
  final TextEditingController _hostname = TextEditingController();

  String? _dbType;
// ValueNotifier to track the checkbox state for "Testing"
  final ValueNotifier<bool> isExisting = ValueNotifier<bool>(false);

  List<String> _dropdownItems = ['MySql', 'MongoDb'];

  final _formKey = GlobalKey<FormState>();

  bool isAlreadyExist() {
    if (widget.dbModel != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    if (isAlreadyExist()) {
      _dbName.text = widget.dbModel!.db_name.toString();
      _dbType = widget.dbModel!.techstack.toString();
      _dbportNo.text = widget.dbModel!.port_no.toString();
      _dbPassword.text = widget.dbModel!.db_password.toString();
      isExisting.value = widget.dbModel!.existing_db!;
    }
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
          isAlreadyExist() ? "Update DataBase" : "Add Database",
          style: AppTextStyles.textStyle18
              .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: Consumer<CreateDbViewmode>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: isExisting,
                      builder: (context, iSExisting, _) {
                        return CheckboxListTile(
                          activeColor: AppColors.darkerShade,
                          title: Text(
                            'Is Existing',
                            style: AppTextStyles.textStyle14,
                          ),
                          value: iSExisting,
                          onChanged: (newValue) {
                            isExisting.value = newValue ?? false;
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ReusableTextFormField(
                      labelText: 'Database Name',
                      hintText: '',
                      controller: _dbName,
                      validator: TextFieldValidator.validateField,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ReusableTextFormField(
                      labelText: 'Username',
                      hintText: 'root',
                      controller: _dbUserName,
                      validator: TextFieldValidator.validateField,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ReusableTextFormField(
                      labelText: 'Password',
                      hintText: 'root',
                      controller: _dbPassword,
                      validator: TextFieldValidator.validateField,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ReusableTextFormField(
                      labelText: 'Port No',
                      hintText: '3306',
                      controller: _dbportNo,
                      validator: TextFieldValidator.validateField,
                    ),
                    ReusableTextFormField(
                      labelText: 'host name',
                      hintText: '',
                      controller: _hostname,
                      validator: TextFieldValidator.validateField,
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButton<String>(
                      // Set the value of the dropdown to the selected item
                      value: _dbType,

                      // OnChanged is called when an item is selected
                      onChanged: (String? newValue) {
                        setState(() {
                          _dbType = newValue;
                        });
                      },

                      // DropDown items
                      items: _dropdownItems
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),

                      // Display a hint if no item is selected
                      hint: Text("Select an item"),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    // Checkbox with ValueListenableBuilder for "Testing"

                    const SizedBox(
                      height: 20,
                    ),

                    ReusableElevatedButton(
                      isLoading: provider.isLoading,
                      text: isAlreadyExist() ? 'Update' : 'Create',
                      onPressed: () {
                        final body = {
                          'db_name': _dbName.text,
                          'db_username': _dbUserName.text,
                          'db_password': _dbPassword.text,
                          'port_no': _dbportNo.text,
                          'techstack': _dbType.toString(),
                          'existing_db': isExisting.value,
                          'host_name': _hostname.text,
                          'proj_id': widget.projId,
                        };

                        if (isAlreadyExist()) {
                          print("-----UPDATING--------");
                          body['id'] = widget.dbModel!.id.toString();
                          print("Update- $body");
                          provider.updateDb(body, widget.dbModel!.id, context);
                        } else {
                          print("ADD - $body");
                          provider.createDb(body, widget.projId, context);
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
