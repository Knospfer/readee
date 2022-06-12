import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:readee/_core/navigation.gr.dart';
import 'package:readee/screens/filter_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Readee")),
      body: ListView.builder(
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => context.router.push(const DetailScreenRoute()),
          child: ListTile(title: Text("Book n. $index")),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showFilterModal(context),
        child: const Icon(Icons.search),
      ),
    );
  }
}
