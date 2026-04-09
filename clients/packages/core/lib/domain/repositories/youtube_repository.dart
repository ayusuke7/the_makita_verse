import 'package:fpdart/fpdart.dart';

import '../domain.dart';

abstract interface class YoutubeRepository {
  Future<Either<Exception, ChannelEntity>> getChannel();
  Future<Either<Exception, List<PlaylistEntity>>> getPlaylists();
}
