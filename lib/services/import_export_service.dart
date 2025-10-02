import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/finance_models.dart';
import '../services/finance_data_service.dart';

class ImportExportService {
  static final ImportExportService _instance = ImportExportService._internal();
  factory ImportExportService() => _instance;
  ImportExportService._internal();

  final FinanceDataService _dataService = FinanceDataService();

  // Export transactions to JSON
  Future<void> exportToJson() async {
    final transactions = _dataService.transactions;
    final exportData = transactions.map((transaction) => {
      'id': transaction.id,
      'date': DateFormat('yyyy-MM-dd').format(transaction.date),
      'description': transaction.title,
      'amount': transaction.amount,
      'type': _mapTransactionTypeToOldFormat(transaction.type),
      'category': transaction.category,
      'contactName': transaction.contactName,
    }).toList();

    final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);
    final bytes = utf8.encode(jsonString);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'finance_backup_${DateFormat('yyyy_MM_dd').format(DateTime.now())}.json';
    html.document.body!.children.add(anchor);
    anchor.click();
    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  // Import transactions from JSON
  Future<List<Transaction>> importFromJson(String jsonString) async {
    try {
      final List<dynamic> jsonData = json.decode(jsonString);
      final List<Transaction> transactions = [];

      for (final item in jsonData) {
        final transaction = Transaction(
          id: item['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
          title: item['description'] ?? 'Imported Transaction',
          amount: (item['amount'] ?? 0).toDouble(),
          category: _mapCategoryFromOldFormat(item['type']),
          date: DateTime.parse(item['date']),
          type: _mapOldFormatToTransactionType(item['type']),
          description: item['description'] ?? '',
          contactName: item['contactName'],
        );
        transactions.add(transaction);
      }

      return transactions;
    } catch (e) {
      throw Exception('Invalid JSON format: $e');
    }
  }

  // Map old format to new transaction types
  TransactionType _mapOldFormatToTransactionType(String oldType) {
    switch (oldType.toLowerCase()) {
      case 'income':
        return TransactionType.income;
      case 'expense':
        return TransactionType.expense;
      case 'lent':
        return TransactionType.lent;
      case 'borrowed':
        return TransactionType.borrowed;
      case 'lent_return':
        return TransactionType.lentReturn;
      case 'borrow_return':
        return TransactionType.borrowReturn;
      default:
        return TransactionType.expense;
    }
  }

  // Map new transaction types to old format
  String _mapTransactionTypeToOldFormat(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return 'income';
      case TransactionType.expense:
        return 'expense';
      case TransactionType.lent:
        return 'lent';
      case TransactionType.borrowed:
        return 'borrowed';
      case TransactionType.lentReturn:
        return 'lent_return';
      case TransactionType.borrowReturn:
        return 'borrow_return';
    }
  }

  // Map category from old format
  String _mapCategoryFromOldFormat(String oldType) {
    switch (oldType.toLowerCase()) {
      case 'income':
        return 'General Income';
      case 'expense':
        return 'General Expense';
      case 'lent':
        return 'Lending';
      case 'borrowed':
        return 'Borrowing';
      default:
        return 'General';
    }
  }

  // Trigger file picker for import
  Future<void> pickAndImportFile(BuildContext context) async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = '.json';
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;

      final reader = html.FileReader();
      reader.readAsText(files[0]);
      reader.onLoad.listen((e) async {
        try {
          final jsonString = reader.result as String;
          final transactions = await importFromJson(jsonString);
          
          // Add transactions to data service
          for (final transaction in transactions) {
            _dataService.addTransaction(transaction);
          }

          // Show success message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Successfully imported ${transactions.length} transactions'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          // Show error message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Import failed: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      });
    });
  }
}