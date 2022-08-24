import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muserpol_pvt/bloc/notification/notification_bloc.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/database/db_provider.dart';
import 'package:muserpol_pvt/model/user_model.dart';
import 'package:muserpol_pvt/screens/navigator_bar.dart';
import 'package:muserpol_pvt/screens/switch.dart';
import 'package:muserpol_pvt/services/auth_service.dart';
import 'package:provider/provider.dart';


//WIDGET: verifica la autenticación del usuario
class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //llamamos a los proveedores de estados
    final authService = Provider.of<AuthService>(context, listen: false);
    // final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    // final appState = Provider.of<AppState>(context, listen: false);
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
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const ScreenSwitch(),
                        transitionDuration: const Duration(seconds: 0)));
              });
            } else {
              final notificationBloc =
                  BlocProvider.of<NotificationBloc>(context);
              // UserModel user = userModelFromJson(prefs!.getString('user')!);
              // userBloc.add(UpdateUser(user.user!));
              DBProvider.db.getAllNotificationModel().then(
                  (res) => notificationBloc.add(UpdateNotifications(res)));
              //en el caso de encontrar el token solicitado
              //redireccionamos al usuario al ScreenLoading
              // authService.logout();
              // UserModel user = userModelFromJson(prefs!.getString('user')!);

              // appState.addKey(
              //     'cianverso', prefs!.getString('ci')!); //num carnet
              // appState.addKey(
              //     'cireverso', prefs!.getString('ci')!); //num carnet
              // appState.addKey('cireverso', user.user!.fullName!); //nombre
              getInfo(context);
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            const NavigatorBar(tutorial: false),
                        transitionDuration: const Duration(seconds: 0)));
              });
            }
            return Container();
          },
        ),
      ),
    );
  }
  getInfo(BuildContext context)async{
    final authService = Provider.of<AuthService>(context, listen: false);
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    if(await authService.readStateApp()=='complement'){
              UserModel user =  userModelFromJson( await authService.readUser());
              userBloc.add(UpdateUser(user.user!));
    }

  }
}
