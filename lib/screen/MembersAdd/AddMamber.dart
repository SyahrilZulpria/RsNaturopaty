import 'package:flutter/material.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';

class AddMembers extends StatefulWidget {
  const AddMembers({super.key});

  @override
  State<AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          "Invite Friends",
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                  top: 20, right: 20, left: 20, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade400, blurRadius: 3),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Roles Invite Friends",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Spacer()
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Text(
                            "Undang teman untuk bergabung, anda akan mendapat komisi tinggi.",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 10),
                          const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "> ",
                                  style: TextStyle(
                                    color: Colors
                                        .blue, // Warna untuk panah atau penanda titik
                                    fontSize: 15,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "Saat produk di beli oleh tingkatan Pertama anda menghasilkan pendapatan. anda akan mendapatkan 10% dari hasil pembelian produk bawahan.",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "> ",
                                  style: TextStyle(
                                    color: Colors
                                        .blue, // Warna untuk panah atau penanda titik
                                    fontSize: 15,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "Saat produk di beli oleh tingkatan Kedua anda menghasilkan pendapatan. anda akan mendapatkan 4% dari hasil pembelian produk bawahan.",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "> ",
                                  style: TextStyle(
                                    color: Colors
                                        .blue, // Warna untuk panah atau penanda titik
                                    fontSize: 15,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "Saat produk di beli oleh tingkatan Ketiga anda menghasilkan pendapatan. anda akan mendapatkan 2% dari hasil pembelian produk bawahan.",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 80),
                          Stack(
                            children: [
                              TextFormField(
                                readOnly: true,
                                style: const TextStyle(fontSize: 16.0),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      top: 15, left: 15, right: 80),
                                  labelText: 'Kode Undangan',
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  filled: true,
                                  fillColor: formColor,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: formBorder)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: formBorder)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: formBorder)),
                                  prefixIcon: const Icon(
                                    Icons.person_outline,
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                top: 5,
                                right: 0,
                                child: ElevatedButton(
                                    onPressed: () {
                                      print("Link code");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .green, // Ubah warna latar belakang menjadi biru
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50),
                                            bottomLeft: Radius.circular(
                                                50)), // Ubah bentuk tombol
                                      ),
                                    ),
                                    child: const Text(
                                      'Copy Code',
                                      style: TextStyle(color: Colors.black),
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Stack(
                            children: [
                              TextFormField(
                                readOnly: true,
                                //controller: otpController,
                                style: const TextStyle(fontSize: 16.0),

                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      top: 15, left: 15, right: 80),
                                  labelText: 'http://m.rsnaturopaty.com',
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  filled: true,
                                  fillColor: formColor,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: formBorder)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: formBorder)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: formBorder)),
                                  prefixIcon: const Icon(
                                    Icons.person_outline,
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                top: 5,
                                right: 0,
                                child: ElevatedButton(
                                    onPressed: () {
                                      print("Link code");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .green, // Ubah warna latar belakang menjadi biru
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50),
                                            bottomLeft: Radius.circular(
                                                50)), // Ubah bentuk tombol
                                      ),
                                    ),
                                    child: const Text(
                                      'Copy Link',
                                      style: TextStyle(color: Colors.black),
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(height: 3, color: Colors.grey[300]),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Text(
                          "Team Overview",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Spacer()
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/manage_user.png"),
                                fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: (size.width - 20) * 0.6,
                          child: const Column(
                            children: [
                              Text(
                                "Number of registered team accounts",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "0",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Number of Members who purchased RS`N products today",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "0",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Total Number of Members who have purchased RS`N products",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "0",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
