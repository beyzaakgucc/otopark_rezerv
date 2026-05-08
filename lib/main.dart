import 'package:flutter/material.dart';

void main() {
  runApp(const BalSisApp());
}

class BalSisApp extends StatelessWidget {
  const BalSisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BAL-SİS',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff0A84FF)),
      ),
      home: const MainScreen(),
    );
  }
}

class ParkingArea {
  final String name;
  final String district;
  final int empty;
  final int total;
  final double price;

  ParkingArea(this.name, this.district, this.empty, this.total, this.price);
}

class Reservation {
  final ParkingArea parking;
  final String slot;
  final String time;
  final String plate;
  bool paid;
  bool photoUploaded;

  Reservation({
    required this.parking,
    required this.slot,
    required this.time,
    required this.plate,
    this.paid = false,
    this.photoUploaded = false,
  });
}

final parkings = [
  ParkingArea('BALPARK Merkez Otopark', 'Karesi', 18, 60, 25),
  ParkingArea('BALPARK Çarşı Otopark', 'Altıeylül', 7, 45, 20),
  ParkingArea('BALPARK Terminal Otopark', 'Otogar Bölgesi', 25, 80, 30),
];

final ValueNotifier<List<Reservation>> reservations = ValueNotifier([]);

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;

  final pages = const [
    HomePage(),
    MapPage(),
    ReservationPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: pageIndex,
        onDestinationSelected: (index) {
          setState(() => pageIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          NavigationDestination(icon: Icon(Icons.map), label: 'Harita'),
          NavigationDestination(icon: Icon(Icons.event), label: 'Rezervasyon'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F7FB),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Text(
              'BAL-SİS',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text(
              'BALPARK Akıllı İzleme Sistemi',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff0A84FF), Color(0xff0057B8)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.local_parking, color: Colors.white, size: 42),
                  SizedBox(height: 14),
                  Text(
                    'En yakın otoparkı bul',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Boş park yerlerini görüntüle, rezervasyon yap, ödeme yap ve fotoğraf yükle.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Yakındaki Otoparklar',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            for (final parking in parkings) ParkingCard(parking: parking),
          ],
        ),
      ),
    );
  }
}

class ParkingCard extends StatelessWidget {
  final ParkingArea parking;

  const ParkingCard({super.key, required this.parking});

  @override
  Widget build(BuildContext context) {
    final full = parking.total - parking.empty;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReservationFormPage(parking: parking),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blue.shade50,
              child: const Icon(Icons.local_parking, color: Colors.blue),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parking.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text('${parking.district} / Balıkesir'),
                  const SizedBox(height: 4),
                  Text('Boş: ${parking.empty}  •  Dolu: $full'),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 17),
          ],
        ),
      ),
    );
  }
}

class ReservationFormPage extends StatefulWidget {
  final ParkingArea parking;

  const ReservationFormPage({super.key, required this.parking});

  @override
  State<ReservationFormPage> createState() => _ReservationFormPageState();
}

class _ReservationFormPageState extends State<ReservationFormPage> {
  String? selectedSlot;
  String? selectedTime;
  final plateController = TextEditingController(text: '34 ABC 123');

  final slots = [
    'A1',
    'A2',
    'A3',
    'A4',
    'B1',
    'B2',
    'B3',
    'B4',
    'C1',
    'C2',
    'C3',
    'C4',
  ];

  final times = [
    '09.00 - 10.00',
    '10.00 - 11.00',
    '11.00 - 12.00',
    '13.00 - 14.00',
    '14.00 - 15.00',
    '15.00 - 16.00',
    '16.00 - 17.00',
  ];

