import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../data/services/gym_feedback_service.dart';

class AddGymFeedbackPage extends StatefulWidget {
  final String gymId;

  const AddGymFeedbackPage({Key? key, required this.gymId}) : super(key: key);

  @override
  State<AddGymFeedbackPage> createState() => _AddGymFeedbackPageState();
}

class _AddGymFeedbackPageState extends State<AddGymFeedbackPage> {
  final _titleController = TextEditingController();
  final _reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _rating = 0;
  bool _isLoading = false;

  final GymFeedbackService _feedbackService = GymFeedbackService();

  @override
  void dispose() {
    _titleController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate() && _rating > 0) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _feedbackService.createFeedback(
          rating: _rating,
          title: _titleController.text.trim(),
          review: _reviewController.text.trim(),
          gymId: widget.gymId,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Відгук опубліковано', style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).primaryColor,
              margin: const EdgeInsets.all(16),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Помилка публікації, спробуйте ще раз', style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor)),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else if (_rating == 0 || _titleController.text.isEmpty ||  _reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Заповніть усі поля', style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor)),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Додати відгук',
            style: Theme.of(context).textTheme.displayMedium,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Icon(
              CupertinoIcons.back,
              color: Theme.of(context).hintColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ваша оцінка',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RatingBar(
                    rating: _rating,
                    onRatingSelected: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Заголовок',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                ),
                validator: (value) {
                  if (value != null && value.length > 100) {
                    return 'Заголовок має бути не більше 100 символів';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _reviewController,
                decoration: InputDecoration(
                  labelText: 'Ваш відгук',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value != null && value.length > 1000) {
                    return 'Відгук має бути не більше 1000 символів';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Додати відгук',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RatingBar extends StatelessWidget {
  final int rating;
  final Function(int) onRatingSelected;

  const RatingBar({
    Key? key,
    required this.rating,
    required this.onRatingSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
            (index) => GestureDetector(
          onTap: () => onRatingSelected(index + 1),
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              index < rating ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 48,
            ),
          ),
        ),
      ),
    );
  }
}