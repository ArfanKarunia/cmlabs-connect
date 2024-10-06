import 'package:flutter/material.dart';
import 'package:quotation_app/src/utils/color.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(25),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.black38),
              ),
              SizedBox(
                height: 20,
              ),

              // INPUT NAME
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Name",
                  style: TextStyle(fontSize: 16, color: AppColors.primaryText),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),

              SizedBox(
                height: 10,
              ),

              // INPUT Date Birth
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Date Birth",
                  style: TextStyle(fontSize: 16, color: AppColors.primaryText),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),

              SizedBox(
                height: 10,
              ),

              // INPUT Gender
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Gender",
                  style: TextStyle(fontSize: 16, color: AppColors.primaryText),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),

              SizedBox(
                height: 10,
              ),

              // INPUT City
              SizedBox(
                width: double.infinity,
                child: Text(
                  "City",
                  style: TextStyle(fontSize: 16, color: AppColors.primaryText),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),

              SizedBox(
                height: 10,
              ),

              // INPUT PHONE NUMBER
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Phone Number",
                  style: TextStyle(fontSize: 16, color: AppColors.primaryText),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
