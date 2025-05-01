import 'dart:async';

import 'package:MyBusiness/API_SUPABASE/supabase_service.dart';
import 'package:MyBusiness/Constants/constants.dart';
import 'package:MyBusiness/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Invitesscreen extends StatefulWidget {
  const Invitesscreen({super.key});

  @override
  State<Invitesscreen> createState() => _InvitesscreenState();
}

class _InvitesscreenState extends State<Invitesscreen> {
  @override
  void initState() {
    super.initState();
    // Se suscribe a los cambios en la tabla 'invitacion_empresa' y actualiza el estado con cada cambio de la base de datos
    supabaseService.client
        .from('invitacion_empresa')
        .stream(primaryKey: ['id_invitacion']);

    supabaseService.client
        .channel('invitacion_empresa')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            table: 'invitacion_empresa',
            callback: (PostgresChangePayload payload) {
              setState(() {});
            })
        .subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Utils().getInvites(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(LocaleKeys.InvitesScreen_no_invites.tr()));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            if (data.isEmpty) {
              return Center(
                  child: Text(LocaleKeys.InvitesScreen_no_invites.tr()));
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                final item = data[index]["usuario"];

                return Card(
                  child: ListTile(
                    title: Text(item['nombre']),
                    subtitle: Text(item['correo']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            Utils().updateInvitacionState(
                                item["id_usuario"], Aceptada);
                            Utils().insertInTable({
                              "id_usuario": item["id_usuario"],
                              "id_empresa": empresa.id_empresa,
                              "rol": Usuario_empresa,
                            }, "usuario_empresa");
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Utils().updateInvitacionState(
                                item["id_usuario"], Rechazada);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: data.length,
            );
          }
          return Center(child: Text(LocaleKeys.InvitesScreen_no_invites.tr()));
        });
  }
}
