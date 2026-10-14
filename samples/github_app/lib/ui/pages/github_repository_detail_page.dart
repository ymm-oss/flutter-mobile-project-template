import 'package:flutter/material.dart';

class GitHubRepositoryDetailPage extends StatelessWidget {
  const GitHubRepositoryDetailPage({
    required this._repositoryName,
    required this._description,
    super.key,
  });

  final String _repositoryName;
  final String? _description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_repositoryName)),
      body: Text(_description ?? 'No Description'),
    );
  }
}
