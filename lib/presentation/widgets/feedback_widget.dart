import 'package:fittrack/data/models/gym_feedback_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/config/secure_storage_keys.dart';
import '../dialogs/confirmation_dialog.dart';
import '../screens/features/gym_info/bloc/gym_info_event.dart';
import '../screens/features/gym_info/bloc/gym_info_bloc.dart';
import '../screens/features/add_feedback_for_gym/add_feedback_screen.dart';
import 'dart:ui' as ui; // Import the ui package

class FeedbackWidget extends StatelessWidget {
  final List<GymFeedbackModel> feedbacks;
  final String gymId;

  const FeedbackWidget({required this.feedbacks, required this.gymId, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Відгуки',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).brightness == Brightness.light
                        ? const Color(0xFF8C8C8C)
                        : Theme.of(context).hintColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddGymFeedbackPage(gymId: gymId)))
                        .then((_) {
                      context
                          .read<GymInfoBloc>()
                          .add(GetGymById(gymId: gymId));
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        "assets/icons/add_icon.svg",
                        width: 12,
                        height: 12,
                      ),
                    ),
                  ),
                )
              ]),
        ),
        (feedbacks.isEmpty)
            ? Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Text(
                'Залиште відгук першим',
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).hintColor),
              ),
            ),
          ),
        )
            : Divider(
          color: Theme.of(context).hintColor,
        ),
        ...feedbacks
            .map((feedback) => _buildFeedbackItem(context, feedback))
            ,
      ],
    );
  }

  Widget _buildFeedbackItem(BuildContext context, GymFeedbackModel feedback) {
    return FutureBuilder<String?>(
      future: _getCurrentUserId(),
      builder: (context, snapshot) {
        final currentUserId = snapshot.data;
        final isOwner = currentUserId == feedback.userId;

        return Card(
          color: Theme.of(context).cardColor,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        feedback.title!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (isOwner)
                      GestureDetector(
                        onTap: () {
                          _showDeleteConfirmation(context, feedback.id);
                        },
                        child: Icon(
                          Icons.delete,
                          size: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                ExpandableText(text: feedback.review!),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '— ${feedback.userEmail}',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> _getCurrentUserId() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: SecureStorageKeys.userId);
  }

  void _showDeleteConfirmation(BuildContext context, String feedbackId) {
    final confirmationDialog = ConfirmationDialog();
    confirmationDialog
        .showConfirmationDialog(
        context,
        "Видалити відгук",
        "Ви впевнені, що хочете видалити цей відгук?"
    ).then((confirmed) {
      if (confirmed) {
        _deleteFeedback(context, feedbackId);
      }
    });

  }

  void _deleteFeedback(BuildContext context, String feedbackId) {
    context.read<GymInfoBloc>().add(DeleteFeedback(feedbackId: feedbackId));
    context.read<GymInfoBloc>().add(GetGymById(gymId: gymId));
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableText({
    required this.text,
    this.maxLines = 4,
    super.key,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: _expanded ? null : widget.maxLines,
          overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        if (_isTextLong())
          GestureDetector(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                _expanded ? 'Згорнути' : 'Більше...',
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool _isTextLong() {
    final textSpan = TextSpan(text: widget.text);
    final textPainter = TextPainter(
      text: textSpan,
      maxLines: widget.maxLines,
      textDirection: ui.TextDirection.ltr, // Correctly reference TextDirection from ui package
    );

    textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 64);

    return textPainter.didExceedMaxLines;
  }}