import 'package:flutter/material.dart';
import 'package:mobile_flutter/models/plants_response_model.dart';

import '../../services/services_restapi_impl.dart';
import '../../utils/state/finite_state.dart';

class GetMyPlantsProvider extends ChangeNotifier {
  // text field control and query
  final searchFieldController = TextEditingController();
  String searchQuery = "";
  //

  final service = ServicesRestApiImpl();
  MyState state = MyState.loading;

  List<PlantsResponseModel> myPlants = [];
  List<PlantsResponseModel> showDataPlants = [];
  // ----
  bool isDeleteMode = false;
  List<int> selectedIndexCard = [];
  List<PlantsResponseModel> dataSelected = [];

  void getMyPlantsData() async {
    if (state == MyState.loaded || state == MyState.failed) {
      state = MyState.loading;
      notifyListeners();
    }
    try {
      myPlants.clear();
      showDataPlants.clear();
      final response = await service.getMyPlants();
      myPlants = response;
      showDataPlants = List.from(myPlants);

      state = MyState.loaded;
      notifyListeners();
    } catch (e) {
      state = MyState.failed;
      notifyListeners();
    }
  }

// --
// -----------------
// --
//
  onSelectedCard({required bool selectStatus, required int indexSelected}) {
    if (selectStatus == false) {
      showDataPlants[indexSelected].isSelected = true;
      selectedIndexCard.add(indexSelected);
      dataSelected.add(myPlants[indexSelected]);
      notifyListeners();
    } else if (selectStatus == true) {
      showDataPlants[indexSelected].isSelected = false;
      selectedIndexCard.remove(indexSelected);
      dataSelected.remove(myPlants[indexSelected]);
      notifyListeners();
    }
  }

  cancelAllSelected() {
    for (var indexSelected in selectedIndexCard) {
      showDataPlants[indexSelected].isSelected = false;
      // print("remove ${data[indexSelected].plantName} from selectedList");
    }
    selectedIndexCard.clear();
    dataSelected.clear();
    isDeleteMode = false;
    notifyListeners();
  }

  deleteModeOnClick() {
    // isDeleteMode = !isDeleteMode;
    isDeleteMode = true;
    notifyListeners();
    // print(isDeleteMode);
  }

  deleteAllSelected(List<int> myplantId) async {
    try {
      final response = await service.deleteMyPlants(myplantId);
      if (response == 200) {
        // buat snackbar berhasil hapus
        // get data lagi biar liat pembaharuan
        getMyPlantsData();
      }
    } catch (e) {
      // buat snackbar gagal
    }

    for (var value in dataSelected) {
      myPlants.remove(value);
      // print("delete ${myPlants[indexSelected].plantName}");
    }
    selectedIndexCard.clear();
    dataSelected.clear();
    isDeleteMode = false;
    notifyListeners();
  }

  //
  // ------- search -------
  //
  void search() {
    searchQuery = searchFieldController.text.toLowerCase();
    showDataPlants.clear();
    if (searchQuery.isEmpty) {
      // print("query nya kosong");
      showDataPlants.addAll(myPlants);
      notifyListeners();
    } else {
      // print("query nya  ada $searchQuery");
      showDataPlants.addAll(
        myPlants.where(
          (element) => element.name!.toLowerCase().contains(searchQuery),
        ),
      );
      notifyListeners();
    }
    // print("${showDataPlants.length} showdata ini dalam fungsi clear");
    // print("${myPlants.length} myplants ini dalam fungsi clear");
  }

  void clearSearchField() {
    searchFieldController.clear();
    searchQuery = "";

    showDataPlants.clear();
    showDataPlants.addAll(myPlants);
    notifyListeners();
    // print("${showDataPlants.length} showdata ini dalam fungsi clear");
    // print("${myPlants.length} myplants ini dalam fungsi clear");
  }
  //
}