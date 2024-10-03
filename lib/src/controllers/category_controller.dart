import 'package:get/get.dart';
import 'package:quotation_app/src/models/category_model.dart';

class CategoryController extends GetxController{

  List<Category> listCategory = [
    Category(id: 1, slug: 'seoContentWriting', name: 'SEO Content Writing'),
    Category(id: 2, slug: 'seoServices', name: 'SEO Services'),
    Category(id: 3, slug: 'sosialMediaManagement', name: 'Sosial Media Management'),
    Category(id: 4, slug: 'digitalMarketing', name: 'Digital Marketing'),
    Category(id: 5, slug: 'digitalAgency', name: 'Digital Agency'),
  ];

  List<Category> get getListCategory {
    return listCategory;
  }


}