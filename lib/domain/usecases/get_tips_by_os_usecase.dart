import '../entities/tip_entity.dart';
import '../repositories/tip_repository.dart';

/// Use case for getting tips by operating system
class GetTipsByOSUseCase {
  final TipRepository _repository;
  
  const GetTipsByOSUseCase(this._repository);
  
  /// Execute the use case
  Future<List<TipEntity>> call(String os) async {
    if (os.isEmpty) {
      throw ArgumentError('OS parameter cannot be empty');
    }
    
    try {
      final tips = await _repository.getTipsByOS(os.toLowerCase());
      
      // Sort tips by creation date (newest first)
      tips.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return tips;
    } catch (e) {
      throw Exception('Failed to get tips for $os: $e');
    }
  }
}
