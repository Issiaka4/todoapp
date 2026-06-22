import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/auth_service.dart';
import '../data/task_repository.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _taskController = TextEditingController();

  void _handleAddTask() async {
    final text = _taskController.text.trim();
    if (text.isEmpty) return;
    _taskController.clear();

    try {
      await taskRepository.addTask(text, widget.user.uid);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Tâches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authService.signOut(),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(hintText: 'Nouvelle tâche...'),
                    onSubmitted: (_) => _handleAddTask(),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: _handleAddTask)
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: taskRepository.getTasksStream(widget.user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Aucune tâche.'));
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final bool isCompleted = data['isCompleted'] ?? false;

                    return ListTile(
                      title: Text(
                        data['title'] ?? '',
                        style: TextStyle(
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      leading: Checkbox(
                        value: isCompleted,
                        onChanged: (_) => taskRepository.toggleTaskStatus(doc.id, isCompleted),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => taskRepository.deleteTask(doc.id),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}