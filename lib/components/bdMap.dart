import 'package:flutter/material.dart';
import 'package:flutter_bmfmap/BaiduMap/bmfmap_map.dart';
import 'package:flutter_bmfbase/BaiduMap/bmfmap_base.dart';

class AMap extends StatefulWidget {
  AMap({Key key}) : super(key: key);

  @override
  _AMapState createState() => _AMapState();
}

class _AMapState extends State<AMap> {
  BMFMapController myMapController;
  BMFCoordinate coordinate = BMFCoordinate(22.54605355, 114.02597366);
  /// 定位模式状态
  bool _showUserLocaion = true;
  /// 定位模式
  BMFUserTrackingMode _userTrackingMode = BMFUserTrackingMode.Follow;
  /// 创建完成回调
  void onBMFMapCreated(BMFMapController controller) {
    myMapController = controller;

    /// 地图加载回调
    myMapController?.setMapDidLoadCallback(callback: () {
      print('mapDidLoad-地图加载完成');
      if (_showUserLocaion) {
        myMapController?.showUserLocation(true);
        myMapController?.setUserTrackingMode(_userTrackingMode);
      }
      myMapController?.showUserLocation(true);
    });
  }

  BMFMapOptions mapOptions = BMFMapOptions();

  @override
  void initState() {
    super.initState();
    BMFLocation location = BMFLocation(
        coordinate: coordinate,
        altitude: 0,
        horizontalAccuracy: 5,
        verticalAccuracy: -1.0,
        speed: -1.0,
        course: -1.0
    );

    BMFUserLocation userLocation = BMFUserLocation(
      location: location,
    );
    myMapController?.updateLocationData(userLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: BMFMapWidget(
          onBMFMapCreated: (controller) {
            onBMFMapCreated(controller);
          },
          mapOptions: mapOptions,
        ),
      ),
    );
  }
}
