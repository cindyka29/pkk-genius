import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pkk/provider/rekap_provider.dart';
import 'package:provider/provider.dart';

class RekapIuranScreen extends StatefulWidget {
  const RekapIuranScreen({super.key});

  @override
  State<RekapIuranScreen> createState() => _RekapIuranScreenState();
}

class _RekapIuranScreenState extends State<RekapIuranScreen> {
  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);

    return Consumer<RekapProvider>(
      builder: (context, provider, __) {
        return Scaffold(
          body: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: themeContext.colorScheme.secondary,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: themeContext.primaryColor,
                    ),
                  ),
                ],
              ),
              Container(
                // color: themeContext.disabledColor,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.45),
                  boxShadow: const [
                    BoxShadow(offset: Offset(0, 4), blurRadius: 10.0),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.separated(
                  itemCount: provider.listRekapIuran.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final dataRekap = provider.listRekapIuran[index];
                    return Container(
                      // color: themeContext.primaryColor,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.orange,
                      ),
                      child: Wrap(
                        direction: Axis.vertical,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(dataRekap.user?.name ?? '-'),
                              ),
                              Expanded(
                                child: Text(dataRekap.isPaid!
                                    ? 'Lunas'
                                    : 'Belum Lunas'),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Expanded(
                                child: Text('Nominal Bayar'),
                              ),
                              Expanded(
                                child: Text(
                                  NumberFormat.currency(locale: 'ID')
                                      .format(dataRekap.nominal),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
