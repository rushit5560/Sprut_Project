import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';

class MyCustomDialog extends StatelessWidget {
  final String message;
  MyCustomDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: textTheme.bodyText2!.copyWith(
                    fontSize: 11.sp, color: colorScheme.secondaryContainer),
              ),
              
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                  
                    onPressed: () {
                    
                       Navigator.of(context).pop();
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(
                        color: AppThemes.dark,
                      ),
                    ),
                    style: ButtonStyle(
                      
                      minimumSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width, 6.h)),
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(
                              color: AppThemes.darkGrey.withOpacity(0.3)),
                        ),
                      ),
                    ),
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
