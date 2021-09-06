import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:soc_project/models/credit_card.dart';


class CreditCardData extends ChangeNotifier {


  List<CreditCard> _cards = [
    CreditCard(
      cardNumber: "123456789",
      cvv: "023",
      scheme: "Visa",
      type: "Debit",
      bank: "Sampath Bank",
      bankEmoji: "🇩🇰",
      branch: "Kandy",
    ),

  ];

  int get cardsCount{
    return _cards.length;
  }

  UnmodifiableListView<CreditCard> get cards{
    return UnmodifiableListView(_cards);
  }

  void clearCardList()
  {
    _cards.clear();
    notifyListeners();
  }

  void addCard(CreditCard creditCard)
  {
    _cards.add(creditCard);
    notifyListeners();
  }


  void deleteCard(CreditCard creditCard)
  {
    _cards.remove(creditCard);
    notifyListeners();
  }


}