import 'package:json_annotation/json_annotation.dart';

part 'mihoyo_fp.g.dart';

@JsonSerializable()
class DeviceInfo {
  final String cpuType;
  final String romCapacity;
  final String productName;
  final String romRemain;
  final String manufacturer;
  final String appMemory;
  final String hostname;
  final String screenSize;
  final String osVersion;
  final String aaid;
  final String vendor;
  final String accelerometer;
  final String buildTags;
  final String model;
  final String brand;
  final String oaid;
  final String hardware;
  final String deviceType;
  final String devId;
  final String serialNumber;
  final String buildTime;
  final String buildUser;
  final String ramCapacity;
  final String magnetometer;
  final String display;
  final String ramRemain;
  final String deviceInfo;
  final String gyroscope;
  final String vaid;
  final String buildType;
  final String sdkVersion;
  final String board;

  DeviceInfo({
    required this.cpuType,
    required this.romCapacity,
    required this.productName,
    required this.romRemain,
    required this.manufacturer,
    required this.appMemory,
    required this.hostname,
    required this.screenSize,
    required this.osVersion,
    required this.aaid,
    required this.vendor,
    required this.accelerometer,
    required this.buildTags,
    required this.model,
    required this.brand,
    required this.oaid,
    required this.hardware,
    required this.deviceType,
    required this.devId,
    required this.serialNumber,
    required this.buildTime,
    required this.buildUser,
    required this.ramCapacity,
    required this.magnetometer,
    required this.display,
    required this.ramRemain,
    required this.deviceInfo,
    required this.gyroscope,
    required this.vaid,
    required this.buildType,
    required this.sdkVersion,
    required this.board,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      cpuType: json['cpuType'] ?? 'arm64-v8a',
      romCapacity: json['romCapacity'] ?? '512',
      productName: json['productName'] ?? 'ishtar',
      romRemain: json['romRemain'] ?? '459',
      manufacturer: json['manufacturer'] ?? 'Xiaomi',
      appMemory: json['appMemory'] ?? '512',
      hostname: json['hostname'] ?? 'xiaomi.eu',
      screenSize: json['screenSize'] ?? '1440x3022',
      osVersion: json['osVersion'] ?? '13',
      aaid: json['aaid'] ?? 'a945fe0c-5f49-4481-9ee8-418e74508414',
      vendor: json['vendor'] ?? '中国电信',
      accelerometer: json['accelerometer'] ?? '0.061016977x0.8362915x9.826724',
      buildTags: json['buildTags'] ?? 'release-keys',
      model: json['model'] ?? '2304FPN6DC',
      brand: json['brand'] ?? 'Xiaomi',
      oaid: json['oaid'] ?? '67b292338ad57a24',
      hardware: json['hardware'] ?? 'qcom',
      deviceType: json['deviceType'] ?? 'ishtar',
      devId: json['devId'] ?? 'REL',
      serialNumber: json['serialNumber'] ?? 'unknown',
      buildTime: json['buildTime'] ?? '1690889245000',
      buildUser: json['buildUser'] ?? 'builder',
      ramCapacity: json['ramCapacity'] ?? '229481',
      magnetometer: json['magnetometer'] ?? '80.64375x-14.1x77.90625',
      display: json['display'] ?? 'TKQ1.221114.001 release-keys',
      ramRemain: json['ramRemain'] ?? '110308',
      deviceInfo: json['deviceInfo'] ?? 'Xiaomi/ishtar/ishtar:13/TKQ1.221114.001/V14.0.17.0.TMACNXM:user/release-keys',
      gyroscope: json['gyroscope'] ?? '7.9894776E-4x-1.3315796E-4x6.6578976E-4',
      vaid: json['vaid'] ?? '4c10d338150078d8',
      buildType: json['buildType'] ?? 'user',
      sdkVersion: json['sdkVersion'] ?? '33',
      board: json['board'] ?? 'kalama',
    );
  }

  Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);
}

@JsonSerializable()
class FpBody {
  final String device_id;
  final String seed_id;
  final String seed_time;
  final String platform;
  final String device_fp;
  final String app_name;
  final String ext_fields;

  FpBody({
    required this.device_id,
    required this.seed_id,
    required this.seed_time,
    required this.platform,
    required this.device_fp,
    required this.app_name,
    required this.ext_fields,
  });

  factory FpBody.fromJson(Map<String, dynamic> json) => _$FpBodyFromJson(json);
  Map<String, dynamic> toJson() => _$FpBodyToJson(this);
}
