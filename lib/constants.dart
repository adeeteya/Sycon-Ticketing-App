import 'package:flutter/material.dart';

const kRichBlack = Color(0xFF010E19);
const kEbonyBlack = Color(0xFF130F26);
const kOuterSpaceGrey = Color(0xFF464646);
const kSandSilver = Color(0xFFC4C4C4);
const kQuickSilver = Color(0xFFA5A5A5);
const kSilver = Color(0xFFCBCBCB);
const kBrightGrey = Color(0xFFEEEEEF);
const kDarkGrey = Color(0xFFA9A9A9);
const kAltoGrey = Color(0xFFDCDCDC);
const kSlateGrey = Color(0xFF7A848C);
const kNickelSilver = Color(0xFF6B737A);
const kChineseWhite = Color(0xFFE0E0E0);
const kSeaShellWhite = Color(0xFFF1F1F1);
const kWildSandWhite = Color(0xFFF4F4F4);
const kAlabasterWhite = Color(0xFFF7F7F7);
const kCulturedWhite = Color(0xFFF8F8F8);
const kCeruleanBlue = Color(0xFF00C0FF);
const kSchoolBusYellow = Color(0xFFFFD800);
const kMalachiteGreen = Color(0xFF01D358);
const kFairPink = Color(0xFFFFE8E8);
const kCongoPink = Color(0xFFFD7A7A);
const kTableHeadingTextStyle =
    TextStyle(color: kRichBlack, fontWeight: FontWeight.w600, fontSize: 16);
const kTableRowValueTextStyle = TextStyle(color: kQuickSilver);

final kLoginInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  hintStyle: const TextStyle(
    color: kSlateGrey,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: kChineseWhite),
    borderRadius: BorderRadius.circular(6),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: kCeruleanBlue),
    borderRadius: BorderRadius.circular(6),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: kCeruleanBlue),
    borderRadius: BorderRadius.circular(6),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: kCongoPink),
    borderRadius: BorderRadius.circular(6),
  ),
);

final kSearchBoxDecorator = InputDecoration(
  isDense: true,
  hintText: 'Search',
  hintStyle: const TextStyle(color: kSilver),
  fillColor: kSeaShellWhite,
  filled: true,
  prefixIcon: const Icon(Icons.search, color: kEbonyBlack),
  border: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(5),
  ),
);
