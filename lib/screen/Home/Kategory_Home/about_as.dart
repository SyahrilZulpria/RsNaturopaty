import 'package:flutter/material.dart';
//import 'package:rsnaturopaty/widget/utils/ImagesContainer.dart';

class AbaoutAsPage extends StatefulWidget {
  const AbaoutAsPage({super.key});

  @override
  State<AbaoutAsPage> createState() => _AbaoutAsPageState();
}

class _AbaoutAsPageState extends State<AbaoutAsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About US",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const AboutImagesHead(
            imageUrl: 'assets/images/Indonesia_map.png',
            //imageUrl: listArticle['image'],
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white),
            child: const Column(
              children: [
                SizedBox(height: 20),
                Text(
                  "Rumah Sehat Naturopaty",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 15),
                Text(
                  "Selamat datang di [Nama Perusahaan/Proyek], tempat di mana kami menyatukan visi, nilai, dan komitmen untuk menciptakan dampak positif dalam masyarakat. Kami percaya bahwa dengan kerjasama dan dedikasi, kita dapat merangkul perbedaan, menginspirasi perubahan, dan menciptakan masa depan yang lebih baik bersama-sama.",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 15),
                Text(
                  "Misi Kami",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                ),
                SizedBox(height: 10),
                Text(
                  "Misi kami adalah [jelaskan misi perusahaan/proyek secara singkat dan jelas]. Kami berkomitmen untuk memberikan layanan/produk berkualitas tinggi, menjaga keberlanjutan lingkungan, dan memberikan dampak positif dalam masyarakat.",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 15),
                Text(
                  "Nilai Kami",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                ),
                SizedBox(height: 10),
                Text(
                  "Misi kami adalah [jelaskan misi perusahaan/proyek secara singkat dan jelas]. Kami berkomitmen untuk memberikan layanan/produk berkualitas tinggi, menjaga keberlanjutan lingkungan, dan memberikan dampak positif dalam masyarakat.",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AboutImagesHead extends StatelessWidget {
  const AboutImagesHead({
    super.key,
    required this.imageUrl,
  });
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ImageAboutas(
      width: double.infinity,
      imageUrl: imageUrl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 10),
              CustomTag(
                backgroundColor: Colors.black.withOpacity(0.5),
                children: const [
                  Text(
                    "About US",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class ImageAboutas extends StatelessWidget {
  const ImageAboutas({
    super.key,
    //required this.height,
    this.borderRadius = 20,
    required this.width,
    required this.imageUrl,
    this.padding,
    this.margin,
    this.child,
  });

  final double width;
  //final double height;
  final String imageUrl;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: AspectRatio(
          aspectRatio: 16 / 8,
          child: Container(
            width: width, // Explicitly set the width here
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class CustomTag extends StatelessWidget {
  const CustomTag(
      {super.key, required this.backgroundColor, required this.children});

  final Color backgroundColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: children,
      ),
    );
  }
}
