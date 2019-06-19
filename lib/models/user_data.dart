class UserData {
  String id;
  String name;
  String email;
  String mobileNumber;
  String imageUrl;
  String token;
  bool isDemo;
  String role;

  UserData.fromMap(Map<dynamic, dynamic> data)
      : name = data["name"],
        email = data["email"],
        mobileNumber = data["mobile_number"],
        imageUrl = data["image_url"],
        token = data["jagaapp_token"],
        isDemo = data["is_demo"],
        role = data["role"];
}
