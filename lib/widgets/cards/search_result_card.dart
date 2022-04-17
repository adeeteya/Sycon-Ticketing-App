import 'package:flutter/material.dart';
import 'package:sycon_ticketing_app/constants.dart';
import 'package:sycon_ticketing_app/models/registration.dart';

class SearchResultCard extends StatelessWidget {
  final Registration searchResult;
  final VoidCallback onCollect;
  final bool isLoading;
  const SearchResultCard(
      {Key? key,
      required this.searchResult,
      required this.onCollect,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  searchResult.fullName,
                  style: const TextStyle(
                      color: kRichBlack,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                searchResult.branch,
                style: TextStyle(
                    color: kRichBlack.withOpacity(0.7),
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                searchResult.registerNumber,
                style:
                    TextStyle(color: kRichBlack.withOpacity(0.5), fontSize: 18),
              ),
              Text(
                searchResult.displayYear(),
                style:
                    TextStyle(color: kRichBlack.withOpacity(0.5), fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: (searchResult.hasPaid) ? null : onCollect,
            child: (isLoading)
                ? const CircularProgressIndicator()
                : Text((searchResult.hasPaid) ? "Collected" : "Collect"),
          ),
        ],
      ),
    );
  }
}
