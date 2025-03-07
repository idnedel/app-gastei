import 'package:flutter/cupertino.dart';
import 'package:app_gastei/services/google_sheets_service.dart';
import 'package:app_gastei/screens/confirmation_screen.dart';

class ExpenseSelectionScreen extends StatefulWidget {
  const ExpenseSelectionScreen({super.key});

  @override
  ExpenseSelectionScreenState createState() => ExpenseSelectionScreenState();
}

class ExpenseSelectionScreenState extends State<ExpenseSelectionScreen> {
  String? selectedCategory;
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Selecione a Categoria'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(CupertinoIcons.back),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 150),

          // botões das categorias organizados em duas linhas
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  categoryButton(
                    'Comida',
                    const Color.fromARGB(255, 211, 48, 48),
                  ),
                  SizedBox(width: 15),
                  categoryButton(
                    'Lazer',
                    const Color.fromARGB(255, 47, 177, 68),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  categoryButton(
                    'Carro',
                    const Color.fromARGB(255, 218, 178, 20),
                  ),
                  SizedBox(width: 15),
                  categoryButton(
                    'Roupa',
                    const Color.fromARGB(255, 42, 94, 204),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  categoryButton(
                    '+',
                    CupertinoColors.systemGrey,
                    isOther: true,
                  ),
                ],
              ),
            ],
          ),

          Spacer(),

          // campo de entrada de valor
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
            child: CupertinoTextField(
              controller: amountController,
              placeholder: 'Digite o valor (R\$)',
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          SizedBox(height: 20),

          // confirmar
          CupertinoButton.filled(
            onPressed: () async {
              if (selectedCategory != null &&
                  amountController.text.isNotEmpty) {
                String amount = amountController.text;

                // enviar para o Google Sheets
                await GoogleSheetsService.sendExpenseToGoogleSheets(
                  selectedCategory!,
                  amount,
                );

                if (!mounted) return;

                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ConfirmationScreen(amount: amount),
                  ),
                );
              }
            },
            child: Text('Confirmar'),
          ),

          SizedBox(height: 190),
        ],
      ),
    );
  }

  // método para criar os botões das categorias
  Widget categoryButton(String title, Color color, {bool isOther = false}) {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      color: selectedCategory == title ? color.withAlpha(130) : color,
      borderRadius: BorderRadius.circular(20),
      onPressed: () {
        setState(() {
          selectedCategory = title;
        });
      },
      child: Text(
        title,
        style: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255),
          fontSize: isOther ? 30 : 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
