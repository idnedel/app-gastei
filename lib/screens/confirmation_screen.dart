import 'package:flutter/cupertino.dart';

class ConfirmationScreen extends StatelessWidget {
  final String amount;

  const ConfirmationScreen({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'VOCÊ GASTOU R\$ $amount!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CupertinoButton.filled(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Voltar para o início'),
            ),
          ],
        ),
      ),
    );
  }
}
