import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bmflocation/bdmap_location_flutter_plugin.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_android_option.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_ios_option.dart';
import 'package:flutter_bmfmap/BaiduMap/bmfmap_map.dart';
import 'package:flutter_bmfbase/BaiduMap/bmfmap_base.dart';

class AMap extends StatefulWidget {
  AMap({Key key}) : super(key: key);

  @override
  _AMapState createState() => _AMapState();
}

class _AMapState extends State<AMap> {


  GlobalKey _globalKey = new GlobalKey();

  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
      _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      String bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  BMFMapController myMapController;
  BMFCoordinate coordinate = BMFCoordinate(0, 0);

  /// 定位模式状态
  bool _showUserLocaion = true;

  /// 定位模式
  BMFUserTrackingMode _userTrackingMode = BMFUserTrackingMode.Follow;

  /// 创建完成回调
  onBMFMapCreated(BMFMapController controller) async{
    myMapController = controller;
    // controller.
    /// 创建BMFMarker
    BMFMarker marker = BMFMarker(
        visible: false,
        zIndex: 9999,
        position: BMFCoordinate(39.928617, 116.40329),
        title: 'flutterMaker',
        identifier: 'flutter_marker',
        scaleX: 0.2,
        scaleY: 0.2,
        // screenPointToLock: BMFPoint(0,0),
        icon: 'assets/images/pos.jpg');

    /// 构造text
    BMFText bmfText = BMFText(
        text: 'hello world',
        position: BMFCoordinate(39.928617, 116.40329),
        bgColor: Colors.blue,
        fontColor: Colors.red,
        fontSize: 40,
        typeFace: BMFTypeFace(
            familyName: BMFFamilyName.sMonospace,
            textStype: BMFTextStyle.BOLD_ITALIC),
        alignY: BMFVerticalAlign.ALIGN_TOP,
        alignX: BMFHorizontalAlign.ALIGN_LEFT,
        rotate: 30.0);
    controller.getTrafficEnabled();
    controller.getGesturesEnabled();
    controller.getZoomEnabled();
    /// 添加图片
    controller.addMarker(marker).then((v) {
      print(v);
      print("绘制成功");
    });
    
    /// 西南角经纬度
    BMFCoordinate southwest = BMFCoordinate(40.00235, 116.330338);

    /// 东北角经纬度
    BMFCoordinate northeast = BMFCoordinate(40.147246, 116.464977);
    BMFCoordinateBounds bounds =
        BMFCoordinateBounds(southwest: southwest, northeast: northeast);

    /// 构造ground
    BMFGround bmfGround = BMFGround(
        image: '', bounds: bounds, transparency: 0.8);

    /// 添加ground
    controller.addGround(bmfGround);
    myMapController
        ?.updateMapOptions(BMFMapOptions(mapType: BMFMapType.Standard));

    /// 添加Marker
    /// 地图加载回调
    myMapController?.setMapDidLoadCallback(callback: () async {
      print('mapDidLoad-地图加载完成');

      if (_showUserLocaion) {
        // myMapController?.showUserLocation(true);
        myMapController?.setUserTrackingMode(_userTrackingMode);
      }

      bool _ = await controller.showUserLocation(false); 
      print("result: $_");
    });
  }

  BMFMapOptions mapOptions = BMFMapOptions(
    center: BMFCoordinate(39.928617, 116.40329),
    zoomLevel: 12,
  );
  LocationFlutterPlugin _locationPlugin = new LocationFlutterPlugin();
  StreamSubscription<Map<String, Object>> _locationListener;
  BaiduLocation _baiduLocation;
  /// 启动定位
  void _startLocation() {
    if (null != _locationPlugin) {
      _setLocOption();
      _locationPlugin.startLocation();
    }
  }
  /// 设置android端和ios端定位参数
  void _setLocOption() {
    /// android 端设置定位参数
    BaiduLocationAndroidOption androidOption = new BaiduLocationAndroidOption();
    androidOption.setCoorType("bd09ll"); // 设置返回的位置坐标系类型
    androidOption.setIsNeedAltitude(true); // 设置是否需要返回海拔高度信息
    androidOption.setIsNeedAddres(true); // 设置是否需要返回地址信息
    androidOption.setIsNeedLocationPoiList(true); // 设置是否需要返回周边poi信息
    androidOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    androidOption.setIsNeedLocationDescribe(true); // 设置是否需要返回位置描述
    androidOption.setOpenGps(true); // 设置是否需要使用gps
    androidOption.setLocationMode(LocationMode.Hight_Accuracy); // 设置定位模式
    androidOption.setScanspan(1000); // 设置发起定位请求时间间隔

    Map androidMap = androidOption.getMap();

    /// ios 端设置定位参数
    BaiduLocationIOSOption iosOption = new BaiduLocationIOSOption();
    iosOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    iosOption.setBMKLocationCoordinateType(
        "BMKLocationCoordinateTypeBMK09LL"); // 设置返回的位置坐标系类型
    iosOption.setActivityType("CLActivityTypeAutomotiveNavigation"); // 设置应用位置类型
    iosOption.setLocationTimeout(10); // 设置位置获取超时时间
    iosOption.setDesiredAccuracy("kCLLocationAccuracyBest"); // 设置预期精度参数
    iosOption.setReGeocodeTimeout(10); // 设置获取地址信息超时时间
    iosOption.setDistanceFilter(100); // 设置定位最小更新距离
    iosOption.setAllowsBackgroundLocationUpdates(true); // 是否允许后台定位
    iosOption.setPauseLocUpdateAutomatically(true); //  定位是否会被系统自动暂停

    Map iosMap = iosOption.getMap();

    _locationPlugin.prepareLoc(androidMap, iosMap);
  }
  @override
  void initState() {
    super.initState();
    /// 动态申请定位权限
    _locationPlugin.requestPermission();
    _startLocation();
    _locationListener =
        _locationPlugin.onResultCallback().listen((Map<String, Object> result) {
      setState(() {
        // _loationResult = result;
        try {
          print(result);
          
          _baiduLocation = BaiduLocation.fromMap(result);
         print("_baiduLocation: $_baiduLocation");
        } catch (e) {
          print(e);
         print("_baiduLocationError: $e");

        }
      });
    });
    BMFLocation location = BMFLocation(
        coordinate: coordinate,
        altitude: 0,
        horizontalAccuracy: 5,
        verticalAccuracy: -1.0,
        speed: -1.0,
        course: -1.0);

    BMFUserLocation userLocation = BMFUserLocation(
      location: location,
    );
    myMapController?.updateLocationData(userLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(
                color: Colors.white,
                width: 3
              )
            ),
            margin: EdgeInsets.only(left: 1),
            height: 200,
            width: 400,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: BMFMapWidget(
                onBMFMapCreated: (controller) {
                  onBMFMapCreated(controller);
                },
                mapOptions: mapOptions,
              )
            ) ,
          ),
          Positioned(bottom: 0,child: Container(
            color: Colors.red,
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: CupertinoTextField(
            
            ),
          ) )
          
        ],
      ) ,
    );
  }
}
