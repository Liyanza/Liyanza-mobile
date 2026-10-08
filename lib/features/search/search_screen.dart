import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../campagnes/campagne.dart';
import '../../campagnes/campagne_detail.dart';
import '../../core/network/app_exceptions.dart';
import '../../core/providers/campagne_providers.dart';
import '../../core/theme/kiyanza_colors.dart';
import '../../data/models/campagnes/campagne_models.dart';

/// Recherche de campagnes par nom (GET /campagnes?search=), onglet de la
/// barre du bas.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<CampagneModel> _results = const [];
  bool _loading = false;
  String? _error;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => _search(value.trim()));
  }

  Future<void> _search(String query) async {
    setState(() {
      _query = query;
      _error = null;
    });
    if (query.length < 2) {
      setState(() => _results = const []);
      return;
    }
    setState(() => _loading = true);
    try {
      final page = await ref.read(campagneRepositoryProvider).list(page: 1, limit: 30, search: query);
      if (mounted && query == _query) setState(() => _results = page.items);
    } on AppException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _controller,
                onChanged: _onChanged,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) => _search(value.trim()),
                decoration: InputDecoration(
                  hintText: 'Rechercher une campagne',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Effacer',
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _controller.clear();
                            _search('');
                          },
                        ),
                  filled: true,
                  fillColor: AppColors.gray100,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(child: _buildResults()),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(child: Text(_error!, style: const TextStyle(color: AppColors.gray500)));
    }
    if (_query.length < 2) {
      return const _Hint(icon: Icons.search, text: 'Tapez au moins 2 lettres du nom d’une campagne.');
    }
    if (_results.isEmpty) {
      return _Hint(icon: Icons.search_off, text: 'Aucune campagne ne correspond à « $_query ».');
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: _results.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.gray100),
      itemBuilder: (context, index) {
        final item = CampaignItem.fromApi(_results[index]);
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: CircleAvatar(
            backgroundColor: AppColors.gray100,
            child: Icon(item.icon, color: item.iconColor, size: 20),
          ),
          title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          subtitle: Text('${item.platform} · ${item.status}', style: const TextStyle(fontSize: 12)),
          trailing: const Icon(Icons.chevron_right, color: AppColors.gray400),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CampaignDetailScreen(campaign: item)),
          ),
        );
      },
    );
  }
}

class _Hint extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Hint({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: AppColors.gray400),
            const SizedBox(height: 10),
            Text(text, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.gray500)),
          ],
        ),
      ),
    );
  }
}
