import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../widgets/search_bar.dart';
import 'disease library.dart';


class DiseaseLibraryPage extends StatefulWidget {
  @override
  _DiseaseLibraryPageState createState() => _DiseaseLibraryPageState();
}

class _DiseaseLibraryPageState extends State<DiseaseLibraryPage> {
  static const _pageSize = 10;
  final PagingController<int, Map<String, dynamic>> _pagingController =
  PagingController(firstPageKey: 0);

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await _fetchDiseases(pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchDiseases(int startIndex, int count) async {
    if (_searchQuery.isEmpty) {
      return diseases.skip(startIndex).take(count).toList();
    } else {
      return diseases
          .where((disease) => disease['name'].toLowerCase().contains(_searchQuery.toLowerCase()))
          .skip(startIndex)
          .take(count)
          .toList();
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _pagingController.refresh();
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      appBar: AppBar(
        title: Text(
          'Disease Library',
          style: TextStyle(fontWeight: FontWeight.w600),
        ).animate().fadeIn(
          duration: 300.ms,
          curve: Curves.easeOut,
        ),
        backgroundColor: CupertinoColors.systemBackground,
        foregroundColor: CupertinoColors.label,
        elevation: 0,
      ),
      body: Column(
        children: [
          SearchBarWidget(onChanged: _onSearchChanged), // Add the search bar here
          Expanded(
            child: PagedListView<int, Map<String, dynamic>>(
              pagingController: _pagingController,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              scrollController: ScrollController(),
              builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
                itemBuilder: (context, disease, index) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 12),
                    elevation: 0,
                    color: CupertinoColors.systemBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: CupertinoColors.separator.withOpacity(0.2),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  disease['name'],
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: CupertinoColors.label,
                                  ),
                                )
                                    .animate(
                                  delay: (10 * index).ms,
                                )
                                    .fadeIn(
                                  duration: 600.ms,
                                  curve: Curves.easeOut,
                                )
                                    .slideX(
                                  begin: 0.4,
                                  end: 0,
                                  duration: 600.ms,
                                  curve: Curves.easeOutCubic,
                                ),
                              ),
                              _buildSeverityBadge(
                                disease['severity'] ?? "",
                                disease['color'],
                                index,
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          _buildInfoRow(
                            CupertinoIcons.exclamationmark_triangle,
                            'Symptoms',
                            disease['symptoms'] ?? '',
                          )
                              .animate(
                            delay: (20 * index).ms,
                          )
                              .fadeIn(
                            duration: 800.ms,
                            curve: Curves.easeOut,
                          )
                              .slideX(
                            begin: 0.4,
                            end: 0,
                            duration: 600.ms,
                            curve: Curves.easeOutCubic,
                          ),
                          SizedBox(height: 8),
                          _buildInfoRow(
                            CupertinoIcons.bandage,
                            'Treatment',
                            disease['treatment'] ?? '',
                          )
                              .animate(
                            delay: (23 * index).ms,
                          )
                              .fadeIn(
                            duration: 600.ms,
                            curve: Curves.easeOut,
                          )
                              .slideX(
                            begin: 0.4,
                            end: 0,
                            duration: 600.ms,
                            curve: Curves.easeOutCubic,
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate(
                    delay: (5 * index).ms,
                  )
                      .fadeIn(
                    duration: 50.ms,
                    curve: Curves.easeOut,
                  )
                      .slideY(
                    begin: 0.01,
                    end: 0,
                    duration: 50.ms,
                    curve: Curves.easeOutCubic,
                  );
                },
                firstPageProgressIndicatorBuilder: (context) => Center(
                  child: CupertinoActivityIndicator(),
                ),
                newPageProgressIndicatorBuilder: (context) => Center(
                  child: CupertinoActivityIndicator(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityBadge(String severity, Color color, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        severity,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    )
        .animate(
      delay: (15 * index).ms,
    )
        .fadeIn(
      duration: 600.ms,
      curve: Curves.easeOut,
    )
        .slideX(
      begin: 0.4,
      end: 0,
      duration: 600.ms,
      curve: Curves.easeOutCubic,
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: CupertinoColors.secondaryLabel,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: CupertinoColors.secondaryLabel,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 4),
              Text(
                text,
                style: TextStyle(
                  color: CupertinoColors.label,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}