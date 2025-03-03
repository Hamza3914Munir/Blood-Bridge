import 'package:flutter/material.dart';
import '../data/lists/blood_banks.dart';
import '../data/lists/hospitals.dart';
import '../data/medical_center.dart';

class MedicalCenterPicker extends StatefulWidget {
  const MedicalCenterPicker({Key? key}) : super(key: key);

  @override
  _MedicalCenterPickerState createState() => _MedicalCenterPickerState();
}

class _MedicalCenterPickerState extends State<MedicalCenterPicker> {
  final _searchController = TextEditingController();
  MedicalCenterCategory _category = MedicalCenterCategory.hospitals;
  late List<MedicalCenter> _centers;

  @override
  void initState() {
    super.initState();
    _centers = hospitals.map((h) => MedicalCenter(
      name: h['name'] as String,
      location: h['location'] as String,
    )).toList();
  }

  void _updateCenters(MedicalCenterCategory category) {
    final data = category == MedicalCenterCategory.hospitals ? hospitals : bloodBanks;
    _centers = data.map((c) => MedicalCenter(
      name: c['name'] as String,
      location: c['location'] as String,
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final filtered = _centers
        .where((c) =>
    c.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
        c.location.toLowerCase().contains(_searchController.text.toLowerCase()))
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search',
                        isDense: true,
                      ),
                      onChanged: (val) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<MedicalCenterCategory>(
                      value: _category,
                      items: MedicalCenterCategory.values
                          .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c.name),
                      ))
                          .toList(),
                      onChanged: (cat) {
                        if (cat == null || cat == _category) return;
                        _updateCenters(cat);
                        setState(() => _category = cat);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: filtered.length,
                itemBuilder: (context, i) => ListTile(
                  dense: true,
                  title: Text(
                    filtered[i].name,
                    style: textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    filtered[i].location,
                    style: textTheme.bodyMedium
                        ?.copyWith(color: textTheme.bodySmall?.color),
                  ),
                  onTap: () {
                    Navigator.pop(context, filtered[i]);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

enum MedicalCenterCategory { hospitals, bloodBanks }

extension on MedicalCenterCategory {
  String get name {
    switch (this) {
      case MedicalCenterCategory.hospitals:
        return 'Hospitals';
      case MedicalCenterCategory.bloodBanks:
        return 'Blood Banks';
    }
  }
}
