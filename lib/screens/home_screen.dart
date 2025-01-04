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
        title: const Text('Gestion de Bibliothèque'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // En-tête du Drawer avec courbe
            SizedBox(
              height: 160,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: DrawerHeaderClipper(),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Terms'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Privacy'),
                  ),
                ],
              ),
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

// ClipPath personnalisé pour la courbe
class DrawerHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
