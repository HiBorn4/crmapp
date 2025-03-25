import 'package:flutter/material.dart';
import '../models/project_model.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.grey[100],
      width: screenWidth * 0.45, // Each card takes about half of the screen width
      height: screenHeight * 0.55, // Increased height for better spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image with increased height
          Container(
            width: screenWidth * 0.45,
            height: screenHeight * 0.3, // Increased height for better visibility
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Image.asset(
              project.image,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(height: screenHeight * 0.008), // Space between image and text

          // Use Expanded to prevent overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project Name
                Text(
                  project.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: screenHeight * 0.004),

                // Location with Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: Colors.grey, size: screenWidth * 0.04),
                    SizedBox(width: screenWidth * 0.005),
                    Text(
                      project.location,
                      style: TextStyle(color: Colors.grey, fontSize: screenWidth * 0.035),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.008),

                // Price inside a button with black border
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.008, horizontal: screenWidth * 0.03),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black), // Black border
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "₹${project.price}", // Extracting price amount
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045, // Larger font for price amount
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          Text(
                            // project.price.split(" ")[1], // Extracting "onwards"
                            " Onwards",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.03, // Smaller font for "onwards"
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
