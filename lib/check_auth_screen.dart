import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muserpol_pvt/bloc/notification/notification_bloc.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/database/db_provider.dart';
import 'package:muserpol_pvt/model/user_model.dart';
import 'package:muserpol_pvt/screens/navigator_bar.dart';
import 'package:muserpol_pvt/screens/switch.dart';
import 'package:muserpol_pvt/services/auth_service.dart';
import 'package:muserpol_pvt/swipe/slider.dart';
import 'package:provider/provider.dart';

//WIDGET: verifica la autenticación del usuario
class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //llamamos a los proveedores de estados
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          //verificamos si el usuario está autenticado
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            //en el caso de no encontrar el token solicitado
            //redireccionamos al usuario al ScreenLogin
            if (!snapshot.hasData) return const Text('');
            if (snapshot.data == '') {
              Future.microtask(() {
                return goFirstInto(context);
              });
            } else {
              final notificationBloc = BlocProvider.of<NotificationBloc>(context);

              // userBloc.add(UpdateUser(user.user!));
              DBProvider.db.getAllNotificationModel().then((res) => notificationBloc.add(UpdateNotifications(res)));
              //en el caso de encontrar el token solicitado
              //redireccionamos al usuario al ScreenLoading
              // authService.logout();
              // appState.addKey('cireverso', user.user!.fullName!); //nombre
              Future.microtask(() {
                return getInfo(context);
                //                 return Navigator.pushReplacementNamed(
                //   context,
                //   'navigator',
                //   arguments: NavigatorArguments(
                //     'virtualofficine',
                //   ),
                // );
              });
            }
            return const Scaffold();
          },
        ),
      ),
    );
  }

  goFirstInto(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (await authService.readFirstTime() == '') {
      Future.microtask(() {
        Navigator.pushReplacement(
            context, PageRouteBuilder(pageBuilder: (_, __, ___) => const PageSlider(), transitionDuration: const Duration(seconds: 0)));
      });
    } else {
      Future.microtask(() {
        Navigator.pushReplacement(
            context, PageRouteBuilder(pageBuilder: (_, __, ___) => const ScreenSwitch(), transitionDuration: const Duration(seconds: 0)));
      });
    }
  }

  getInfo(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    debugPrint('holaa ${await authService.readStateApp()}');
    if (await authService.readStateApp() == 'complement') {
      UserModel user = userModelFromJson(await authService.readUser());
      userBloc.add(UpdateUser(user.user!));
    }
    final stateApp = await authService.readStateApp();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => NavigatorBar(tutorial: false, stateApp: stateApp), transitionDuration: const Duration(seconds: 0)));
  }
}
