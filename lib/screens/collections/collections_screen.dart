import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_gradient.dart';
import 'collection_details_screen.dart';
import 'collections_controller.dart';
import 'create_collection_sheet.dart';

class CollectionsScreen extends ConsumerStatefulWidget {
  const CollectionsScreen({super.key});

  @override
  ConsumerState<CollectionsScreen> createState() =>
      _CollectionsScreenState();
}

class _CollectionsScreenState extends ConsumerState<CollectionsScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final collectionsAsync =
    ref.watch(collectionsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collections'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showCreateCollectionSheet(context, ref),
          ),
        ],
      ),
      body: collectionsAsync.when(
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('Error: $e')),
        data: (collections) {
          final filtered = collections.where((c) {
            return c.name
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
          }).toList();

          return Column(
            children: [
              // Search
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search collections...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onChanged: (v) =>
                      setState(() => searchQuery = v),
                ),
              ),

              // Header Card
              Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filtered.length}\nCollections Created',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const Icon(Icons.folder,
                        color: Colors.white, size: 32),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                  child: Text('No collections found'),
                )
                    : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.5,
                  ),
                  itemBuilder: (_, i) {
                    final c = filtered[i];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CollectionDetailsScreen(
                                  collection: c,
                                ),
                          ),
                        );
                      },
                      child:
                      _CollectionCard(collection: c),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final Collection collection;
  const _CollectionCard({required this.collection});

  @override
  Widget build(BuildContext context) {

    final bgColor = Color(
      int.parse(collection.color.replaceFirst('#', '0xff')),
    );

    return Container(
      padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: bgColor.withOpacity(0.15),
    borderRadius: BorderRadius.circular(20),
    ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Icon(Icons.folder, size: 36, color: bgColor,),
          const SizedBox(height: 12),
          Text(
            collection.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap to view quotes',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
