import 'package:wow/data/models/category.dart';

class AppConstants {
  static final List<Category> categories = [
    const Category(
        id: '1',
        name: 'Casa',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/2991/2991148.png'
    ),
    const Category(
        id: '2',
        name: 'Trabalho',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/2991/2991152.png'
    ),
    const Category(
        id: '3',
        name: 'Estudo',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/2991/2991150.png'
    ),
    const Category(
        id: '4',
        name: 'Pessoal',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/2991/2991147.png'
    ),
  ];
}