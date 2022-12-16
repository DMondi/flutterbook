import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "NotesDBWorker.dart";
import "NotesModel.dart" show NotesModel, notesModel;

class NotesEntry extends StatelessWidget {

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController =  TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  NotesEntry({super.key}) {
    _titleEditingController.addListener(() {
      notesModel.entityBeingEdited.title = _titleEditingController.text;
    });
    _contentEditingController.addListener(() {
      notesModel.entityBeingEdited.content = _contentEditingController.text;
    });
  }

  @override
    Widget build(BuildContext context) {

    _titleEditingController.text = notesModel.entityBeingEdited.title;
    _contentEditingController.text = notesModel.entityBeingEdited.content;

    // Return widget.
    return ScopedModel(
        model: notesModel,
        child: ScopedModelDescendant<NotesModel>(builder:
            (BuildContext context, Widget? inChild, NotesModel inModel) {
          return Scaffold(
              bottomNavigationBar: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Row(children: [
                    ElevatedButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          // Hide soft keyboard.
                          FocusScope.of(context).requestFocus(FocusNode());
                          // Go back to the list view.
                          inModel.setStackIndex(0);
                        }),
                    const Spacer(),
                    ElevatedButton(
                        child: Text("Save"),
                        onPressed: () {
                          _save(context, notesModel);
                        })
                  ])),
              body: Form(
                  key: _formKey,
                  child: ListView(children: [
                    // Title.
                    ListTile(
                        leading: const Icon(Icons.title),
                        title: TextFormField(
                            decoration: const InputDecoration(hintText: "Title"),
                            controller: _titleEditingController,
                            validator: (String? inValue) {
                              if (inValue?.length == 0) {
                                return "Please enter a title";
                              }
                              return null;
                            })),
                    // Content.
                    ListTile(
                        leading: const Icon(Icons.content_paste),
                        title: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 8,
                            decoration: const InputDecoration(hintText: "Content"),
                            controller: _contentEditingController,
                            validator: (String? inValue) {
                              if (inValue?.length == 0) {
                                return "Please enter content";
                              }
                              return null;
                            })),
                    // Note color.
                    ListTile(
                        leading: const Icon(Icons.color_lens),
                        title: Row(children: [
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                          color: Colors.red, width: 18) +
                                          Border.all(
                                              width: 6,
                                              color: notesModel.color == "red"
                                                  ? Colors.red
                                                  : Theme.of(context)
                                                  .canvasColor))),
                              onTap: () {
                                notesModel.entityBeingEdited.color = "red";
                                notesModel.setColor("red");
                              }),
                          const Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                          color: Colors.green, width: 18) +
                                          Border.all(
                                              width: 6,
                                              color: notesModel.color == "green"
                                                  ? Colors.green
                                                  : Theme.of(context)
                                                  .canvasColor))),
                              onTap: () {
                                notesModel.entityBeingEdited.color = "green";
                                notesModel.setColor("green");
                              }),
                          const Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                          color: Colors.blue, width: 18) +
                                          Border.all(
                                              width: 6,
                                              color: notesModel.color == "blue"
                                                  ? Colors.blue
                                                  : Theme.of(context)
                                                  .canvasColor))),
                              onTap: () {
                                notesModel.entityBeingEdited.color = "blue";
                                notesModel.setColor("blue");
                              }),
                          const Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                          color: Colors.yellow, width: 18) +
                                          Border.all(
                                              width: 6,
                                              color:
                                              notesModel.color == "yellow"
                                                  ? Colors.yellow
                                                  : Theme.of(context)
                                                  .canvasColor))),
                              onTap: () {
                                notesModel.entityBeingEdited.color = "yellow";
                                notesModel.setColor("yellow");
                              }),
                          const Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                          color: Colors.grey, width: 18) +
                                          Border.all(
                                              width: 6,
                                              color: notesModel.color == "grey"
                                                  ? Colors.grey
                                                  : Theme.of(context)
                                                  .canvasColor))),
                              onTap: () {
                                notesModel.entityBeingEdited.color = "grey";
                                notesModel.setColor("grey");
                              }),
                          const Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(
                                          color: Colors.purple, width: 18) +
                                          Border.all(
                                              width: 6,
                                              color:
                                              notesModel.color == "purple"
                                                  ? Colors.purple
                                                  : Theme.of(context)
                                                  .canvasColor))),
                              onTap: () {
                                notesModel.entityBeingEdited.color = "purple";
                                notesModel.setColor("purple");
                              })
                        ]))
                  ] /* End Column children. */
                  ) /* End ListView. */
              ) /* End Form. */
          ); /* End Scaffold. */
        } /* End ScopedModelDescendant builder(). */
        ) /* End ScopedModelDescendant. */
    ); /* End ScopedModel. */
  } /* End build(). */

  void _save(BuildContext context, NotesModel inModel) async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (inModel.entityBeingEdited.id == null) {
        await NotesDBWorker.db.create(notesModel.entityBeingEdited);
  } else {
      await NotesDBWorker.db.update(notesModel.entityBeingEdited);
    }

    notesModel.loadData("notes", NotesDBWorker.db);
    inModel.setStackIndex(0);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text("Note saved")));
  }


}