  @override
  Widget build(BuildContext context) {
    final full = widget.parking.total - widget.parking.empty;

    return Scaffold(
      backgroundColor: const Color(0xffF3F7FB),
      appBar: AppBar(
        title: const Text('Rezervasyon Yap'),
        backgroundColor: const Color(0xff0A84FF),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.local_parking, color: Colors.blue),
              title: Text(widget.parking.name),
              subtitle: Text(
                '${widget.parking.district} / Balıkesir\nBoş: ${widget.parking.empty} - Dolu: $full',
              ),
              isThreeLine: true,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Park Yeri Seç',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: slots.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final slot = slots[index];
              final isFull = index == 2 || index == 5 || index == 9;
              final isSelected = selectedSlot == slot;

              return GestureDetector(
                onTap: isFull
                    ? null
                    : () {
                        setState(() {
                          selectedSlot = slot;
                        });
                      },
                child: Container(
                  decoration: BoxDecoration(
                    color: isFull
                        ? Colors.red.shade100
                        : isSelected
                            ? Colors.blue
                            : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      isFull ? '$slot\nDolu' : '$slot\nBoş',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 22),
          const Text(
            'Saat Seç',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: times.map((time) {
              return ChoiceChip(
                label: Text(time),
                selected: selectedTime == time,
                onSelected: (_) {
                  setState(() {
                    selectedTime = time;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 22),
          const Text(
            'Plaka',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: plateController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: '34 ABC 123',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: () {
              if (selectedSlot == null || selectedTime == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lütfen park yeri ve saat seç.'),
                  ),
                );
                return;
              }

              final reservation = Reservation(
                parking: widget.parking,
                slot: selectedSlot!,
                time: selectedTime!,
                plate: plateController.text,
              );

              reservations.value = [...reservations.value, reservation];

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ReservationDetailPage(
                    reservation: reservation,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.check),
            label: const Text('Rezervasyonu Oluştur'),
          ),
        ],
      ),
    );
  }
}

class ReservationDetailPage extends StatefulWidget {
  final Reservation reservation;

  const ReservationDetailPage({super.key, required this.reservation});

  @override
  State<ReservationDetailPage> createState() => _ReservationDetailPageState();
}

class _ReservationDetailPageState extends State<ReservationDetailPage> {
  void uploadDemoPhoto() {
    setState(() {
      widget.reservation.photoUploaded = true;
    });

    reservations.value = [...reservations.value];

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Demo fotoğraf yüklendi.')),
    );
  }

  void makePayment() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ödeme Yöntemi Seç',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.credit_card),
                title: const Text('Kredi/Banka Kartı'),
                subtitle: Text('${widget.reservation.parking.price.toInt()}₺'),
                onTap: completePayment,
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text('BAL-SİS Cüzdan'),
                subtitle: Text('${widget.reservation.parking.price.toInt()}₺'),
                onTap: completePayment,
              ),
              ListTile(
                leading: const Icon(Icons.money),
                title: const Text('Otoparkta Nakit Ödeme'),
                subtitle: const Text('Girişte ödeme yapılacak'),
                onTap: completePayment,
              ),
            ],
          ),
        );
      },
    );
  }

  void completePayment() {
    Navigator.pop(context);

    setState(() {
      widget.reservation.paid = true;
    });

    reservations.value = [...reservations.value];

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ödeme başarıyla tamamlandı.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.reservation;

    return Scaffold(
      backgroundColor: const Color(0xffF3F7FB),
      appBar: AppBar(
        title: const Text('Rezervasyon Detayı'),
        backgroundColor: const Color(0xff0A84FF),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.local_parking, color: Colors.blue),
              title: Text(r.parking.name),
              subtitle: Text(
                'Yer: ${r.slot}\nSaat: ${r.time}\nPlaka: ${r.plate}\nÜcret: ${r.parking.price.toInt()}₺',
              ),
              isThreeLine: true,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: r.photoUploaded ? Colors.green.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Center(
              child: r.photoUploaded
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 80, color: Colors.green),
                        SizedBox(height: 8),
                        Text(
                          'Demo fotoğraf yüklendi',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 70, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Henüz fotoğraf yüklenmedi'),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: uploadDemoPhoto,
            icon: const Icon(Icons.photo_camera),
            label: const Text('Fotoğraf Yükle'),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: r.paid ? Colors.green : Colors.black87,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: r.paid ? null : makePayment,
            icon: Icon(r.paid ? Icons.check_circle : Icons.payment),
            label: Text(r.paid ? 'Ödeme Yapıldı' : 'Ödeme Yap'),
          ),
        ],
      ),
    );
  }
}

class ReservationPage extends StatelessWidget {
  const ReservationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F7FB),
      appBar: AppBar(
        title: const Text('Rezervasyonlarım'),
        backgroundColor: const Color(0xff0A84FF),
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder<List<Reservation>>(
        valueListenable: reservations,
        builder: (context, list, _) {
          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Otopark Seç',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            for (final parking in parkings)
                              Card(
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.local_parking,
                                    color: Colors.blue,
                                  ),
                                  title: Text(parking.name),
                                  subtitle: Text(
                                    '${parking.district} - Boş yer: ${parking.empty}',
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ReservationFormPage(parking: parking),
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
                },
                icon: const Icon(Icons.add),
                label: const Text('Yeni Rezervasyon Yap'),
              ),
              const SizedBox(height: 18),
              if (list.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Center(
                    child: Text(
                      'Henüz rezervasyon yok.\nYeni rezervasyon yap butonuna basabilirsin.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                for (final r in list)
                  Card(
                    child: ListTile(
                      leading: Icon(
                        r.paid ? Icons.check_circle : Icons.event,
                        color: r.paid ? Colors.green : Colors.orange,
                      ),
                      title: Text(r.parking.name),
                      subtitle: Text(
                        'Yer: ${r.slot}\nSaat: ${r.time}\nPlaka: ${r.plate}\nÖdeme: ${r.paid ? "Yapıldı" : "Bekliyor"}\nFotoğraf: ${r.photoUploaded ? "Yüklendi" : "Yok"}',
                      ),
                      isThreeLine: true,
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReservationDetailPage(
                              reservation: r,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F7FB),
      appBar: AppBar(
        title: const Text('Harita'),
        backgroundColor: const Color(0xff0A84FF),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              const Center(
                child: Text(
                  'BALPARK Dijital Harita',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(top: 70, left: 40, child: mapPin('P1', Colors.green)),
              Positioned(top: 150, right: 50, child: mapPin('P2', Colors.red)),
              Positioned(bottom: 130, left: 90, child: mapPin('P3', Colors.green)),
              Positioned(bottom: 80, right: 80, child: mapPin('P4', Colors.orange)),
            ],
          ),
        ),
      ),
    );
  }

  Widget mapPin(String text, Color color) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: color,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F7FB),
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: const Color(0xff0A84FF),
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white, size: 45),
            ),
            SizedBox(height: 12),
            Text(
              'Demo Kullanıcı',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text('34 ABC 123'),
            SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: Icon(Icons.car_rental),
                title: Text('Araç Bilgisi'),
                subtitle: Text('Plaka: 34 ABC 123'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.payment),
                title: Text('Ödeme Yöntemi'),
                subtitle: Text('Kart / Cüzdan / Nakit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}