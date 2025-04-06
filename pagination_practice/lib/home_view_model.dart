import 'package:pagination_practice/service/dio_api_client.dart';
import 'package:pagination_practice/service/product_model.dart';
import 'package:pagination_practice/widget/paginated_list_view.dart';

class HomeViewModel {
  late final DioApiClient apiClient;
  late final PaginationController<Product> productPController;

  HomeViewModel() {
    apiClient = DioApiClient();
    productPController = PaginationController(
      fetchItems: (page) {
        return fetchData(page: page);
      },
    );
  }

  Future<List<Product>> fetchData({int page = 1, int limit = 10}) async {
    var products = <Product>[];

    final response = await apiClient.fetch(
      path:
          'https://dummyjson.com/products/?limit=$limit${page > 1 ? '&skip=${page * limit}' : ''}',
    );

    if (response != null) {
      final model = Products.fromJson(response);
      products = [...model.products!];
      return products;
    }
    return [];
  }
}
