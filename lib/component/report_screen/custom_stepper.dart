import 'package:flutter/material.dart';

class CustomStepper extends StatelessWidget {
  final List<String> steps;
  final int currentStep;
  final ValueChanged<int>? onStepTapped;
  

  const CustomStepper(
      {super.key,
      required this.steps,
      required this.currentStep,
      this.onStepTapped,
      });

  @override
  Widget build(BuildContext context) {
    return 
       Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List<Widget>.generate(steps.length, (int index) {
            final bool isCurrentStep = index == currentStep;
            final bool isCompleted = index < currentStep;

            final Color circleColor = isCompleted || isCurrentStep
                ? const Color(0xFF2196F3)
                : Colors.grey.shade200;
            final Color circleNumberTextColor =
                isCompleted || isCurrentStep ? Colors.white : Colors.black;
            final Color borderColor = isCompleted || isCurrentStep
                ? const Color(0xFF2196F3)
                : Colors.grey.shade300;
            final Color lineColor =
                isCompleted ? const Color(0xFF2196F3) : Colors.grey.shade400;
            final Color stepNameTextColor = isCompleted || isCurrentStep
                ? const Color(0xFF2196F3)
                : Colors.black;

            return Expanded(
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      onStepTapped?.call(index);
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: circleColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: borderColor, width: 1.0),
                          ),
                          alignment: Alignment.center,
                          child: isCompleted
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                )
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: circleNumberTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 60,
                          child: Text(
                            steps[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: stepNameTextColor,
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index < steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: lineColor,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    
    
  }
}
