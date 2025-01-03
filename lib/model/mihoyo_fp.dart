import 'package:json_annotation/json_annotation.dart';

part 'mihoyo_fp.g.dart';

@JsonSerializable()
class DeviceInfo {
  final String romCapacity;
  final String deviceName;
  final String productName;
  final String romRemain;
  final String hostname;
  final String screenSize;
  final int isTablet;
  final String aaid;
  final String model;
  final String brand;
  final String hardware;
  final String deviceType;
  final String devId;
  final String serialNumber;
  final int sdCapacity;
  final String buildTime;
  final String buildUser;
  final int simState;
  final String ramRemain;
  final int appUpdateTimeDiff;
  final String deviceInfo;
  final String vaid;
  final String buildType;
  final String sdkVersion;
  final String uiMode;
  final int isMockLocation;
  final String cpuType;
  final int isAirMode;
  final int ringMode;
  final int chargeStatus;
  final String manufacturer;
  final int emulatorStatus;
  final String appMemory;
  final String osVersion;
  final String vendor;
  final String accelerometer;
  final int sdRemain;
  final String buildTags;
  final String packageName;
  final String networkType;
  final String oaid;
  final int debugStatus;
  final String ramCapacity;
  final String magnetometer;
  final String display;
  final int appInstallTimeDiff;
  final String packageVersion;
  final String gyroscope;
  final int batteryStatus;
  final int hasKeyboard;
  final String board;

  DeviceInfo({
    required this.romCapacity,
    required this.deviceName,
    required this.productName,
    required this.romRemain,
    required this.hostname,
    required this.screenSize,
    required this.isTablet,
    required this.aaid,
    required this.model,
    required this.brand,
    required this.hardware,
    required this.deviceType,
    required this.devId,
    required this.serialNumber,
    required this.sdCapacity,
    required this.buildTime,
    required this.buildUser,
    required this.simState,
    required this.ramRemain,
    required this.appUpdateTimeDiff,
    required this.deviceInfo,
    required this.vaid,
    required this.buildType,
    required this.sdkVersion,
    required this.uiMode,
    required this.isMockLocation,
    required this.cpuType,
    required this.isAirMode,
    required this.ringMode,
    required this.chargeStatus,
    required this.manufacturer,
    required this.emulatorStatus,
    required this.appMemory,
    required this.osVersion,
    required this.vendor,
    required this.accelerometer,
    required this.sdRemain,
    required this.buildTags,
    required this.packageName,
    required this.networkType,
    required this.oaid,
    required this.debugStatus,
    required this.ramCapacity,
    required this.magnetometer,
    required this.display,
    required this.appInstallTimeDiff,
    required this.packageVersion,
    required this.gyroscope,
    required this.batteryStatus,
    required this.hasKeyboard,
    required this.board,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) => _$DeviceInfoFromJson(json);
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
  final String bbs_device_id;

  FpBody({
    required this.device_id,
    required this.seed_id,
    required this.seed_time,
    required this.platform,
    required this.device_fp,
    required this.app_name,
    required this.ext_fields,
    required this.bbs_device_id,
  });

  factory FpBody.fromJson(Map<String, dynamic> json) => _$FpBodyFromJson(json);
  Map<String, dynamic> toJson() => _$FpBodyToJson(this);
}

class FpResult {
  final String device_fp;
  final int code;
  final String msg;

  FpResult({
    required this.device_fp,
    required this.code,
    required this.msg,
  });

  factory FpResult.fromJson(Map<String, dynamic> json) {
    return FpResult(
      device_fp: json['device_fp'],
      code: json['code'],
      msg: json['msg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_fp': device_fp,
      'code': code,
      'msg': msg,
    };
  }
}

class FpInfo {
  final String deviceFp;
  final String bbsDeviceId;
  final String sysVsersion;
  final String deviceName;
  final String deviceModel;
  final String brand;

  FpInfo({
    required this.deviceFp,
    required this.bbsDeviceId,
    required this.sysVsersion,
    required this.deviceName,
    required this.deviceModel,
    required this.brand,
  });

  factory FpInfo.fromJson(Map<String, dynamic> json) {
    return FpInfo(
      deviceFp: json['deviceFp'],
      bbsDeviceId: json['bbsDeviceId'],
      sysVsersion: json['sysVsersion'],
      deviceName: json['deviceName'],
      deviceModel: json['deviceModel'],
      brand: json['brand'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceFp': deviceFp,
      'bbsDeviceId': bbsDeviceId,
      'sysVsersion': sysVsersion,
      'deviceName': deviceName,
      'deviceModel': deviceModel,
      'brand': brand,
    };
  }
}
