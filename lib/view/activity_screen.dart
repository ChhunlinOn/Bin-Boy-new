import 'package:flutter/material.dart';
import 'package:boybin/controllers/activity_controller.dart';
import 'package:boybin/models/activity_model.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final ActivityController _activityController = ActivityController();
  late Future<List<Activity>> _activities;

  @override
  void initState() {
    super.initState();
    _activities = _activityController.fetchActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text('Activity', style: TextStyle(color: Colors.green, fontWeight: FontWeight.normal),),
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.green), // Green back arrow
    onPressed: () {
      Navigator.pop(context); // Navigate back to the previous screen
    },
  ),
),
      body: FutureBuilder<List<Activity>>(
        future: _activities,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No activities found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final activity = snapshot.data![index];
                return _buildActivityItem(
                  activity.title,
                  '${activity.estimateWeight} kg', // Display weight
                  activity.points, // Display points
                  _formatTime(activity.date), // Format time
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, String points, String time) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.green,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                points,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    final duration = DateTime.now().difference(date);
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes} minutes ago';
    } else if (duration.inHours < 24) {
      return '${duration.inHours} hours ago';
    } else {
      return '${duration.inDays} days ago';
    }
  }
}