import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

/// Curated set of icon identifiers used by the design system.
class MinimalIcons {
  // Navigation
  static const IconData home = Icons.home;
  static const IconData menu = Icons.menu;
  static const IconData back = Icons.arrow_back;
  static const IconData forward = Icons.arrow_forward;
  static const IconData close = Icons.close;
  static const IconData search = Icons.search;

  // Actions
  static const IconData add = Icons.add;
  static const IconData edit = Icons.edit;
  static const IconData delete = Icons.delete;
  static const IconData save = Icons.save;
  static const IconData share = Icons.share;
  static const IconData download = Icons.download;

  // Content
  static const IconData favorite = Icons.favorite;
  static const IconData star = Icons.star;
  static const IconData bookmark = Icons.bookmark;
  static const IconData comment = Icons.comment;
  static const IconData attach = Icons.attach_file;
  static const IconData image = Icons.image;

  // Status
  static const IconData success = Icons.check_circle;
  static const IconData error = Icons.error;
  static const IconData warning = Icons.warning;
  static const IconData info = Icons.info;
  static const IconData loading = Icons.hourglass_empty;

  // Data
  static const IconData sort = Icons.sort;
  static const IconData filter = Icons.filter_list;
  static const IconData refresh = Icons.refresh;
  static const IconData sync = Icons.sync;

  // Communication
  static const IconData phone = Icons.phone;
  static const IconData email = Icons.email;
  static const IconData message = Icons.message;
  static const IconData notification = Icons.notifications;

  // Media
  static const IconData play = Icons.play_arrow;
  static const IconData pause = Icons.pause;
  static const IconData stop = Icons.stop;
  static const IconData volume = Icons.volume_up;

  // Settings
  static const IconData settings = Icons.settings;
  static const IconData profile = Icons.person;
  static const IconData help = Icons.help;
  static const IconData logout = Icons.logout;
}

class MinimalIconCategories {
  static const List<IconData> navigation = [
    MinimalIcons.home,
    MinimalIcons.menu,
    MinimalIcons.back,
    MinimalIcons.forward,
    MinimalIcons.close,
    MinimalIcons.search,
  ];

  static const List<IconData> actions = [
    MinimalIcons.add,
    MinimalIcons.edit,
    MinimalIcons.delete,
    MinimalIcons.save,
    MinimalIcons.share,
    MinimalIcons.download,
  ];

  static const List<IconData> status = [
    MinimalIcons.success,
    MinimalIcons.error,
    MinimalIcons.warning,
    MinimalIcons.info,
    MinimalIcons.loading,
  ];
}
