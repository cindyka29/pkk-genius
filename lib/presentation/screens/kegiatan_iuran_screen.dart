import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pkk/extensions/datetime_ext.dart';
import 'package:pkk/presentation/wdigets/app_image_network.dart';
import 'package:pkk/provider/kegiatan_iuran_provider.dart';
import 'package:provider/provider.dart';

class KegiatanIuranScreen extends StatefulWidget {
  const KegiatanIuranScreen({super.key, required this.activityId});

  final String activityId;

  @override
  State<KegiatanIuranScreen> createState() => _KegiatanIuranScreenState();
}

class _KegiatanIuranScreenState extends State<KegiatanIuranScreen> {
  late final GlobalKey<FormBuilderState> formKey;
  final nominalSelection = const [
    DropdownMenuItem<int>(
      value: 10000,
      child: Text('Rp 10.000'),
    ),
    DropdownMenuItem<int>(
      value: 15000,
      child: Text('Rp 15.000'),
    ),
    DropdownMenuItem<int>(
      value: 20000,
      child: Text('Rp 20.000'),
    ),
    DropdownMenuItem<int>(
      value: 25000,
      child: Text('Rp 25.000'),
    ),
    DropdownMenuItem<int>(
      value: 30000,
      child: Text('Rp 30.000'),
    ),
  ];

  @override
  void initState() {
    formKey = GlobalKey<FormBuilderState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KegiatanIuranProvider>(context, listen: false)
          .getUserIuranList(widget.activityId);
    });
    final themeContext = Theme.of(context);
    return Consumer<KegiatanIuranProvider>(
      builder: (context, provider, _) => Scaffold(
        body: FormBuilder(
          key: formKey,
          child: Stack(
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
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: RefreshIndicator(
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        backgroundColor: Colors.transparent,
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: Container(
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: const Color(0x55FFFFFF),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Text(
                              'Iuran Pengurus PKK',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Kegiatan: ${provider.activity.name ?? '-'}'),
                                    const Divider(),
                                    Text(
                                        'Catatan: ${provider.activity.note ?? '-'}'),
                                    const Divider(),
                                    Text(
                                        'Tanggal: ${provider.activity.date?.toDMmmmYyyy() ?? '-'}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(12),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: provider.userElementList.length,
                            (context, index) {
                              final user = provider.userElementList[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF9A02),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: [
                                          AppImageNetwork(
                                            user.user?.image ?? '',
                                            width: 126,
                                            height: 126,
                                          ),
                                          Text(user.user?.name ?? '-'),
                                          Text(user.user?.role ?? '-'),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 28),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF9A02),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          children: [
                                            FormBuilderCheckbox(
                                              name: user.userId!,
                                              title: const Text('Lunas'),
                                              initialValue: user.isPaid == 1,
                                              onChanged: (value) async {
                                                if (value == null) return;
                                                if (value ==
                                                    (user.isPaid == 1)) {
                                                  return;
                                                }
                                                final isSuccess = await provider
                                                    .updateUserIuranStatus(
                                                  id: user.activityId!,
                                                  userIndex: index,
                                                  isPaid: value,
                                                );
                                                if (!isSuccess) {
                                                  formKey.currentState!
                                                      .fields[user.userId]!
                                                      .didChange(!value);
                                                }
                                              },
                                            ),
                                            FormBuilderDropdown(
                                              name: 'nominal',
                                              items: nominalSelection,
                                              initialValue: user.nominal,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  onRefresh: () => provider.getUserIuranList(widget.activityId),
                ),
              ),
              if (provider.isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
