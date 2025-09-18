import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommentApp extends StatefulWidget {
  const CommentApp({super.key});

  @override
  State<CommentApp> createState() => _CommentAppState();
}

class _CommentAppState extends State<CommentApp> {
  List<Map<String, dynamic>> comments = [];
  bool isShowingList = false;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchComments() async {
    if (comments.isNotEmpty) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/comments'),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          comments = decoded
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList(growable: false);
        } else {
          throw const FormatException('Expected a list from API');
        }
      } else {
        errorMessage = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage = 'Failed to load comments: $e';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleComments() async {
    if (!isShowingList && comments.isEmpty) {
      await fetchComments();
    }
    setState(() {
      isShowingList = !isShowingList;
    });
  }

  void showFullComment(Map<String, dynamic> comment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(comment['name']?.toString() ?? 'No Title'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('ID', comment['id']?.toString() ?? 'N/A'),
                _buildDetailRow(
                  'Post ID',
                  comment['postId']?.toString() ?? 'N/A',
                ),
                _buildDetailRow('Name', comment['name']?.toString() ?? 'N/A'),
                _buildDetailRow('Email', comment['email']?.toString() ?? 'N/A'),
                _buildDetailRow(
                  'Body',
                  (comment['body']?.toString() ?? 'N/A').isEmpty
                      ? 'No content'
                      : comment['body']?.toString() ?? 'N/A',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme
                .of(context)
                .textTheme
                .labelLarge
                ?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(value, style: Theme
                .of(context)
                .textTheme
                .bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    if (!isShowingList) {
      return const Center(child: Text('Press the button to show comments'));
    }

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchComments,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (comments.isEmpty) {
      return const Center(child: Text('No comments available'));
    }

    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        final id = comment['id']?.toString() ?? '';
        final name = comment['name']?.toString() ?? 'No Title';

        return ListTile(
          leading: CircleAvatar(child: Text(id)),
          title: Text('ID: $id, Name: $name'),
          onTap: () => showFullComment(comment),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comment App'), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleComments,
        child: Icon(isShowingList ? Icons.close : Icons.list),
      ),
      body: buildBody(),
    );
  }
}
