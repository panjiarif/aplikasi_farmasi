import 'dart:async';
import 'package:aplikasi_farmasi/services/konversi_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format mata uang

// --- Buat Widget KalkulatorKonversi di file yang sama atau file terpisah ---
class KalkulatorKonversi extends StatefulWidget {
  const KalkulatorKonversi({super.key});

  @override
  State<KalkulatorKonversi> createState() => _KalkulatorKonversiState();
}

class _KalkulatorKonversiState extends State<KalkulatorKonversi> {
  final TextEditingController _amountController = TextEditingController();
  final KonversiService _konversiService = KonversiService();

  List<String> _availableCurrencies = [
    'USD',
    'EUR',
    'JPY',
    'GBP',
    'AUD',
    'CAD',
    'CHF',
    'CNY'
  ]; // Mata uang default
  String _selectedCurrency = 'USD'; // Mata uang tujuan default
  String _result = '0.00'; // Hasil konversi
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, String> _currencyNames =
      {}; // Untuk menyimpan nama lengkap mata uang

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchCurrencies(); // Muat daftar mata uang saat dialog pertama kali dibuka
    _amountController.addListener(
        _onAmountChanged); // Tambahkan listener untuk konversi otomatis
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    _debounce?.cancel(); // Batalkan timer jika ada
    super.dispose();
  }

  // Metode baru yang akan dipanggil saat input jumlah berubah
  void _onAmountChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel(); // Batalkan timer sebelumnya jika ada
    _debounce = Timer(const Duration(milliseconds: 700), () { // Tunggu 700ms setelah user berhenti mengetik
      _convertCurrency(); // Panggil konversi setelah delay
    });
  }

  // Ambil daftar mata uang yang didukung dari API
  Future<void> _fetchCurrencies() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      // Dapatkan semua mata uang
      final Map<String, String> allCurrencies =
          await _konversiService.getCurrencies();

      // Filter hanya mata uang yang ingin ditampilkan
      // Anda bisa sesuaikan daftar ini atau biarkan semua
      final List<String> filteredCurrencies = allCurrencies.keys
          .where((code) => [
                'USD',
                'EUR',
                'JPY',
                'GBP',
                'AUD',
                'CAD',
                'CHF',
                'CNY',
                'SGD',
                'MYR',
                'KRW'
              ].contains(code))
          .toList();
      filteredCurrencies.sort(); // Urutkan alfabetis

      setState(() {
        _currencyNames = allCurrencies; // Simpan nama lengkap mata uang
        _availableCurrencies = filteredCurrencies;
        if (!filteredCurrencies.contains(_selectedCurrency) &&
            filteredCurrencies.isNotEmpty) {
          _selectedCurrency = filteredCurrencies
              .first; // Pilih yang pertama jika default tidak ada
        }
      });
      _convertCurrency(); // Lakukan konversi awal setelah memuat mata uang
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Lakukan konversi mata uang
  void _convertCurrency() async {
    if (_amountController.text.isEmpty ||
        _selectedCurrency.isEmpty ||
        _isLoading) {
      setState(() {
        _result = '0.00';
      });
      return;
    }

    final double amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount <= 0) {
      setState(() {
        _result = '0.00';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final Map<String, double> rates = await _konversiService.getExchangeRates(
        baseCurrency: 'IDR', // Mata uang dasar adalah Rupiah
        currencies: [_selectedCurrency], // Hanya minta mata uang tujuan
      );

      if (rates.containsKey(_selectedCurrency)) {
        final double rate = rates[_selectedCurrency]!;
        final double convertedAmount = amount * rate;
        setState(() {
          // Format hasil dengan NumberFormat untuk mata uang
          final NumberFormat currencyFormatter = NumberFormat.currency(
            locale: 'en_US', // Ganti dengan locale yang sesuai jika perlu
            symbol: _selectedCurrency,
            decimalDigits: 2,
          );
          _result = currencyFormatter.format(convertedAmount);
        });
      } else {
        setState(() {
          _result = 'Tidak tersedia';
          _errorMessage =
              'Nilai tukar untuk $_selectedCurrency tidak ditemukan.';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error';
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.0),
      title: const Text("Konversi Harga Obat"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah (IDR)',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              decoration: const InputDecoration(
                labelText: 'Konversi Ke',
                border: OutlineInputBorder(),
              ),
              items: _availableCurrencies.map((String currencyCode) {
                return DropdownMenuItem<String>(
                  value: currencyCode,
                  child: Text(
                      '$currencyCode - ${_currencyNames[currencyCode] ?? ''}'),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCurrency = newValue;
                  });
                  _convertCurrency(); // Lakukan konversi saat mata uang tujuan berubah
                }
              },
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage != null)
              Text(
                'Error: $_errorMessage',
                style: const TextStyle(color: Colors.red),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hasil Konversi:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _result,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ],
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Tutup"),
        ),
      ],
    );
  }
}
