import 'package:fpdart/fpdart.dart';

import '../../domain/domain.dart';
import '../data.dart';

class ChannelRepositoryImpl implements ChannelRepository {
  final YoutubeDataSource _dataSource;

  ChannelEntity? _cacheChannel;

  ChannelRepositoryImpl(this._dataSource);

  @override
  Future<Either<Exception, ChannelEntity>> getChannel() async {
    if (_cacheChannel != null) {
      return right(_cacheChannel!);
    }

    try {
      final result = await _dataSource.getChannel();
      _cacheChannel = result.toEntity();
      return right(_cacheChannel!);
    } catch (e) {
      return left(e as Exception);
    }
  }
}
