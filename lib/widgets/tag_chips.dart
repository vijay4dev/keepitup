import 'package:flutter/material.dart';
import 'package:keepitup/utils/Appcolors.dart';
class TagChips extends StatefulWidget {
  final List<String> tags;
  final Function(String)? onChanged;

  const TagChips({
    super.key,
    required this.tags,
    this.onChanged,
  });

  @override
  State<TagChips> createState() => _TagChipsState();
}

class _TagChipsState extends State<TagChips> {
  late String selectedTag;

  @override
  void initState() {
    super.initState();
    selectedTag = widget.tags.first; // "All" default
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.tags.length,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final tag = widget.tags[index];
          final isSelected = tag == selectedTag;

          return GestureDetector(
            onTap: () {
              setState(() => selectedTag = tag);
              widget.onChanged?.call(tag);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: Appcolors.app_blue_color.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 20,
                    offset: Offset(0, 10)
                  )
                ] : [],
                color: isSelected
                    ? Appcolors.app_blue_color // selected
                    : const Color.fromARGB(255, 232, 232, 232),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.transparent
                ),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
