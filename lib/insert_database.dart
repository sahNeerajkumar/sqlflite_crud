import 'package:flutter/material.dart';
import 'package:untitled2/home_page.dart';

class InsertDatabase extends StatefulWidget {
  const InsertDatabase({super.key});

  @override
  State<InsertDatabase> createState() => _InsertDatabaseState();
}

class _InsertDatabaseState extends State<InsertDatabase> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  List<Map<String, dynamic>> allNotes = [];
  DBHelper? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  void getNotes() async {
    allNotes = await dbRef!.getAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {},
          ),
          title: Text('Insert Update Delete',style: TextStyle(color: Colors.white,fontSize: 25,fontWeight:FontWeight.bold,fontStyle: FontStyle.italic),),
          backgroundColor: Colors.blue,
        ),
        body: allNotes.isNotEmpty
            ? ListView.builder(
                itemCount: allNotes.length,
                itemBuilder: (_,index) {
                  return Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      leading:CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Text('${index+1}'),
                      ),
                      title: Text(
                          "${allNotes[index][DBHelper.COLUMN_NOTE_TITLE]}"),
                      subtitle:
                          Text('${allNotes[index][DBHelper.COLUMN_NOTE_DESC]}'),
                      trailing: SizedBox(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                nameController.text = allNotes[index][DBHelper.COLUMN_NOTE_TITLE];
                                ageController.text = allNotes[index][DBHelper.COLUMN_NOTE_DESC];
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return getBottomSheetWidget(
                                        isUpdate: true,
                                        id: allNotes[index]
                                        [DBHelper.COLUMN_NOTE_SNO]);

                                  },
                                );
                              },
                              child: Icon(Icons.edit),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () async {
                                bool check = await dbRef!.deleteNote(
                                    id: allNotes[index]
                                        [DBHelper.COLUMN_NOTE_SNO]);
                                if (check) {
                                  getNotes();
                                }
                              },
                              child: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : Center(
                child: Text('No Notes yet!'),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return getBottomSheetWidget();
              },
            );
            // getNotes();
            // nameController.clear();
            // ageController.clear();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget getBottomSheetWidget({bool isUpdate = false, id = 0}) {
    var widthScreen = MediaQuery.of(context).size.width;
    var heightScreen = MediaQuery.of(context).size.height;
    return Container(
      width: widthScreen,
      height: heightScreen,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            isUpdate ? 'update Data' : 'Add Notes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: 'Enter Name',
                label: Text('Name')),
          ),
          SizedBox(height: 20),
          TextField(
            controller: ageController,
            maxLength: 100,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Age',
                label: Text('Age')),
          ),
          Row(
            children: [
              Expanded(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11))),
                      onPressed: () async {
                        var name = nameController.text;
                        var age = ageController.text;
                        if (name.isNotEmpty && age.isNotEmpty) {
                          bool check = isUpdate
                              ? await dbRef!
                                  .updateNote(name: name, age: age, id: id)
                              : await dbRef!.addNote(title: name, desc: age);
                          if (check) {
                            getNotes();
                          }
                        }
                        Navigator.pop(context);
                        nameController.clear();
                        ageController.clear();
                      },
                      child: Text(isUpdate ? 'Update Data' : 'Add Data'))),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11))),
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
