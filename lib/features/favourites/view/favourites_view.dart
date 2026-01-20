
  import 'package:flutter/material.dart';

import '../../../shared/widgets/costum_text.dart';
  class FavouritesView extends StatefulWidget {
    const FavouritesView({super.key});

    @override
    State<FavouritesView> createState() => _FavouritesViewState();
  }

  class _FavouritesViewState extends State<FavouritesView> {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Center(
            child: CustomText(text: "Favourites")),

      );
    }
  }
