import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:sycon_ticketing_app/constants.dart';
import 'package:sycon_ticketing_app/providers.dart';
import 'package:sycon_ticketing_app/services/firestore_services.dart';
import 'package:sycon_ticketing_app/widgets/cards/search_result_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final bool isAdmin;

  const SearchScreen({super.key, this.isAdmin = false});

  @override
  ConsumerState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String _searchVal = "";
  bool _first = true;
  bool _isCollectLoading = false;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchRef = ref.watch(searchResultProvider(_searchVal));
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
        if (kIsWeb) {
          setState(() {
            _searchVal = _textEditingController.text;
            _first = false;
          });
        }
      },
      child: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: _textEditingController,
              cursorColor: kEbonyBlack,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.search,
              autofocus: true,
              onFieldSubmitted: (val) {
                setState(() {
                  _searchVal = val;
                  _first = false;
                });
              },
              decoration: kSearchBoxDecorator,
            ),
            const SizedBox(height: 20),
            if (!_first)
              Flexible(
                child: searchRef.when(
                  data: (searchResult) {
                    if (searchResult == null) {
                      return const Center(
                        child: Text("No Results found"),
                      );
                    }
                    return SearchResultCard(
                      searchResult: searchResult,
                      isLoading: _isCollectLoading,
                      onCollect: () async {
                        if (widget.isAdmin) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Admin Cannot Collect Money"),
                            ),
                          );
                          return;
                        }
                        setState(() {
                          _isCollectLoading = true;
                        });
                        await setRegisterPaid(
                          searchResult.documentId,
                          ref.read(userDataProvider).value?.referralCode ?? 0,
                        );
                        await sendQREmail(searchResult.documentId,
                            searchResult.fullName, searchResult.email);
                        await incrementUserReferral();
                        ref.invalidate(userDataProvider);
                        setState(() {
                          searchResult.hasPaid = true;
                          _isCollectLoading = false;
                        });
                      },
                    );
                  },
                  error: (_, __) => Center(
                    child: Lottie.asset('assets/lottie/error.json'),
                  ),
                  loading: () => Center(
                    child: Lottie.asset('assets/lottie/search_loading.json'),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
