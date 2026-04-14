import 'package:fpdart/fpdart.dart';

import '../domain.dart';

abstract interface class ChannelRepository {
  Future<Either<Exception, ChannelEntity>> getChannel();
}
