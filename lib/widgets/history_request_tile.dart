import 'package:flutter/material.dart';
import '../common/colors.dart';
import '../data/blood_request.dart';
import '../screens/single_request_screen.dart';
import '../utils/tools.dart';

const kBorderRadius = 12.0;

class HistoryRequestTile extends StatelessWidget {
  final BloodRequest request;

  const HistoryRequestTile({Key? key, required this.request}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(kBorderRadius),
                topRight: Radius.circular(kBorderRadius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Fulfilled',
                  style: textTheme.labelMedium?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Patient Name', style: textTheme.bodySmall),
                      Text(request.patientName ?? ''),
                      const SizedBox(height: 12),
                      Text('Location', style: textTheme.bodySmall),
                      Text(
                        '${request.medicalCenter.name} - ${request.medicalCenter.location}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Requested On', style: textTheme.bodySmall),
                    Text(Tools.formatDate(request.submittedAt) ?? ''),
                    Text('Blood Type', style: textTheme.bodySmall),
                    Text(request.bloodType.name),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => SingleRequestScreen(request: request),
              ));
            },
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(kBorderRadius),
              bottomLeft: Radius.circular(kBorderRadius),
            ),
            child: Ink(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: MainColors.primary,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(kBorderRadius),
                  bottomLeft: Radius.circular(kBorderRadius),
                ),
              ),
              child: Center(
                child: Text(
                  'View Details',
                  style: textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}