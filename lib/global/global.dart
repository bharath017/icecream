import 'package:firebase_auth/firebase_auth.dart';
import 'package:icecream/models/direction_details_info.dart';
import 'package:icecream/models/user_model.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList = []; //online-active drivers Information List
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? chosenDriverId = "";
String originAddress = "";
String cloudMessagingServerToken =
    "key=AAAAewj-JJc:APA91bE3Cgem8HKHh6nispSoG03SNjvrEY8yH-gJv1cBPrXEUOAmpjcW4ahuovQGw0cQgcm90E_PSXgTXGmGF6JtAVGkFvpdkH6mNMVRzoIy0jD4qNFn2ZhaL7EBgFboh5gs_Y_6ZsJr";
String userDropOffAddress = "";
String driverCarDetails = "";
String driverName = "";
String driverPhone = "";
String phoneNumber = '';
String MailAddress = '';
String accountSid = "AC023c32da3fe2c841471f98c1d4a5edd6";
String authToken = "eeafec3db69010fedb92593d9e915d2c";
String twilioNumber = "+19793664339";
