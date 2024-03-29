class Todo {

  // Todo Skeleton Variables
  final int id;
  final int taskId;
  final String title;
  final int isDone;

  // Constructor
  Todo({this.id,this.taskId,this.title,this.isDone});

  Map<String, dynamic> toMap(){
    return{
      'id':id,
      'taskId':taskId,
      'title':title,
      'isDone':isDone,
    };
  }
}