import 'package:flutter/material.dart';
import 'package:sqlite_app/data/local/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  DbHelper? dbRef;
  List<Map<String, dynamic>> allNotes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbRef = DbHelper.getInstanse;
    getNotes();
  }

  // method to get all notes from db
  void getNotes() async {
    allNotes = await dbRef!.getAllData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes app'),
        centerTitle: true,
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    child: Text(allNotes[index][DbHelper.Col_SRNO].toString()),
                  ),
                  title: Text(allNotes[index][DbHelper.Col_TITLE]),
                  subtitle: Text(allNotes[index][DbHelper.Col_DESC]),
                  trailing: SizedBox(
                    width: 50,
                    child: Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        // set text in fields
                                        titleController.text =
                                            allNotes[index][DbHelper.Col_TITLE];

                                        descController.text =
                                            allNotes[index][DbHelper.Col_DESC];

                                        return getModelBottemSheet(
                                            isUpdate: true,
                                            idno: allNotes[index]
                                                [DbHelper.Col_SRNO]);
                                      });
                                },
                                icon: Icon(Icons.edit)),
                          ),
                          Flexible(
                            child: IconButton(
                                onPressed: () async {
                                  bool check = await dbRef!.delete(
                                      id: allNotes[index][DbHelper.Col_SRNO]);
                                  if (check) {
                                    getNotes();
                                  }
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })
          : Center(
              child: Text('No Data Fond'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
// Note will be added from here

          showModalBottomSheet(
              context: context,
              builder: (context) {
                return getModelBottemSheet(isUpdate: false);
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getModelBottemSheet({bool isUpdate = false, int idno = 0}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Text(
            isUpdate ? 'Update Note' : 'Add Note',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'Enter title here',
              label: Text('Title'),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          TextField(
            maxLines: 4,
            controller: descController,
            decoration: InputDecoration(
              hintText: 'Enter title here',
              label: Text('desc'),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Expanded(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: () async {
                        String title = titleController.text;
                        String desc = descController.text;
                        if (title.isNotEmpty && desc.isNotEmpty) {
                          bool check = isUpdate
                              ? await dbRef!.updateData(
                                  mTitle: title, mDesc: desc, sno: idno)
                              : await dbRef!
                                  .addData(mTitle: title, mDesc: desc);
                          if (check) {
                            Navigator.pop(context);
                            getNotes();
                            titleController.clear();
                            descController.clear();
                          } else
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('data not added')));
                        }
                      },
                      child: Text(isUpdate ? 'Update Note' : 'Add Note'))),
              SizedBox(
                width: 8,
              ),
              Expanded(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'))),
            ],
          )
        ],
      ),
    );
  }
}
