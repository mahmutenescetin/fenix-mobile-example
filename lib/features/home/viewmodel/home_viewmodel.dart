import 'package:flutter/material.dart';
import 'package:fenix_mobile_example/core/base/base_viewmodel.dart';
import 'package:fenix_mobile_example/features/home/model/home_model.dart';
import 'package:fenix_mobile_example/features/home/service/home_service.dart';


class HomeViewModel extends BaseViewModel {
  final HomeService _homeService;
  HomeModel? _homeModel;
  List<HomeModel> _homeList = [];

  HomeViewModel(this._homeService);

  HomeModel? get homeModel => _homeModel;
  List<HomeModel> get homeList => _homeList;

  Future<void> fetchHomeData() async {
    try {
      setLoading(true);
      _homeList = await _homeService.getHomeData();
      notifyListeners();
    } catch (e) {
      setError(true, message: e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchHomeDetail(int id) async {
    try {
      setLoading(true);
      _homeModel = await _homeService.getHomeDetail(id);
      notifyListeners();
    } catch (e) {
      setError(true, message: e.toString());
    } finally {
      setLoading(false);
    }
  }
} 