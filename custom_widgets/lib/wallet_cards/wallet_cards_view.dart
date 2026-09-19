import 'package:custom_widgets/wallet_cards/wallet_cards.dart';
import 'package:flutter/material.dart';

class WalletCardsView extends StatelessWidget {
  const WalletCardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1178),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: const WalletCards(),
    );
  }
}
