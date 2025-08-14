

enum Assignee {
  john,
  jane,
  peter,
  mary,
}

enum Status {
  pending,
  completed,
}

class TodoItem {
  String task;
  DateTime startDate;
  DateTime dueDate;
  Assignee assignee;
  Duration timeEstimate;
  Status status;

  TodoItem({
    required this.task,
    required this.startDate,
    required this.dueDate,
    required this.assignee,
    required this.timeEstimate,
    this.status = Status.pending,
  });
}