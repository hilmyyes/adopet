class Decisions{
  int user_id;
  int pet_id;
  String description;
  String username;
  String status;

  Decisions({required this.user_id, required this.pet_id, required this.description, required this.username, required this.status});

  factory Decisions.fromJSON(Map<String, dynamic> json) {
  return Decisions(
   user_id: json['user_id'],
   pet_id: json['pet_id'],
   description: json['description'],
   username: json['username'],
   status: json['status'],
  );
 }
}