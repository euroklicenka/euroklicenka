import 'package:eurokey2/features/internet_access/allowed_urls.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

///Manages access to custom YAML property files.
class YAMLDataManager {
  static YAMLDataManager? _instance;

  final String _downloadURLsParam = 'download_urls';
  final String _aboutEuroKeyUrlParam = 'about_eurokey_url';
  final String _aboutEuroKeyWebUrlParam = 'about_eurokey_web_url';
  final String _universityOfOstravaUrlParam = 'university_of_ostrava_url';
  final String _universityOfOstravaKIPUrlParam = 'university_of_ostrava_kip_url';

  static Future<YAMLDataManager> getInstance() async {
    _instance ??= await _create();
    return _instance!;
  }

  YAMLDataManager._();


  /// Creates a new instance of [YAMLDataManager].
  static Future<YAMLDataManager> _create() async {
    final YAMLDataManager m = YAMLDataManager._();
    final String rawData = await rootBundle.loadString('assets/url_addresses.yaml');
    final YamlMap data = await loadYaml(rawData) as YamlMap;

    final List<String> downloads = [];
    for (final url in data[m._downloadURLsParam] as YamlList) {
      downloads.add(url.toString());
    }

    setAllowedURLs(
        downloads: downloads,
        aboutEuroKey: data[m._aboutEuroKeyUrlParam].toString(),
        aboutEuroKeyWeb: data[m._aboutEuroKeyWebUrlParam].toString(),
        universityOfOstrava:  data[m._universityOfOstravaUrlParam].toString(),
        universityOfOstravaKIP: data[m._universityOfOstravaKIPUrlParam].toString(),
    );

    return m;
  }
}
