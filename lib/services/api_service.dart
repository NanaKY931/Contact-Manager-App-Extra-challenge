import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contact.dart';

class ApiService {
  static const String _baseUrl =
      'https://apps.ashesi.edu.gh/contactmgt/actions';

  // GET all contacts
  static Future<List<Contact>> getAllContacts() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/get_all_contact_mob'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Contact.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load contacts');
    }
  }

  // GET one contact by id
  static Future<Contact> getOneContact(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/get_a_contact_mob?contid=$id'),
    );

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      // API may return a list with one item or a single object
      if (data is List && data.isNotEmpty) {
        return Contact.fromJson(data[0]);
      } else if (data is Map<String, dynamic>) {
        return Contact.fromJson(data);
      }
      throw Exception('Contact not found');
    } else {
      throw Exception('Failed to load contact');
    }
  }

  // POST add new contact
  static Future<String> addContact(String name, String phone) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/add_contact_mob'),
      body: {
        'ufullname': name,
        'uphonename': phone,
      },
    );

    if (response.statusCode == 200) {
      return response.body.trim(); // "success" or "failed"
    } else {
      throw Exception('Failed to add contact');
    }
  }

  // POST update contact
  static Future<String> updateContact(
      int id, String name, String phone) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/update_contact'),
      body: {
        'cid': id.toString(),
        'cname': name,
        'cnum': phone,
      },
    );

    if (response.statusCode == 200) {
      return response.body.trim(); // "success" or "failed"
    } else {
      throw Exception('Failed to update contact');
    }
  }

  // POST delete contact
  static Future<bool> deleteContact(int id) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/delete_contact'),
      body: {
        'cid': id.toString(),
      },
    );

    if (response.statusCode == 200) {
      final body = response.body.trim().toLowerCase();
      return body == 'true' || body == '1';
    } else {
      throw Exception('Failed to delete contact');
    }
  }
}
