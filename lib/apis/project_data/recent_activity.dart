import 'package:project/components/export.dart';
import 'package:project/models/comment_model.dart';

class RecentActivityApi {
  final Ref ref;
  // final String _path = 'project_data/status_overview';
  RecentActivityApi({required this.ref});
  Future<List<CommentModel>> get() async {
    await Future.delayed(Duration(seconds: 1));
    try {
      // Response response = await ref.read(apiClientProvider).get(_path, queryParameters: {'project_hd_id': projectHDId});
      // return response.data;
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(dummyRecentActivity);
      return data.map((item) => CommentModel.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final apiRecentActivity = Provider<RecentActivityApi>((ref) => RecentActivityApi(ref: ref));

final dummyRecentActivity = [
  {
    "table_name": "",
    "id": "50",
    "project": {"table_name": "ProjectHDModel", "id": "95", "name": "Demo"},
    "type_of_work": {"table_name": "TypeOfWorkModel", "id": "2", "name": "Bug", "color": "#FF5733"},
    "task": {"table_name": "TaskModel", "id": "104", "name": "Lorem Ipsum2"},
    "comment_json": [
      {
        "insert": "อยากกลับบ้านครับบบพี่โอ T-T",
        "attributes": {"size": "huge", "color": "#FF000000"},
      },
      {"insert": "\n"},
    ],
    "created_at": "2025-08-07T16:37:35.828683",
    "create_by": {"table_name": "UserModel", "id": "1", "name": "Administrator"},
  },
  {
    "table_name": "",
    "id": "51",
    "project": {"table_name": "ProjectHDModel", "id": "95", "name": "Demo"},
    "type_of_work": {"table_name": "TypeOfWorkModel", "id": "1", "name": "Task", "color": "#FF5733"},
    "task": {"table_name": "TaskModel", "id": "104", "name": "Lorem Ipsum2"},
    "comment_json": [
      {
        "insert": "asdsadsadasasadsa",
        "attributes": {"bold": true, "size": "large"},
      },
      {"insert": "\n"},
      {
        "insert": "asdsadsadsadas",
        "attributes": {"bold": true},
      },
      {"insert": "\nasdsadsadsad\n\nasdsadsadsad\nasdsadsdsa\nasdaasdadsadasdsa"},
      {
        "insert": "\n",
        "attributes": {"list": "ordered"},
      },
      {"insert": "asdsaasdsadasa"},
      {
        "insert": "\n",
        "attributes": {"list": "ordered"},
      },
      {"insert": "asdassdasdsadsa"},
      {
        "insert": "\n",
        "attributes": {"list": "ordered"},
      },
      {"insert": "asdsadsadsad"},
      {
        "insert": "\n",
        "attributes": {"list": "ordered"},
      },
      {"insert": "asdsaadsaasdsadsa"},
      {
        "insert": "\n",
        "attributes": {"list": "ordered"},
      },
      {"insert": "\nsdasasd"},
      {
        "insert": "\n",
        "attributes": {"list": "bullet"},
      },
      {"insert": "asdasdasd"},
      {
        "insert": "\n",
        "attributes": {"list": "bullet"},
      },
      {"insert": "asdsaadsa"},
      {
        "insert": "\n",
        "attributes": {"list": "bullet"},
      },
      {"insert": "asdsadsadsa"},
      {
        "insert": "\n",
        "attributes": {"list": "bullet"},
      },
      {"insert": "dasdsadsads"},
      {
        "insert": "\n",
        "attributes": {"list": "bullet"},
      },
      {"insert": "aasdsasdadasd"},
      {
        "insert": "\n",
        "attributes": {"list": "bullet"},
      },
      {"insert": "asdasda"},
      {
        "insert": "\n",
        "attributes": {"list": "bullet"},
      },
    ],
    "created_at": "2025-08-07T16:52:08.063695",
    "create_by": {"table_name": "UserModel", "id": "1", "name": "Administrator"},
  },
  {
    "table_name": "",
    "id": "52",
    "project": {"table_name": "ProjectHDModel", "id": "95", "name": "Demo"},
    "type_of_work": {"table_name": "TypeOfWorkModel", "id": "1", "name": "Task", "color": "#FF5733"},
    "task": {"table_name": "TaskModel", "id": "104", "name": "Lorem Ipsum2"},
    "comment_json": [
      {
        "insert": "[",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "    {",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "        \"table_name\": \"master_type_of_work\",",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "        \"id\": \"1\",",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "        \"name\": \"Task\",",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "        \"description\": \"งานที่ต้องทำ\",",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "        \"color\": \"#FF5733\",",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "        \"active\": true",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "    },",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "    {",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "        \"table_name\": \"master_type_of_work\",",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "        \"id\": \"2\",",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "        \"name\": \"Bug\",",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "        \"description\": \"งานที่มีปัญหา\",",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "        \"color\": \"#FF5733\",",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "        \"active\": true",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "    },",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "    {",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "        \"table_name\": \"master_type_of_work\",",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "        \"id\": \"3\",",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "        \"name\": \"Request\",",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "        \"description\": \"งานที่ร้องขอ\",",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "        \"color\": \"#FF5733\",",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "        \"active\": true",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "    }",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "]",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
    ],
    "created_at": "2025-08-07T16:56:30.525909",
    "create_by": {"table_name": "UserModel", "id": "1", "name": "Administrator"},
  },
  {
    "table_name": "",
    "id": "53",
    "project": {"table_name": "ProjectHDModel", "id": "95", "name": "Demo"},
    "type_of_work": {"table_name": "TypeOfWorkModel", "id": "1", "name": "Task", "color": "#FF5733"},
    "task": {"table_name": "TaskModel", "id": "104", "name": "Lorem Ipsum2"},
    "comment_json": [
      {
        "insert": "หวัดดีจ้า",
        "attributes": {"bold": true, "background": "#FFFFF176"},
      },
      {"insert": "\n"},
    ],
    "created_at": "2025-08-07T17:10:07.004468",
    "create_by": {"table_name": "UserModel", "id": "1", "name": "Administrator"},
  },
  {
    "table_name": "",
    "id": "54",
    "project": {"table_name": "ProjectHDModel", "id": "95", "name": "Demo"},
    "type_of_work": {"table_name": "TypeOfWorkModel", "id": "1", "name": "Task", "color": "#FF5733"},
    "task": {"table_name": "TaskModel", "id": "104", "name": "Lorem Ipsum2"},
    "comment_json": [
      {
        "insert": "EIEI",
        "attributes": {"bold": true},
      },
      {"insert": "\n"},
    ],
    "created_at": "2025-08-07T17:10:43.710512",
    "create_by": {"table_name": "UserModel", "id": "1", "name": "Administrator"},
  },
  {
    "table_name": "",
    "id": "55",
    "project": {"table_name": "ProjectHDModel", "id": "95", "name": "Demo"},
    "type_of_work": {"table_name": "TypeOfWorkModel", "id": "1", "name": "Task", "color": "#FF5733"},
    "task": {"table_name": "TaskModel", "id": "104", "name": "Lorem Ipsum2"},
    "comment_json": [
      {
        "insert": "assadasdsaddsa",
        "attributes": {"bold": true, "size": "large"},
      },
      {
        "insert": "\n",
        "attributes": {"indent": 1},
      },
      {
        "insert": "adsaadasasdas",
        "attributes": {"font": "sans-serif", "size": "large"},
      },
      {
        "insert": "\n",
        "attributes": {"list": "ordered", "indent": 1},
      },
      {
        "insert": "asdasdsadsad",
        "attributes": {"font": "sans-serif", "size": "large", "strike": true},
      },
      {
        "insert": "\n",
        "attributes": {"list": "ordered", "indent": 1},
      },
      {
        "insert": "adsadasdas",
        "attributes": {"font": "sans-serif", "size": "large"},
      },
      {
        "insert": "\n",
        "attributes": {"list": "ordered", "indent": 1},
      },
      {
        "insert": "asdasasda",
        "attributes": {"font": "sans-serif", "size": "large"},
      },
      {
        "insert": "\n",
        "attributes": {"list": "ordered", "indent": 1},
      },
      {
        "insert": "\n",
        "attributes": {"indent": 1},
      },
      {"insert": "Design"},
      {
        "insert": "\n",
        "attributes": {"list": "checked", "indent": 1},
      },
      {"insert": "Api"},
      {
        "insert": "\n",
        "attributes": {"list": "checked", "indent": 1},
      },
      {"insert": "asdsadas"},
      {
        "insert": "\n",
        "attributes": {"list": "checked", "indent": 1},
      },
      {"insert": "sadasdsadas"},
      {
        "insert": "\n",
        "attributes": {"list": "unchecked", "indent": 1},
      },
      {
        "insert": "\n",
        "attributes": {"indent": 1},
      },
      {"insert": "enddate"},
      {
        "insert": "\n",
        "attributes": {"indent": 1},
      },
      {"insert": "ไม่ควรเลือก วันที่ก่อน startdate ได้"},
      {
        "insert": "\n",
        "attributes": {"indent": 1, "blockquote": true},
      },
      {
        "insert": "asdadsa",
        "attributes": {"code": true},
      },
      {
        "insert": "\n",
        "attributes": {"indent": 1},
      },
      {
        "insert": "asdadsadasd",
        "attributes": {"code": true},
      },
      {
        "insert": "\n",
        "attributes": {"indent": 1},
      },
      {
        "insert": "sdasdsa",
        "attributes": {"code": true},
      },
      {
        "insert": "\n",
        "attributes": {"indent": 1},
      },
      {
        "insert": "asdasdasdasd",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "asdsadasas",
        "attributes": {"code": true},
      },
      {"insert": "\n\n"},
      {
        "insert": "asdsasada",
        "attributes": {"code": true},
      },
      {"insert": "\n"},
      {
        "insert": "\n",
        "attributes": {"indent": 1, "code-block": true},
      },
      {"insert": "aadasdsdadadasasdas"},
      {
        "insert": "\n",
        "attributes": {"indent": 1, "code-block": true},
      },
      {"insert": "asd"},
      {
        "insert": "\n",
        "attributes": {"indent": 1, "code-block": true},
      },
    ],
    "created_at": "2025-08-08T10:30:10.814654",
    "create_by": {"table_name": "UserModel", "id": "1", "name": "Administrator"},
  },
  {
    "table_name": "",
    "id": "70",
    "project": {"table_name": "ProjectHDModel", "id": "95", "name": "Demo"},
    "type_of_work": {"table_name": "TypeOfWorkModel", "id": "1", "name": "Task", "color": "#FF5733"},
    "task": {"table_name": "TaskModel", "id": "104", "name": "Lorem Ipsum2"},
    "comment_json": [
      {"insert": "adadsdaasdas\n"},
    ],
    "created_at": "2025-08-08T16:52:42.034112",
    "create_by": {"table_name": "UserModel", "id": "1", "name": "Administrator"},
  },
  {
    "table_name": "",
    "id": "71",
    "project": {"table_name": "ProjectHDModel", "id": "95", "name": "Demo"},
    "type_of_work": {"table_name": "TypeOfWorkModel", "id": "1", "name": "Task", "color": "#FF5733"},
    "task": {"table_name": "TaskModel", "id": "104", "name": "Lorem Ipsum2"},
    "comment_json": [
      {"insert": "assdaassada\n"},
    ],
    "created_at": "2025-08-08T16:58:59.140172",
    "create_by": {"table_name": "UserModel", "id": "3", "name": "Pop"},
  },
];
