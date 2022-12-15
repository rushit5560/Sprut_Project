import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_bloc.dart';
import 'package:sprut/presentation/pages/no_internet/no_internet.dart';
import 'package:sprut/resources/configs/helpers/helpers.dart';
import 'package:sprut/resources/configs/routes/routes.dart';
import 'package:sprut/resources/configs/service_locator/service_locator.dart';
import 'package:sprut/resources/services/database/database.dart';
import 'package:sprut/resources/services/database/database_keys.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../business_logic/blocs/connection_bloc/connection_state/connection_state.dart';

class PrivacyPolicy extends StatefulWidget {
  PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  final DatabaseService databaseService = serviceLocator.get<DatabaseService>();

  @override
  void initState() {
    super.initState();
    internetConnectivity();
  }

  void internetConnectivity() async {
    bool isConnected = await Helpers.checkInternetConnectivity();

    if (!isConnected) {
      Helpers.internetDialog(context);

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Color(0xff292a2a),
      body: SafeArea(
        child: WebView(
          initialUrl: language.privacy_policy_url,
          zoomEnabled: true,
          allowsInlineMediaPlayback: true,
          debuggingEnabled: true,
          gestureNavigationEnabled: true,
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        child: Text(
          "Accept",
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          padding: EdgeInsets.all(15),
          primary: Colors.grey,
        ),
        onPressed: () {
          databaseService.saveToDisk(DatabaseKeys.privacyPolicyAccepted, true);
          Navigator.pushReplacementNamed(context, Routes.cityLogin);
        },
      ),
    );
  }
}
