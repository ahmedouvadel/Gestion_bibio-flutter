import 'package:flutter/material.dart';

import 'Acc_screen.dart';
import 'ecrivains_screen.dart';
import 'livres_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // En-tête du Drawer
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Explore our features!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items avec icônes
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Fermer le Drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Our Books'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LivresScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Our auteurs'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EcrivainsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Careers'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Sell With Us'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.newspaper),
              title: const Text('Newsletter'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Pop-up Leasing'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Account'),
              onTap: () {},
            ),

            // Séparateurs et bas de page
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Terms'),
                  Text('Privacy'),
                ],
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: const Center(
        child: AccScreen(),
      ),
    );
  }
}
