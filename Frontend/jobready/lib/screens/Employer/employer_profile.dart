import 'package:flutter/material.dart';

class EmployerProfilePage extends StatefulWidget {
  const EmployerProfilePage({super.key});

  @override
  State<EmployerProfilePage> createState() => _EmployerProfilePageState();
}

class _EmployerProfilePageState extends State<EmployerProfilePage> {
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile"), backgroundColor: const Color(0xFFFF8C00)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const CircleAvatar(radius: 50, child: Icon(Icons.business, size: 50)),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: "Satsangi Tours and Travels",
                decoration: const InputDecoration(labelText: "Company Name", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              TextFormField(
                initialValue: "Rajkot, Gujarat",
                decoration: const InputDecoration(labelText: "Location", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8C00)),
                  child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}