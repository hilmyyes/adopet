class Pet {
 int pet_id;
 String pet_name;
 String pet_type;
 String pet_image;
 String pet_description;
 String pet_status;
 int pet_user_id;
 String? pet_username;
 Pet({required this.pet_id, required this.pet_name, required this.pet_type, required this.pet_image, required this.pet_description, required this.pet_status, required this.pet_user_id, required this.pet_username});

 factory Pet.fromJSON(Map<String, dynamic> json) {
  return Pet(
   pet_id: json['id'],
   pet_name: json['name'],
   pet_type: json['type'],
   pet_image: json['image'],
   pet_description: json['description'],
   pet_status: json['status'],
   pet_user_id: json['user_id'],
   pet_username: json['username'] ?? 'waiting',
  );
 }
}

