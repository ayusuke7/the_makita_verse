import 'package:fpdart/fpdart.dart';

import '../../domain/domain.dart';
import '../data.dart';

class YoutubeRepositoryImpl implements YoutubeRepository {
  final YoutubeDataSource _dataSource;

  ChannelEntity? _cacheChannel;
  List<PlaylistEntity>? _cachePlaylists;

  YoutubeRepositoryImpl(this._dataSource);

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

  @override
  Future<Either<Exception, List<PlaylistEntity>>> getPlaylists() async {
    if (_cachePlaylists != null) {
      return right(_cachePlaylists!);
    }

    try {
      final result = await _dataSource.getPlaylists();
      _cachePlaylists = result.map((e) => e.toEntity()).toList();
      return right(_cachePlaylists!);
    } catch (e) {
      return left(e as Exception);
    }
  }
}
