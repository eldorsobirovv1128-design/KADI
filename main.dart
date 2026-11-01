import 'package:flutter/material.dart';

void main() {
  runApp(const KadiApp());
}

class KadiApp extends StatelessWidget {
  const KadiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kadi',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const RegisterScreen(), // Ilova birinchi Profil yaratish ekranidan boshlanadi
      debugShowCheckedModeBanner: false,
    );
  }
}

// 1. PROFIL YARATISH EKRANI
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kadi - Profil yaratish'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Kadi ilovasiga xush kelibsiz! 🐼',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Ismingiz', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Telefon raqam (+998)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone)),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Yoshingiz', border: OutlineInputBorder(), prefixIcon: Icon(Icons.cake)),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                  onPressed: () {
                    // Profil saqlangandan so'ng Swipe (Surish) ekraniga o'tish
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SwipeHomeScreen()),
                    );
                  },
                  child: const Text('Davom etish', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. SWIPE (SURISH VA LIKE) EKRANI
class UserProfile {
  final String name;
  final int age;
  final String city;
  final String imageUrl;

  UserProfile({required this.name, required this.age, required this.city, required this.imageUrl});
}

class SwipeHomeScreen extends StatefulWidget {
  const SwipeHomeScreen({super.key});

  @override
  State<SwipeHomeScreen> createState() => _SwipeHomeScreenState();
}

class _SwipeHomeScreenState extends State<SwipeHomeScreen> {
  int _currentIndex = 0;

  final List<UserProfile> _profiles = [
    UserProfile(name: 'Malika', age: 22, city: 'Urganch, Xorazm', imageUrl: 'https://picsum.photos/400/600?random=1'),
    UserProfile(name: 'Jasur', age: 25, city: 'Xiva, Xorazm', imageUrl: 'https://picsum.photos/400/600?random=2'),
  ];

  void _nextProfile(bool isLiked) {
    if (isLiked) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('🎉 Sizda yangi KADI bor!', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${_profiles[_currentIndex].name} ham sizga Like bosgan!'),
              const SizedBox(height: 15),
              const Text('Suhbatni boshlash uchun oylik obuna (10 000 so‘m) talab qilinadi.', style: TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Keyinroq')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
              onPressed: () {
                Navigator.pop(context);
                // Like bosilib, to'lov oynasiga o'tish
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatUnlockScreen()));
              },
              child: const Text('Chatni ochish (10 000 so‘m)', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    setState(() {
      if (_currentIndex < _profiles.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentProfile = _profiles[_currentIndex];
    return Scaffold(
      appBar: AppBar(title: const Text('Kadi 🐼', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.pinkAccent, centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned.fill(child: Image.network(currentProfile.imageUrl, fit: BoxFit.cover)),
                    Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [Colors.transparent, Colors.black87], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${currentProfile.name}, ${currentProfile.age}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                            Text(currentProfile.city, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.large(backgroundColor: Colors.white, onPressed: () => _nextProfile(false), child: const Icon(Icons.close, color: Colors.red, size: 36)),
                FloatingActionButton.large(backgroundColor: Colors.pinkAccent, onPressed: () => _nextProfile(true), child: const Icon(Icons.favorite, color: Colors.white, size: 36)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 3. TO'LOV VA CHAT EKRANI
class ChatUnlockScreen extends StatelessWidget {
  const ChatUnlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kadi - Obuna'), backgroundColor: Colors.pinkAccent),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 80, color: Colors.pinkAccent),
            const SizedBox(height: 20),
            const Text('Suhbatni boshlash uchun blokdan chiqaring', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            const Text('Cheksiz chat yozish uchun oylik obuna narxi atigi 10 000 so‘m!', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
                },
                child: const Text('10 000 so‘m to‘lash', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> _messages = ['Salom! Qalaysiz?', 'Salom, Xorazmdanman!'];
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Malika, 22'), backgroundColor: Colors.pinkAccent),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isMe = index % 2 != 0;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: isMe ? Colors.pinkAccent : Colors.grey.shade200, borderRadius: BorderRadius.circular(15)),
                    child: Text(_messages[index], style: TextStyle(color: isMe ? Colors.white : Colors.black87)),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _messageController, decoration: const InputDecoration(hintText: 'Xabar yozish...', border: OutlineInputBorder()))),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.pinkAccent),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      setState(() {
                        _messages.add(_messageController.text);
                        _messageController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
