import 'package:app_mobile/core/model/product_model.dart';
import 'package:app_mobile/core/storage/local/getx_storage.dart';
import 'package:app_mobile/core/validator/validator.dart';
import 'package:app_mobile/features/search/data/request/search_request.dart';
import 'package:app_mobile/features/search/domain/di/di.dart';
import 'package:app_mobile/features/search/domain/use_case/search_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../constants/di/dependency_injection.dart';

class AppSearchController extends GetxController {
  late TextEditingController searchController;
  final FieldValidator validator = FieldValidator();
  bool isLoading = false;
  bool searched = false;
  List<String> searchResults = [];
  List<ProductModel> products = [];

  void changeIsLoading({
    required bool value,
  }) {
    isLoading = value;
    update();
  }

  void changeSearched({
    required bool value,
  }) {
    searched = value;
    update();
  }

  void changeSearchText({
    required String value,
  }) {
    searchController.text = value;
    update();
    searchRequest();
  }

  void searchRequest() async {
    changeIsLoading(
      value: true,
    );
    changeSearched(
      value: true,
    );
    addSearch();
    final SearchUseCase useCase = instance<SearchUseCase>();
    (await useCase.execute(SearchRequest(
      filter: searchController.text,
    )))
        .fold(
      (l) {
        changeIsLoading(
          value: false,
        );

        //@todo: Call the failed toast
      },
      (r) async {
        products = r.products;
        update();
        changeIsLoading(
          value: false,
        );
        changeSearched(
          value: true,
        );
      },
    );
  }

  void addSearch() {
    GetxStorage()
        .addSearch(
      searchController.text,
    )
        .then(
      (data) {
        searchResults = paginateSearchResults(
          data,
        );
        update();
      },
    );
  }

  void emptySearch() {
    GetxStorage().emptySearch().then(
      (data) {
        searchResults = paginateSearchResults(
          data,
        );
        update();
      },
    );
  }

  void deleteSearch({
    required String value,
  }) {
    GetxStorage()
        .deleteSearch(
      value,
    )
        .then(
      (data) {
        searchResults = paginateSearchResults(
          data,
        );
        update();
      },
    );
  }

  void fetchSearchResults() {
    GetxStorage().getSearches().then(
      (data) {
        searchResults = paginateSearchResults(
          data,
        );
        update();
      },
    );
  }

  List<String> paginateSearchResults(List<String> items) {
    int startIndex = items.length >= 5 ? items.length - 5 : 0;

    return items.sublist(startIndex).reversed.toList();
  }

  @override
  void onInit() {
    super.onInit();
    initSearchRequest();
    fetchSearchResults();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    disposeSearchRequest();
    searchController.dispose();
  }
}
