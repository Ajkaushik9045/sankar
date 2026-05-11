import 'package:sankar/features/quotes/data/models/quote_model.dart';

abstract class QuoteRepository {
  Future<QuoteModel> getRandomQuote();
}
