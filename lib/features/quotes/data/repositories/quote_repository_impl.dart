import 'package:sankar/core/network/dio_client.dart';
import 'package:sankar/features/quotes/domain/repositories/quote_repository.dart';
import 'package:sankar/features/quotes/data/models/quote_model.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  final DioClient _dioClient;

  QuoteRepositoryImpl(this._dioClient);

  @override
  Future<QuoteModel> getRandomQuote() async {
    try {
      final response = await _dioClient.get('https://api.quotable.io/random');
      return QuoteModel.fromJson(response.data);
    } catch (e) {
      // Return a fallback quote if API fails
      return const QuoteModel(
        content: "Success is not final, failure is not fatal: it is the courage to continue that counts.",
        author: "Winston Churchill",
      );
    }
  }
}
