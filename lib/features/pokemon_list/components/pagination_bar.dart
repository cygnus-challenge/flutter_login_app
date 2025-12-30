import 'package:auth_app/core/theme/app_pallet.dart';
import 'package:flutter/material.dart';

class PaginationBar extends StatelessWidget {
  final int totalPages;
  final int currentPage;
  final Function(int) onPageSelected;

  const PaginationBar({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    // 1. CACULATE VISIBLE PAGES
    List<int> visiblePages = [];
    
    if (totalPages <= 3) {
      visiblePages = List.generate(totalPages, (index) => index + 1);
    } else {
      int start = currentPage - 1;
      
      if (start < 1) start = 1;
      
      if (start + 2 > totalPages) {
        start = totalPages - 2;
      }
      
      visiblePages = [start, start + 1, start + 2];
    }

    return Container(
      height: 50,
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          // 2. PREVIOUS BUTTON (<)
          if (currentPage > 1)
            IconButton(
              icon: const Icon(Icons.chevron_left),
              padding: EdgeInsets.zero,
              onPressed: () => onPageSelected(currentPage - 1),
            ),

          // 3. LIST NUMBER PAGE
          ...visiblePages.map((page) {
            final isActive = page == currentPage;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: SizedBox(
                width: 40,
                height: 40,
                child: isActive
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPallet.greyColor,
                          foregroundColor: AppPallet.homeCorlor,
                          shape: const CircleBorder(),
                          padding: EdgeInsets.zero, 
                          elevation: 2,
                        ),
                        onPressed: () {}, 
                        child: Text("$page", style: const TextStyle(fontWeight: FontWeight.bold)),
                      )
                    : TextButton(
                        style: TextButton.styleFrom(
                          shape: const CircleBorder(),
                          foregroundColor: AppPallet.homeCorlor,
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () => onPageSelected(page),
                        child: Text("$page"),
                      ),
              ),
            );
          }),

          // 4. NEXT BUTTON (>)
          if (currentPage < totalPages)
            IconButton(
              icon: const Icon(Icons.chevron_right),
              padding: EdgeInsets.zero,
              onPressed: () => onPageSelected(currentPage + 1),
            ),
        ],
      ),
    );
  }
}