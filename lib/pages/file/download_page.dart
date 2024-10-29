import 'package:flutter/material.dart';
import 'package:playboy/l10n/i10n.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  DownloadPageState createState() => DownloadPageState();
}

class DownloadPageState extends State<DownloadPage> {
  int choosed = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(context.l10n.download_manager),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
          const SizedBox(
            width: 6,
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const SizedBox(
                  width: 16,
                ),
                FilterChip(
                  showCheckmark: false,
                  avatar: const Icon(Icons.download_outlined),
                  label: Text(context.l10n.downloading),
                  onSelected: (value) {
                    setState(() {
                      choosed = 0;
                    });
                  },
                  selected: choosed == 0,
                ),
                const SizedBox(
                  width: 6,
                ),
                FilterChip(
                  showCheckmark: false,
                  avatar: const Icon(Icons.download_done),
                  label: Text(context.l10n.completed),
                  onSelected: (value) {
                    setState(() {
                      choosed = 1;
                    });
                  },
                  selected: choosed == 1,
                ),
                const SizedBox(
                  width: 6,
                ),
                FilterChip(
                  showCheckmark: false,
                  avatar: const Icon(Icons.error_outline),
                  label: Text(context.l10n.download_failed),
                  onSelected: (value) {
                    setState(() {
                      choosed = 2;
                    });
                  },
                  selected: choosed == 2,
                ),
                const SizedBox(
                  width: 6,
                ),
                FilterChip(
                  showCheckmark: false,
                  avatar: const Icon(Icons.task_alt),
                  label: Text(context.l10n.all_tasks),
                  onSelected: (value) {
                    setState(() {
                      choosed = 3;
                    });
                  },
                  selected: choosed == 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
