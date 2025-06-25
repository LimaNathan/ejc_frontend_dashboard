import 'package:flutter/material.dart';

class PaginationBuilder extends StatefulWidget {
  const PaginationBuilder({
    required this.totalPages,
    required this.currentPage,
    required this.onTap,
    super.key,
  });

  final int totalPages;
  final int currentPage;
  final void Function(int index) onTap;

  @override
  State<PaginationBuilder> createState() => _PaginationBuilderState();
}

class _PaginationBuilderState extends State<PaginationBuilder> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    const maxVisible = 7;
    final items = <Widget>[];

    void addPage(int index) {
      items.add(
        InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            if (index == widget.currentPage) return;
            widget.onTap(index);
          },
          child: Container(
            alignment: Alignment.center,
            height: 36,
            width: 36,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              border: widget.currentPage != index
                  ? null
                  : Border.all(
                      color: colorScheme //
                          .surface
                          .withAlpha(100),
                      width: 3,
                    ),
              borderRadius: BorderRadius.circular(28),
              color: widget.currentPage != index ? null : colorScheme.primary,
            ),
            child: Text(
              '${index + 1}',
              style: textTheme.bodyLarge?.copyWith(
                color: widget.currentPage != index
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      );
    }

    void addEllipsis() {
      items.add(
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('...'),
        ),
      );
    }

    if (widget.totalPages <= maxVisible) {
      for (var i = 0; i < widget.totalPages; i++) {
        addPage(i);
      }
    } else {
      if (widget.currentPage < 3) {
        // Início
        for (var i = 0; i < 4; i++) {
          addPage(i);
        }
        addEllipsis();
        addPage(widget.totalPages - 1);
      } else if (widget.currentPage > widget.totalPages - 4) {
        // Fim
        addPage(0);
        addEllipsis();
        for (var i = widget.totalPages - 4; i < widget.totalPages; i++) {
          addPage(i);
        }
      } else {
        // Meio
        addPage(0);
        addEllipsis();
        for (var i = widget.currentPage - 1; i <= widget.currentPage + 1; i++) {
          addPage(i);
        }
        addEllipsis();
        addPage(widget.totalPages - 1);
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items,
    );
  }
}
