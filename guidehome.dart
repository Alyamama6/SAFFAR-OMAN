// file: lib/guidehome.dart
import 'package:flutter/material.dart';

class GuideHomeScreen extends StatelessWidget {
  const GuideHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6B4F3A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان + صورة الجايد
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hello, Ahmed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('images/man.png'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'Upcoming Tours',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              _tourCard(
                image: 'images/matrah.jpeg',
                title: 'Wahiba Sands',
                day: 'Today',
                time: '10:00 AM',
              ),
              const SizedBox(height: 12),
              _tourCard(
                image: 'images/jebel.jpeg',
                title: 'Jebel Akhdar',
                day: 'Tomorrow',
                time: '5:40 AM',
              ),

              const SizedBox(height: 24),
              const Text(
                'Pending Requests',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView(
                  children: [
                    _requestItem(
                      name: 'John Smith',
                      place: 'Wadi Shab',
                      time: 'Tomorrow 5:00PM',
                      avatar: 'images/man (1).png',
                    ),
                    _requestItem(
                      name: 'Mohammed Al-Abdullah',
                      place: 'Nizwa Fort',
                      time: '20.DEC.2025 8:00AM',
                      avatar: 'images/man (2).png',
                    ),
                    _requestItem(
                      name: 'Sara Ahmed',
                      place: 'Muscat',
                      time: '22.DEC.2025 4:30PM',
                      avatar: 'images/man (3).png',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tourCard({
    required String image,
    required String title,
    required String day,
    required String time,
  }) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFBFA892),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              bottomLeft: Radius.circular(18),
            ),
            child: Image.asset(
              image,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(day,
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black87)),
                  Text(time,
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black54)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _requestItem({
    required String name,
    required String place,
    required String time,
    required String avatar,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFBFA892),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage(avatar),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                Text(place),
                Text(time, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Column(
            children: [
              _statusButton('YES', Colors.green),
              const SizedBox(height: 6),
              _statusButton('NO', Colors.red),
            ],
          ),
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
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
