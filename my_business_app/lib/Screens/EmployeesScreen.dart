import 'package:MyBusiness/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MyBusiness/Class/Usuario_empresa.dart';
import 'package:MyBusiness/Constants/constants.dart';
import 'package:flutter/material.dart';

class Employeesscreen extends StatefulWidget {
  const Employeesscreen({super.key});

  @override
  State<Employeesscreen> createState() => _EmployeesscreenState();
}

class _EmployeesscreenState extends State<Employeesscreen> {
  List<Usuario_emp> employees = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getEmployees(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Scaffold(
              body: ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  Usuario_emp employee = employees[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor:
                                Theme.of(context).colorScheme.surfaceBright,
                            child: Text(
                              employee.usuario!.nombre[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  employee.usuario!.nombre,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  employee.rol,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (employee.id_usuario == usuario.id_usuario)
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 23),
                              ],
                            )
                          else
                            employee.rol == "Administrador"
                                ? TextButton(
                                    onPressed: () {
                                      cambiarRol(
                                          employee.id_usuario_emp, "Usuario");
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: Text(LocaleKeys
                                        .EmployeesScreen_degrade.tr()),
                                  )
                                : Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          cambiarRol(employee.id_usuario_emp,
                                              "Administrador");
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.green,
                                        ),
                                        child: Text(LocaleKeys
                                            .EmployeesScreen_ascend.tr()),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                        onPressed: () {
                                          eliminar(employee.id_usuario_emp);
                                        },
                                        child: Text(LocaleKeys
                                            .EmployeesScreen_delete.tr()),
                                      ),
                                    ],
                                  ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        });
  }

  Future<void> getEmployees() async {
    var response = await Utils().getUsersEmpresa();
    response.sort((a, b) {
      return a["usuario"]["nombre"].compareTo(b["usuario"]["nombre"]);
    });
    response.sort((a, b) {
      return a["rol"].compareTo(b["rol"]);
    });

    employees = response.map<Usuario_emp>((json) {
      return Usuario_emp.fromJson(json);
    }).toList();
  }

  Future<void> cambiarRol(int id_usuario_emp, String rol) async {
    var response = await Utils().cambiarRol(id_usuario_emp, rol);
    if (response.isNotEmpty) {
      setState(() {});
    }
  }

  Future<void> eliminar(int id_usuario_emp) async {
    var response = await Utils().eliminarUsuarioEmpresa(id_usuario_emp);
    if (response.isNotEmpty) {
      setState(() {});
    }
  }
}
