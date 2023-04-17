String setLogin() => '/auth';
//get events
String events(String? id) => '/events/${id ?? ''}';
String reportStudentsByEvent(String? id) => '/events/report/student/$id';
//get events by campus
String eventsCampus(String campus) => '/events/campus/$campus';
//categories
String categories(String? id) => '/categories/${id ?? ''}';
String deleteCategories(String id) => '/categories/delete/$id';
//expositores
String guests(String? id) => '/guests/${id ?? ''}';
String deleteGuest(String id) => '/guests/delete/$id';

//users
String users(String? id) => '/users/${id ?? ''}';
String deleteUsers(String id) => '/users/delete/$id';

//permisos
String permisions() => '/permisions';
//roles
String roles(String? id) => '/roles/${id ?? ''}';
String deleteRol(String id) => '/roles/delete/$id';
//tipos de usuaros
String typeUsers(String? id) => '/typeusers/${id ?? ''}';
String deleteTypeUsers(String id) => '/typeusers/delete/$id';
//estudiantes
String students() => '/students';
String studentsAddEvent(String id) => '/students/add/event/$id';

String studentsXlxs() => '/students/file';

String careers() => '/careers';

//dashboard
String dashboard() => '/dashboard';
String dashboardFilter() => '/dashboard/filter';

//reportes
String reportsFilter() => '/reports';
String reportsDownload() => '/reports/download';
