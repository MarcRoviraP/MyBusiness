import 'dart:io';

import 'package:MyBusiness/API_SUPABASE/supabase_service.dart';
import 'package:MyBusiness/Constants/constants.dart';
import 'package:MyBusiness/Dialog/ShowImage.dart';
import 'package:MyBusiness/generated/locale_keys.g.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MyBusiness/Class/ChatMessage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Bussineschat extends StatefulWidget {
  const Bussineschat({super.key});

  @override
  State<Bussineschat> createState() => _BussineschatState();
}

class _BussineschatState extends State<Bussineschat> {
  List<ChatMessage> messages = [];
  TextEditingController messageController = TextEditingController();
  XFile? image;
    Map<String, Color> colorMap = {
    'A': Colors.red,
    'B': Colors.orange,
    'C': Colors.yellow,
    'D': Colors.green,
    'E': Colors.indigo,
    'F': Colors.purple,
    'G': Colors.pink,
    'H': Colors.teal,
    'I': Colors.brown,
    'J': Colors.cyan,
    'K': Colors.lime,
    'L': Colors.amber,
    'M': Colors.deepOrange,
    'N': Colors.deepPurple,
    'O': Colors.pinkAccent,
    'P': Colors.blueGrey,
    'Q': Colors.greenAccent,
    'R': Colors.redAccent,
    'S': Colors.orangeAccent,
    'T': Colors.yellowAccent,
    'U': Colors.greenAccent,
    'V': Colors.purpleAccent,
    'W': Colors.tealAccent,
    'X': Colors.limeAccent,
    'Y': Colors.pinkAccent,
    'Z': Colors.brown,
    '0': Colors.grey,
    '1': Colors.black,
    '2': Colors.green,
    '3': Colors.red,
    '4': Colors.yellow,
    '5': Colors.purple,
    '6': Colors.orange,
    '7': Colors.brown,
    '8': Colors.cyan,
    '9': Colors.lime
  };
  @override
  void initState() {
    super.initState();
    // Se suscribe a los cambios en la tabla 'chat_empresa' y actualiza el estado con cada cambio de la base de datos
    supabaseService.client
        .from('chat_empresa')
        .stream(primaryKey: ['id_mensaje']);

    supabaseService.client
        .channel('chat_empresa')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            table: 'chat_empresa',
            callback: (PostgresChangePayload payload) {
              setState(() {});
            })
        .subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getMessages(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading messages'));
          } else {
            if (snapshot.hasData) {
              messages = snapshot.data as List<ChatMessage>;
            }
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        ChatMessage message = messages[index];
                        return Align(
                          alignment:
                              message.usuario?.id_usuario == usuario.id_usuario
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: message.usuario?.id_usuario ==
                                      usuario.id_usuario
                                  ? Colors.blueAccent
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: message.usuario?.id_usuario ==
                                        usuario.id_usuario
                                    ? Radius.circular(20)
                                    : Radius.zero,
                                bottomRight: message.usuario?.id_usuario ==
                                        usuario.id_usuario
                                    ? Radius.zero
                                    : Radius.circular(20),
                              ),
                            ),
                            constraints: BoxConstraints(
                                maxWidth:
                                    // Obtenemos el ancho de la pantalla y lo multiplicamos por 0.75
                                    MediaQuery.of(context).size.width * 0.75),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.usuario?.nombre ??
                                      'Usuario desconocido',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: message.usuario?.id_usuario ==
                                            usuario.id_usuario
                                        ? Colors.white
                                        : colorMap[
                                            message.usuario?.nombre[0].toUpperCase()] ??
                                            Colors.black,
                                  ),
                                ),
                                message.imagen_url != ""
                                    ? GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (context) => ShowImage(
                                                url:
                                                    "https://cghpzfumlnoaxhqapbky.supabase.co/storage/v1/object/public/$bucketChat//${message.imagen_url}"),
                                          );
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "https://cghpzfumlnoaxhqapbky.supabase.co/storage/v1/object/public/$bucketChat//${message.imagen_url}",
                                          width: 200,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                        ),
                                      )
                                    : const SizedBox(),
                                Text(
                                  message.mensaje,
                                  style: TextStyle(
                                    color: message.usuario?.id_usuario ==
                                            usuario.id_usuario
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    DateFormat(getDateFormat(message))
                                        .format(message.fecha_envio),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: message.usuario?.id_usuario ==
                                              usuario.id_usuario
                                          ? Colors.white70
                                          : Colors.black45,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            decoration: InputDecoration(
                              hintText:
                                  LocaleKeys.BussinesChat_type_message.tr(),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: enviarMensaje, icon: Icon(Icons.send)),
                        IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                ),
                                builder: (context) {
                                  return Wrap(
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text(LocaleKeys
                                            .BussinesChat_open_camera.tr()),
                                        onTap: () {
                                          Navigator.pop(context);
                                          takePhoto().then((value) {
                                            if (value != null) {
                                              setState(() {
                                                image = value;
                                              });
                                            }
                                          });
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.photo_library),
                                        title: Text(LocaleKeys
                                                .BussinesChat_select_from_gallery
                                            .tr()),
                                        onTap: () {
                                          Navigator.pop(context);
                                          takePhotoGallery().then((value) {
                                            if (value != null) {
                                              setState(() {
                                                image = value;
                                              });
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: image == null
                                ? Icon(Icons.attach_file)
                                : Image.file(
                                    File(image!.path),
                                    width: 30,
                                    height: 30,
                                  )),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        });
  }

  Future<void> getMessages() async {
    var chat = await Utils().getChat();

    messages = chat.map((e) {
      return ChatMessage.fromJson(e);
    }).toList();
  }

  void enviarMensaje() async {
    if (messageController.text.isNotEmpty) {
      String name = "";
      if (image != null) {
        // Guarda la imagen en el servidor
        name = "${DateTime.now().millisecondsSinceEpoch}.png";
        await uploadImage(File(image!.path), name, bucketChat);
      }
      Utils().insertInTable({
        'id_empresa': empresa.id_empresa,
        'id_usuario': usuario.id_usuario,
        'mensaje': messageController.text,
        'imagen_url': name == "" ? "" : name,
        'fecha_envio': DateTime.now().toString(),
      }, "chat_empresa");

      setState(() {
        messageController.clear();
        image = null;
      });
    }
  }

  String getDateFormat(ChatMessage message) {
    if (DateTime.now().difference(message.fecha_envio).inDays == 0) {
      return 'HH:mm';
    } else if (DateTime.now().difference(message.fecha_envio).inDays <= 7) {
      return 'EEE HH:mm';
    } else {
      return 'dd/MM/yyyy HH:mm';
    }
  }

  Future<XFile?> takePhoto() async {
    XFile? picture = await ImagePicker().pickImage(source: ImageSource.camera);

    return picture;
  }

  Future<XFile?> takePhotoGallery() async {
    XFile? picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    return picture;
  }
}
