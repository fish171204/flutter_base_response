import 'package:flutter/material.dart';
import 'dart:convert' as convert;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final String json = '''
      {
        "status": 200,
        "message": "Ok",
        "data": {
            "orderId": "azxlsdj220k",
            "price": 2000000,
            "items": [
              {
                "id": "123",
                "name": "A",
                "quantity": 1,
                "price": 1000000
              },
              {
                "id": "456",
                "name": "B",
                "quantity": 1,
                "price": 1000000
              }
            ]
        } 
      }
  ''';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dùng jsonDecode để chuyển chuỗi JSON → Map Dart.
    // Dùng BaseResponse.parseJson() để parse toàn bộ phản hồi JSON thành đối tượng Dart (BaseResponse<Order>).
    final decoded = convert.jsonDecode(json);
    final response = BaseResponse<Order>().parseJson(decoded, Order.fromJson);

    Order order = response.data!;
    for (var item in order.items) {
      print('ID: ${item.id}');
      print('Name: ${item.name}');
      print('Quantity: ${item.quantity}');
      print('Price: ${item.price}');
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Order Info")),
      body: const Center(child: Text("Check console for output")),
    );
  }
}

// BaseResponse<T> dùng để parse toàn bộ phản hồi.
class BaseResponse<T> {
  int? status;
  String? message;
  T? data;

  BaseResponse({this.status, this.message, this.data});

  BaseResponse<T> parseJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return BaseResponse<T>(
      status: json['status'],
      message: json['message'],
      data: fromJson(json['data']),
    );
  }
}

// BaseObject<T> buộc các class cụ thể phải biết cách từ json tạo ra chính nó.
abstract class BaseObject<T> {
  T fromJson(Map<String, dynamic> json);
}

class Order extends BaseObject<Order> {
  String orderId;
  double price;
  List<Product> items;

  Order({required this.orderId, required this.price, required this.items});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json["orderId"],
      price: (json["price"] as num).toDouble(),
      items: (json["items"] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
    );
  }

  @override
  Order fromJson(Map<String, dynamic> json) {
    return Order.fromJson(json);
  }
}

class Product {
  String id;
  String name;
  int quantity;
  double price;

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      quantity: (json["quantity"] as num).toInt(),
      price: (json["price"] as num).toDouble(),
    );
  }
}
