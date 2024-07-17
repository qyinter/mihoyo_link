// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mihoyo_fp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => DeviceInfo(
      cpuType: json['cpuType'] as String,
      romCapacity: json['romCapacity'] as String,
      productName: json['productName'] as String,
      romRemain: json['romRemain'] as String,
      manufacturer: json['manufacturer'] as String,
      appMemory: json['appMemory'] as String,
      hostname: json['hostname'] as String,
      screenSize: json['screenSize'] as String,
      osVersion: json['osVersion'] as String,
      aaid: json['aaid'] as String,
      vendor: json['vendor'] as String,
      accelerometer: json['accelerometer'] as String,
      buildTags: json['buildTags'] as String,
      model: json['model'] as String,
      brand: json['brand'] as String,
      oaid: json['oaid'] as String,
      hardware: json['hardware'] as String,
      deviceType: json['deviceType'] as String,
      devId: json['devId'] as String,
      serialNumber: json['serialNumber'] as String,
      buildTime: json['buildTime'] as String,
      buildUser: json['buildUser'] as String,
      ramCapacity: json['ramCapacity'] as String,
      magnetometer: json['magnetometer'] as String,
      display: json['display'] as String,
      ramRemain: json['ramRemain'] as String,
      deviceInfo: json['deviceInfo'] as String,
      gyroscope: json['gyroscope'] as String,
      vaid: json['vaid'] as String,
      buildType: json['buildType'] as String,
      sdkVersion: json['sdkVersion'] as String,
      board: json['board'] as String,
    );

Map<String, dynamic> _$DeviceInfoToJson(DeviceInfo instance) =>
    <String, dynamic>{
      'cpuType': instance.cpuType,
      'romCapacity': instance.romCapacity,
      'productName': instance.productName,
      'romRemain': instance.romRemain,
      'manufacturer': instance.manufacturer,
      'appMemory': instance.appMemory,
      'hostname': instance.hostname,
      'screenSize': instance.screenSize,
      'osVersion': instance.osVersion,
      'aaid': instance.aaid,
      'vendor': instance.vendor,
      'accelerometer': instance.accelerometer,
      'buildTags': instance.buildTags,
      'model': instance.model,
      'brand': instance.brand,
      'oaid': instance.oaid,
      'hardware': instance.hardware,
      'deviceType': instance.deviceType,
      'devId': instance.devId,
      'serialNumber': instance.serialNumber,
      'buildTime': instance.buildTime,
      'buildUser': instance.buildUser,
      'ramCapacity': instance.ramCapacity,
      'magnetometer': instance.magnetometer,
      'display': instance.display,
      'ramRemain': instance.ramRemain,
      'deviceInfo': instance.deviceInfo,
      'gyroscope': instance.gyroscope,
      'vaid': instance.vaid,
      'buildType': instance.buildType,
      'sdkVersion': instance.sdkVersion,
      'board': instance.board,
    };

FpBody _$FpBodyFromJson(Map<String, dynamic> json) => FpBody(
      device_id: json['device_id'] as String,
      seed_id: json['seed_id'] as String,
      seed_time: json['seed_time'] as String,
      platform: json['platform'] as String,
      device_fp: json['device_fp'] as String,
      app_name: json['app_name'] as String,
      ext_fields: json['ext_fields'] as String,
    );

Map<String, dynamic> _$FpBodyToJson(FpBody instance) => <String, dynamic>{
      'device_id': instance.device_id,
      'seed_id': instance.seed_id,
      'seed_time': instance.seed_time,
      'platform': instance.platform,
      'device_fp': instance.device_fp,
      'app_name': instance.app_name,
      'ext_fields': instance.ext_fields,
    };
