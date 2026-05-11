import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sankar/features/quotes/domain/repositories/quote_repository.dart';
import 'quote_state.dart';

class QuoteCubit extends Cubit<QuoteState> {
  final QuoteRepository _quoteRepository;

  QuoteCubit(this._quoteRepository) : super(QuoteInitial());

  Future<void> getRandomQuote() async {
    emit(QuoteLoading());
    try {
      final quote = await _quoteRepository.getRandomQuote();
      emit(QuoteLoaded(quote));
    } catch (e) {
      emit(QuoteError(e.toString()));
    }
  }
}
