import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:playboy/pages/file/file_explorer.dart';

class FolderCard extends StatelessWidget {
  const FolderCard({super.key, required this.source, required this.icon});
  final String source;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    String name = basename(source);
    late final colorScheme = Theme.of(context).colorScheme;
    return Card(
      // surfaceTintColor: Colors.transparent,
      elevation: 1.6,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FileExplorer(path: source)));
        },
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Ink(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: colorScheme.tertiaryContainer,
                ),
                child: Icon(
                  icon ?? Icons.folder,
                  color: colorScheme.onTertiaryContainer,
                  size: 60,
                ),
              ),
            ),
            Expanded(
              child: Center(
                  child: Text(
                name,
                style: const TextStyle(
                  fontSize: 12,
                ),
              )),
            )
          ],
        ),
      ),
    );
  }
}
