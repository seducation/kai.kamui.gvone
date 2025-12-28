import 'package:appwrite/appwrite.dart';

final Client client = Client()
    .setProject("gvone")
    .setEndpoint("https://fra.cloud.appwrite.io/v1");

class AppwriteClient {
  Client get clientInstance => client;

  Account get account => Account(client);
  Databases get databases => Databases(client);
  Storage get storage => Storage(client);
}
