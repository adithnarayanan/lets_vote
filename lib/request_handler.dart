import 'package:hive/hive.dart';

import 'ballot.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lets_vote/ballot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class BallotCacheManager extends BaseCacheManager {
  static const key = 'customCache';

  static BallotCacheManager _instance;

  factory BallotCacheManager() {
    if (_instance == null) {
      _instance = new BallotCacheManager();
    }
    return _instance;
  }

  BallotCacheManager._() : super(key, maxAgeCacheObject: Duration(days: 3));

  @override
  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return path.join(directory.path, key);
  }
}

void updateBallots(String voterId) async {
  var ballotsBox = Hive.box<Ballot>('ballotBox');
  String sendUrl =
      'https://api.wevoteusa.org/apis/v1/voterBallotItemsRetrieve/?&voter_device_id=' +
          voterId;
  var file = await BallotCacheManager._().getFileFromCache(sendUrl);
  if (file != null) {
    //checkForUpdates();
  }
}
