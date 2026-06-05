import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoamlyTestApp extends StatefulWidget {
  const RoamlyTestApp({super.key});

  @override
  State<RoamlyTestApp> createState() => _RoamlyTestAppState();
}

class _RoamlyTestAppState extends State<RoamlyTestApp> {
  final SupabaseClient supabase = Supabase.instance.client;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String message = 'Not connected yet.';
  List<Map<String, dynamic>> places = [];

  Future<void> signUp() async {
    try {
      await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      setState(() {
        message = 'Signup success. Try loading places.';
      });
    } catch (error) {
      setState(() {
        message = 'Signup error: $error';
      });
    }
  }

  Future<void> signIn() async {
    try {
      await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      setState(() {
        message = 'Login success. Now loading places...';
      });

      await loadPlaces();
    } catch (error) {
      setState(() {
        message = 'Login error: $error';
      });
    }
  }

  Future<void> loadPlaces() async {
    try {
      final response = await supabase
          .from('places')
          .select(
            'id, name, description, latitude, longitude, unlock_radius_meters',
          )
          .eq('status', 'approved')
          .order('name');

      setState(() {
        places = List<Map<String, dynamic>>.from(response);
        message = 'Loaded ${places.length} places from Supabase.';
      });
    } catch (error) {
      setState(() {
        message = 'Load places error: $error';
      });
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();

    setState(() {
      places = [];
      message = 'Logged out.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roamly Test',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Roamly Supabase Test'),
          actions: [
            IconButton(onPressed: signOut, icon: const Icon(Icons.logout)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: signUp,
                      child: const Text('Register'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: signIn,
                      child: const Text('Login + Load'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(message),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    final place = places[index];

                    return ListTile(
                      leading: const Icon(Icons.place),
                      title: Text(place['name'] ?? 'Unnamed place'),
                      subtitle: Text(
                        'Lat: ${place['latitude']} | Lng: ${place['longitude']}',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
