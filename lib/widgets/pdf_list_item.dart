import 'dart:io';
import 'package:flutter/material.dart';
import 'package:keepitup/utils/Appcolors.dart';
import 'package:keepitup/utils/extensions.dart';
import 'package:keepitup/widgets/pdf_thumbnail.dart';

class PdfListItem extends StatelessWidget {
  final File file;
  final List<String> tags;
  final String subtitle;
  final String date;
  final VoidCallback onTap;
  final VoidCallback? onMoreTap;

  const PdfListItem({
    super.key,
    required this.file,
    required this.tags,
    required this.subtitle,
    required this.date,
    required this.onTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📄 PDF THUMBNAIL
            PdfThumbnail(
              file: file,
            ),

            12.ww,

            // 📄 MAIN CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE + MENU
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          file.path.split('/').last,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  6.hh,

                  // SUBTITLE
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),

                  10.hh,

                  // TAGS + DATE
                  Row(
                    children: [
                      ...tags.take(2).map(
                        (tag) => Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: _TagChip(label: tag),
                        ),
                      ),
                      10.ww,
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/// ------------------
/// Tag Chip
/// ------------------
class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Appcolors.tag_bg_color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Appcolors.tag_text_color,
        ),
      ),
    );
  }
}
