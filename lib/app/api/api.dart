import 'package:unsplash_client/unsplash_client.dart';

Future<Photo> fetchSinglePhoto() async {
  // Loading des credentials (pas implémenté car buggé)
  var appCredentials = loadAppCredentialsFromEnv();

  if (appCredentials == null) {
    throw 'Please provide app credentials.';
  }

  // charge du client (utilisation d'une librairie pour simplifier l'utilisation).
  final client = UnsplashClient(
    settings: ClientSettings(credentials: appCredentials),
  );

  // Exemple de requète pour une image.
  final photo = await client.photos.random(count: 1).goAndGet();

  // Fermeture du client pour éviter la surcharge et les lags.
  client.close();

  return photo.first;
}

/// Loads [AppCredentials] from environment variables
/// (`UNSPLASH_ACCESS_KEY`, `UNSPLASH_SECRET_KEY`).
///
/// Returns `null` if the variables do not exist.
AppCredentials? loadAppCredentialsFromEnv() {
  // Credentials en claire pour le moment (à modifier)
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
