import 'package:flutter/material.dart';
import 'package:project_skillcrow/reusable_widgets/reusable_widget.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/Freelancer_Widgets/JobCard.dart';
import 'package:project_skillcrow/screens/FreelancerScreens/freelancer_jobs_apply.dart';
import 'package:project_skillcrow/server.dart';
import 'package:project_skillcrow/user_fetch.dart';

class CategoryButtons extends StatefulWidget {
  final VoidCallback? refreshCallback;

  CategoryButtons({Key? key, this.refreshCallback}) : super(key: key);

  @override
  State<CategoryButtons> createState() => _CategoryButtonsState();
}

class _CategoryButtonsState extends State<CategoryButtons> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(
          Server.JobCategoriesList!.length,
          (index) {
            return Container(
              margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: TextButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(0, 255, 132, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () async {
                  String selectedCat =
                      Server.JobCategoriesList![index]['CategoryName'];
                  CrudFunction.searchJobsByCategory(selectedCat);
                  setState(
                    () {
                      // Call the callback to trigger the update of JobCardView
                      if (widget.refreshCallback != null) {
                        print('Here');
                        widget.refreshCallback!();
                      }
                    },
                  );
                },
                child: Text(
                  Server.JobCategoriesList![index]['CategoryName'],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
