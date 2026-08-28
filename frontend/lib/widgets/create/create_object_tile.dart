import 'package:flutter/material.dart';
import 'package:frontend/widgets/create/create_object_sheet.dart';

class CreateObjectTile extends StatelessWidget {
  const CreateObjectTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("+"),
      subtitle: const Text("Yeni Cisim Oluştur"),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => const CreateObjectSheet(location: null),
        );
      },
    );
  }
}
