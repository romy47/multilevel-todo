import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:second_attempt/models/project_model.dart';

class DatabaseServices {
  final String uid;
  final FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
  DatabaseServices(this.uid);

  //recieve the data

  Stream<List<Project>> getUserProjectList() {
    return _fireStoreDataBase
        .collection('projects')
        .doc(this.uid)
        .collection('project')
        .snapshots()
        .map(((snapShot) =>
            snapShot.docs.map((doc) => Project.fromJson(doc.data())).toList()));
  }

  //upload a data
  addProject(Project project) {
    DocumentReference ref = _fireStoreDataBase
        .collection('projects')
        .doc(uid)
        .collection('project')
        .doc();
    var addProjectData = Map<String, dynamic>();
    addProjectData['title'] = project.title;
    addProjectData['id'] = ref.id;
    addProjectData['color'] = project.color;
    addProjectData['uid'] = project.uid;
    return ref.set(addProjectData);
  }
}
