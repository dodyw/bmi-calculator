import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bmi_provider.dart';
import '../widgets/bmi_history_chart.dart';
import '../utils/app_theme.dart';
import 'package:intl/intl.dart';
import '../models/bmi_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bmiProvider = Provider.of<BMIProvider>(context);
    final bmiHistory = bmiProvider.bmiHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI History'),
        actions: [
          if (bmiHistory.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => _showClearHistoryDialog(context),
              tooltip: 'Clear History',
            ),
        ],
      ),
      body:
          bmiHistory.isEmpty
              ? _buildEmptyState(context)
              : _buildHistoryContent(context, bmiHistory),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: AppTheme.primaryColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No BMI History',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Calculate your BMI to start tracking your progress',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryContent(BuildContext context, List<BMIModel> bmiHistory) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'Your BMI Progress',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Expanded(
          child: ListView(
            children: [
              BMIHistoryChart(bmiHistory: bmiHistory),
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'History Records',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bmiHistory.length,
                itemBuilder: (context, index) {
                  // Reverse the list to show newest first
                  final bmi = bmiHistory[bmiHistory.length - 1 - index];
                  return _buildHistoryItem(context, bmi);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(BuildContext context, BMIModel bmi) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final formattedDate = dateFormat.format(bmi.date);

    return Dismissible(
      key: Key(bmi.date.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<BMIProvider>(context, listen: false).deleteBMIRecord(bmi);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Record deleted')));
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: bmi.categoryColor.withOpacity(0.2),
          child: Text(
            bmi.bmiValue.toStringAsFixed(1),
            style: TextStyle(
              color: bmi.categoryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(bmi.categoryName),
        subtitle: Text(formattedDate),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'H: ${bmi.height.toStringAsFixed(1)} cm',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'W: ${bmi.weight.toStringAsFixed(1)} kg',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () {
          // Show detailed view of this record
          _showBMIDetails(context, bmi);
        },
      ),
    );
  }

  void _showBMIDetails(BuildContext context, BMIModel bmi) {
    final dateFormat = DateFormat('MMMM dd, yyyy');
    final formattedDate = dateFormat.format(bmi.date);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'BMI Details',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              _buildDetailRow(
                context,
                'BMI Value',
                bmi.bmiValue.toStringAsFixed(1),
              ),
              _buildDetailRow(context, 'Category', bmi.categoryName),
              _buildDetailRow(
                context,
                'Height',
                '${bmi.height.toStringAsFixed(1)} cm',
              ),
              _buildDetailRow(
                context,
                'Weight',
                '${bmi.weight.toStringAsFixed(1)} kg',
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Health Recommendation:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                bmi.healthRecommendation,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear History'),
            content: const Text(
              'Are you sure you want to clear all your BMI history? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<BMIProvider>(
                    context,
                    listen: false,
                  ).clearHistory();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('History cleared')),
                  );
                },
                child: const Text('CLEAR'),
              ),
            ],
          ),
    );
  }
}
