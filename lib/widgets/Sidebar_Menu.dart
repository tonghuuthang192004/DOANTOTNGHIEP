import 'package:flutter/material.dart';
import 'dart:math';

import '../pages/home/HomeCreen.dart';

class SidebarMenu extends StatefulWidget {
  const SidebarMenu({super.key});

  @override
  State<SidebarMenu> createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  double value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Sidebar
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 0, 0),
                  Color.fromARGB(255, 64, 64, 64),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: SafeArea(
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const DrawerHeader(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50.0,
                            backgroundImage:
                            AssetImage("images/profile.jpg"),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "Hữu Thắng",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: const [
                          ListTile(
                            leading: Icon(Icons.home, color: Colors.white),
                            title: Text('Home',
                                style: TextStyle(color: Colors.white)),
                          ),
                          ListTile(
                            leading: Icon(Icons.person, color: Colors.white),
                            title: Text('Profile',
                                style: TextStyle(color: Colors.white)),
                          ),
                          ListTile(
                            leading: Icon(Icons.settings, color: Colors.white),
                            title: Text('Settings',
                                style: TextStyle(color: Colors.white)),
                          ),
                          ListTile(
                            leading: Icon(Icons.help, color: Colors.white),
                            title: Text('Help',
                                style: TextStyle(color: Colors.white)),
                          ),
                          ListTile(
                            leading: Icon(Icons.logout, color: Colors.white),
                            title: Text('Logout',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Main Screen with 3D animation
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: value),
            duration: const Duration(milliseconds: 400),
            builder: (_, double val, __) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(val * 200)
                  ..rotateY(val * -0.3),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      value == 0 ? value = 1 : value = 0;
                    });
                  },
                  child: AbsorbPointer(
                    absorbing: value == 1,
                    child:HomeCreen() ,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
