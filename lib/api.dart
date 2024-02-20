import 'package:unsplash_client/unsplash_client.dart';

Future<Photo> fetchSinglePhoto() async {
  // Load app credentials from environment variables or file.
  var appCredentials = loadAppCredentialsFromEnv();

  if (appCredentials == null) {
    throw 'Please provide app credentials.';
  }

  // Create a client.
  final client = UnsplashClient(
    settings: ClientSettings(credentials: appCredentials),
  );

  // Fetch a single random photo.
  final photo = await client.photos.random(count: 1).goAndGet();

  // Close the client when it is done being used to clean up allocated resources.
  client.close();

  return photo.first;
}

/// Loads [AppCredentials] from environment variables
/// (`UNSPLASH_ACCESS_KEY`, `UNSPLASH_SECRET_KEY`).
///
/// Returns `null` if the variables do not exist.
AppCredentials? loadAppCredentialsFromEnv() {
  // Hardcode the access key and secret key here
  final accessKey = 'LapDdyGsYqIgC--edS3SQS0wf0kdDDoBAZIMEcjN09Y';
  final secretKey = '2LhFVj9jQrdzWmdMdKouqg_FinL4TUEO8nFOwhWaGxg';

  if (accessKey.isNotEmpty && secretKey.isNotEmpty) {
    return AppCredentials(
      accessKey: accessKey,
      secretKey: secretKey,
    );
  }

  return null;
}
