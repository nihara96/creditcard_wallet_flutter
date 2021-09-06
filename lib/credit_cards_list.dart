import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soc_project/components/my_credit_card.dart';
import 'package:soc_project/models/credit_card_data.dart';

class CreditCardList extends StatelessWidget {
  const CreditCardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CreditCardData>(
        builder: (context,cardData,child){
          return ListView.builder(
              itemBuilder: (context,index){
                final creditCard = cardData.cards[index];

                return MyCreditCard(
                    cardNumber: creditCard.cardNumber,
                    cvv: creditCard.cvv,
                    scheme: creditCard.scheme,
                    type: creditCard.type,
                    bank: creditCard.bank,
                    bankEmoji: creditCard.bankEmoji,
                    branch: creditCard.branch
                );
              },
              itemCount: cardData.cardsCount,
          );

        }
    );
  }
}
