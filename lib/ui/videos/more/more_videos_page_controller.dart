import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../data/local/state/states.dart';
import '../../../data/remote/model/video_resource/video_resource.dart';
import '../../../data/remote/repository/remote_repository.dart';

class MoreVideosPageController extends GetxController {
  final String url;

  MoreVideosPageController({required this.url});

  late Rx<UiState> uiState;

  late int currentPage;
  late int lastPage;
  late String errorMessage;
  late List<VideoResource> itemList;

  @override
  void onInit() {
    uiState = UiState.onInitialization.obs;

    currentPage = 1;
    lastPage = 1;
    errorMessage = defaultString;
    itemList = [];

    super.onInit();
  }

  @override
  void onReady() {
    getVideoItems();
    super.onReady();
  }

  @override
  void onClose() {
    uiState.close();
    super.onClose();
  }

  void updateView(String id) {
    update([id]);
  }

  Future<void> getVideoItems() async {
    try {
      uiState.value = UiState.onLoading;
      final response = await Future.delayed(
        Duration(milliseconds: 500),
          () => RemoteRepository.on().getPaginatedVideoList(
          url,
          pageNo: currentPage,
        ),
      );

      if (response.details != null && response.details!.data != null) {
        if (response.details!.data!.isNotEmpty) {
          currentPage = response.details?.currentPage ?? 1;
          lastPage = response.details?.lastPage ?? 1;
          itemList.addAll(response.details!.data!);
          uiState.value = UiState.onResult;
        } else {
          uiState.value = UiState.onResultEmpty;
        }
      } else {
        errorMessage = 'Something went wrong';
        currentPage -= 1;
        uiState.value = UiState.onError;
      }
    } catch (e) {
      Get.log("Error: ${e.toString()}");
      errorMessage = e.toString();
      currentPage -= 1;
      uiState.value = UiState.onError;
    }
  }
}
