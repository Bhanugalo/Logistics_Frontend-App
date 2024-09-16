import 'package:Logistic/dialogs/role_list_model.dart';
import 'package:flutter/material.dart';
import 'package:Logistic/dialogs/role_list_model.dart';
import '../constant/app_color.dart';
import '../constant/app_fonts.dart';
import '../constant/app_styles.dart';

class DialogRole extends StatefulWidget {
  final RoleModel? data;
  final String? ImagePath;
  const DialogRole({
    Key? key,
    this.data,
    this.ImagePath,
  }) : super(key: key);

  @override
  _DialogRoleState createState() => _DialogRoleState();
}

class _DialogRoleState extends State<DialogRole> {
  double padding = 10;
  // ignore: non_constant_identifier_names
  late List<RoleList> personList;
  String errorMessage = "", ratting = '';
  // ignore: unused_field
  final GlobalKey<FormState> _formKey = GlobalKey();
  var searchTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      personList = widget.data!.data!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      // backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      color: Colors.white,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      'assets/icons/ic_close.png',
                      height: 25,
                      width: 25,
                    ),
                  ),
                )),
            //Search
            Row(children: <Widget>[
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: searchTextEditingController,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            personList = widget.data!.data!;
                          });
                        } else {
                          List<RoleList> filterCountryList = [];
                          personList.forEach((Person) {
                            if ((Person.stringmapname!
                                    .toLowerCase()
                                    .contains(value.toLowerCase())) ||
                                (Person.stringmapname!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))) {
                              filterCountryList.add(Person);
                            }
                          });
                          setState(() {
                            personList = filterCountryList;
                          });
                        }
                      },
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: AppStyles.textFieldInputDecoration.copyWith(
                          hintText: "Search by Name",
                          prefixIcon: Icon(
                            Icons.search,
                            size: 25,
                            color: AppColors.lightBlackColor,
                          )),
                      style: AppStyles.textInputTextStyle,
                    ),
                  ),
                ),
              )),
            ]),
            Expanded(
              child: ListView.separated(
                itemCount: personList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      var Dialogdata = {
                        "stringmapname": personList[index].stringmapname,
                        "stringmapname1": personList[index].stringmapname
                      };
                      Navigator.of(context).pop(Dialogdata);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                      child: Text(
                        personList[index].stringmapname!,
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 14.0,
                            fontFamily: appFontFamily,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.grey,
                  );
                },
              ),
            ),
          ]),
    );
  }
}
