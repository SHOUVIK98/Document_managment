import 'package:document_management_main/data/file_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:document_management_main/widgets/folder_screen_widget.dart';

import '../files_viewer/image_viewer_page.dart';
import '../files_viewer/pdf_viewer_page.dart';
import '../files_viewer/text_viewer_page.dart';

class GridLayout extends StatelessWidget {
  final List<FileItem> items;

  const GridLayout({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildGridLayout(item, context);
      },
    );
  }

  Widget _buildGridLayout(dynamic item, BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Item tapped: ${item.name}");
        //OpenFile.open(item.filePath);
        if(item.isFolder){
          Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => FolderScreenWidget(fileItems: item.children?? [], folderName: item.name,),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0); // Start from the right
                  const end = Offset.zero; // End at the original position
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(position: offsetAnimation, child: child);
                },
              )
          );
        }else if (item.filePath.endsWith(".pdf")) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PdfViewerPage(filePath: item.filePath)),
          );
        } else if (item.filePath.endsWith(".txt")) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TextFileViewerPage(filePath: item.filePath)),
          );
        } else if (item.filePath.endsWith(".png") || item.filePath.endsWith(".jpg")) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ImageViewerPage(imagePath: item.filePath)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Unsupported file type")),
          );
        }

      },
      onDoubleTap: () {
        // Handle item double tap
        print("Item double tapped: ${item.name}");
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: item.isFolder ? Colors.blue.shade50 : Colors.grey.shade200,
        ),
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: double.infinity,
                ),
                SvgPicture.asset(
                  item.icon,
                  height: 90.0,
                  width: 90.0,
                ),
                const SizedBox(height: 15.0),
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            if (item.isStarred)
              const Positioned(
                bottom: 0.0,
                right: 8.0,
                child: Icon(
                  Icons.star,
                  color: Color.fromARGB(255, 3, 52, 92),
                  size: 18.0,
                ),
              ),
            Positioned(
              top: 0.0,
              right: 0.0,
              left: 125,
              child: IconButton(
                icon: const Icon(Icons.more_vert,size: 24.0,),
                onPressed: () {
                  // Handle three dots button press
                  print("Three dots button pressed for item: ${item.name}");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
