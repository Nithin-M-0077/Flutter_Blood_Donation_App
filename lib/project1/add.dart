import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  String? selectedGroup;
  final CollectionReference donor =
  FirebaseFirestore.instance.collection('donor');

  TextEditingController donorName = TextEditingController();
  TextEditingController donorPhone = TextEditingController();

  String? nameError;
  String? phoneError;
  String? groupError;

  void addDonor() {
    final data = {
      'name': donorName.text,
      'phone': donorPhone.text,
      'group': selectedGroup,
    };
    donor.add(data);
  }

  void saveDonor() {
    setState(() {
      nameError = validateName(donorName.text);
      phoneError = validatePhone(donorPhone.text);
      groupError = validateGroup(selectedGroup);
    });

    if (nameError == null && phoneError == null && groupError == null) {
      addDonor();
      Navigator.pop(context);
    }
  }

  String? validateName(String value) {
    if (value.isEmpty) {
      return "Enter Donor Name";
    }
    return null;
  }

  String? validatePhone(String value) {
    if (value.isEmpty) {
      return "Enter Phone Number";
    } else if (value.length != 10) {
      return "Phone Number must be 10 digits";
    }
    return null;
  }

  String? validateGroup(String? value) {
    if (value == null) {
      return "Select Blood Group";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.3,
        elevation: 0,
        title: Text(
          "Add Donors",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.name,
                  controller: donorName,
                  decoration: InputDecoration(
                    hintText: 'Donor Name',
                    hintStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    errorText: nameError,
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  cursorColor: Colors.red,
                  controller: donorPhone,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    errorText: phoneError,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButtonFormField(
                  borderRadius: BorderRadius.circular(12),
                  dropdownColor: Colors.white,
                  decoration: InputDecoration(
                    label: Text(
                      "Select Blood Group",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.grey),
                    ),
                    errorText: groupError,
                  ),
                  items: bloodGroups
                      .map((e) => DropdownMenuItem(
                    child: Text(
                      e,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.red),
                    ),
                    value: e,
                  ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedGroup = val;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  saveDonor();
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
