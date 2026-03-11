import 'dart:async';
import 'package:flutter/material.dart';

/// A customizable searchable dropdown widget for single-item selection.
///
/// This widget provides a searchable list of items that can be filtered locally
/// or via a server-side search callback.
class CustomSearchDropdownWidget<T> extends StatefulWidget {
  /// Creates a [CustomSearchDropdownWidget].
  const CustomSearchDropdownWidget({
    super.key,
    required this.onChange,
    required this.itemsList,
    required this.backgroundColor,
    this.onSearch,
    required this.listItemBuilder,
    required this.headerBuilder,
    this.selectedItem,
    this.isLoading = false,
    this.searchFieldDecoration,
    this.itemToString,
  });

  /// Optional function to convert an item to a string for filtering.
  /// If not provided, `item.toString()` is used.
  final String Function(T item)? itemToString;

  /// Callback function called when an item is selected.
  final void Function(T value) onChange;

  /// The list of items to display in the dropdown.
  final List<T> itemsList;

  /// Background color of the dropdown search panel.
  final Color backgroundColor;

  /// Optional callback for server-side search.
  /// If provided, local filtering is disabled.
  final void Function(String query)? onSearch;

  /// Builder for individual list items in the dropdown.
  final Widget Function(BuildContext context, T item, bool isSelected) listItemBuilder;

  /// Builder for the collapsed dropdown header (the button).
  final Widget Function(BuildContext context, T? selectedItem, bool enabled) headerBuilder;

  /// The currently selected item, if any.
  final T? selectedItem;

  /// Indicates whether a search operation is in progress.
  final bool isLoading;

  /// Custom decoration for the search text field.
  final InputDecoration? searchFieldDecoration;

  @override
  State<CustomSearchDropdownWidget<T>> createState() => _CustomSearchDropdownWidgetState<T>();
}

class _CustomSearchDropdownWidgetState<T> extends State<CustomSearchDropdownWidget<T>> {
  List<T> filteredList = [];
  final LayerLink layerLink = LayerLink();
  final GlobalKey buttonKey = GlobalKey();
  OverlayEntry? overlay;
  Timer? debounce;
  bool isToggle = false;
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    filteredList = List.from(widget.itemsList);
    searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(covariant CustomSearchDropdownWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemsList != oldWidget.itemsList || widget.isLoading != oldWidget.isLoading) {
      if (widget.onSearch != null) {
        filteredList = List.from(widget.itemsList);
      } else {
        _applyLocalFilter(searchController.text);
      }

      if (overlay != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (overlay?.mounted ?? false) {
            overlay?.markNeedsBuild();
          }
        });
      }
    }
  }

  void _onSearchChanged() {
    final query = searchController.text;
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      if (widget.onSearch != null) {
        widget.onSearch!(query);
      } else {
        _applyLocalFilter(query);
      }
    });
  }

  void _applyLocalFilter(String query) {
    if (query.isEmpty) {
      if (mounted) {
        setState(() {
          filteredList = List.from(widget.itemsList);
        });
      }
    } else {
      if (mounted) {
        setState(() {
          filteredList = widget.itemsList.where((item) {
            final String filterString = widget.itemToString?.call(item) ?? item.toString();
            return filterString.toLowerCase().contains(query.toLowerCase());
          }).toList();
        });
      }
    }
    if (overlay?.mounted ?? false) {
      overlay?.markNeedsBuild();
    }
  }

  void _toggleOverLay() {
    if (overlay == null) {
      isToggle = true;
      overlay = _buildOverlay();
      Overlay.of(context).insert(overlay!);
    } else {
      isToggle = false;
      if (overlay?.mounted ?? false) {
        overlay?.remove();
      }
      overlay = null;
      searchController.clear();
    }
    if (mounted) setState(() {});
  }

  void _removeOverlay() {
    if (overlay != null) {
      isToggle = false;
      if (overlay?.mounted ?? false) {
        overlay?.remove();
      }
      overlay = null;
      if (mounted) setState(() {});
    }
  }

  OverlayEntry _buildOverlay() {
    final RenderBox renderBox = buttonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    double screenHeight = MediaQuery.of(context).size.height;
    double distanceFromBottom = screenHeight - (position.dy + size.height);

    return OverlayEntry(
      builder: (context) {
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, res) async {
            if (didPop) _removeOverlay();
          },
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(color: const Color.fromARGB(45, 158, 158, 158)),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: InkWell(
                        overlayColor: WidgetStateProperty.all(Colors.transparent),
                        onTap: _removeOverlay,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                      ),
                    ),
                    Positioned(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                        child: CompositedTransformFollower(
                          link: layerLink,
                          offset: MediaQuery.of(context).viewInsets.bottom > 0 && distanceFromBottom > 450
                              ? const Offset(0, -10)
                              : MediaQuery.of(context).viewInsets.bottom > 0 &&
                                      distanceFromBottom < 450 &&
                                      distanceFromBottom > 300
                                  ? const Offset(0, -100)
                                  : distanceFromBottom < 300
                                      ? const Offset(0, -300)
                                      : const Offset(0, 60),
                          showWhenUnlinked: false,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black26, blurRadius: 8.0, offset: Offset(0, 2))
                                ],
                              ),
                              child: _buildSearchPanel(width: size.width),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchPanel({double? width}) {
    return StatefulBuilder(
      builder: (BuildContext context, innerSetState) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          height: 370,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8.0, offset: Offset(0, 2))],
          ),
          width: width ?? MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Search', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              TextField(
                autofocus: true,
                focusNode: _searchFocusNode,
                controller: searchController,
                decoration: widget.searchFieldDecoration ??
                    InputDecoration(
                      hintText: 'Search here...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      suffixIcon: const Icon(Icons.search),
                    ),
              ),
              const SizedBox(height: 10),
              if (widget.isLoading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else if (filteredList.isNotEmpty) ...[
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.zero,
                    itemCount: filteredList.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      final isSelected = widget.selectedItem == item;
                      return InkWell(
                        onTap: () {
                          widget.onChange(item);
                          _removeOverlay();
                        },
                        child: widget.listItemBuilder(context, item, isSelected),
                      );
                    },
                  ),
                ),
              ] else ...[
                const Expanded(
                  child: Center(
                    child: Text("No Result Found", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: InkWell(
        key: buttonKey,
        onTap: _toggleOverLay,
        child: widget.headerBuilder(context, widget.selectedItem, true),
      ),
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    searchController.dispose();
    _searchFocusNode.dispose();
    debounce?.cancel();
    super.dispose();
  }
}
