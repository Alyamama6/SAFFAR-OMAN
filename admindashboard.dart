import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      print("Logout error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6B4F3A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF6B4F3A),
        elevation: 0,
        automaticallyImplyLeading: false,


        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Logout",
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Saffar Oman",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 30),

                const Text("Admin Tools",
                    style: TextStyle(fontSize: 18, color: Colors.white)),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _adminBox(
                      title: "Manage Users",
                      subtitle: "Add, Update, Delete",
                      icon: Icons.group,
                      onTap: () {
                        Navigator.pushNamed(context, "/adminManageUsers");
                      },
                    ),
                    _adminBox(
                      title: "Manage Sites",
                      subtitle: "Add, Update, Delete",
                      icon: Icons.location_on,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _adminBox(
                      title: "Manage Reviews",
                      subtitle: "View & respond",
                      icon: Icons.reviews,
                      onTap: () {},
                    ),
                    _adminBox(
                      title: "Send Notifications",
                      subtitle: "Push alerts",
                      icon: Icons.notifications,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _adminBox(
                      title: "Approve Guides",
                      subtitle: "Review Applications",
                      icon: Icons.verified_user,
                      onTap: () {},
                    ),
                    _adminBox(
                      title: "Track Guides",
                      subtitle: "Live Locations",
                      icon: Icons.map,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                const Text(
                  "Pending Guides Approvals",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),

                const SizedBox(height: 20),

                _pendingGuide("Ammar Al-Hashmi", "22.DEC.2025"),
                _pendingGuide("Shahad Al-Qasmi", "20.DEC.2025"),
                _pendingGuide("Nasser Al-Busaidi", "18.DEC.2025"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _adminBox({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 130,
        decoration: BoxDecoration(
          color: const Color(0xFFBFA892),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 35, color: Colors.black87),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _pendingGuide(String name, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFBFA892),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage("assets/images/man.png"),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("Applied $date"),
              ],
            ),
          ),
          Column(
            children: [
              _statusButton("YES", Colors.green),
              const SizedBox(height: 5),
              _statusButton("NO", Colors.red),
            ],
          )
        ],
      ),
    );
  }

  Widget _statusButton(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
